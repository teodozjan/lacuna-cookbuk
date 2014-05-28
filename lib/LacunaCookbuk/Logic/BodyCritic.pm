use v6;

use LacunaCookbuk::Logic;
use Form;

class BodyCritic is Logic;

constant $limited_format= '{<<<<<<<<<<<<<<<<<<<<<} {>>>>}/{<<<<} {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}';
constant $ore_format_str = '{<<<<<<<<<<<<<<<<<<<}  ' ~ '{||||} ' x 20;


submethod elaborate_spaceport(Planet $planet) {
    
    my SpacePort $spaceport = $planet.find_space_port;

#bug?
    my Int $free = $spaceport.docks_available;    
    my Str $docks = $free == 0 ?? "FULL" !! ~$free;
    my Str $max = ~$spaceport.max_ships;
    my Str $ships = self.format_ships($spaceport.docked_ships);
    
    
    print form( 
	$limited_format,
	$planet.name, $docks, $max, $ships);

}

submethod elaborate_intelligence(Planet $planet) {
    my Intelligence $imini = $planet.find_intelligence_ministry;
    my Str $numspies = ~$imini.current;
    my Str $spies = $numspies == 0 ?? "NONE!!!" !! ~$numspies;
    my Str $max = ~$imini.maximum;     
    my Str $spiesl = self.format_spies($imini.get_view_spies);
    print form( 
	$limited_format,
	$planet.name, $spies, $max, $spiesl);

}

submethod elaborate_ores(Planet $planet, Str @header){
#keys and values in hash 
    my Str @header_copy = @header.clone;
    @header_copy.shift;

    my Str @values = gather for @header_copy -> $head {
	take ~$planet.ore{$head};
    }
    @values.unshift($planet.name);
    print form($ore_format_str, @values);
}

#todo optimize for reading
submethod elaborate {

    say "Planets -- Potential ores";
    my Str @header = self.bodybuilder.home_planet.ore.keys;
    @header.unshift('Planet name');
    print form($ore_format_str, @header);
    for self.bodybuilder.planets -> Planet $planet {
	self.elaborate_ores($planet, @header);
    }    

    say "\n\nSpaceport -- Docks";
    for self.bodybuilder.planets -> Planet $planet {
	self.elaborate_spaceport($planet);
    }

    say "\nIntellignece -- Spies";
    for self.bodybuilder.planets -> Planet $planet {
	self.elaborate_intelligence($planet);
    }

   

}

method format_ships(%ships --> Str){
    my Str $ret;
    for %ships.keys -> Str $key {
	$ret ~=	 $key ~ ":" ~ %ships{$key} ~ " ";
    }
    $ret;
}

method format_spies(Spy @spies --> Str) {
    my %assignments;
    for @spies -> Spy $spy {
	%assignments{$spy.assignment}++;
    }

    my Str $ret;
    for %assignments.keys -> Str $key {
	$ret ~=	form(' {>>>>>}:{<<<<} ', $key, ~%assignments{$key});
    }
    $ret;
}
