//Dimensions of the flume and free surface
l = 6;
hm = 0.4;
h = 0.3;
wt = 0.01;
H = 0.06;

// Characteristic mesh length
lc = 0.009; 

// Define points with coordinates and characteristic length
Point(1) = {0, 0, 0, lc};
Point(2) = {l, 0, 0, lc};
Point(3) = {0, hm, 0, lc};
Point(4) = {l, hm, 0, lc};

// Define lines connecting the points
Line(1) = {1,2};
Line(2) = {2,4};
Line(3) = {4,3};
Line(4) = {3,1};

// Define a curve loop using the lines
Curve Loop(1) = {1, 2, 3, 4};

// Create a surface from the curve loop
Plane Surface(1) = {1};

// Divide the surface into elements
Transfinite Surface {1};
Recombine Surface {1};

// Extrude the surface to create a volume
Extrude {0, 0, wt} {
    Surface{1}; Layers{2}; Recombine;
}

// Define the volume as transfinite
Transfinite Volume {1};

// Assign physical names to surfaces and volumes
Physical Surface("lowerWall") = {13};
Physical Surface("sides") = {1,26};
Physical Surface("rightWall") = {17};
Physical Surface("inlet") = {25};
Physical Surface("atmosphere") = {21};
Physical Volume("internal") = {1};

// Define a field for the fine mesh
Field[1] = Box;

// Set the field where the mesh will be fine
Field[1].VIn = lc/2.5;
Field[1].XMin = 0;
Field[1].XMax = l;
Field[1].YMin = h-H;
Field[1].YMax = h+H;
Field[1].ZMin = 0;
Field[1].ZMax = wt;

// Apply the field as background
Background Field = 1;
