# OpenSCAD Vise Jaw Covers (soft grip)

A fully parameterised [OpenSCAD](https://openscad.org/) model for generating soft grip vise jaw covers.

## Features

### Dimensions
Precise control over all dimensions, driven by the size of the jaw (easily measured) and the desired thickness of the walls and surfaces. No calculations needed, only a pair of calipers.

### Magnets

- **Shape** - Round or square.

- **Size** - Diameter (round) or side length (square).

- **Depth** - Depth of the magnet hole.

All settings above can be checked by printing a magnet hole fit test.

- **Number** - Set the number of magnet holes (same on both faces).

- **Position** - Magnet holes can be positioned to stick to the top of the jaw, to the front, or both.

- **Spacing** - 2 options for spacing available:
  - Space around: keeps the space around each magnet constant, so the space _between_ magnets is twice the space to the edge.
  - Space evenly: keeps the space between magnets and the space to the edge the same.
  
### Grip lines
A grid of grip lines on the surface of the cover, to improve grip on smooth materials. Can be turned ON/OFF and customised.

- **Depth** - How deep the lines cut into the surface.

- **Spacing** - The spacing between the lines.

- **Angle** - The angle between the lines (default 45°).

- **Offset** - Horizontal and vertical offset, to help getting rid of bit of the grid that are too small to be printed correctly.

### Round stock holders
1 horizontal and up to 2 vertical round stock holders, individually configurable.
 - **Size** - The aperture of the groove, ie the minimum size of stock that can be gripped with the jaws fully closed (assuming an angle scale of 1).

 - **Angle scale** - This can be used to make the groove aperture wider or narrower without affecting the depth.

 - **Position** - Customise the vertical holder position relative to the edge of the face.

 - **Holder angle** - Either one of the vertical holders can be set at an angle.

### Rendering

- Generate either the left jaw, the right one, or both
- Generate a magnet hole fit test to verify tollerances
- Change the orientation of the rendered objects to help with 3D printing
- Change the number of segments for round features

### Other features

- No phantom surface issue deriving from undersized solid intesections.
- Some validation of input parameters to avoid conflicts of settings (check the render log for the error messages).

---

Originally derived from the following projects on Printables:
- [Customizable Vise Soft Jaws (fully parametric!)](https://www.printables.com/model/12846-customizable-vise-soft-jaws-fully-parametric) by user **DT**
- [Remix - Customizable soft jaws for vise (fully parametric)](https://www.printables.com/model/85269-remix-customizable-soft-jaws-for-vise-fully-parame) by user **MojoRuns**

The majority of the code has been rewritten or heavily modified. The original reason to rewrite it was to change the dimension parameters from the size of the finished cover (requiring calculations) to instead derive from the measures of the vise jaw. Also, the original models had issue with phantom surfaces showing up in the preview (from undersized solid cutting), which made visualising the preview hard.

Also, this was my first foray at OpenSCAD development, so a great learning project.
