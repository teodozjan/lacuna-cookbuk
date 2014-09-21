
use v6;


use LacunaCookbuk::Logic::Chairman::BuildGoal;
use LacunaCookbuk::Logic::ShipCritic;
use LacunaCookbuk::Logic::OreCritic;
use LacunaCookbuk::Logic::IntelCritic;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::Chairman;
use LacunaCookbuk::Logic::Chairman::Resource;
use LacunaCookbuk::Logic::Chairman::BuildingEnum;
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
   LacunaCookbuk::Logic::ShipCritic.elaborate_ships;
}

#| Will show all ores on planet stub 
method ore {    
   LacunaCookbuk::Logic::OreCritic.elaborate_ore;
}

#| Will vote YES to ALL propostions. Be careful if you care about politics
method votes {
   LacunaCookbuk::Logic::Secretary.clean(["Parliament"]);
   LacunaCookbuk::Logic::Ambassador.vote_all(True);
}

#| Create Halls of Vrbansk and transport all glyphs and plans to home planet
method ordinary {
    say "Creating all possible halls";
   LacunaCookbuk::Logic::PlanMaker.make_possible_halls;
    
    say "Transporting all glyphs to home planet if possible";
   LacunaCookbuk::Logic::Transporter.transport_all_cargo;
}

#| Will upgrade buildings in order passed to L<doc:LacunaCookbuk::Chariman>
#| chairman will work only on existing buildings but this may change in future
method chairman {
    my LacunaCookbuk::Logic::Chairman::BuildGoal $saw .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::saw, level=>12);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $wastet .=  new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::wastedigester, level=>15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $space .=  new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::spaceport, level=>10);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $arch .=  new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::archaeology, level=>30);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $sec .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::security, level => 30); 


    my LacunaCookbuk::Logic::Chairman::BuildGoal $politic .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::politicstraining,level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $mayhem .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::mayhemtraining, level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $intel .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::inteltraining, level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $espionage .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::espionage, level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $intelli .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::intelligence, level =>15);

    my LacunaCookbuk::Logic::Chairman::BuildGoal $happy .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::entertainment, level => 30);

    my LacunaCookbuk::Logic::Chairman::BuildGoal $mercenaries .= new(building => LacunaCookbuk::Logic::Chairman::BuildingEnum::mercenariesguild, level => 30);

    my LacunaCookbuk::Logic::Chairman::BuildGoal @goals = (
	$saw,
	$wastet,$space, $arch, $sec,
	$politic, $mayhem, $intel, $espionage, $intelli,
	$happy
	);

    my $c =LacunaCookbuk::Logic::Chairman.new(build_goals=>(@goals));
    $c.all;
}

#| Use power of chairman to upgrade home planet
method upgrade_home {
    my LacunaCookbuk::Logic::Chairman::BuildGoal $saw .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::saw, level=> 12);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $wastet .=  new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::wastedigester, level=>15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $space .=  new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::spaceport, level=>10);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $arch .=  new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::archaeology, level=>30);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $sec .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::security, level => 30); 

    my LacunaCookbuk::Logic::Chairman::BuildGoal $politic .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::politicstraining,level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $mayhem .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::mayhemtraining, level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $intel .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::inteltraining, level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $espionage .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::espionage, level => 15);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $intelli .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::intelligence, level =>15);

    my LacunaCookbuk::Logic::Chairman::BuildGoal $happy .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::entertainment, level => 30);

    my LacunaCookbuk::Logic::Chairman::BuildGoal $mercenaries .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::mercenariesguild, level => 30);

    my LacunaCookbuk::Logic::Chairman::BuildGoal $saw2 .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::saw, level=> 30);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $trade .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::trade, level=> 30);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $university .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::university, level=> 30);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $capitol .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::capitol, level=> 30);
    my LacunaCookbuk::Logic::Chairman::BuildGoal $stockpile .= new(building => LacunaCookbuk::Logic::Chairman::LacunaCookbuk::Logic::Chairman::BuildingEnum::stockpile, level=> 30);
    my LacunaCookbuk::Logic::Chairman::BuildGoal @goals = (
	$saw,
	$wastet,$space, $arch, $sec,
	$politic, $mayhem, $intel, $espionage, $intelli,
	$happy,
	$saw2, $trade, $university,
	$capitol, $stockpile
	);

	my $c =LacunaCookbuk::Logic::Chairman.new(build_goals=>(@goals));
	$c.build;
}

#| Print list of incoming ships
method defend {
   LacunaCookbuk::Logic::Commander.find_incoming;
}

#| Print summary of spies
method spies {
   LacunaCookbuk::Logic::IntelCritic.elaborate_spies;
}

#| Print all plans can be made of glyphs in stock
method plans {
   LacunaCookbuk::Logic::PlanMaker.show_possible_plans;
}


#| Where are my planets? It is not best implementation
#| but at least grep capable
method zones {
    LacunaCookbuk::Logic::BodyBuilder.report_zones;
}
