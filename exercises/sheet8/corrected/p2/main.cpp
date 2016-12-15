/*************************************************
*	Comments by Bulcsu Sandor: "// BS: "
*	Points: 4/4
*************************************************/

// BS: our system has been upgraded finally
// BS: now your makefile also works
// BS: so there is no need for the clang compiler

/**
 * Solution to problem 2 sheet 8
 * by Lars Gröber and Hendrik Edelmann
 *
 * There is a makefile available.
 */

#include <iostream>
#include <vector>

#include "ExoPlanets.h"

int main ()
{
    // vector to hold the data
    std::vector<std::vector<std::string>> data;
    // BS: it's good that it's only 1MB 

    // vector to hold the comment
    std::vector<std::string> comment;

    //if ( ! ExoPlanets::readFile( "../../p1/exoplanet.eu_catalog.dat", data, comment ) )
    // BS: the path was wrong!
    if ( ! ExoPlanets::readFile( "../p1/exoplanet.eu_catalog.dat", data, comment ) )
    {
        fprintf( stderr, "Something went wrong reading the file..." );
    }

    if ( ! ExoPlanets::writeFile( "../planets.dat", data, comment ) )
    {
        fprintf( stderr, "Something went wrong writing the file..." );
    }

    return 0;
}
