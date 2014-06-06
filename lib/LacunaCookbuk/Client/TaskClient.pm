use v6;

use LacunaCookbuk::Client;
use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;

use LacunaCookbuk::Logic::Chairman::GoalChairman;
use LacunaCookbuk::Logic::Chairman::Building;
use LacunaCookbuk::Logic::Chairman::BuildGoal;


class TaskClient is Client {
    submethod ordinary {
	
	say "Creating all possible halls";
	PlanMaker.new(bodybuilder => self.cache).makePossibleHalls;
	
	say "Transporting all glyphs to home planet if possible";
	Transporter.new(bodybuilder => self.cache).transport_all_cargo;
    }

#= chairman will work only on existing buildings but this may change in future
    method chairman {
	
	my BuildGoal $wastet =  BuildGoal.new(building => wastetreatment, level=>15);
	my BuildGoal $space .=  new(building => spaceport, level=>10);
	my BuildGoal $arch .=  new(building => archaeology, level=>30);
	my BuildGoal $sec .= new(building => security, level => 30); 


	my BuildGoal $politic .= new(building => politicstraining,level => 15);
	my BuildGoal $mayhem .= new(building => mayhemtraining, level => 15);
	my BuildGoal $intel .= new(building => inteltraining, level => 15);
	my BuildGoal $espionage .= new(building => espionage, level => 30);
	my BuildGoal $intelli .= new(building => intelligence, level =>30);

	my BuildGoal $happy .= new(building => entertainment, level => 30);

	my BuildGoal @goals = (
	    $wastet,$space, $arch, $sec,
	    $politic, $mayhem, $intel, $espionage, $intelli,
	    $happy
	    );

	my $c = GoalChairman.new(
	    bodybuilder => self.cache,
	    build_goals=>(@goals)	    
	    );
	#$c.check_space_ports;
	$c.all;


    }

}
