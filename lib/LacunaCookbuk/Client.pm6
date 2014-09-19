
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

#| LacunaCookbuk main client
class LacunaCookbuk::Client;

#| Login
sub create_session is export {
    Empire.start_rpc_keeper;    
    Empire.create_session;     
}

#| Logout
sub close_session is export {
    Empire.close_session;
}

#| Will show summary for docks and scuttle ships that have efficency lower 45% if ship is docked
method ships {    
    ShipCritic.elaborate_ships;
}

#| Will show all ores on planet stub 
method ore {    
    OreCritic.elaborate_ore;
}

#| Will vote YES to ALL propostions. Be careful if you care about politics
method votes {
    Secretary.clean(["Parliament"]);
    Ambassador.vote_all(True);
}

#| Create Halls of Vrbansk and transport all glyphs and plans to home planet
method ordinary {
    say "Creating all possible halls";
    PlanMaker.make_possible_halls;
    
    say "Transporting all glyphs to home planet if possible";
    Transporter.transport_all_cargo;
}

#| Will upgrade buildings in order passed to L<doc:LacunaCookbuk::Chariman>
#| chairman will work only on existing buildings but this may change in future
method chairman {
    my BuildGoal $saw .= new(building => Building::Building::saw, level=>12);
    my BuildGoal $wastet .=  new(building => Building::Building::wastedigester, level=>15);
    my BuildGoal $space .=  new(building => Building::Building::spaceport, level=>10);
    my BuildGoal $arch .=  new(building => Building::Building::archaeology, level=>30);
    my BuildGoal $sec .= new(building => Building::Building::security, level => 30); 


    my BuildGoal $politic .= new(building => Building::Building::politicstraining,level => 15);
    my BuildGoal $mayhem .= new(building => Building::Building::mayhemtraining, level => 15);
    my BuildGoal $intel .= new(building => Building::Building::inteltraining, level => 15);
    my BuildGoal $espionage .= new(building => Building::Building::espionage, level => 15);
    my BuildGoal $intelli .= new(building => Building::Building::intelligence, level =>15);

    my BuildGoal $happy .= new(building => Building::Building::entertainment, level => 30);

    my BuildGoal $mercenaries .= new(building => Building::Building::mercenariesguild, level => 30);

    my BuildGoal @goals = (
	$saw,
	$wastet,$space, $arch, $sec,
	$politic, $mayhem, $intel, $espionage, $intelli,
	$happy
	);

    my $c = Chairman.new(build_goals=>(@goals));
    $c.all;
}

#| Use power of chairman to upgrade home planet
method upgrade_home {
    my BuildGoal $saw .= new(building => Building::Building::saw, level=> 12);
    my BuildGoal $wastet .=  new(building => Building::Building::wastedigester, level=>15);
    my BuildGoal $space .=  new(building => Building::Building::spaceport, level=>10);
    my BuildGoal $arch .=  new(building => Building::Building::archaeology, level=>30);
    my BuildGoal $sec .= new(building => Building::Building::security, level => 30); 

    my BuildGoal $politic .= new(building => Building::Building::politicstraining,level => 15);
    my BuildGoal $mayhem .= new(building => Building::Building::mayhemtraining, level => 15);
    my BuildGoal $intel .= new(building => Building::Building::inteltraining, level => 15);
    my BuildGoal $espionage .= new(building => Building::Building::espionage, level => 15);
    my BuildGoal $intelli .= new(building => Building::Building::intelligence, level =>15);

    my BuildGoal $happy .= new(building => Building::Building::entertainment, level => 30);

    my BuildGoal $mercenaries .= new(building => Building::Building::mercenariesguild, level => 30);

    my BuildGoal $saw2 .= new(building => Building::Building::saw, level=> 30);
    my BuildGoal $trade .= new(building => Building::Building::trade, level=> 30);
    my BuildGoal $university .= new(building => Building::Building::university, level=> 30);
    my BuildGoal $capitol .= new(building => Building::Building::capitol, level=> 30);
    my BuildGoal $stockpile .= new(building => Building::Building::stockpile, level=> 30);
    my BuildGoal @goals = (
	$saw,
	$wastet,$space, $arch, $sec,
	$politic, $mayhem, $intel, $espionage, $intelli,
	$happy,
	$saw2, $trade, $university,
	$capitol, $stockpile
	);

	my $c = Chairman.new(build_goals=>(@goals));
	$c.build;
}

#| Print list of incoming ships
method defend {
    Commander.find_incoming;
}

#| Print summary of spies
method spies {
    IntelCritic.elaborate_spies;
}

#| Print all plans can be made of glyphs in stock
method plans {
    PlanMaker.show_possible_plans;
}


#| Where are my planets? It is not best implementation
#| but at least grep capable
method zones {
    BodyBuilder.report_zones;
}