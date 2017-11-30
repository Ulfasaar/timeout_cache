import haxe.unit.TestCase;
import haxe.unit.TestRunner;

class Unit extends TestCase{

    var cache = new TimeoutCache(1200);

    // pretend database 
    var test_val = 0;
    
    public function new(){
        super();
        this.cache.refresh = function(){
            // had to make it untyped to tell the compiler to shut up
            untyped cache.store(test_val++);
        }
    }

    public function test_get(){

        var actual = this.cache.get();
        var expected = 0;
        assertEquals(expected, actual); 
    }

    public function test_cached(){
        // call again should be same value
        var actual = this.cache.get();
        var expected = 0;
        assertEquals(expected, actual); 
    }

    public function test_refreshed(){
        // refresh then call again, should be new value
        this.cache.refresh();
        var actual = this.cache.get();
        var expected = 1;
        assertEquals(expected, actual); 
    }

    public function test_timed_out(){

        // wait 2 seconds
        var current_time = Date.now().getTime();
        var prev_time = current_time;
        var diff_time = current_time - prev_time;

        while(diff_time < 2000){
            current_time = Date.now().getTime();
            diff_time = current_time - prev_time;
        }

        var actual = this.cache.get();
        var expected = 2;
        assertEquals(expected, actual); 
    }
}


class Test{

    public static function main(){
        var runner = new TestRunner();
        runner.add(new Unit());
        runner.run();
    }
}