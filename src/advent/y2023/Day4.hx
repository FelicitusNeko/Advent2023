package advent.y2023;

import haxe.Exception;

private var test1 = 'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11';

private typedef Card = {
    var id:Int;
	var winningNumbers:Array<Int>;
	var yourNumbers:Array<Int>;
}

class Day4 extends Day {
	public function new() {
		year = 2023;
		day = 4;
		super();
	}

	function processData(?test) {
		inline function parseNumberList(list:String, sort = true) {
			var iretval = list.split(" ").filter(i -> i != "").map(Std.parseInt);
			if (sort)
				iretval.sort((x, y) -> x - y);
			return iretval;
		}

		var retval:Array<Card> = [];
		var pattern = ~/^Card\s+(\d+): ([\s\d]+)\| ([\s\d]+)$/;
		for (card in parseData(test)) {
			if (!pattern.match(card))
				throw new Exception('Invalid card data "$card"');
			retval.push({
                id: Std.parseInt(pattern.matched(1)),
				winningNumbers: parseNumberList(pattern.matched(2)),
				yourNumbers: parseNumberList(pattern.matched(3))
			});
		}
		return retval;
	}

	public function Part1() {
		var retval = 0;
		for (card in processData()) {
			var x = 0, y = 0, match = 0;
			while (x < card.yourNumbers.length && y < card.winningNumbers.length) {
				if (card.yourNumbers[x] == card.winningNumbers[y]) {
					x++;
					y++;
					match++;
				} else if (card.yourNumbers[x] < card.winningNumbers[y])
					x++;
				else if (card.yourNumbers[x] > card.winningNumbers[y])
					y++;
			}
			if (match > 0)
				retval += Math.round(Math.pow(2, match - 1));
		}
		return retval;
	}

	public function Part2() {
		var retval = 0;
		var extras:Map<Int, Int> = [];

		for (card in processData()) {
			var x = 0, y = 0, match = 0, copies = 1;
            if (extras.exists(card.id)) {
                copies += extras[card.id];
                extras.remove(card.id);
            }
            retval += copies;
			while (x < card.yourNumbers.length && y < card.winningNumbers.length) {
				if (card.yourNumbers[x] == card.winningNumbers[y]) {
					x++;
					y++;
                    if (extras.exists(card.id + ++match)) extras[card.id + match] += copies;
                    else extras.set(card.id + match, copies);
				} else if (card.yourNumbers[x] < card.winningNumbers[y])
					x++;
				else if (card.yourNumbers[x] > card.winningNumbers[y])
					y++;
			}
		}
		return retval;
	}
}
