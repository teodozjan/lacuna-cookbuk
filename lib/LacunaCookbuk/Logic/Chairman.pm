use v6;
use LacunaCookbuk::Logic;
use LacunaCookbuk::Model::SpacePort;
use LacunaCookbuk::Model::LacunaBuilding;

class Chairman is Logic;

enum Building <algae algaepond amalgusmeadow apple archaeology atmosphericevaporator beach bean beeldeban beeldebannest blackholegenerator bread burger capitol cheese chip cider citadelofknope cloakinglab corn cornmeal crashedshipsite crater dairy denton dentonbrambles deployedbleeder development distributioncenter embassy energyreserve entertainment espionage essentiavein fission fissure foodreserve fusion gasgiantlab gasgiantplatform geneticslab geo geothermalvent gratchsgauntlet greatballofjunk grove hallsofvrbansk hydrocarbon intelligence inteltraining interdimensionalrift junkhengesculpture kalavianruins kasternskeep lake lagoon lapis lapisforest libraryofjith lostcityoftyleon luxuryhousing malcud malcudfield massadshenge mayhemtraining mercenariesguild metaljunkarches mine miningministry missioncommand munitionslab naturalspring network19 observatory oracleofanid orerefinery orestorage oversight pancake pantheonofhagness park pie pilottraining planetarycommand politicstraining potato propulsion pyramidjunksculpture ravine rockyoutcrop sand saw security shake shipyard singularity soup spacejunkpark spaceport spacestationlab stockpile subspacesupplydepot supplypod syrup templeofthedrajilites terraforminglab terraformingplatform thedillonforge thefttraining themepark trade transporter university volcano wastedigester wasteenergy wasteexchanger wasterecycling wastesequestration wastetreatment waterproduction waterpurification waterreclamation waterstorage wheat>; 

has Building @.build_order;
constant @STORAGE = (foodreserve, energyreserve, orestorage, wastesequestration, waterstorage);

#constant @RESOURCES = 
method build(Body $body) {  
    if $body.find_development_ministry.full {
	note "Queue full on \n";
	return;
    }

    for self.build_order -> Building $buildingguide {

	my LacunaBuilding @buildings =	$body.find_buildings('/' ~ $buildingguide).sort: {.level};
	for @buildings -> LacunaBuilding $building {
	    try $building.upgrade;
	    if ($!) {
		note "Cannot upgrade " ~ $buildingguide;
		last;		
	    } else {
		note "Successful upgrade of " ~ $buildingguide;
#		last;
	    }
	    
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



submethod capitol_order {
    my @order = (oversight,university, stockpile, trade, shipyard, terraforminglab, gasgiantlab);
    @order.push: archaeology;
    @order.push: @STORAGE;




    @order;
}


submethod glyph_mule_order {
    my @order = (archaeology, spaceport, security, intelligence);

    @order.push: @STORAGE;
    @order.push: saw;



    @order;
}


submethod make_smuggler_capable(Planet $planet){

    my @buildings = $planet.find_buildings($SpacePort::URL);
    if @buildings[0].level > 9 {
	note $planet.name ~ " smuggler capable";
	return;
    }
    @buildings.=sort:{.level};
  

    my LacunaBuilding $port =  @buildings[@buildings.end];
    if $port.level < 10 {
	try $port.upgrade;
	note $port.level ~ " level on " ~ $planet.name ~ ": " ~ $!;
    } else {
	note $planet.name ~ " smuggler capable";
    }
}

method check_space_ports {
    for self.bodybuilder.planets -> $planet {
	self.make_smuggler_capable($planet)
    }

}


