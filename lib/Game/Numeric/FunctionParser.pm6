use v6.c;

### a parser for f(x)

class Game::Numeric::FunctionParser {

	has $!function-string; ### e.g. x for f(x)

	submethod BUILD(:$str) {
		### the character x for f(x) can be used and alpahanums,+ and * 
		$!function-string = $str;
	}

	multi method set-function-string($str) {
		$!function-string = $str;
	}

	multi method call-function($value) {
		return self.construct-function-value($value);		
	}	

	### constructing a function value for f(x)
	### $a is the value of x
	multi method construct-function-value($a) {
		my $tempvalue = 0.0;
		my $result = 0.0;
		### we start at 1 for $backwardchar and $forwardchar
		return self.parse-simple(1, $tempvalue, $a, $result, $!function-string);
	}

	### FIXME grammar and regexes
	multi method parse-simple($index, $tempvalue, $a, $result, $substring) {
		my $len = $substring.bytes;
		my $prevop = '';
		my $op = '';

		while ($index+1 < $len) {
			my $backwardchar = $substring.substr($index-1, $index);

			if ($backwardchar === 'x') {
				$tempvalue = $a;
			} elsif ($backwardchar.unival) {  ### alphanumeric
				my ($idx, $rslt) =  self.scan-number($index-1, $substring);
				$index = $idx;
				$tempvalue = $rslt;
			}
			my $char = $substring.substr($index, $index + 1);
			if ($char === '*') {
				$prevop = $op;
				$op = '*';
				my $forwardchar = $substring.substr($index+1, $index + 2);
				if ($forwardchar === 'x') {
					$tempvalue *= $a;
					$tempvalue = 0.0;
					
				} elsif ($forwardchar.unival != NaN) {
					my ($idx, $rslt) =  self.scan-number($index-1, $substring);
					$index = $idx;
					$tempvalue *= $rslt;
						
				}
				### coming out of parsing, adding to $result
				if ($prevop === '*') {
					$result *= $tempvalue;
				} elsif ($prevop === '+') {
					$result += $tempvalue;
				} else {
					$result = $tempvalue;
				}
				$tempvalue = 0.0;
			} elsif ($char === '+') {
				$prevop = $op;
				$op = '+';
				my $forwardchar = $substring.substr($index+1, $index + 2);
				if ($forwardchar === 'x') {
					$tempvalue *= $a;
					$tempvalue = 0.0;
					
				} elsif ($forwardchar.unival != NaN) {
					my ($idx, $rslt) =  self.scan-number($index-1, $substring);
					$index = $idx;
					$tempvalue *= $rslt;
						
				}
				### coming out of parsing, adding to $result
				if ($prevop === '*') {
					$result *= $tempvalue;
				} elsif ($prevop === '+') {
					$result += $tempvalue;
				} else {
					$result = $tempvalue;
				}
				$tempvalue = 0.0;
			}
			$index += 1;			
		}
		return $result;	
	}

	### helper function
	multi method scan-number($index, $substring) {
		my $t = 0;
		my $result = 0.0;
		while ($substring.substr($index, $index+1).unival != NaN) {
			$result += $t*10*$substring.substr($index, $index+1);
			$index += 1;
		}

		return ($index, $result);
	}	

}
