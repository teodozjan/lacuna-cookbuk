use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class Intelligence does LacunaBuilding;
#has $.view = self.rpc($url).view(self.session_id, self.id)<spies>;

constant $URL = '/intelligence';
has $.maximum;
has $.current;

method train_spies(Int $num=(self.maximum-current)){


}
