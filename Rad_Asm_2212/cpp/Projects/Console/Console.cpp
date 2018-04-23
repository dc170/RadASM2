
#include "iostream.h"
#include <math.h>


// Variable declarations

// rad    is the radius
// area   is the surface area
// volume is the volume of the sphere

float rad, area, volume;
float pi = 3.14159;

main()
{

   cout << "Enter the radius of the sphere ";
   cin  >> rad;

// Compute the surface area and volume of the sphere.

   area = 4. * pi * pow(rad,2);
   volume = (4.0 / 3.0) * pi * pow(rad,3);

/* Print the values of the radius (given in cm), the surface
   area (sq cm), and the volume (cubic cm).*/

   cout << "\n";
   cout << rad << " cm is the value of the radius\n\n";
   cout << "In a sphere of radius " << rad
        << " cm, the surface area is " << area
        << " sq cm \nand its volume is " << volume
        << " cubic cm.\n\n";

   cin  >> rad;

return(0);
}

