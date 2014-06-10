use v6;

use LacunaCookbuk::Logic;
use Form;
use Term::ANSIColor;


class IntelCritic does Logic;

constant $limited_format= '{<<<<<<<<<<<<<<<<<<<<<<<<<<<} {>>>>}/{<<<<} {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}';
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
