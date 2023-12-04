package advent.y2023;

import haxe.Exception;
import utils.Point;

private var test1 = '467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..';

private enum MapSymbol {
	Empty;
	Digit(d:Int);
	Symbol(s:String);
}

class Day3 extends Day {
	static var ZERO = '0'.charCodeAt(0);
	static var NINE = '9'.charCodeAt(0);
	static var PERIOD = '.'.charCodeAt(0);

    var p2sol:Null<Int> = null;

	public function new() {
		year = 2023;
		day = 3;
		super();
	}

	function processData(?test) {
		var retval = parseData(test).map(i -> i.split('').map(ii -> switch (ii.charCodeAt(0)) {
			case x if (x >= ZERO && x <= NINE): Digit(x - ZERO);
			case x if (x == PERIOD): Empty;
			default: Symbol(ii);
		}));
		return retval;
	}

	public function Part1() {
		var map = processData();
		var gears:Map<String, Array<Int>> = [];
		var retval = 0;

		for (y => row in map) {
			var num = 0, start = -1, streak = 0;
			function scan() {
				var hasSymbol = false;
				if (start < 0 || streak == 0)
					return;
				for (dy in -1...2) {
					for (dx in -1...streak + 1) {
						var pt = new Point(start + dx, y + dy);
						switch (pt.arrayGet(map) ?? Empty) {
                            case Symbol(s):
                                hasSymbol = true;
								if (s == '*') {
									if (!gears.exists(pt))
										gears.set(pt, [num]);
									else
										gears[pt].push(num);
								}
							default:
						}
					}
				}
				if (hasSymbol)
					retval += num;
				num = 0;
				start = -1;
				streak = 0;
			}

			for (x => cell in row)
				switch (cell) {
					case Digit(d):
						if (start == -1)
							start = x;
						streak++;
						num = num * 10 + d;
					default:
						scan();
				}
			scan();
		}

        p2sol = 0;
		for (nums in gears)
			if (nums.length == 2)
				p2sol += nums[0] * nums[1];

		return retval;
	}

	public function Part2() {
        if (p2sol == null) throw new Exception('Run part 1 first');
        return cast p2sol;
	}
}
