use v6.c;
use Test;      # a Standard module included with Rakudo 
use lib 'lib';

my $num-tests = 2;

plan $num-tests;
 
# .... tests 
#  

use-ok "Game::Numeric::Integral";
use-ok "Game::Numeric::FunctionParser";

done-testing;  # optional with 'plan' 
