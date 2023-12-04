package advent;

import haxe.Exception;
//import sys.Http;
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;

using StringTools;

//using thx.promise.Promise;

abstract class Day {
	public var year(default, null):Int;
	public var day(default, null):Int;
    public var data:String;

    var USERAGENT = File.getContent("./secrets/useragent");
    var COOKIE = File.getContent("./secrets/session");

	var inputURI(get, never):String;

	public function new() {
        // getData().either(
        //     v -> data = v,
        //     e -> throw e
        // );
        data = getData();
	}

	final inline function get_inputURI()
		return 'https://adventofcode.com/$year/day/$day/input';

    final function getData() {
		if (!FileSystem.exists("./cache"))
			FileSystem.createDirectory("./cache");
		var cachePath = Path.join(["./cache", Std.string(year)]);
		if (!FileSystem.exists(cachePath))
			FileSystem.createDirectory(cachePath);
		var cacheFile = Path.join([cachePath, '$day.txt']);

		// if (FileSystem.exists(cacheFile)) return Promise.value(File.getContent(cacheFile));
        if (FileSystem.exists(cacheFile)) return File.getContent(cacheFile);
        throw new Exception("Today's cache not found and auto retrieval not working");
        // return Promise.create((f, r) -> {
        //     var h = new Http(inputURI);
        //     h.addHeader("User-Agent", USERAGENT);
        //     h.addHeader("Cookie", 'session=$COOKIE');
        //     h.onData = d -> {
        //         File.saveContent(cacheFile, d);
        //         f(d);
        //     }
        //     h.onError = e -> r(new thx.Error('HTTP error: $e'));
        //     h.request();
        // });
    }

    function parseData(?test:String)
        return (test ?? data).trim().split("\n");

    abstract public function Part1():Null<Dynamic>;
    abstract public function Part2():Null<Dynamic>;
}
