# CMP170HX + Phanteks T30 — smooth duct, fan raised 22 mm

This remix connects a 120 mm Phanteks T30 to the measured CMP170HX card interface. The fan, collar and fan plate are raised by 22 mm compared with our earlier printed v4, to address an HDD-bay collision while keeping the GPU attachment and axial length unchanged.

**Printed prototype:** the three real photographs show the finished v5 in transparent light-blue PETG. The GPU attachment is unchanged from the previously fitted v4. Final v5 installation in the case, HDD clearance and operating temperatures have not yet been verified. CAD renders also show v5; the repository keeps the earlier v4 installation photo as reference.

## Changes from the original

The air path was reshaped to reduce restrictions and feed the card inlet more evenly. Rounded openings, fewer internal dividers and a tapered splitter replace abrupt obstructions.

During development, a preliminary airflow simulation compared our earlier **v2 and v4 prototypes at the same 20 CFM**. It indicated:

- **Lower pressure loss:** about **55% less** through the duct and short card entry, from 1.70 to 0.76 Pa.
- **More even air distribution:** variation in forward air speed across the card inlet fell from about **44% to 32%** (velocity CV; lower is better).
- **Smaller backflow zones:** the area with air moving in the wrong direction fell from about **5.4% to 2.0%** of the sampled inlet section.

These are preliminary v4-versus-v2 results, not measurements of the published v5. Strict numerical convergence was not reached; the simplified model omitted the fan rotor, heatsink fins and heat transfer. **The raised-fan v5 has not been simulated again**, and these numbers do not establish higher real fan airflow or lower GPU temperatures.

[Simulation comparison and velocity maps](https://github.com/aotd1/cmp170hx-t30-duct/blob/master/docs/AIRFLOW.md)

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
