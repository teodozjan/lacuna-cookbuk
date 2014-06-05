use v6;

use LacunaCookbuk::Logic::Chairman;


class SpacePortChairman does Chairman;

submethod make_smuggler_capable(Planet $planet){

    my @buildings = $planet.find_buildings($SpacePort::URL);
    if @buildings[0].view.level > 9 {
	note $planet.name ~ " smuggler capable";
	return;
    }
    @buildings.=sort:{.view.level};
  

    my LacunaBuilding $port =  @buildings[@buildings.end];
    if $port.view.level < 10 {
	try $port.upgrade;
	note $port.view.level ~ " level on " ~ $planet.name ~ ": " ~ $!;
    } else {
	note $planet.name ~ " smuggler capable";
    }
}

method check_space_ports {
    for self.bodybuilder.planets -> $planet {
	self.make_smuggler_capable($planet)
    }
}
