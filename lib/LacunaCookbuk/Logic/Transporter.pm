use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Planet;

class Transporter is LacunaSession;

submethod transport_glyphs {
    for self.planets.keys -> $planet_id {
	next if $planet_id == self.home_planet_id;
	my Planet $planet = Planet.planet($planet_id);
	my $trade = $planet.find_trade_ministry;
	
	if $trade
	{
	    my @glyphs = $trade.get_glyphs;
	    unless  @glyphs {
		note "No glyphs on " ~ $planet.name;;
		next
	    }

	    unless $trade.get_push_ships {
		warn "No ships available on "~ $planet.name;;
		next
	    }
	
	    say $trade.push(@glyphs);
	} 
    }
}


