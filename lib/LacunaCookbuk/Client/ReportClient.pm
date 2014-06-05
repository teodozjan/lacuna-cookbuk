use v6;

use LacunaCookbuk::Client;
use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::BodyCritic;

class ReportClient is Client;

submethod ships {
    
    BodyCritic.new(bodybuilder => self.cache).elaborate_ships;
}

submethod ore {
    
    BodyCritic.new(bodybuilder => self.cache).elaborate_ore;
}

