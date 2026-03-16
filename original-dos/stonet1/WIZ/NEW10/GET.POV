// GET.POV - vyukovy soubor k programu POVRAY 2.0
// Povray

// definice knihoven,ktere se budou na scene vyuzivat

#include "colors.inc"
#include "textures.inc"
#include "shapes.inc"


// Definice kamery
 camera{
        location<0,45,-45> 
          // umisteni kamery
        direction<0,0,1.5>
          // smer kamery
        look_at<0,0,0>
          // pohled kamery
        }

// Definice svetla
 light_source{ <100,140,-130> 
                // pozice zdroje
               colour White
                // barva svetla
             }

// Scena:

 // Podklad
   // napr.: Plocha
     plane{y,-25 
             // pozice ,cislo je vzdalenost od kamery
             // pismeno y,x,z je podle jake osy je plocha natocena
           texture {Peel
             // textura                         
                    scale <3,5,3> 
                     // velikost
                    }
           // barva se zadava prikazem pigment {nazev barvy}
          }

  // Objekty
    // Koule
     sphere {<10, 5, 0>,10
               // x  y   z   r
              texture {Blue_Sky
                         // definice textury
                         // pigment { red 0.3 green 0.0 blue 2.55 } 
                         // blizsi zadani barev
                       scale <3, 4, 3>
                         // rozmery textury
                      }
             }      
    // Kvadr
     box { <-8.0,-5,-2.0>,<6.5,6,3.0>
          //x y z   x  y z
          texture {Blood_Sky
                   scale<3,2,4>
                   rotate <2,-20,0>
                    // otoceni textury
                  }
          finish{
                  // Konecna definece vlastnosti objektu 
                ambient 0.2
                  // tmavost
                diffuse 0.8 
                  // pohlceni svetla
                reflection 0.5
                  // odraz svetla
                }
          rotate <-20,30,0>
           // otoceni objektu
         }

      // Dve spojene koule
         sphere { <-15,10,-20>,5
                  pigment {Red}
                  finish { ambient 0.1 diffuse 0.5 reflection 0.1 }
                }
         sphere { <-10,9,-21>,5
                  pigment {Red}
                  finish { ambient 0.1 diffuse 0.5 reflection 0.1 } 
                }  
         light_source {<-50,50,-30> colour Yellow}
          // dalsi svetlo
             
// Soubor musi obsahovat vsechny potrebne zavorky,musi se dbat na velka a 
// mala pismena a predem definovat pouzivane knihovny            