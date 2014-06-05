use v6;

use LacunaCookbuk::Model::LacunaBuilding;
use LacunaCookbuk::Model::Spy;

class Intelligence does LacunaBuilding;
#has $.view = self.rpc($url).view(self.session_id, self.id)<spies>;

constant $URL = '/intelligence';
has $.maximum;
has $.current;

method train_spies(Int $num=(self.maximum)){
    self.rpc($URL).train_spy(self.session_id, self.id)
}

method get_view_spies {
    my @spies = self.rpc($URL).view_spies(self.session_id, self.id)<spies>;
    my Spy @list = gather for @spies -> @spy {
	for @spy -> %spyattr {
	    take Spy.new(|%spyattr);
	}
    }
    @list;
}

