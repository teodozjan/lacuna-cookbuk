use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Planet;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::BodyCritic;


my BodyBuilder $b = BodyBuilder.from_file('./var/bodybuilder.pl');


#session info is static for all classes
my LacunaSession $f = LacunaSession.new;
$f.create_session;

BodyCritic.new(bodybuilder => $b).elaborate;

say "Creating all possible halls";
PlanMaker.new(bodybuilder => $b).makePossibleHalls;

#todo transport in separate class
say "Transporting all glyphs to home planet if possible";
Transporter.new(bodybuilder => $b).transport_all_cargo;

#say "Checking balance on home planet (takes ages)";
#say Planet.home_planet.calculate_sustainablity();

$f.close_session;




