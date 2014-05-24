use v6;

use LacunaCookbuk::Logic;
use Form;

class BodyCritic is Logic;

submethod elaborate_spaceport(Planet $planet) {
    my $spaceport = $planet.find_space_port;

#bug?
    my Int $free = $spaceport.free_docks;    
    my Str $docks = $free == 0 ?? "FULL" !! ~$free;
    my Str $max = ~$spaceport.max_ships;
    
    
    say form( 
	'{<<<<<<<<<<<<<<<<<<<<<<<} {>>>>>>>>>>>>>>>>>>}/{>>>}',
	$planet.name, $docks, $max);

}

submethod elaborate {
    say "Spaceport -- Docks";
    for self.bodybuilder.planets -> Planet $planet {
	self.elaborate_spaceport($planet);
    }
}
