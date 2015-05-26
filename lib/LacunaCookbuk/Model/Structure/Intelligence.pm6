use v6;

use LacunaCookbuk::Model::Empire;
use LacunaCookbuk::Model::LacunaBuilding;
use LacunaCookbuk::Model::Spy;

unit class Intelligence does LacunaBuilding;

constant $URL = '/intelligence';
has $.maximum;
has $.current;

method train_spies(Int $num=(self.maximum)){
    rpc($URL).train_spy(session_id, self.id)
}

method get_view_spies {
    my @spies = rpc($URL).view_spies(session_id, self.id)<spies>;
    my Spy @list = gather for @spies -> @spy {
	for @spy -> %spyattr {
	    take Spy.new(|%spyattr);
	}
    }
    @list;
}

method name_spy(Str $spy_id, Str $name){
    rpc($URL).name_spy(session_id, self.id, $spy_id, $name);
}

