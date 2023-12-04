package advent.y2023;

import haxe.Exception;

class Day1 extends Day {
	static var ZERO = '0'.charCodeAt(0);
	static var NINE = '9'.charCodeAt(0);

	public function new() {
		year = 2023;
		day = 1;
		super();
	}

	public function Part1() {
		var total = 0;
		for (line in parseData()) {
			var digits = ~/[^\d]/g.replace(line, "").split('');
			total += Std.parseInt('${digits[0]}${digits[digits.length - 1]}');
		}
		return total;
	}

	public function Part2() {
		var dnames = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

		var total = 0;
		for (line in parseData()) {
			var firstNum:Null<Int> = null, lastNum:Null<Int> = null;
			inline function setnum(v:Int) {
				if (firstNum == null)
					firstNum = v;
				lastNum = v;
			}

			var x = 0;
			do {
				var ch = line.charCodeAt(x);
				if (ch == null)
					throw new Exception("Failed char code read");
				if (ch >= ZERO && ch <= NINE)
					setnum(ch - ZERO);
				else
					for (y => digit in dnames)
						if (line.indexOf(digit, x) == x)
							setnum(y);
			} while (++x < line.length);

			total += firstNum * 10 + lastNum;
		}
		return total;
	}
}
