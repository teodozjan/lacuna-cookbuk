use v6;

use LacunaCookbuk::Logic::Chairman;

class GoalChairman does Chairman;

has BuildGoal @.build_goals;

constant $UNSUSTAINABLE = 1012;
constant $NO_ROOM_IN_QUEUE = 1009;
constant $INCOMPLETE_PENDING_BUILD = 1010;
constant $NOT_ENOUGH_STORAGE = 1011;

method build(Body $body) {  
   
    for self.build_goals -> BuildGoal $goal {
	
	my LacunaBuilding @buildings =	$body.find_buildings('/' ~ $goal.building);
	for @buildings -> LacunaBuilding $building {
	    next unless $goal.level > $building.view.level;#goal reached
	    self.upgrade($body, $building, $goal);
	    
	}
    }
}

method upgrade(Body $body, LacunaBuilding $building, BuildGoal $goal ) {
    my $view := $building.view;

    if ($view.upgrade<can>) {
	$building.upgrade;
	note "Upgrade started " ~ $goal.building;
    } else {
	given $view.upgrade<reason>[0] {
	    when $UNSUSTAINABLE {
		note 'Need to produce more ' ~ $view.upgrade<reason>[2] ~ ' for ' ~ $goal.building
	    }
	    when $NOT_ENOUGH_STORAGE {
		note 'Need to store more ' ~ $view.upgrade<reason>[2] ~ ' for ' ~ $goal.building
	    }
	    when $NO_ROOM_IN_QUEUE {note 'Queue full';return}
	    when $INCOMPLETE_PENDING_BUILD {next}
	    default {die $view.upgrade}

	}
    }
}
method all {
  for self.bodybuilder.planets -> Planet $planet {
      next if $planet.is_home;
      note "Upgrading " ~ $planet.name;
      self.build($planet)
    }
}
