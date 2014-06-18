use v6;

use LacunaCookbuk::Logic::ShipCritic;
use LacunaCookbuk::Logic::OreCritic;
use LacunaCookbuk::Logic::IntelCritic;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::Chairman;
use LacunaCookbuk::Logic::Chairman::Building;
use LacunaCookbuk::Logic::Chairman::BuildGoal;
use LacunaCookbuk::Logic::Ambassador;
use LacunaCookbuk::Logic::Commander;
use LacunaCookbuk::Logic::Secretary;

use LacunaCookbuk::Model::Empire;

#= LacunaCookbuk main client
class Client;

sub create_session is export {
    Empire.create_session;   
}

sub close_session is export {
    Empire.close_session;
}

#= Will show summary for docks and scuttle ships that have efficency lower 45% if ship is docked
method ships {    
    ShipCritic.elaborate_ships;
}

#= Will show all ores on planet stub 
method ore {    
    OreCritic.elaborate_ore;
}

#= Will vote YES to ALL propostions. Be careful if you care about politics
method votes {
    Secretary.clean(["Parliament"]);
    Ambassador.vote_all(True);
}

#= Create Halls of Vrbansk and transport all glyphs and plans to home planet
method ordinary {
    say "Creating all possible halls";
    PlanMaker.makePossibleHalls;
    
    say "Transporting all glyphs to home planet if possible";
    Transporter.transport_all_cargo;
}

#= Will upgrade buildings in order passed to L<doc:LacunaCookbuk::Chariman> chairman will work only on existing buildings but this may change in future
method chairman {

    my BuildGoal $wastet =  BuildGoal.new(building => Building::Building::wastetreatment, level=>15);
    my BuildGoal $space .=  new(building => Building::Building::spaceport, level=>10);
    my BuildGoal $arch .=  new(building => Building::Building::archaeology, level=>30);
    my BuildGoal $sec .= new(building => Building::Building::security, level => 30); 


    my BuildGoal $politic .= new(building => Building::Building::politicstraining,level => 15);
    my BuildGoal $mayhem .= new(building => Building::Building::mayhemtraining, level => 15);
    my BuildGoal $intel .= new(building => Building::Building::inteltraining, level => 15);
    my BuildGoal $espionage .= new(building => Building::Building::espionage, level => 30);
    my BuildGoal $intelli .= new(building => Building::Building::intelligence, level =>30);

    my BuildGoal $happy .= new(building => Building::Building::entertainment, level => 30);

    my BuildGoal @goals = (
	$wastet,$space, $arch, $sec,
	$politic, $mayhem, $intel, $espionage, $intelli,
	$happy
	);

    my $c = Chairman.new(build_goals=>(@goals));
    $c.all;


}

method defend {
    Commander.find_incoming;
}

method spies {
    IntelCritic.elaborate_spies;
}


