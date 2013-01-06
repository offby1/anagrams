package bag

import "testing"
import "math/big"

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

func TestWordsToBags(t *testing.T) {
	type TestCase struct {
		Input          string
		ExpectedOutput int64
	}

	var cases = []TestCase{
		TestCase{"", 1},
		TestCase{"cat", 710},
		TestCase{" Cat ! ... ", 710},
		TestCase{"CAT", 710},
		TestCase{"tac", 710},
		TestCase{"acat", 1420},
	}

	for _, c := range cases {
		actual := WordToBag(c.Input)
		if actual.Cmp(big.NewInt(c.ExpectedOutput)) != 0 {
			t.Errorf("For word '%s', got %d but expected %d",
				c.Input,
				actual,
				c.ExpectedOutput)
		}
	}
}

func TestSubtraction(t *testing.T) {
	type TestCase struct {
		Minuend            string
		Subtrahend         string
		ExpectedDifference *big.Int
		ExpectedError      bool
	}

	var cases = []TestCase{
		TestCase{"", "", big.NewInt(1), false},
		TestCase{"a", "", WordToBag("a"), false},
		TestCase{"", "a", big.NewInt(1), true},
		TestCase{"cat", "a", WordToBag("ct"), false},
		TestCase{"caat", "a", WordToBag("cat"), false},
	}

	for _, c := range cases {
		diff, err := Subtract(WordToBag(c.Minuend), WordToBag(c.Subtrahend))
		if (err == nil) == c.ExpectedError || diff.Cmp(c.ExpectedDifference) != 0 {
			t.Errorf("For '%s' - '%s', got %d, %s but expected %d, %s",
				c.Minuend,
				c.Subtrahend,
				diff, err,
				c.ExpectedDifference, c.ExpectedError)
		}
	}
}
