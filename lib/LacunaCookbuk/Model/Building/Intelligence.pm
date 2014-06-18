use v6;

use LacunaCookbuk::Model::Empire;
use LacunaCookbuk::Model::LacunaBuilding;
use LacunaCookbuk::Model::Spy;

class Intelligence does LacunaBuilding;
#has $.view = rpc($url).view(session_id, self.id)<spies>;

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

