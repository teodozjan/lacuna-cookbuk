use v6;

use LacunaCookbuk::Model::Body;
use LacunaCookbuk::Logic::BodyBuilder;

use LacunaCookbuk::Model::Structure::Development;
use LacunaCookbuk::Logic::Chairman::Resource;
use LacunaCookbuk::Logic::Chairman::BuildingEnum;

use Term::ANSIColor;

#| Chairman is the class that does all the magic.
class LacunaCookbuk::Logic::Chairman;

class BuildGoal {
    has LacunaCookbuk::Logic::Chairman::BuildingEnum $.building;
    has Int $.level;
}

has LacunaCookbuk::Logic::Chairman::BuildGoal @.build_goals;

constant $UNSUSTAINABLE = 1012;
constant $NO_ROOM_IN_QUEUE = 1009;
constant $INCOMPLETE_PENDING_BUILD = 1010;
constant $NOT_ENOUGH_STORAGE = 1011;

sub print_queue_summary(Body $body = home_planet) {
    my Development $dev = $body.find_development_ministry;
    for $dev.build_queue -> %item {
	note colored(%item<name> ~ " ⌛" ~ DateTime.new(now + %item<seconds_remaining>), 'blue'); 	
    }
}


method build(Body $body = home_planet) {
    if $body.get_happiness < 0 {
	note colored("Planet is negative happiness. Leaving...", 'red');
	return;
    }
   
    for @!build_goals -> $goal {
        my $alt_goal = $goal;
	my $i=5;
	repeat while $alt_goal {
	    if $alt_goal.level < 1 {
		# It looks like you cannot call last on repeat loop
		print_queue_summary($body);
		return;
	    }
	    
	    if --$i == 0 {
		note colored("Infinite recursion. Did you play with supply chains?", 'red');
		return
	    }
	    $alt_goal = upgrade($body, $alt_goal);
	} 
	
    }  
    print_queue_summary($body);
}


sub upgrade(Body $body, $goal --> LacunaCookbuk::Logic::Chairman::BuildGoal){
    my LacunaBuilding @buildings = $body.find_buildings('/' ~ $goal.building);
 
    for @buildings -> LacunaBuilding $building {

	my $view = $building.view;
	next unless $goal.level > $view.level;#goal reached
	
	if $view.upgrade<can> {
	    $building.upgrade;
	    note colored("Upgrade started " ~ $goal.building, 'green');
	} else {
	    given $view.upgrade<reason>[0] {
		when $UNSUSTAINABLE {
		    unless $view.upgrade<reason>[2] {
			note colored($view.upgrade<reason>[1], 'red');
			next
		    }

		    my $resource = value_of($view.upgrade<reason>[2]);
		    note 'Need to produce more ' ~ $resource  ~ ' for ' ~ $goal.building;
		    my $new_goal =  LacunaCookbuk::Logic::Chairman::BuildGoal.new(building => production($resource), level => 15);
		    if $new_goal.building != $goal.building {
			note "Too low $resource for upgrading {$new_goal.building}";
			return $new_goal;
			} else {
			note "Cannot upgrade itself";
			next
		    }
		}
		when $NOT_ENOUGH_STORAGE {
		    my $resource = value_of($view.upgrade<reason>[2]);
		    my $quantity = $view.upgrade<cost>{$resource};
		    my $status = $body.get_status<body>;
		    my $capacity = $status{$resource ~ '_capacity'};
		    note "Need to have $quantity of $resource for {$goal.building}";
		    
		    if  $quantity > $capacity {
			note "To small stores will try to upgrade";
			my $new_goal = LacunaCookbuk::Logic::Chairman::BuildGoal.new(building=> storage($resource), level => 15);
			return $new_goal unless $new_goal.building == $goal.building;
			} else {
			note "Capacity of $capacity is sufficent, stores will be left as is";
		    }
		}
		when $NO_ROOM_IN_QUEUE {
		    note 'Queue full';
		    # Unclean
		    return LacunaCookbuk::Logic::Chairman::BuildGoal.new(level => -1); 
			#last;
		}
		when $INCOMPLETE_PENDING_BUILD {next}
		default {die $view.upgrade}
	    }		
	}
    }    
    LacunaCookbuk::Logic::Chairman::BuildGoal;
}

sub storage(LacunaCookbuk::Logic::Chairman::Resource $resource --> LacunaCookbuk::Logic::Chairman::BuildingEnum) {
    
    given $resource {
	when food {return foodreserve}
	when ore {return orestorage}
	when water {return waterstorage}
	when waste {return wastesequestration}
	when energy {return energyreserve}
	default{die $resource}
    }
}

sub production(LacunaCookbuk::Logic::Chairman::Resource $resource --> LacunaCookbuk::Logic::Chairman::BuildingEnum) {
    
    given $resource {
	when food {
	    my @array of LacunaCookbuk::Logic::Chairman::BuildingEnum = (dairy, 
				     lapis,
				     apple,
				     beeldeban,
				     algae,
				     malcud
		);
	    return @array.pick }#FIXME
	when ore {
	    my @array of LacunaCookbuk::Logic::Chairman::BuildingEnum = (mine, orerefinery);
	    return  @array.pick
	}
	when water {return atmosphericevaporator}
#	when waste {return wastesequestration}
	when energy {return singularity}
	default{die $resource}
    }
}


submethod all {
    for (planets) -> Body $planet {
	next if $planet.is_home;
	note BOLD, "Upgrading " ~ $planet.name, RESET;
	.build($planet);
    }
}

sub value_of(Str $str --> LacunaCookbuk::Logic::Chairman::Resource){
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

