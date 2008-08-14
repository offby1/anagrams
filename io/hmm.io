Importer addSearchPath("/usr/local/src/langs/io/cifre/stdlib")

# keys are characters; values are the number of times that character
# appeared in the original string.

Sequence asMap  := method (
  result := Map clone
  self foreach(i, c, 
    ch := c asCharacter asLowercase
    if ((ch >= "a" at(0) asCharacter and ch <= "z" at(0) asCharacter),
      if (result hasKey (ch),
        result atPut (ch, 1 + result at (ch)),
        result atPut (ch, 1)))
    result))

Map asString := method (
  result := String clone
  self foreach (char, count, 
    for (n, 0, count -1,
      result := result asMutable appendSeq (char)))
  result)

f := File setPath ("/usr/share/dict/american-english") openForReading

dict := 

while(line := f readLine,
  line := line asString
  if (line, 
    line print
    ": " print
    line asMap asString linePrint))
