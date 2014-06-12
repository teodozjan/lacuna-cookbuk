use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Logic::ShipCritic;
use LacunaCookbuk::Logic::OreCritic;
use LacunaCookbuk::Logic::IntelCritic;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::Chairman;
use LacunaCookbuk::Logic::Chairman::Building;
use LacunaCookbuk::Logic::Chairman::BuildGoal;
use LacunaCookbuk::Logic::Ambassador;
use LacunaCookbuk::Logic::Commander;

my $path =  IO::Path.new($*PROGRAM_NAME).parent.parent ~ '/var/bodybuilder.pl';

#= LacunaCookbuk main client
class Client;

has BodyBuilder $.cache = BodyBuilder.from_file($path);
has LacunaSession $.session;

#= LacunaCookbuk client requires all building ids with its urls to work. Due to it is big rpc costs and rare changes they are stored inside a file
method fill_cache {
    self.cache.process_all_bodies(self.session.planets_hash);
    self.cache.to_file($path);
}

#= Will show summary for docks and scuttle ships that have efficency lower 45% if ship is docked
submethod ships {    
    ShipCritic.new(bodybuilder => self.cache).elaborate_ships;
}

#= Will show all ores on planet stub 
submethod ore {    
    OreCritic.new(bodybuilder => self.cache).elaborate_ore;
}

#= Will vote YES to ALL propostions. Be careful if you care about politics
submethod votes {
    Ambassador.new(bodybuilder => self.cache).vote_all(True);
}

#= Create Halls of Vrbansk and transport all glyphs and plans to home planet
submethod ordinary {
    #= dadasdad
    say "Creating all possible halls";
    PlanMaker.new(bodybuilder => self.cache).makePossibleHalls;
    
    say "Transporting all glyphs to home planet if possible";
    Transporter.new(bodybuilder => self.cache).transport_all_cargo;
}

#= Will upgrade buildings in order passed to L<doc:LacunaCookbuk::Chariman> chairman will work only on existing buildings but this may change in future
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

    my $c = Chairman.new(
	bodybuilder => self.cache,
	build_goals=>(@goals)	    
	);
    #$c.check_space_ports;
    $c.all;


}

method defend {
    Commander.new(bodybuilder => self.cache).find_incoming;
}

method spies {
    IntelCritic.new(bodybuilder => self.cache).elaborate_spies;
}

=begin pod

=head1 NAME

Client.pm main client for Lacuna cookbuk

=end pod
