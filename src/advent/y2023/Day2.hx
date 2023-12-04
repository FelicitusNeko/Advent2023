package advent.y2023;

import haxe.Exception;

private typedef Move = {
	var r:Int;
	var g:Int;
	var b:Int;
}

class Day2 extends Day {
	public function new() {
		year = 2023;
		day = 2;
		super();
	}

	function processData(?test) {
		var data = parseData(test);
		var retval:Map<Int, Array<Move>> = [];
		var gameline = ~/^Game (\d+): (.*)$/;
		for (line in data) {
			var moves:Array<Move> = [];

			if (!gameline.match(line))
				throw new Exception('No match on $line');
			var movelist = gameline.matched(2).split("; ").map(i -> i.split(", ").map(ii -> ii.split(' ')));
			for (move in movelist) {
				var movedata:Move = {r: 0, g: 0, b: 0};
				for (color in move) {
					var qty = Std.parseInt(color[0]);
					switch (color[1]) {
						case "red":
							movedata.r += qty;
						case "green":
							movedata.g += qty;
						case "blue":
							movedata.b += qty;
						case z:
							throw new Exception('Unknown color "$z"');
					}
				}
				moves.push(movedata);
			}

			retval.set(Std.parseInt(gameline.matched(1)), moves);
		}

		return retval;
	}

	public function Part1() {
		var cap:Move = {r: 12, g: 13, b: 14};
		var retval = 0;
		for (x => game in processData()) {
			var max:Move = {r: 0, g: 0, b: 0};
			for (move in game) {
				max.r = Math.round(Math.max(max.r, move.r));
				max.g = Math.round(Math.max(max.g, move.g));
				max.b = Math.round(Math.max(max.b, move.b));
			}
			if (max.r <= cap.r && max.g <= cap.g && max.b <= cap.b)
				retval += x;
		}
		return retval;
	}

	public function Part2() {
		var retval = 0;
		for (game in processData()) {
			var max:Move = {r: 0, g: 0, b: 0};
			for (move in game) {
				max.r = Math.round(Math.max(max.r, move.r));
				max.g = Math.round(Math.max(max.g, move.g));
				max.b = Math.round(Math.max(max.b, move.b));
			}
			retval += max.r * max.g * max.b;
		}
		return retval;
	}
}
