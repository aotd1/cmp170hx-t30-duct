from pathlib import Path
import hashlib,zipfile,json
P=Path(__file__).resolve().parents[1];D=P/'dist';D.mkdir(exist_ok=True)
files=[p for p in P.rglob('*') if p.is_file() and not any(x.startswith('.') or x in ['dist','__pycache__'] for x in p.relative_to(P).parts)]
# Generated local build outputs are not release inputs.
files=[p for p in files if not (p.parent==P/'src/v5' and p.name not in ['build_body.py','gpu_interface.stl','engraving.stl','design-parameters.json'])]
version=json.loads((P/'publication.json').read_text())['version'];out=D/f'cmp170hx-t30-duct-v{version}.zip'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
 for p in sorted(files):z.write(p,p.relative_to(P))
selected=[out,P/'models/v5-raised22/print-orientation.stl',P/'profiles/p1s/v5-raised22-p1s-petg.3mf']
(D/'SHA256SUMS.txt').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n' for p in selected))
print(out)
