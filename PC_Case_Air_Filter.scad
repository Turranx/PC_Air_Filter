$fn=60;

// Vegetables
module filter (){
        union(){
            // Base
            // NOTE:  These measurements are tight.
            color("blue") translate([0,0,06.5/2])cube([131,112,06.5],center=true);
            
            // Pleats
            // NOTE:  The X/Y measurements are loose.
            //        The z   meassurement is  tight.
            color("white")translate([0,0,21.0/2])cube([117,101,21.0],center=true);
        };
};
;
module pressureFitting() {
    
    color("blue")
    translate([0,0,21])
    cylinder(h=7,d=4.5);
    
    color("gray")
    translate([0,0,14])
    cylinder(h=7,d=4.5);
    
    color("red")
    translate([0,0,7])
    cylinder(h=7,d=4.5);
    
    color("black")
    cylinder(h=7,d=4.5);
    
    
};
;
module countersinkWasher(){
    cylinder(h=10,d=8);
};
;
module countersinkNumber6Nut(){
    translate([0,0,4.7])
    cylinder(d=10,h=10,$fn=6);  // <-- Hole wide enough to encompass entire nut
    cylinder(d=7.5,h=10,$fn=6); // <-- Hole slightly smaller than nut to ensure it melts the sides
};
;
module countersinkNumber6Head(){
    cylinder(h=10,d=7);
};
;
module countersinkNumber6Washer(){
    cylinder(d=11,h=20);
};
;
module shaftNumber6(){
    cylinder(d=4,h=14);
};
;
module shaftNumber6wide(){
    cylinder(d=5,h=14);
};
;

module basePlate2(){
        union(){
            difference() {
                translate([0,0,15])cube([140,140,30],center=true);
                
                // Center Hole
                translate([0,0,20])cube([134-14*2,116-14*2,30],center=true);
                
                // Filter
                translate([0,0,21])rotate([180,0,0])
                minkowski() {
                    filter();
                    
                    // Widen X & Y, but not Z
                    cube([1,1,0.1],center=true);
                };
                ;
                
                // Pressure Plate
                minkowski() {
                    pressurePlateSolid();
                    
                    // This provides 3mm of empty space to squish the blue rubber filter
                    cube([1,1,3],center=true);
                };
                
                // Chassis Mounting Holes
                color("red")  translate([+124.5/2,+124.5/2,-1])resize([0,0,40])pressureFitting();
                color("green")translate([+124.5/2,-124.5/2,-1])resize([0,0,40])pressureFitting();
                color("blue") translate([-124.5/2,+124.5/2,-1])resize([0,0,40])pressureFitting();
                color("pink") translate([-124.5/2,-124.5/2,-1])resize([0,0,40])pressureFitting();
            };
        };
};
;
module pressurePlateSolid(){
        translate([0,0,8])
        union() {
            color("green")  // runs along y-axis
            cube([114,136,16],center=true);
            
            color("orange") // runs along x-axis
            cube([136,114,16],center=true);
        };
};
;
module pressurePlate(){
    translate([0,0,8])
    union() {

        difference() {
            color("blue")
            translate([0,0,-8])
            pressurePlateSolid();
            
            // Center Hole
            color("white")
            cube([117,101,20],center=true);
            
            color("purple")
            minkowski() {
                translate([0,0,13])
                rotate([180,0,0])
                filter();
                
                // Widen X & Y, but not Z
                cube([1,1,0.1],center=true);
            };
            
        };
    };
};
;
module fanMount(fanSize=80){
    // Constants
    fanHeight                  =  38;
    fanBoxHeight               =  fanHeight-3; // Subtract 3mm 
    pyramidHeightInner         =  25;
    pyramidHeightOuter         =  pyramidHeightInner;

    // Calculated Parameters
    fanWidth   = fanSize;
    bladeWidth = fanWidth - 2;

    translate([0,0,0.5])
    union() {
        // Fan Box
        rotate(rotateFanBox(fanSize))
        translate([0,0,pyramidHeightInner+10+fanBoxHeight/2-1])
        union() {
            difference() {
                // Outside
                cube([fanBoxWidth(fanSize),fanBoxWidth(fanSize),fanBoxHeight],center=true);
                
                // Inside
                translate([0,0,-0.1])
                cube([fanWidth+1,fanWidth+1,fanBoxHeight+2],center=true);
                
                // Hole For Wire
                // Fans have wires in different locations, so multiple holes
                translate([+(fanWidth/2-15),-53,5.01])
                cube([7,60,fanBoxHeight-10],center=true);
                
                // Hole For Wire
                // Fans have wires in different locations, so multiple holes
                translate([-(fanWidth/2-15),-53,5.01])
                cube([7,60,fanBoxHeight-10],center=true);
            };
            
        };
        ;
        

        // Round Air Shaft
        rotate(a=rotateFanBox(fanSize))
        translate([0,0,pyramidHeightInner+4])
        union() {
            difference() {
                color("blue")
                //translate([0,0,2])
                cube([fanBoxWidth(fanSize),fanBoxWidth(fanSize),10],center=true);
                FanHole(fanSize);
                //cylinder(d=bladeWidth,h=20,center=true);
                
                // Fan Box Mounting Holes (Variable fan size)
                X3 = fanMountingHoleDistance_(fanSize)/2;
                Y3 = fanMountingHoleDistance_(fanSize)/2;
                Z3 = -1;

                echo(fanSize);
                echo(X3);
                echo(Y3);
                
                color("pink")     translate([+X3,+Y3,Z3])countersinkNumber6Nut();
                color("seagreen") translate([+X3,-Y3,Z3])countersinkNumber6Nut();
                color("lightblue")translate([-X3,+Y3,Z3])countersinkNumber6Nut();
                color("gray")     translate([-X3,-Y3,Z3])countersinkNumber6Nut();
                
                // Fan Box Screw Shafts (Variable fan size)
                X2 = fanMountingHoleDistance_(fanSize)/2;
                Y2 = fanMountingHoleDistance_(fanSize)/2;
                Z2 = -10.99;
                //Z2 = -12.99;
                color("pink")     translate([+X2,+Y2,Z2])shaftNumber6wide();
                color("seagreen") translate([+X2,-Y2,Z2])shaftNumber6wide();
                color("lightblue")translate([-X2,+Y2,Z2])shaftNumber6wide();
                color("gray")     translate([-X2,-Y2,Z2])shaftNumber6wide();
            };
        };
        ;
        
        // Pyramid
        difference() {
            // Outside
            hull() {
                // Top
                rotate(a=rotateFanBox(fanSize))
                translate([0,0,pyramidHeightOuter-2])
                cube([fanBoxWidth(fanSize),fanBoxWidth(fanSize),2],center=true);
                
                // Base
                cube([140,140,1],center=true);
            };
            ;
            // Hollow Inside
            hull () {
                // Top
                rotate(rotateFanBox(fanSize))
                translate([0,0,pyramidHeightOuter-1])
                //cylinder(d=bladeWidth,h=0.01,center=true);
                FanHole(fanSize,blobHeight1=0.1);
                
                // Bottom
                translate([0,0,-0.1])
                cube([134-14*2,116-14*2,1],center=true);
            };
            ;
            
            // Remove visual artifacts at boundary 
            //where pyramid and air shaft meet
            *translate([0,0,pyramidHeightOuter-1])
            cylinder(d=bladeWidth,h=5,center=true);
            
            
            // Chassis Mounting Holes (140mm fan size)
            X1 = fanMountingHoleDistance_(140)/2;
            Y1 = fanMountingHoleDistance_(140)/2;

            color("red")      translate([+X1,+Y1,-2])pressureFitting();  
            color("pink")     translate([+X1,+Y1,3])countersinkNumber6Washer();
            
            color("green")    translate([+X1,-Y1,-2])pressureFitting();
            color("seagreen") translate([+X1,-Y1,3])countersinkNumber6Washer();
            
            color("blue")     translate([-X1,+Y1,-2])pressureFitting();
            color("lightblue")translate([-X1,+Y1,3])countersinkNumber6Washer();
            
            color("silver")   translate([-X1,-Y1,-2])pressureFitting();
            color("gray")     translate([-X1,-Y1,3])countersinkNumber6Washer();

            rotate(a=rotateFanBox(fanSize))
            union(){    
                // Fan Box Screw Shafts (Variable fan size)
                X2 = fanMountingHoleDistance_(fanSize)/2;
                Y2 = fanMountingHoleDistance_(fanSize)/2;
                //Z2 = 22;
                Z2 = 19;
                color("pink")     translate([+X2,+Y2,Z2])shaftNumber6wide();
                color("seagreen") translate([+X2,-Y2,Z2])shaftNumber6wide();
                color("lightblue")translate([-X2,+Y2,Z2])shaftNumber6wide();
                color("gray")     translate([-X2,-Y2,Z2])shaftNumber6wide();
            };
        };
    };
    ;
}
;
function fanMountingHoleDistance_(fanDiameter) =
        (fanDiameter == 140) ? 124.5:
        (fanDiameter == 120) ? 105.0:
        (fanDiameter ==  92) ?  82.5:
        (fanDiameter ==  80) ?  71.5:
        (fanDiameter ==  70) ?  60.0:10;
;
function fanBoxWidth(fanDiameter) =
        (fanDiameter == 120) ? 122:
        (fanDiameter ==  92) ? 96:
        (fanDiameter ==  80) ? 96:
        (fanDiameter ==  70) ? 96:10;
;
function rotateFanBox(fanDiameter) =
        (fanDiameter == 120) ? [0,0,6]:       // Six degrees of rotation to make room for washers bolts.
        (fanDiameter ==  92) ? [0,0,0]:       // Disable rotation
        (fanDiameter ==  80) ? [0,0,0]:       // Disable rotation
        (fanDiameter ==  70) ? [0,0,0]:[0,0,0];     // Disable rotation
;
module fanCover(fanSize=80){
    // Constants
    fanHeight                  =  38;
    fanBoxHeight               =  fanHeight;
    pyramidHeightInner         =  25;
    pyramidHeightOuter         =  pyramidHeightInner;

    // Calculated Parameters
    fanWidth   = fanSize;
    bladeWidth = fanWidth - 2;

    rotate(a=rotateFanBox(fanSize))    
    union() {
        // Fan Box
        translate([0,0,0])
        union() {
            difference() {
                // Outside
                translate([0,0,1])
                cube([fanBoxWidth(fanSize),fanBoxWidth(fanSize),fanBoxHeight+2],center=true);
                
                // Inside
                translate([0,0,-0.1])
                cube([fanWidth+1,fanWidth+1,fanBoxHeight+2],center=true);
                
                // Hole For Wire
                // Fans have wires in different locations, so multiple holes
                translate([+(fanWidth/2-15),-43,5.01])
                cube([7,30,fanBoxHeight-10],center=true);
                
                // Hole For Wire
                // Fans have wires in different locations, so multiple holes
                translate([-(fanWidth/2-15),-43,5.01])
                cube([7,30,fanBoxHeight-10],center=true);

                // Exhaust Hole
                translate([0,0,20])
                FanHole(fanSize=fanSize,blobHeight1=20);

                // Fan Box Screw Shafts (Variable fan size)
                X2 = fanMountingHoleDistance_(fanSize)/2;
                Y2 = fanMountingHoleDistance_(fanSize)/2;
                Z2 = 10;
                color("pink")     translate([+X2,+Y2,Z2])shaftNumber6();
                color("seagreen") translate([+X2,-Y2,Z2])shaftNumber6();
                color("lightblue")translate([-X2,+Y2,Z2])shaftNumber6();
                color("gray")     translate([-X2,-Y2,Z2])shaftNumber6();


                // The Fan Exhaust Cover
                    // If a fanmount failed to finish printing, but it got part of the way up the 38mm thickness of the fan, follow these instructions.
                    // 1. Pull the semi-printed object off the metal print bed
                    // 2. Put the fan into the fanmount
                    // 3. Use your calipers to measure how much of the fan is uncovered.  Example:  15.52mm
                    // 4. Put that value into the Z-value in line AAAA (below) like this: [0,0,15.52]

                    // If the fanmount printed OK, leave AAAA at [0,0,3]
                color("orange")
                rotate([180,0,0])     // <-- Rotated so translate (directly below) now works inverted
                translate([0,0,3])    // <-- AAAA
                translate([0,0,100 - (fanBoxHeight+1.8)/2]) // Do Not Change.  Ever. 
                cube([200,200,200],center=true);
            };
        };
        ;
    };
    ;
}
;
module FanHole(fanSize,blobHeight1=20) {
    exitDiameter = 
        (fanSize == 120) ? 125:
        (fanSize ==  92) ? 103:
        (fanSize ==  80) ? 89:
        (fanSize ==  70) ? 77:10;

    color("gray")
    intersection() {
        cylinder(d=exitDiameter,h=blobHeight1,center=true);
        cube([fanSize-2,fanSize-2,blobHeight1 + 0.02],center=true);
    };
};

fanSize_ = 120;  // Acceptable Values: 120, 92, 80, 70
difference() {
    union() {
        translate([0,0,110]) fanCover(fanSize_);

        // Adding a Gap Filler Under The Fan Cover
        // Not Needed For Most Prints, so Leave Disabled
        *translate([0,0,126.38])
        render()
        intersection() {
            linear_extrude(3.52) projection(cut = false) fanCover(fanBoxWidth(fanSize));
            cube([fanSize_,fanSize_,100],center=true);
        };    

        translate([0,0,30])fanMount(fanSize_);  
        pressurePlate();
        basePlate2();
        
        *translate([0,0,21])rotate([180,0,0])filter();
    };

    // Countersink Washers
        translate([+50,+124.5/2,-0.01])countersinkWasher();
        translate([+00,+124.5/2,-0.01])countersinkWasher();
        translate([-50,+124.5/2,-0.01])countersinkWasher();
        translate([+50,-124.5/2,-0.01])countersinkWasher();
        translate([+00,-124.5/2,-0.01])countersinkWasher();
        translate([-50,-124.5/2,-0.01])countersinkWasher();
    
    // Pressure Fitting Mounting Holes
        translate([+50,+124.5/2,0])pressureFitting();
        translate([+00,+124.5/2,0])pressureFitting();
        translate([-50,+124.5/2,0])pressureFitting();
        translate([+50,-124.5/2,0])pressureFitting();
        translate([+00,-124.5/2,0])pressureFitting();
        translate([-50,-124.5/2,0])pressureFitting();    
};

*translate([0,0,21])rotate([180,0,0])filter();


// 2-Inch #6 Bolt depth gauge
// Four of these bolts secure the fan in the fan box.
*translate([36,36,52])
cylinder(d=2,h=51);

*color("black")
translate([0,50,12.7])
cube([20,20,16.6],center=true);
