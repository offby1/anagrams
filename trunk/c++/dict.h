// -*-c++-*-
#ifndef DICT_H
#define DICT_H

#include <vector>
#include <numeric-bag.h>

typedef std::vector<std::string> wordlist;
//typedef std::pair<bag, wordlist > entry;

class entry : public std::pair<bag, wordlist > {
public:
  entry (const bag &b, const wordlist &wl)
    : std::pair<bag, wordlist >(b, wl)
  {}
  bool operator < (const entry &other) const;

  friend std::ostream &
  operator <<(std::ostream &o, const entry &e);

};

extern std::vector<entry > the_dictionary;

void
init (const bag &filter);

#endif
