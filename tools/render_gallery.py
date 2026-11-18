from pathlib import Path
import numpy as np,trimesh,manifold3d as md
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
P=Path(__file__).resolve().parents[1]
m=trimesh.load_mesh(P/'models/v5-raised22/assembly.stl')
a=md.Manifold(md.Mesh(vert_properties=np.asarray(m.vertices,dtype=np.float32),tri_verts=np.asarray(m.faces,dtype=np.uint32))).simplify(.06);m=a.to_mesh();m=trimesh.Trimesh(m.vert_properties[:,:3],m.tri_verts)
# Source CAD -X is physically upward; Z runs from GPU toward fan.
m.vertices=m.vertices[:,[2,1,0]]*[1,1,-1]
lo,hi=m.bounds;mid=(lo+hi)/2;span=max(hi-lo)*1.09
def render(angle):
 az,el=np.radians(angle);eye=np.array([np.cos(el)*np.cos(az),np.cos(el)*np.sin(az),np.sin(el)]);right=np.cross([0,0,1],eye);right/=np.linalg.norm(right);up=np.cross(eye,right)
 vs=(m.vertices-mid)@np.array([right,up,eye]).T
 W,H=1400,1000;scale=min((W-120)/np.ptp(vs[:,0]),(H-100)/np.ptp(vs[:,1]));vs[:,0]=vs[:,0]*scale+W/2;vs[:,1]=H/2-vs[:,1]*scale
 canvas=np.empty((H,W,3),dtype=np.uint8);canvas[:]=[245,246,247];depth=np.full((H,W),-np.inf)
 light=np.array([-.5,-.6,1]);light/=np.linalg.norm(light);shade=.38+.62*np.clip(m.face_normals@light,0,1);colors=(np.array([35,153,169])[None,:]*shade[:,None]).astype(np.uint8)
 for face,col in zip(m.faces,colors):
  t=vs[face];x0=max(0,int(np.floor(t[:,0].min())));x1=min(W-1,int(np.ceil(t[:,0].max())));y0=max(0,int(np.floor(t[:,1].min())));y1=min(H-1,int(np.ceil(t[:,1].max())))
  if x1<x0 or y1<y0:continue
  a,b,c=t;den=(b[1]-c[1])*(a[0]-c[0])+(c[0]-b[0])*(a[1]-c[1])
  if abs(den)<1e-9:continue
  yy,xx=np.mgrid[y0:y1+1,x0:x1+1];xx=xx+.5;yy=yy+.5
  u=((b[1]-c[1])*(xx-c[0])+(c[0]-b[0])*(yy-c[1]))/den;v=((c[1]-a[1])*(xx-c[0])+(a[0]-c[0])*(yy-c[1]))/den;w=1-u-v;z=u*a[2]+v*b[2]+w*c[2]
  zbuf=depth[y0:y1+1,x0:x1+1];mask=(u>=-1e-7)&(v>=-1e-7)&(w>=-1e-7)&(z>zbuf);zbuf[mask]=z[mask];canvas[y0:y1+1,x0:x1+1][mask]=col
 return canvas
for name,angle,title in [('v5-cover.png',(-125,22),'CMP170HX + T30'),('v5-detail.png',(55,25),'Raised-fan duct / v5')]:
 fig=plt.figure(figsize=(12,9),dpi=150,facecolor='#f5f6f7');ax=fig.add_axes([.04,.12,.92,.71]);ax.imshow(render(angle));ax.axis('off')
 fig.text(.07,.91,title,fontsize=29,fontweight='bold',color='#132c35');fig.text(.07,.86,'22 mm fan lift · fixed GPU mount · 120 mm fan',fontsize=17,color='#34616d');fig.text(.07,.06,'CAD render — v5 prototype; final fit and thermal checks pending',fontsize=12,color='#526570');fig.savefig(P/'assets/gallery'/name);plt.close(fig)
