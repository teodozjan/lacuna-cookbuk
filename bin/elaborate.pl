use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyCritic;


my BodyBuilder $b = BodyBuilder.from_file('./var/bodybuilder.pl');

#session info is static for all classes
my LacunaSession $f = LacunaSession.new;
$f.create_session;

BodyCritic.new(bodybuilder => $b).elaborate;

$f.close_session;




