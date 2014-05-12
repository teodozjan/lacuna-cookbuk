use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Planet;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;

#session info is static for all classes
my LacunaSession $f = LacunaSession.new;
$f.create_session;

say "Creating all possible halls";
PlanMaker.new.makePossibleHalls();

#todo transport in separate class
say "Transporting all glyphs to home planet if possible";
Transporter.new.transport_glyphs;

say "Checking balance on home planet (takes ages)";
say Planet.new.calculate_sustainablity();

$f.close_session;




