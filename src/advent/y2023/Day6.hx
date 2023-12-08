package advent.y2023;

private var test = 'Time:      7  15   30
Distance:  9  40  200';

private typedef Race = {
	var time:Int;
	var distance:Int;
}

class Day6 extends Day {
	public function new() {
		year = 2023;
		day = 6;
		super();
	}

	function processData(glom = false, ?test):Array<Race> {
		var trimMiddle = ~/\s\s*/g;
		var data = parseData(test).map(i -> trimMiddle.replace(i, " ").split(" ").slice(1));
        if (glom) data = data.map(i -> [i.join('')]);
		return [
			for (x => v in data[0])
				{
					time: Std.parseInt(data[0][x]),
					distance: Std.parseInt(data[1][x])
				}
		];
	}

	public function Part1() {
		var retval = 1;
		for (race in processData(false))
			for (x in 1...Math.round(race.time / 2))
				if (x * (race.time - x) > race.distance) {
					retval *= race.time - (x * 2) + 1;
					break;
				}
		return retval;
	}

	public function Part2() {
        // NOTE: this doesn't work; number too big
        return cast null;

        var race = processData(true)[0];
        for (x in 1...Math.round(race.time / 2))
            if (x * (race.time - x) > race.distance)
                return race.time - (x * 2) + 1;

        return null;
    }
}
