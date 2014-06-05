use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::BodyCritic;
use LacunaCookbuk::Logic::Chairman::GoalChairman;
use LacunaCookbuk::Logic::Chairman::Building;
use LacunaCookbuk::Logic::Chairman::BuildGoal;


class Client {
    has BodyBuilder $!cache;
    has LacunaSession $!session;

    submethod cache {
#todo review
	$!cache = BodyBuilder.new(session =>$!session);
	$!cache.process_all_bodies($!session.planets_hash);
	$!cache.to_file('./var/bodybuilder.pl');
    }

    submethod elaborate {
	$!cache= BodyBuilder.from_file('./var/bodybuilder.pl') unless $!cache;
	BodyCritic.new(bodybuilder => $!cache).elaborate;
    }

    submethod ordinary {
	$!cache= BodyBuilder.from_file('./var/bodybuilder.pl') unless $!cache;
	say "Creating all possible halls";
	PlanMaker.new(bodybuilder => $!cache).makePossibleHalls;
	
	say "Transporting all glyphs to home planet if possible";
	Transporter.new(bodybuilder => $!cache).transport_all_cargo;
    }


#= chariman will upgrade only existing buildings but this may change in future
    submethod chairman {
	$!cache = BodyBuilder.from_file('./var/bodybuilder.pl') unless $!cache;
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
	    bodybuilder => $!cache,
	    build_goals=>(@goals)	    
	    );
	#$c.check_space_ports;
	$c.all;


    }

}


my @todo;

if @*ARGS.grep('all') {
    @todo := <cache elaborate ordinary chairman>
} else {
    @todo := @*ARGS
}

my LacunaSession $f = LacunaSession.new;
$f.create_session;
my Client $client .= new(session => $f);

for @todo -> $willdo {
    $client."$willdo"();
}

$f.close_session;





