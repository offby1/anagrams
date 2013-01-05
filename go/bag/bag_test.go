package bag

import "testing"

func TestLetterToPrime(t *testing.T) {
	b := LetterToPrime('b')

	if b != 3 {
		t.Errorf("got %d; wanted 3", b)
	}

	bang := LetterToPrime('!')
	if bang != 1 {
		t.Errorf("got %d; wanted 1", bang)
	}
}

type TestCase struct {
	Input          string
	ExpectedOutput Bag
}

func TestWordsToBags(t *testing.T) {
	var cases = []TestCase{
		TestCase{"", 1},
		TestCase{"cat", 710},
		TestCase{"tac", 710},
		TestCase{"acat", 1420},
	}
	for _, c := range cases {
		actual := WordToBag(c.Input)
		if actual != c.ExpectedOutput {
			t.Errorf("For word '%s', got %d but expected %d",
				c.Input,
				actual,
				c.ExpectedOutput)
		}
	}
}
