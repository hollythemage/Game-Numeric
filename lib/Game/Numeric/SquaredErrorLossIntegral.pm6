use v6.c;

### squared error loss is defined by (theta - a)^2 
### == theta^2 - 2 * theta * a + a^2
### it's integral is theta^2 * - 2/2 * theta * a^2 + a^3/3

class Game::Numeric::SquaredErrorLossIntegral {

	submethod BUILD() {
	}

	### API method :
	method calculate-integral($a, $b, $theta) { ### a lower bound, b upper bound
		return self.integral($theta, $b) - self.integral($theta, $a);
	}

	method integral($theta, $a) {

		return self.square($theta) * $a -  
			$theta * self.square($a) + self.cubic($a)/3;	

	}

	

	method square($t) {
		return Math::pow($t,2);
	}

	method cubic($t) {
		return Math::pow($t,3);
	}
}
