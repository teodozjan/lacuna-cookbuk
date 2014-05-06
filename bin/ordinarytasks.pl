use v6;

use JSON::RPC::Client;
use LacunaCookbuk::RPCMaker;
use LacunaCookbuk::LacunaSession;
use LacunaCookbuk::LacunaBuilding;
use LacunaBuilding::Archeology;
use LacunaBuilding::Trade;
use LacunaCookbuk::EmpireInfo;
use LacunaCookbuk::PlanMaker; 





my $f = EmpireInfo.new;
$f.create_session;

my $home_planet_id = $f.find_home_planet_id;
my @planets = keys $f.find_planets;


say "Creating all possible halls";
say PlanMaker.new(f => $f, session =>$f.session).makePossibleHalls($home_planet_id);

say "Transporting all glyphs to home planet if possible";
for @planets -> $planet_id {
    next if $planet_id == $home_planet_id;
    my $trade = $f.find_trade_ministry($planet_id);
    if $trade
    {
	#say @($trade.getGlyphs);
	next unless $trade.getPushShips($home_planet_id);
	next unless $trade.getGlyphs;



	say $trade.pushTo($home_planet_id, $trade.getGlyphs);
    }
}

say "Checking balance on home planet (takes ages)";
say $f.calculateSustainablity($home_planet_id);

$f.close_session;




