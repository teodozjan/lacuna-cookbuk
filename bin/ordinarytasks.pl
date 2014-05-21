use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Planet;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;

#session info is static for all classes
my LacunaSession $f = LacunaSession.new;
$f.create_session;

my BodyBuilder $b = BodyBuilder.new(session =>$f);
$b.process_all_bodies($f.planets_hash);

say "Creating all possible halls";
PlanMaker.new(bodybuilder => $b).makePossibleHalls;

#todo transport in separate class
say "Transporting all glyphs to home planet if possible";
Transporter.new(bodybuilder => $b).transport_all_cargo;

say "Checking balance on home planet (takes ages)";
say Planet.new(bodybuilder => $b).calculate_sustainablity();

$f.close_session;




