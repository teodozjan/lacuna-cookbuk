use v6;

use LacunaCookbuk::Model::Body::Planet;
use LacunaCookbuk::Logic::BodyBuilder;
use Form;
use Term::ANSIColor;

class OreCritic;

constant $limited_format= '{<<<<<<<<<<<<<<<<<<<<<<<<<<<} {>>>>}/{<<<<} {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}';
constant $ore_format_str = '{<<<<<<<<<<<<<<<<<<<}  ' ~ '{||||} ' x 20;
constant $ruler = '-' x 160;

submethod elaborate_intelligence(Planet $planet) {
    my Intelligence $imini = $planet.find_intelligence_ministry;
    my Str $numspies = ~$imini.current;
    my Str $max = ~$imini.maximum;   
    my Str $spies = $numspies == 0 ?? "NONE!!!" !! ~$numspies;
    
    my Str $spiesl = self.format_spies($imini.get_view_spies);
    
    print form( 
	$limited_format,
	$planet.name, $spies, $max, $spiesl);

}

submethod elaborate_ores(Planet $planet, Str @header) {
#keys and values in hash 
    my Str @header_copy = @header.clone;
    @header_copy.shift;

    my Str @values = gather for @header_copy -> $head {
	take ~$planet.ore{$head};
    }
    @values.unshift($planet.name);
    print form($ore_format_str, @values);
}

submethod elaborate_ore {

    say "Planets -- Potential ores";
    my Str @header = home_planet.ore.keys;
    @header.unshift('Planet name');
    print BOLD, form($ore_format_str, @header), RESET;
    
    for (planets) -> Planet $planet {
	self.elaborate_ores($planet, @header);
    }    
}

