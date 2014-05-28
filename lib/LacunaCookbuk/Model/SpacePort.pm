use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class SpacePort is LacunaBuilding;

constant $URL = '/spaceport';

has $.max_ships;
has $.docks_available;
has %.docked_ships;

