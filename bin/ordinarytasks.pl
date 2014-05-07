use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Planet;
#use JSON::RPC::Client;
use LacunaCookbuk::Logic::PlanMaker;

#session info is static for all classes
my LacunaSession $f = LacunaSession.new;
$f.create_session;

say "Creating all possible halls";
PlanMaker.new.makePossibleHalls();

#todo transport in separate class
say "Transporting all glyphs to home planet if possible";
for $f.planets.keys -> $planet_id {
    next if $planet_id == $f.home_planet_id;
    my Planet $planet = Planet.new(id => $planet_id);
    my $trade = $planet.find_trade_ministry;
    my $planet_name = $planet.planet_name($planet_id);
    if $trade
    {
	
	unless my @glyphs = $trade.get_glyphs {
	    note "No glyphs on ", $planet_name;
	    next
	}

	unless $trade.get_push_ships($f.home_planet_id) {
	    warn "No ships available on ", $planet_name;
	    next
	}
	#todo home planet as default destination;
	say $trade.push_to($f.home_planet_id, @glyphs);
    }
}

say "Checking balance on home planet (takes ages)";
say Planet.new(id => $f.home_planet_id).calculate_sustainablity();

$f.close_session;




