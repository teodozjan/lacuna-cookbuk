use v6;

use LacunaCookbuk::Logic;
use Form;

class BodyCritic is Logic;

submethod elaborate_planet(Planet $planet) {
    my $spaceport = $planet.find_space_port;
    die "Planet " ~ $planet.name ~ " without space port" unless $spaceport;
    my Str $docks = ~$spaceport.free_docks;
    my Str $max = ~$spaceport.max_ships;
    say form(
	'{||||||||}',~$planet.name, 
	'Docks {>>>>} of {>>>>}',  $docks, $max); 

}

submethod elaborate {
    for self.bodybuilder.planets -> Planet $planet{
	self.elaborate_planet($planet);
    }
}
