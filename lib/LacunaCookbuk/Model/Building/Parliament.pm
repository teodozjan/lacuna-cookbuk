use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class Parliament is LacunaBuilding;

constant $URL = '/parliament';

method view_propositions {
    return self.rpc($URL).view_propositions(self.session_id, self.id)<propositions>;
}

method cast_vote($vote_id, $vote) {
    say $vote_id.perl;
    say $vote.perl;
    self.rpc($URL).cast_vote(self.session_id, self.id, $vote_id);


}
