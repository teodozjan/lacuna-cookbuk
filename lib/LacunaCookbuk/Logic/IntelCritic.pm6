use v6;

use LacunaCookbuk::Model::Body::Planet;
use LacunaCookbuk::Logic::BodyBuilder;
use Form;
use Term::ANSIColor;


class IntelCritic;

constant $limited_format= '{<<<<<<<<<<<<<<<<<<<<<<<<<<<} {>>>>}/{<<<<} {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}';
constant $ruler = '-' x 160;

sub elaborate_intelligence(Planet $planet) {
    my Intelligence $imini = $planet.find_intelligence_ministry;
    my Str $numspies = ~$imini.current;
    my Str $max = ~$imini.maximum;   
    my Str $spies = $numspies == 0 ?? "NONE!!!" !! ~$numspies;
    my @list = $imini.get_view_spies;
    my Str $spiesl = format_spies(@list);
    rename_spies($planet, @list);
    
    print form( 
	$limited_format,
	$planet.name, $spies, $max, $spiesl);

}

sub rename_spies($planet, @spies){
    my Intelligence $imini = $planet.find_intelligence_ministry;
    for @spies -> Spy $spy {
	if $spy.name ~~ "Agent Null"  {
	    $imini.name_spy($spy.id, $planet.name);
	    note "Renamed spy {$spy.name}";
	}
    }
}

submethod elaborate_spies{
    say "\nIntellignece -- Spies";
    my @header = <planet num limit details>;
    print form ($limited_format, @header);
    say $ruler;
    for (planets) -> Planet $planet {
	elaborate_intelligence($planet);
    }
}

 sub format_spies(@spies --> Str) {
    my %assignments;
    for @spies -> Spy $spy {
	%assignments{$spy.assignment}++;
    }

    my Str $ret;
    for %assignments.keys -> Str $key {
	my $val = $key ~ ':' ~%assignments{$key} ~ '   ';	
	$val = colored($val, 'yellow') if $key ~~ 'Idle';
	$ret ~=	$val;
    }
    $ret;
}

