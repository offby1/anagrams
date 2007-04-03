import bag;
import dictionary;
import std.stream;

dictionary the_dictionary;

char [][] anagrams_internal (dictionary d, bag b)
{
  char [][] rv;
  bag smaller_bag = new bag ();

  foreach (bag this_word, char [][] these_anagrams; d) {
    printf ("%*s\n", this_word.toString ());
  }
  
  rv.length = rv.length + 1;
  rv[rv.length - 1] = "Whoops";

  rv.length = rv.length + 1;
  rv[rv.length - 1] = "Golly";
  return rv;
}

int main()
{
  BufferedFile s = new BufferedFile (
                                     "/usr/share/dict/words"
                                     //"one_percent_dict"
                                     );
  printf ("Snarfing big dictionary ...\n");
  the_dictionary = new dictionary (s, "Ernest");
  printf ("done\n");

  foreach (char [] a;  anagrams_internal (the_dictionary, new bag ("Ernest"))) {
    printf ("%*s\n", a);
  }
  
  return 0;
}
