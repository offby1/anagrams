use v6;
use Test;

sub bag_from_letters($letters) {
    my %bag;
    for $letters.split('') -> $l {
        my $lc = $l.lc;
        %bag{$lc}++ if $lc ~~ 'a' .. 'z';
    }
    %bag;
}

sub bag_empty($b) {
    return $b == {};
}

is_deeply(bag_from_letters('abcdeaa'), {a=>3, b=>1, c=>1, d=>1, e=>1});
is_deeply(bag_from_letters('AB!!!c') , {a=>1, b=>1, c=>1});
ok(bag_empty(bag_from_letters('')));
nok(bag_empty(bag_from_letters('whoa nellie')));
is_deeply(bag_from_letters('a '), bag_from_letters('a'));
is_deeply(bag_from_letters('abc'), bag_from_letters('cba'));

done;
