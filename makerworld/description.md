# CMP170HX + Phanteks T30 — smooth duct, fan raised 22 mm

This remix connects a 120 mm Phanteks T30 to the measured CMP170HX card interface. The fan, collar and fan plate are raised by 22 mm compared with our earlier printed v4, to address an HDD-bay collision while keeping the GPU attachment and axial length unchanged.

**Prototype status:** the earlier v4 was printed and fitted. v5 is sliced, but the finished v5 installation and operating temperatures are not yet verified. CAD renders show v5; the real installation photograph is explicitly labelled v4 reference.

## Changes from the original

Measured GPU windows, rounded entry edges, fewer internal dividers, tapered horizontal splitter, smooth 75 mm transition, 5 mm collar, 4 mm fan plate and nominal 2 mm XY shell offset. v5 adds the 22 mm physical upward shift. The original attribution is retained.

## Printing

P1S, PETG, 0.4 mm nozzle, 0.2 mm layers, 3 walls, 20% gyroid, 5 top/bottom layers. Print with the fan flange flat on the bed. Tree supports from the build plate are required: 0.2 mm top Z gap and 3 interface layers. Support images are generated from the actual local slice.

The editable 3MF uses the trial NIT PETG profile at 250/75 °C. Map your own filament slot and reslice. Estimate: 5 h 22 min and 102.88 g including supports, 120 × 120 × 104 mm print envelope. No ready-to-run G-code is provided.

## Fit and assembly

Measured card end: 98 × 38.5 mm. Main window: 94.3 × 23.65 mm, narrowing to 92.5 mm over 6 mm. GPU screw spacing: 28.5 mm; fan spacing: 105 mm. Verify fit on your card revision. A100 compatibility has not been tested.

Place the fan's outlet side (label and support struts) toward the duct/card. Use two GPU screws matched to the actual card and four suitable fan mounts; check screw length and EPS clearance. Support the fan end independently and avoid overtightening the GPU attachment. Allow roughly 124 mm from the GPU end including the T30, plus assembly/cable clearance.

Check HDD travel and upper clearances before use. No v5 CFD, temperature improvement or long-term PETG strength is claimed.

## Source and license

Remix of **K. Crisafulli / kelleec — CMP170HX / A100 120mm Fan Adapter 4 shroud locations**, V1.40 POS1:
https://www.thingiverse.com/thing:7411932

**CC BY-SA 4.0** — personal and commercial printing allowed, with attribution and share-alike terms:
https://creativecommons.org/licenses/by-sa/4.0/

Source, STL, editable 3MF and updates:
https://github.com/aotd1/cmp170hx-t30-duct
