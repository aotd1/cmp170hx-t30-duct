# Publishing and updates

The configured origin is the working repository. Its one-way GitHub mirror synchronizes after pushes and once an hour. Public documentation links only to GitHub and MakerWorld. Mirror synchronization copies Git references, not GitHub release attachments or MakerWorld listings.

1. Update geometry and the editable 3MF together. Rebuild, verify the mesh/package, reslice if geometry or print settings change, and inspect support placement.
2. Update version, changelog, attribution, evidence status, pictures and MakerWorld description. Keep unverified fit/thermal claims out of the listing.
3. Run `python tools/verify_package.py` and `python tools/package_release.py`. Commit the intended changes, push to origin and verify that GitHub has the same commit.
4. Create or update a draft GitHub release and attach the ZIP, SHA256SUMS.txt, print-oriented STL and editable 3MF. Tags and release attachments must refer to the same commit.
5. Review the saved MakerWorld remix draft, its source link and CC BY-SA 4.0 license. Three photographs/views of the actual v5 print are supplied. Record the final installation clearance result before claiming that the raised revision has been fitted.
6. On publication, replace the owner-only draft link in README.md and publication.json with the public model URL, and update the GitHub release and MakerWorld files together.

Current candidate: 0.1.0. MakerWorld and GitHub release remain drafts. A draft release is visible only to repository collaborators with the necessary access.
