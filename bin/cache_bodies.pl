use v6;
use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;


#session info is static for all classes
my LacunaSession $f = LacunaSession.new;
$f.create_session;



my BodyBuilder $b = BodyBuilder.new(session =>$f);
$b.process_all_bodies($f.planets_hash);

#relative path should be exchanged
$b.to_file('./var/bodybuilder.pl');

$f.close_session;
