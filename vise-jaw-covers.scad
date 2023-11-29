/* [Jaws] */

// The *interior* length of the jaw covers.  This should be the lenght of your vise's jaw (ie the size of your vise). The walls will be added to this size.
Jaw_Length = 104;

// The height of the jaws as measured from the bottom of the jaw to the top.
Jaw_Height = 19;

// The depth of the top surface, from the face of the jaw to the back of the part.
Jaw_Depth = 20;

// The thickness of the gripping portion of the jaw cover.
Soft_Grip_Depth = 9;



/* [Walls] */

// The thickness of the walls to either side of the jaw.
Side_Wall_Thickness = 2;

// The thickness of the top wall. Needs to be more than the magnets thickness, if present.
Top_Wall_Thickness = 3.15; // .01



/* [Magnets] */

// Number of magnet holes.
Magnets_Count = 2;

// The surface onto which the magnet holes are to be added.
Magnets_Surface = "top"; // [top:Top only, face:Face only, both:Both top and face]

// The shape of the magnets, circle or square.
Magnets_Shape = 0; // [0:Circle, 1:Square]

// Size of the magnets. For round magnets input the diameter, for square ones use the side of the square.
Magnets_Size = 10; // .01

// Height of the magnets. Make sure that your wall thickness is greater than this value.
Magnets_Depth = 3; // .01

// Spacing of the magnet holes. *Space around* sets the space to the edge to be half of the spacing between magnets; *Space evenly* keeps the same spacing between magnets and to the edges.
Magnets_Spacing = 0; // [0:Space around, 1:Space evenly]



/* [Grip Lines] */

// Create a grid of grip lines on the face of the jaw.
Grip_Lines = "yes"; // [yes, no]

// Jaw face spacing between grip lines
Grip_Lines_Depth = 1.5; // .1

// Jaw face spacing between grip lines
Grip_Lines_Spacing = 10; // .1

// Angle of the grip lines.  Values over 75 don't work so well.
Grip_Lines_Angle = 45;

// Horizontal offset, useful to remove small bits of grid from the sides.
Grip_Lines_Horizontal_Offset = 0; // .1

// Vertical offset, useful to remove small bits of grid from the top/bottom.
Grip_Lines_Vertical_Offset = 0; // .1



/* [Horizontal round stock holder] */

// Include a horizontal round stock holder
Horizontal_Round_Stock_Holder = "yes"; // [yes, no]

// Groove face size
Horizontal_Round_Stock_Holder_Depth = 7.5; // .1

// Angle scale of the groove faces. 1 = 45 degrees; <1 = smaller angles; >1 larger angles.
Horizontal_Round_Stock_Holder_Scale = 1; // .1



/* [Main vertical round stock holder] */

// Include a main vertical round stock holder
Main_Vertical_Round_Stock_Holder = "yes"; // [yes, no]

// Groove face size
Main_Vertical_Round_Stock_Holder_Depth = 7.5; // .1

// Angle scale of the groove faces. 1 = 45 degrees; <1 = smaller angles; >1 larger angles.
Main_Vertical_Round_Stock_Holder_Scale = 1; // .1

// Position of the stock holder groove as a percentage of the face (0 to 100).
Main_Vertical_Round_Stock_Holder_Position = 20;

// The angle of the round stock holder
Main_Vertical_Round_Stock_Holder_Angle = 0;



/* [Secondary vertical round stock holder] */

// Include a secondary vertical round stock holder
Secondary_Vertical_Round_Stock_Holder = "yes"; // [yes, no]

// Groove face size
Secondary_Vertical_Round_Stock_Holder_Depth = 7.5; // .1

// Angle scale of the groove faces. 1 = 45 degrees; <1 = smaller angles; >1 larger angles.
Secondary_Vertical_Round_Stock_Holder_Scale = 1; // .1

// Position of the stock holder groove as a percentage of the face (0 to 100).
Secondary_Vertical_Round_Stock_Holder_Position = 80;

// The angle of the round stock holder
Secondary_Vertical_Round_Stock_Holder_Angle = 0;



/* [Rendering options] */

// Which jaw(s) to create, left, right, or both. Can also be set to print a magnet hole fit test.
Generate_Objects = "both"; // [both: Both jaws, left: Left jaw, right: Right jaw, magtest: Magnet hole fit test]

// The orientation of the rendered jaw covers.
Orientation = 0; // [0: Top face down, 90: Front face down, 180: Top face up, 270: Front face up]

// Circle facets (increase for better visualization of round holes)
$fn = 100;




/***** Helper variables *****/

totalLength = Jaw_Length + (Side_Wall_Thickness*2);
totalWidth = Soft_Grip_Depth + Jaw_Depth;
totalHeight = Jaw_Height + Top_Wall_Thickness;

/***** Pre-render checks *****/

if (Horizontal_Round_Stock_Holder_Depth >= totalHeight)
{
	echo ("ERROR: *Horizontal_Round_Stock_Holder_Depth* should be less than *totalHeight*");
}

else if (Magnets_Count > 0 && Magnets_Surface != "face" && Top_Wall_Thickness <= Magnets_Depth)
{
	echo ("ERROR: *Magnets_Depth* should be less than *Top_Wall_Thickness*");
}

else if (Magnets_Count > 0 && Magnets_Surface != "face" && Jaw_Depth <= Magnets_Size)
{
	echo ("ERROR: *Magnets_Size* should be less than *Jaw_Depth*");
}

else {
	Render();
}



module Render() {
	if (Generate_Objects == "magtest")
	{
		CreateMagnetHoleTest(Magnets_Size, Magnets_Depth, Magnets_Shape);
	}
	else 
	{
		CreateJaws();
	}
}

module CreateJaws()
{
	if (Generate_Objects != "right")
	// Create the first jaw
	{
		rotate ([Orientation, 0, 0])
		{
			CreateJaw();
		}
	}
	if (Generate_Objects != "left")
	// Create the second jaw
	{
		// The translation amount depends heavily on the angle. Without this they end up
		// a long way apart or overlapping
		if (Orientation < 45)
		{
			CreateSecondJaw(-3);
		}
		else if (Orientation < 90)
		{
			CreateSecondJaw(-2);
		}
		else if (Orientation < 200)
		{
			CreateSecondJaw(-1);
		}
		else
		{
			CreateSecondJaw(1);
		}
	}
}

module CreateSecondJaw(translationSize)
{
	mirror([0, 1, 0])
	{
		// Move over a little and create a second jaw
		translate([0, totalWidth * translationSize, 0])
		{
			rotate ([Orientation, 0, 0])
			{
				CreateJaw();
			}
		}
	}
}

module CreateJaw()
{
	difference()
	{
		// The full jaw size
		cube([totalLength, totalWidth, totalHeight], false);


		// Subtract the "interior" of the jaws
		translate([Side_Wall_Thickness, Soft_Grip_Depth, Top_Wall_Thickness])
		{
			cube([Jaw_Length, totalWidth, totalHeight], false);
		}


		// Add magnet holes to top surface
		if (Magnets_Count > 0 && Magnets_Surface != "face")
		{
			holeCenter = Jaw_Depth/2+Soft_Grip_Depth;
			// Subtract holes for the magnets
			translate([Side_Wall_Thickness, holeCenter, Top_Wall_Thickness - Magnets_Depth])
			{
				CreateMagnetHoles(Magnets_Count, Jaw_Length, Magnets_Size, Magnets_Depth, Magnets_Shape, Magnets_Spacing); 
			}
		}


		// Add magnet holes to face surface
		if (Magnets_Count > 0 && Magnets_Surface != "top")
		{
			translate([Side_Wall_Thickness, Soft_Grip_Depth-Magnets_Depth, Jaw_Height/2 + Top_Wall_Thickness])
			{
				rotate([-90,0,0])
				{
					CreateMagnetHoles(Magnets_Count, Jaw_Length, Magnets_Size, Magnets_Depth, Magnets_Shape, Magnets_Spacing);
				}	
			}
		}
		
		
		// Carve lines for the face "grip" pattern
		if (Grip_Lines == "yes")
		{
			translate([Grip_Lines_Horizontal_Offset, 0, Grip_Lines_Vertical_Offset]) {
				CreateGrip(Grip_Lines_Spacing, totalLength, totalHeight, Grip_Lines_Angle);
			}
		}


		// Create horizontal round stock holder
		if (Horizontal_Round_Stock_Holder == "yes")
		{
			translate([0, 0, (totalHeight / 2)])
			{
				rotate([0,90,0])
				{
					CreateRoundStockHolderGroove(Horizontal_Round_Stock_Holder_Depth, Jaw_Length, Horizontal_Round_Stock_Holder_Scale);
				}
			}
		}


		// Create main vertical round stock holder
		if (Main_Vertical_Round_Stock_Holder == "yes" )
		{
			translate([(totalLength * (Main_Vertical_Round_Stock_Holder_Position / 100)), 0, 0])   
			{
				rotate([0, Main_Vertical_Round_Stock_Holder_Angle, 0])
				{
					CreateRoundStockHolderGroove(Main_Vertical_Round_Stock_Holder_Depth, totalHeight, Main_Vertical_Round_Stock_Holder_Scale);
				}   
			}
		}

		// Create secondary vertical round stock holder
		if (Secondary_Vertical_Round_Stock_Holder == "yes" )
		{
			translate([(totalLength * (Secondary_Vertical_Round_Stock_Holder_Position / 100)), 0, 0])   
			{
				rotate([0, Secondary_Vertical_Round_Stock_Holder_Angle, 0]) 
				{
					CreateRoundStockHolderGroove(Secondary_Vertical_Round_Stock_Holder_Depth, totalHeight, Secondary_Vertical_Round_Stock_Holder_Scale);
				}  
			}
		}
	}
}

module CreateMagnetHoles(magnetCount, length, size, depth, magnetType, spacing)
{
	jawLenghtMinusMangetHoles = (length - (size * magnetCount));
	spaceBetweenCircles = jawLenghtMinusMangetHoles / (magnetCount + spacing);
	spaceBetweenCenters = spaceBetweenCircles + size;
	firstSpace = (spaceBetweenCircles / 2) + (size / 2) + ((spaceBetweenCircles / 2) * spacing);
	
	// Cubes are created with the corner at origin, so we need to translate by half the side dimension
	// Using magnetType the compensation is 0 for cylindrical magnets
	squareCornerCompensation = magnetType * (size/2);
	
	for (moveCount = [0:magnetCount-1])
	{
		x = firstSpace + (spaceBetweenCenters * moveCount) - squareCornerCompensation;
		y = - squareCornerCompensation;
		translate([x, y, 0])
		{
			if (magnetType == 0)
			{
				cylinder(depth*2, d=size, center=false);
			}
			else
			{
				cube([size, size, depth*2], center=false);
			}
		}
	}
}

module CreateGrip(spacing, length, height, angle)
{
	extendedLength = length * 4;
	horizontalMovementCount = extendedLength / spacing;
	// First pass at the given angle
	CreateGripLines(angle, horizontalMovementCount, spacing, height, length);
	// Second pass at the opposite of that angle
	CreateGripLines(-angle, horizontalMovementCount, spacing, height, length);
}

module CreateGripLines(angle, movementCount, spacing, height, extendedLength)
{
	// If we're going to do an angle movement we have to
	// back off a bit so that the angles intersect the main cube
	translate([-extendedLength, 0, 0])
	{
		for(moveCount = [1:movementCount])
		{
			translate([moveCount * spacing, 0, 0])
			{
				// Rotate to the grip angle that the user specified
				rotate ([0, angle, 0])
				{
					// Turn so that the grip is nicely beveled and easier to print
					// than square edges.  We're rotating separately here because if you 
					// put both values in the same rotation it rotates first one way
					// then the other and you really don't end up where you wanted to be
					rotate([0, 0, 45])
					{
						cube([Grip_Lines_Depth, Grip_Lines_Depth, height * 10], true);
					}
				}
			}
		}
	}
}

module CreateRoundStockHolderGroove(size, length, scale)
{
	//cubeSideLength = (size/2) * sqrt(2); // This defines the groove as the diagonal measure
	cubeSideLength = size;
	// Rotate so that we get a V groove that round stock fits in nicely
	scale([scale * 1, 1, 1])
	{
		rotate([0, 0, 45])
		{
			// Long length to make sure that we don't miss any edges
			cube([cubeSideLength, cubeSideLength, length * 20], true);
		}
	}
}

module CreateMagnetHoleTest(size, depth, type)
{
	side = size + 4; // Leaving 2mm margin
	difference()
	{
		cube([side, side, depth + 0.25]); // Create base plate
		translate([side/2, side/2, 0.25]) {
			if (type == 0 ) {
				cylinder(h = depth*2, d = size);
			}
			else
			{
				translate([0, 0, depth+0.25]) { // Needed to offset cube with 3D center on origin
					cube([size, size, depth*2], center=true);
				}
			}	
		}
	}		
}	