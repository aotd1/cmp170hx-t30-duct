# Build from source

Python 3.10+; the working environment used Python 3.11 and the pinned packages below.

```sh
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/python src/v5/build_body.py
.venv/bin/python tools/verify_package.py
```

The generator writes the two long-named STL files, geometry-validation.json, loft-data.npz and transition_flow_domain.stl next to src/v5/build_body.py. It uses the exact inherited gpu_interface.stl and engraving.stl, plus upstream/V140-POS1-reference.stl for comparison. It does not rely on any original workspace paths or printer services.

To update published geometry, inspect the build output and copy the assembly and fan_down STL to models/v5-raised22/assembly.stl and print-orientation.stl. Replace the mesh in Bambu Studio, reslice, inspect supports and update the 3MF, validation records, gallery and publication metadata together. Run tools/package_release.py to regenerate the distribution ZIP and checksums.

The source contains fixed geometric constants; design-parameters.json is the recorded measurement/configuration sheet, not an automatically loaded configuration. Editing the JSON alone does not change the generated model.

The inherited interface is retained as a mesh input; its original author source is supplied in upstream/. No native Fusion 360 history or STEP solid is claimed.
