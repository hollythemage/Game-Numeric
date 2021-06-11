use v6.c;

use Game::Numeric::FunctionParser;

### calculation of integrals by numerical (analytical) functions
### e.g. trapezoidal rule

class Game::Numeric::Integral {

	has $!funcp;

	### $str e..g (t - a)^2 ==> t*t-2*a*t+a*a
	submethod BUILD(:$str) {
		$!funcp = Game::Numeric::FunctionParser.new($str);	
	}

	multi method calculate-composite-trapezoidal-rule($a, $b, $n) {
		my $sum = 0.0;

		loop (my $k = 0; $k < $n-1; $k++) {
			$sum += $!funcp.call-function($a + $k/$n*($b-$a));
		}

		return ($b - $a) / $n *($!funcp.call-function($a)/2 + $sum + $!funcp.call-function($b)/2);
	}
}
