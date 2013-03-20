package bag

import (
	"fmt"
	"sort"
	"strings"
)

type Bag struct {
	Letters []byte
}

func (b Bag) Format(f fmt.State, c rune) {
	fmt.Fprintf(f, "%v",
		b.Letters)
}

func (b Bag) AsString() string {
	return string(b.Letters)
}

type SortableString []byte

func (s SortableString) Len() int {
	return len(s)
}
func (s SortableString) Less(i, j int) bool {
	return s[i] < s[j]
}
func (s SortableString) Swap(i, j int) {
	tmp := s[i]
	s[i] = s[j]
	s[j] = tmp
}

func FromString(w string) Bag {
	w = strings.ToLower(w)
	sort_me := make(SortableString, 0)
	for _, ch := range w {

		if ch >= 'a' && ch <= 'z' {
			sort_me = append(sort_me, byte(ch))
		}
	}

	sort.Sort(sort_me)
	return Bag{sort_me}
}

func (this Bag) same(other Bag) bool {
	return string(this.Letters) == string(other.Letters)
}

func (this Bag) Empty() bool {
	return len(this.Letters) == 0
}

func (minuend Bag) Subtract(subtrahend Bag) (Bag, bool) {
	diff, ok := subtract(minuend.Letters, subtrahend.Letters)
	return Bag{diff}, ok
}

func cmp(a, b []byte) int {
	if a[0] < b[0] {
		return -1
	}
	if a[0] == b[0] {
		return 0
	}
	return 1
}

func subtract(top, bottom []byte) ([]byte, bool) {
	output_size := 0
	difference := make([]byte, len(top))

	for {
		switch {
		case len(bottom) == 0:
			copy(difference[output_size:], top)
			output_size += len(top)
			difference = difference[:output_size]
			return difference, true
		case len(top) == 0:
			return top, false
		case top[0] == bottom[0]:
			break
		case top[0] > bottom[0]:
			return top, false
		default:
			for cmp(top, bottom) < 0 {
				difference[output_size] = top[0]
				output_size++

				top = top[1:]
				if len(top) == 0 {
					break
				}
			}

			continue
		}

		top = top[1:]
		bottom = bottom[1:]
	}
	difference = difference[:output_size]
	return difference, true
}
