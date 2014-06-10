use v6;

use LacunaCookbuk::Logic;
use Form;
use Term::ANSIColor;

#| TODO split
class OreCritic is Logic;

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
    my Str @header = self.bodybuilder.home_planet.ore.keys;
    @header.unshift('Planet name');
    print BOLD, form($ore_format_str, @header), RESET;
    
    for self.bodybuilder.planets -> Planet $planet {
	self.elaborate_ores($planet, @header);
    }    
}

submethod elaborate_spies{
    say "\nIntellignece -- Spies";
    my @header = <planet num limit details>;
    print form ($limited_format, @header);
    say $ruler;
    for self.bodybuilder.planets -> Planet $planet {
	self.elaborate_intelligence($planet);
    }
}

method format_spies(Spy @spies --> Str) {
    my %assignments;
    for @spies -> Spy $spy {
	%assignments{$spy.assignment}++;
    }

    my Str $ret;
    for %assignments.keys -> Str $key {
	$ret ~=	$key ~ ':' ~%assignments{$key} ~ '   ';
    }
    $ret;
}
