use v6;

use LacunaCookbuk::Model::Body;
use LacunaCookbuk::Model::Parliament;

class SpaceStation is Body;

submethod find_parliament(--> Parliament) { #(--> Trade)){
    for self.buildings -> LacunaBuilding $building {
	return Parliament.new(id => $building.id) if $building.url ~~ $Parliament::URL;
    }
    #warn "No Parliament on " ~ self.name;
    Parliament;
}

