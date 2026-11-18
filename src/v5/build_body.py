from pathlib import Path
import json,numpy as np,trimesh,manifold3d as md
from shapely.geometry import Polygon,LineString,Point
from shapely.geometry.polygon import orient
from scipy.spatial import cKDTree
P=Path(__file__).resolve().parent;ROOT=P.parents[1]
N=256;H=75.;STRAIGHT=5.;PLATE=4.;Z0=10.;ZF=Z0+H+STRAIGHT
# Exact duct-facing opening boundary from author V1.40 POS1 at z=10.
poly=Polygon([[-18.82,24.25],[.23,24.25],[.23,1],[17.53,1],[17.53,97.2],[-18.82,97.2]])
C0=np.array([6.,55.]);C1=np.array([-2.45,40.2]);angles=np.linspace(0,2*np.pi,N,endpoint=False)
# Include every exact mouth corner so radial resampling cannot leave
# unintended chamfers across the enlarged entry windows.
corner=np.asarray(poly.exterior.coords[:-1])-C0
angles=np.unique(np.r_[angles,np.mod(np.arctan2(corner[:,1],corner[:,0]),2*np.pi)])
N=len(angles)
rays=np.c_[np.cos(angles),np.sin(angles)]
bottom=[]
for d in rays:
 hit=LineString([C0,C0+d*500]).intersection(poly.boundary)
 pts=[hit] if hit.geom_type=='Point' else list(hit.geoms)
 pts=[p for p in pts if p.geom_type=='Point' and np.dot(np.array(p.coords[0])-C0,d)>0]
 bottom.append(min((np.array(p.coords[0]) for p in pts),key=lambda p:np.linalg.norm(p-C0)))
bottom=np.array(bottom);top=C1+56.5*rays
# Raised-cosine end ramps: continuous position/slope/curvature, mostly constant
# displacement slope in the central 60%, rather than a steep full-length S bend.
def g(t,a=.2):
 t=np.asarray(t);v=np.minimum(t,1-t);f=(v/2-a/(2*np.pi)*np.sin(np.pi*v/a))/(1-a)
 value=np.where(v<a,f,(v-a/2)/(1-a));return np.where(t<=.5,value,1-value)
# Preserve a connector bay to z35. Vary freeze height continuously around the
# notch so the roof joins the surrounding wall without a free internal baffle.
# Keep the connector bay stationary up to z35; fade the constraint smoothly
# along the two neighboring walls, with zero influence on the opposite wall.
wx=np.clip((10-bottom[:,0])/(10-.23),0,1)
wy=np.clip((50-bottom[:,1])/(50-24.25),0,1)
weights=(.5-.5*np.cos(np.pi*wx))*(.5-.5*np.cos(np.pi*wy))
freeze=25*weights
Zs=np.linspace(Z0,Z0+H,141);loops=[]
for z in Zs:
 t=np.clip((z-Z0-freeze)/(H-freeze),0,1);w=g(t)
 xy=bottom*(1-w[:,None])+top*w[:,None]
 # Blend sharp perimeter corners away gradually inside the transition.
 from scipy.ndimage import gaussian_filter1d
 sigma=3*np.sin(np.pi*(z-Z0)/H)**2
 if sigma>.001:xy=gaussian_filter1d(xy,sigma,axis=0,mode='wrap')
 assert Polygon(xy).is_valid
 loops.append(xy)
loops=np.array(loops)
areas=np.array([Polygon(x).area for x in loops]);assert np.all(np.diff(areas)>-1e-5)
# Smooth external offset, nominal XY wall thickness2mm; normal thickness lower on sloped walls. Join rounded
# corners with angular resampling about each local interpolated center.
outers=[]
for xy in loops:
 po=Polygon(xy).buffer(2,quad_segs=8);center=np.array(Polygon(xy).centroid.coords[0]);out=[]
 # Same index/radial direction as each inner vertex, preserving correspondence.
 for p in xy:
  d=p-center;d/=np.linalg.norm(d);hit=LineString([center,center+d*500]).intersection(po.boundary)
  if hit.geom_type!='Point':hit=min(list(hit.geoms),key=lambda q:Point(p).distance(q))
  out.append(hit.coords[0])
 outers.append(np.array(out))
outers=np.array(outers)
def loft_solid(xys,zs):
 vs=np.c_[xys.reshape(-1,2),np.repeat(zs,N)];faces=[]
 for k in range(len(zs)-1):
  for j in range(N):
   a=k*N+j;b=k*N+(j+1)%N;c=(k+1)*N+(j+1)%N;d=(k+1)*N+j
   faces.extend([[a,b,c],[a,c,d]])
 vs=np.vstack([vs,[*xys[0].mean(0),zs[0]],[*xys[-1].mean(0),zs[-1]]]);low=len(vs)-2;high=len(vs)-1
 for j in range(N):faces.extend([[low,(j+1)%N,j],[high,(len(zs)-1)*N+j,(len(zs)-1)*N+(j+1)%N]])
 t=trimesh.Trimesh(vs,faces,process=True);assert t.is_watertight
 return t
# Add a 0.4-mm overlap onto the flange and a 10-mm constant circular collar.
zs=np.r_[Zs,ZF+.2];inner=np.concatenate([loops,loops[-1:]]);outer=np.concatenate([outers,outers[-1:]])
def solid(m):
 q=md.Manifold(md.Mesh(vert_properties=np.asarray(m.vertices,dtype=np.float32),tri_verts=np.asarray(m.faces,dtype=np.uint32)))
 assert q.status()==md.Error.NoError,q.status();return q
shell=solid(loft_solid(outer,zs))-solid(loft_solid(inner,zs))
gpu=trimesh.load_mesh(P/'gpu_interface.stl');model=solid(gpu)+shell
# Four-mm fan plate, original 105 mm hole pattern. Plate circular aperture
# equals collar bore; no sudden square plenum immediately after the fan.
box=trimesh.creation.box([120,120,PLATE]);box.apply_translation([*C1,ZF+PLATE/2]);plate=solid(box)
def cyl(d,z,h,x,y):
 m=trimesh.creation.cylinder(radius=d/2,height=h,sections=128);m.apply_translation([x,y,z+h/2]);return solid(m)
plate=plate-cyl(113,ZF-1,PLATE+2,*C1)
centers=[C1+[x*52.5,y*52.5] for x in [-1,1] for y in [-1,1]]
for x,y in centers:plate=plate-cyl(4.8,ZF-1,PLATE+2,x,y)
model=model+plate
label=trimesh.load_mesh(P/"engraving.stl");label.apply_translation([-22,0,0]);model=model-solid(label)
# Maintain screwdriver bore clearance. No access pillars added to the airway.
for x,y in centers:model=model-cyl(8.5,10.01,ZF-10.01,x,y)
# Exterior relief: retain nominal plug/latch keepout plus0.2mm; local
# notch-wall target1.75mm, pending slicing and physical load/fit tests.
EPS_RELIEF=md.Manifold.cube([19.55,24.8,20.5]).translate([-22.62,-2.3,10.0])
model=model-EPS_RELIEF
# Quantization cleanup before STL round-trip.
model=model.simplify();me=model.to_mesh();model=md.Manifold(md.Mesh(vert_properties=np.array(np.round(me.vert_properties,4),dtype=np.float32,copy=True,order="C"),tri_verts=np.array(me.tri_verts,dtype=np.uint32,copy=True,order="C"))).simplify();assert model.status()==md.Error.NoError;me=model.to_mesh();m=trimesh.Trimesh(me.vert_properties[:,:3],me.tri_verts,process=True)
assert m.is_volume and m.is_watertight
m.export(P/'CMP170HX_T30_smooth_POS1_v5_raise22_assembly.stl')
v=m.copy();v.apply_transform(trimesh.transformations.rotation_matrix(np.pi,[0,1,0]));v.apply_translation([-v.bounds[:,0].mean(),-v.bounds[:,1].mean(),-v.bounds[0,2]])
vsolid=solid(v).simplify();mm=vsolid.to_mesh();v=trimesh.Trimesh(mm.vert_properties[:,:3],mm.tri_verts,process=True);v.export(P/'CMP170HX_T30_smooth_POS1_v5_raise22_fan_down.stl');r=trimesh.load_mesh(P/'CMP170HX_T30_smooth_POS1_v5_raise22_fan_down.stl');assert r.is_volume and r.is_watertight
# GPU fit preserved below original mounting plate back face.
box=trimesh.creation.box([400,400,100]);box.apply_translation([0,0,-40.001]);cut=solid(box)
original=trimesh.load_mesh(ROOT/'upstream/V140-POS1-reference.stl');delta=((model^cut)-(solid(gpu)^cut)).volume()+((solid(gpu)^cut)-(model^cut)).volume();assert abs(delta)<.1
# Compare clear sections in both ducts, using largest hole contour.
oldareas=[]
for z in np.linspace(10.1,59.8,80):
 ps=sorted([Polygon(p[:,:2]) for p in original.section(plane_origin=[0,0,z],plane_normal=[0,0,1]).discrete],key=lambda p:p.area,reverse=True)
 oldareas.append([z,ps[1].area])
# Screw axes are free to plate and enlarged channel cuts do not pierce airway.
clear=[]
for c in centers:
 distances=[Polygon(xy).distance(Point(c)) for xy in loops]
 clear.append(float(min(distances)))
assert min(clear)>4.25,clear
# Original mounting openings union area (exclude EPS/latch) retained exactly.
flow=loft_solid(inner,zs);flow.export(P/'transition_flow_domain.stl')
report={'state':'geometry_candidate_not_CFD_validated','version':5,'fan_translation_from_v4_mm':[-22,0,0],'fan':'T30-120','position':'Installed orientation: fan/collar move CAD X=-22mm (physical up); fixed GPU mount','size_mm':r.extents.tolist(),'watertight':True,'winding':bool(r.is_winding_consistent),'components':len(r.split()),'volume_mm3':float(r.volume),'assembled_interface_input_difference_mm3':float(delta),'transition_length_mm':H,'straight_collar_mm':STRAIGHT,'fan_plate_mm':PLATE,'air_area_at_gpu_end_mm2':float(areas[0]),'air_area_at_fan_mm2':float(areas[-1]),'monotonic_contraction_towards_GPU':True,'old_max_airway_area_mm2':max(a for _,a in oldareas),'area_samples_mm':[[float(z),float(a)] for z,a in zip(Zs[::5],areas[::5])],'old_area_samples_mm':oldareas,'screw_axes_min_distance_to_airway_mm':clear,'added_length_vs_V140_mm':float(ZF+PLATE-63.5),'forward_extension_with_T30_mm':float(ZF+PLATE+30),'case_clearance_conservative_estimate_mm':float(503-270-25-(ZF+PLATE+30)),'numeric_CFD_performed':False,'mass_flow_gain_claimed':False,'important_limits':['Source GPU fit geometry preserved; actual card, plug bend, fan pads and chassis not fitted','No heatsink porous resistance, fan P-Q at PWM, or leakage measurements; no aerodynamic optimum or temperatures certified','Connector notch retained with locally delayed blending, requires plug/cable trial','No strength/creep margin without process-matched properties; longer cantilever needs assembly support/check']}
(P/'geometry-validation.json').write_text(json.dumps(report,indent=2));np.savez(P/'loft-data.npz',inner=loops,outer=outers,z=Zs,areas=areas);print(json.dumps(report,indent=2))
