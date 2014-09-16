using Lua;
using Gee;


class ConfigReader : Object {
    public LuaVM vm;
    
    public ConfigReader() {
        vm = new LuaVM ();
    }
    
    
    public int loadConfigFile(string filename)
    {
        if (vm.do_file(filename)) {
            stdout.printf("Cannot load config file: %s.\n", filename);
            return -1;
        }
        
        return 0;
    }
    
    public int getNumber(string varname) {
            vm.get_global(varname);
            if (!vm.is_number(-1)) {
                stdout.printf("Variable %s is not a number.\n", varname);
                return -1;
            }
            
            var num = vm.to_number(-1);
            vm.pop(1);
            
            return (int)num;
    }
    
    public string? getString(string varname) {
            vm.get_global(varname);
            if (!vm.is_string(-1) && !vm.is_number(-1)) {
                stdout.printf("Variable %s is not a string.\n", varname);
                return null;
            }
            
            var str = vm.to_string(-1);
            vm.pop(1);
            
            return str;
    }

    // specially, arr_name is 'hosts'
    public int[] getNumberArray(string arr_name) {
            vm.get_global(arr_name);
            
            int[] num_arr = {};
            
            vm.push_nil();
            while (vm.next(-2) != 0) {
                var index = vm.to_number(-2);
                var val = vm.to_number(-1);
                num_arr += val;
                vm.pop(1);
            }
            
            vm.pop(2);
            return num_arr;
    }

    // specially, arr_name is 'hosts'
    public string[] getStringArray(string arr_name) {
            vm.get_global(arr_name);
            
            string[] str_arr = {};
            
            vm.push_nil();
            while (vm.next(-2) != 0) {
                var index = vm.to_number(-2);
                var str = vm.to_string(-1);
                str_arr += str;
                vm.pop(1);
            }
            
            vm.pop(2);
            return str_arr;
    }

    
    public HashMap<string, string>? getHash(string varname) {
            vm.get_global(varname);
            if (!vm.is_table(-1)) {
                stdout.printf("Variable %s is not a hash.\n", varname);
                return null;
            }
            
            var hash = new HashMap<string, string> ();
            
            vm.push_nil();
            while (vm.next(-2) != 0) {
                var key = vm.to_string(-2);
                var val = vm.to_string(-1);
                hash.set(key, val);
                vm.pop(1);
            }
            
            vm.pop(2);
            return hash;
    }
    
    // specially, arr_name is 'hosts'
    public HashMap<string, string> getArrayItem(string arr_name, int i) {
            vm.get_global(arr_name);
            vm.raw_geti(-1, i);
            
            var item = new HashMap<string, string> ();
            
            vm.push_nil();
            string key, val;
            while (vm.next(-2) != 0) {
                if (vm.is_string(-2) && vm.is_string(-1)) {
                    key = vm.to_string(-2);
                    val = vm.to_string(-1);
                    item.set(key, val);
                }
                vm.pop(1);
            }
            
            vm.pop(3);
            return item;
    }
    
    // specially, arr_name is "hosts", key is "routes"
    public HashMap<string, string> getArrayItemInnerHash(string arr_name, int i, string key) {
            vm.get_global(arr_name);
            vm.raw_geti(-1, i);
            vm.get_field(-1, key);
            
            var hash = new HashMap<string, string> ();
            
            vm.push_nil();
            while (vm.next(-2) != 0) {
                var key = vm.to_string(-2);
                var val = vm.to_string(-1);
                hash.set(key, val);
                vm.pop(1);
            }
            
            vm.pop(4);
            return hash;
    }
    
    
    
    
}



/*
static int loadConfigFile(LuaVM vm, string filename)
{
    if (vm.load_file(filename) != 0 || vm.pcall(0, 0, 0) != 0 ) {
        stdout.printf("Cannot load config file: %s.\n", filename);
        return -1;
    }
    
    return 0;
}



static int loadConfigFile(LuaVM vm, string filename)
{
    if (vm.do_file(filename)) {
        stdout.printf("Cannot load config file: %s.\n", filename);
        return -1;
    }
    
    return 0;
}
*/



static int main () {

    var vm = new LuaVM ();
    vm.open_libs ();

    loadConfigFile(vm, "config.lua");

    vm.get_global("zmqport");
    string s = vm.to_string(-1);
    
    stdout.printf("%s --->\n", s);
    

    /*
    // Create a Lua table with name 'foo'
    vm.new_table ();
    for (int i = 1; i <= 5; i++) {
        vm.push_number (i);         // Push the table index
        vm.push_number (i * 2);     // Push the cell value
        vm.raw_set (-3);            // Stores the pair in the table
    }
    vm.set_global ("foo");

    // Ask Lua to run our little script
    vm.do_string ("""

        -- Receives a table, returns the sum of its components.
        io.write("The table the script received has:\n");
        x = 0
        for i = 1, #foo do
          print(i, foo[i])
          x = x + foo[i]
        end
        io.write("Returning data back to C\n");
        return x

    """);

    // Get the returned value at the top of the stack (index -1)
    var sum = vm.to_number (-1);

    stdout.printf ("Script returned: %.0f\n", sum);

    vm.pop (1);  // Take the returned value out of the stack
    */

    return 0;
}
