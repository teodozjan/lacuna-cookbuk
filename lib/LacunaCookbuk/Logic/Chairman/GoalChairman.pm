use v6;

use LacunaCookbuk::Logic::Chairman;
use LacunaCookbuk::Logic::Chairman::Resource;

class GoalChairman does Chairman;

has BuildGoal @.build_goals;

constant $UNSUSTAINABLE = 1012;
constant $NO_ROOM_IN_QUEUE = 1009;
constant $INCOMPLETE_PENDING_BUILD = 1010;
constant $NOT_ENOUGH_STORAGE = 1011;



method build(Body $body) {
    for self.build_goals -> BuildGoal $goal {

	my $alt_goal = $goal;
	repeat {
	    return if $alt_goal.level < 1;
	    my LacunaBuilding @buildings = $body.find_buildings('/' ~ $alt_goal.building);
	    $alt_goal = self.upgrade(@buildings, $alt_goal);
	} while $alt_goal

   }
}

method upgrade(LacunaBuilding @buildings, BuildGoal $goal --> BuildGoal){
    for @buildings -> LacunaBuilding $building {
	next unless $goal.level > $building.view.level;#goal reached

	my $view := $building.view;
	
	if $view.upgrade<can> {
	    $building.upgrade;
	    note "Upgrade started " ~ $goal.building;
	} else {
	    given $view.upgrade<reason>[0] {
		when $UNSUSTAINABLE {
		    note 'Need to produce more ' ~ $view.upgrade<reason>[2] ~ ' for ' ~ $goal.building
		}
		when $NOT_ENOUGH_STORAGE {
		    
		    my Resource $resource = value_of($view.upgrade<reason>[2]);
		    
		    note "Need to store more $resource for {$goal.building}";

		    my $new_goal =  BuildGoal.new(building=> self.storage($resource), level => 30);
                    # To understand recurrence you need to understand recurrence
		    note "Too low storage for upgrading storage" && return $new_goal unless $new_goal.building == $goal.building;
		}
		when $NO_ROOM_IN_QUEUE {
		    note 'Queue full';
		    # Unclean
		    return BuildGoal.new(level => -1); 
			#last;
		}
		when $INCOMPLETE_PENDING_BUILD {next}
		default {die $view.upgrade}
	    }		
	}
    }    
    BuildGoal;
}

method storage(Resource $resource --> Building) {
    
    given $resource {
	when food {return Building::foodreserve}
	when ore {return Building::orestorage}
	when water {return Building::waterstorage}
	when waste {return Building::wastesequestration}
	when energy {return Building::energyreserve}
	default{die $resource}
    }
}

method all {
    for self.bodybuilder.planets -> Planet $planet {
	next if $planet.is_home;
	note "Upgrading " ~ $planet.name;
	self.build($planet)
    }
}

sub value_of(Str $str --> Resource){
    given $str {
	when 'food' {return food;}
	when 'ore' {return ore;}
	when 'water' {return water;}
	when 'energy' {return energy;}
	when 'waste' {return waste;}
	when 'happiness' {return happiness;}
	default{die $str}

    }
}
