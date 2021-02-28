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
    cylinder(d=7,h=10,$fn=6);
};
;
module countersinkNumber6Head(){
    cylinder(h=10,d=7);
};
;
module countersinkNumber6Washer(){
    cylinder(d=11,h=10);
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
module pressurePlateSolid (){
        translate([0,0,8])
        union() {
            color("green")  // runs along y-axis
            cube([114,136,16],center=true);
            
            color("orange") // runs along x-axis
            cube([136,114,16],center=true);
        };
};
;
module pressurePlate (){
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
module fanMount(){
    // Constants
    fanMountingHoleDistance140 = 124.5;  // Fan Size: 140mm
    fanMountingHoleDistance120 = 105.0;  // Fan Size: 120mm
    fanMountingHoleDistance92  =  82.5;  // Fan Size:  92mm
    fanMountingHoleDistance80  =  71.5;  // Fan Size:  80mm
    fanMountingHoleDistance70  =  60.0;  // Fan Size:  70mm
    
    // Human Provided Parameters
    fanWidth           = 80;  // 92, 80, 70
    fanHeight          = 38;
    bladeWidth         = 78;  // 90, 78, 68
    pyramidHeightInner = 25;
    fanMountingHoleDistance = fanMountingHoleDistance80;
    
    // Calculated Parameters
    fanBoxWidth  = 96;//fanWidth + 4;
    fanBoxHeight = fanHeight;//fanHeight + 4;
    pyramidHeightOuter = pyramidHeightInner;
    
    
    
    translate([0,0,0.5])
    union() {
        // Fan Box
        translate([0,0,pyramidHeightInner+10+fanBoxHeight/2-1])
        union() {
            difference() {
                // Outside
                cube([fanBoxWidth,fanBoxWidth,fanBoxHeight],center=true);
                
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
            };
        };
        ;
        
        
        
        // Round Air Shaft
        
        translate([0,0,pyramidHeightInner+4])
        difference() {
            color("blue")
            //translate([0,0,2])
            cube([fanBoxWidth,fanBoxWidth,10],center=true);
            cylinder(d=bladeWidth,h=20,center=true);
            
            // Fan Box Mounting Holes (Variable fan size)
            X3 = fanMountingHoleDistance/2;
            Y3 = fanMountingHoleDistance/2;
            Z3 = -1;
            color("pink")     translate([+X3,+Y3,Z3])countersinkNumber6Nut();
            color("seagreen") translate([+X3,-Y3,Z3])countersinkNumber6Nut();
            color("lightblue")translate([-X3,+Y3,Z3])countersinkNumber6Nut();
            color("gray")     translate([-X3,-Y3,Z3])countersinkNumber6Nut();
            
            // Fan Box Screw Shafts (Variable fan size)
            X2 = fanMountingHoleDistance/2;
            Y2 = fanMountingHoleDistance/2;
            Z2 = -10.99;
            //Z2 = -12.99;
            color("pink")     translate([+X2,+Y2,Z2])shaftNumber6wide();
            color("seagreen") translate([+X2,-Y2,Z2])shaftNumber6wide();
            color("lightblue")translate([-X2,+Y2,Z2])shaftNumber6wide();
            color("gray")     translate([-X2,-Y2,Z2])shaftNumber6wide();
        };
        ;
        
        // Pyramid
        difference() {
            // Outside
            hull() {
                // Top
                translate([0,0,pyramidHeightOuter-2])
                cube([fanBoxWidth,fanBoxWidth,2],center=true);
                
                // Base
                cube([140,140,1],center=true);
            };
            ;
            // Hollow Inside
            hull () {
                // Top
                translate([0,0,pyramidHeightOuter-1])
                cylinder(d=bladeWidth,h=0.01,center=true);
                
                // Bottom
                translate([0,0,-0.1])
                cube([134-14*2,116-14*2,1],center=true);
            };
            ;
            
            // Remove visual artifacts at boundary 
            //where pyramid and air shaft meet
            translate([0,0,pyramidHeightOuter-1])
            cylinder(d=bladeWidth,h=5,center=true);
            
            // Chassis Mounting Holes (140mm fan size)
            X1 = fanMountingHoleDistance140/2;
            Y1 = fanMountingHoleDistance140/2;

            color("red")      translate([+X1,+Y1,-2])pressureFitting();  
            color("pink")     translate([+X1,+Y1,3])countersinkNumber6Washer();
            
            color("green")    translate([+X1,-Y1,-2])pressureFitting();
            color("seagreen") translate([+X1,-Y1,3])countersinkNumber6Washer();
            
            color("blue")     translate([-X1,+Y1,-2])pressureFitting();
            color("lightblue")translate([-X1,+Y1,3])countersinkNumber6Washer();
            
            color("silver")   translate([-X1,-Y1,-2])pressureFitting();
            color("gray")     translate([-X1,-Y1,3])countersinkNumber6Washer();
            
            // Fan Box Screw Shafts (Variable fan size)
            X2 = fanMountingHoleDistance/2;
            Y2 = fanMountingHoleDistance/2;
            //Z2 = 22;
            Z2 = 19;
            color("pink")     translate([+X2,+Y2,Z2])shaftNumber6wide();
            color("seagreen") translate([+X2,-Y2,Z2])shaftNumber6wide();
            color("lightblue")translate([-X2,+Y2,Z2])shaftNumber6wide();
            color("gray")     translate([-X2,-Y2,Z2])shaftNumber6wide();
        };
    };
    ;
}
;


difference() {
    union() {
        translate([0,0,30])fanMount();
        *pressurePlate();
        *basePlate2();
        
        *translate([0,0,21])rotate([180,0,0])filter();
    }
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
    
    
    //color("orange") translate([0,43,0])cube([200,200,200],center=true);
    //color("orange") translate([43,0,0])cube([200,200,200],center=true);
    //color("orange") translate([0,0,110])cube([200,200,200],center=true);
};
//fanMount();
*translate([0,0,21])rotate([180,0,0])filter();
//color("green")

// 2-Inch #6 Bolt depth gauge
// Four of these bolts secure the fan in the fan box.
*translate([36,36,52])
cylinder(d=2,h=51);