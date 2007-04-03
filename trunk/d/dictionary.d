import std.stream;
import bag;

class dictionary
{
  int [char []][bag] map;

  this (Stream s, char [] filter)
  {
    bag f = new bag (filter);
    while (!s.eof ())
      {
        char []this_line = s.readLine ();
        bag t = new bag (this_line);
        bag diff;
        bool ok;
        f.subtract (t, diff, ok);
        if (ok)
          map[t][this_line]++;
      }
  }

  int size ()
  {
    return map.length;
  }
  
  char[][] lookup (bag b)
  {
    return map[b].keys;
  }
  bag[] keys ()
  {
    return map.keys;
  }

  unittest
  {
    printf ("Snarfing a test dictionary; patience! ... \n");
    alias char[] strings;
    strings test_lines;

    test_lines ~= "Hey\n";
    test_lines ~= "You\n";
    test_lines ~= "cuz\n";
    test_lines ~= "what\n";
    test_lines ~= "up\n";
    test_lines ~= "zuc\n";
    test_lines ~= "cuz\n";
    test_lines ~= "what\n";

    dictionary words = new dictionary (new TArrayStream! (char[]) (test_lines),
                                       "heyyoucuzwhatup");
    printf ("done\n");
    assert (5 == words.size ());

    printf ("Dictionary unit tests passed\n");
  }
}
