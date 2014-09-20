
use v6;

use LacunaCookbuk::Logic::ShipCritic;
use LacunaCookbuk::Logic::OreCritic;
use LacunaCookbuk::Logic::IntelCritic;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::Chairman;
use LacunaCookbuk::Logic::Chairman::BuildingEnum;
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
    my BuildGoal $saw .= new(building => LacunaCookbuk::BuildingEnum::saw, level=>12);
    my BuildGoal $wastet .=  new(building => LacunaCookbuk::BuildingEnum::wastedigester, level=>15);
    my BuildGoal $space .=  new(building => LacunaCookbuk::BuildingEnum::spaceport, level=>10);
    my BuildGoal $arch .=  new(building => LacunaCookbuk::BuildingEnum::archaeology, level=>30);
    my BuildGoal $sec .= new(building => LacunaCookbuk::BuildingEnum::security, level => 30); 


    my BuildGoal $politic .= new(building => LacunaCookbuk::BuildingEnum::politicstraining,level => 15);
    my BuildGoal $mayhem .= new(building => LacunaCookbuk::BuildingEnum::mayhemtraining, level => 15);
    my BuildGoal $intel .= new(building => LacunaCookbuk::BuildingEnum::inteltraining, level => 15);
    my BuildGoal $espionage .= new(building => LacunaCookbuk::BuildingEnum::espionage, level => 15);
    my BuildGoal $intelli .= new(building => LacunaCookbuk::BuildingEnum::intelligence, level =>15);

    my BuildGoal $happy .= new(building => LacunaCookbuk::BuildingEnum::entertainment, level => 30);

    my BuildGoal $mercenaries .= new(building => LacunaCookbuk::BuildingEnum::mercenariesguild, level => 30);

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
    my BuildGoal $saw .= new(building => LacunaCookbuk::BuildingEnum::saw, level=> 12);
    my BuildGoal $wastet .=  new(building => LacunaCookbuk::BuildingEnum::wastedigester, level=>15);
    my BuildGoal $space .=  new(building => LacunaCookbuk::BuildingEnum::spaceport, level=>10);
    my BuildGoal $arch .=  new(building => LacunaCookbuk::BuildingEnum::archaeology, level=>30);
    my BuildGoal $sec .= new(building => LacunaCookbuk::BuildingEnum::security, level => 30); 

    my BuildGoal $politic .= new(building => LacunaCookbuk::BuildingEnum::politicstraining,level => 15);
    my BuildGoal $mayhem .= new(building => LacunaCookbuk::BuildingEnum::mayhemtraining, level => 15);
    my BuildGoal $intel .= new(building => LacunaCookbuk::BuildingEnum::inteltraining, level => 15);
    my BuildGoal $espionage .= new(building => LacunaCookbuk::BuildingEnum::espionage, level => 15);
    my BuildGoal $intelli .= new(building => LacunaCookbuk::BuildingEnum::intelligence, level =>15);

    my BuildGoal $happy .= new(building => LacunaCookbuk::BuildingEnum::entertainment, level => 30);

    my BuildGoal $mercenaries .= new(building => LacunaCookbuk::BuildingEnum::mercenariesguild, level => 30);

    my BuildGoal $saw2 .= new(building => LacunaCookbuk::BuildingEnum::saw, level=> 30);
    my BuildGoal $trade .= new(building => LacunaCookbuk::BuildingEnum::trade, level=> 30);
    my BuildGoal $university .= new(building => LacunaCookbuk::BuildingEnum::university, level=> 30);
    my BuildGoal $capitol .= new(building => LacunaCookbuk::BuildingEnum::capitol, level=> 30);
    my BuildGoal $stockpile .= new(building => LacunaCookbuk::BuildingEnum::stockpile, level=> 30);
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