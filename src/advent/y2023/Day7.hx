package advent.y2023;

import haxe.Exception;

private var test = '32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483';

private var test2 = '33332 50
2AAAA 25';

private typedef Hand = {
	var cards:Array<Int>;
	var bid:Int;
	var rank:HandRank;
}

private enum IHandRank {
	HighCard(hand:Array<Int>);
	OnePair(rank:Int, kickers:Array<Int>);
	TwoPair(high:Int, low:Int, kicker:Int);
	ThreeKind(rank:Int, kickers:Array<Int>);
	FullHouse(big:Int, small:Int);
	FourKind(rank:Int, kicker:Int);
	FiveKind(rank:Int);
}

private abstract HandRank(IHandRank) from IHandRank to IHandRank {
	@:op(a > b)
	static function gt(lh:HandRank, rh:HandRank)
		return comp(lh, rh) > 0;

	public static function comp(lh:HandRank, rh:HandRank):Int {
		// if (lh.getIndex() != rh.getIndex())
			return rh.getIndex() - lh.getIndex();
		// else
		// 	return switch ([lh, rh]) {
		// 		case [FiveKind(lr), FiveKind(rr)]: rr - lr;
		// 		case [FourKind(lr, _), FourKind(rr, _)]:
		// 			rr - lr;
		// 		case [FullHouse(lb, ls), FullHouse(rb, rs)]:
		// 			(lb != rb) ? rb - lb : rs - ls;
		// 		case [ThreeKind(lr, _), ThreeKind(rr, _)]:
		// 			rr - lr;
		// 		case [TwoPair(lh, ll, _), TwoPair(rh, rl, _)]:
		// 			(lh != rh) ? rh - lh : rl - ll;
		// 		case [OnePair(lr, _), OnePair(rr, _)]:
		// 			rr - lr;
		// 		default: 0;
		// 	}
	}

	@:to
	function toInt()
		return switch (this.getName()) {
			case "FiveKind": 6;
			case "FourKind": 5;
			case "FullHouse": 4;
			case "ThreeKind": 3;
			case "TwoPair": 2;
			case "OnePair": 1;
			default: 0;
		}

	public function getIndex()
		return this.getIndex();

	public function getName()
		return this.getName();

	static public function fromHand(cardsorig:Array<Int>) {
        var cards = cardsorig.slice(0);
        cards.sort((x, y) -> y - x);
		var analyse:Map<Int, Int> = [];
		for (card in cards)
			if (!analyse.exists(card))
				analyse.set(card, 1);
			else
				analyse[card]++;

		var max = 0, diffs = 0;
		for (ct in analyse) {
			diffs++;
			if (ct > max)
				max = ct;
		}

		switch ([diffs, max]) {
			case [1, _]:
				return FiveKind(cards[0]);
			case [2, 4]:
				var hb = analyse[cards[0]] == 4;
				return FourKind(hb ? cards[0] : cards[4], hb ? cards[4] : cards[0]);
			case [2, 3]:
				var hb = analyse[cards[0]] == 3;
				return FullHouse(hb ? cards[0] : cards[4], hb ? cards[4] : cards[0]);
			case [3, 3]:
				for (x => y in analyse)
					if (y == 3)
						return ThreeKind(x, cards.filter(i -> i != x));
				throw new Exception("3K not found");
			case [3, 2]:
				var fp = 0;
				for (x => y in analyse)
					if (y == 2) {
						if (fp == 0)
							fp = x;
						else
							return TwoPair(fp > x ? fp : x, fp > x ? x : fp, cards.filter(i -> i != fp && i != x)[0]);
					}
				throw new Exception((fp == 0 ? "First" : "Second") + " pair not found");
			case [4, _]:
				for (x => y in analyse)
					if (y == 2)
						return OnePair(x, cards.filter(i -> i != x));
				throw new Exception("Pair not found");
			default:
				return HighCard(cards);
		}
	}

	@:to
	function toString()
		return switch (this) {
			case HighCard(hand): 'High card ${hand[0]} (${hand.slice(1).join(", ")})';
			case OnePair(rank, kickers): 'Pair of ${rank}s (${kickers.join(", ")})';
			case TwoPair(high, low, kicker): 'Two pair, ${high}s over ${low}s ($kicker)';
			case ThreeKind(rank, kickers): 'Three ${rank}s (${kickers.join(", ")})';
			case FullHouse(big, small): 'Full house, ${big}s over ${small}s';
			case FourKind(rank, kicker): 'Four ${rank}s ($kicker)';
			case FiveKind(rank): 'Five ${rank}s!';
		}
}

class Day7 extends Day {
	static var ranks = "23456789TJQKA".split('');

	public function new() {
		year = 2023;
		day = 7;
		super();
	}

	static function arrayCmp(lh:Array<Int>, rh:Array<Int>) {
		if (lh.length != rh.length)
			throw new Exception("Arrays must be same length");
		for (x in 0...lh.length)
			if (lh[x] != rh[x])
				return rh[x] - lh[x];
		return 0;
	}

	function processData(?test):Array<Hand> {
		return parseData(test).map(i -> {
			var seg = i.split(" ");
			var cards = [for (card in seg[0].split("")) ranks.indexOf(card) + 2];
			return {
				cards: cards,
				bid: Std.parseInt(seg[1]),
				rank: HandRank.fromHand(cards)
			}
		});
	}

	public function Part1() {
		var hands = processData();
        hands.sort((x, y) -> arrayCmp(y.cards, x.cards));
		hands.sort((x, y) -> HandRank.comp(x.rank, y.rank));
        var retval = 0;
        for (x => hand in hands) {
            trace(hand.rank, hand.cards);
            retval += hand.bid * (hands.length - x);
        }
        // 253989971 too high
        // 253958826 too high
        // 253706130 just says wrong but not in which direction
        // ARGH
		return retval;
	}

	public function Part2() {
		return null;
	}
}
