use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;

class Client;

has BodyBuilder $.cache = BodyBuilder.from_file('./var/bodybuilder.pl');
has LacunaSession $.session;

method fill_cache {
#todo review
    #self.cache = BodyBuilder.new(session =>self.session);
    self.cache.process_all_bodies(self.session.planets_hash);
    self.cache.to_file('./var/bodybuilder.pl');
}
