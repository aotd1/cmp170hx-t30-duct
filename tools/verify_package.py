from pathlib import Path
import json,zipfile,hashlib,xml.etree.ElementTree as E
import trimesh,numpy as np
P=Path(__file__).resolve().parents[1]
results={}
for name in ['assembly.stl','print-orientation.stl']:
 m=trimesh.load_mesh(P/'models/v5-raised22'/name)
 assert m.is_watertight and m.is_volume and len(m.split())==1
 results[name]={'watertight':True,'components':1,'size_mm':m.extents.tolist(),'sha256':hashlib.sha256((P/'models/v5-raised22'/name).read_bytes()).hexdigest()}
assert np.allclose(results['print-orientation.stl']['size_mm'],[120,120,104],atol=.01)
f=P/'profiles/p1s/v5-raised22-p1s-petg.3mf'
with zipfile.ZipFile(f) as z:
 assert z.testzip() is None
 s=json.loads(z.read('Metadata/project_settings.config'))
 assert s['wall_loops']=='3' and s['layer_height']=='0.2' and s['enable_support']=='1'
 assert s['support_on_build_plate_only']=='1'
 for name in z.namelist():
  if name.endswith(('.model','.config')):
   b=z.read(name)
   assert b'/Users/aotd' not in b and b'git.aotd.ru' not in b,name
 assert b'CC BY-SA 4.0' in z.read('3D/3dmodel.model')
results['project_3mf']={'zip_ok':True,'wall_loops':3,'layer_height_mm':.2,'supports':True}
for path in P.rglob('*.md'):
 assert 'git.aotd.ru' not in path.read_text(),path
(P/'validation/package-validation.json').write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps(results,indent=2))
