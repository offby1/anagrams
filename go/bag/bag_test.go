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

func TestWordsToBags(t *testing.T) {
	type TestCase struct {
		Input          string
		ExpectedOutput Bag
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
		if actual != c.ExpectedOutput {
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
		ExpectedDifference Bag
		ExpectedError      bool
	}

	var cases = []TestCase{
		TestCase{"", "", 1, false},
		TestCase{"a", "", WordToBag("a"), false},
		TestCase{"", "a", Bag(1), true},
		TestCase{"cat", "a", WordToBag("ct"), false},
		TestCase{"caat", "a", WordToBag("cat"), false},
	}

	for _, c := range cases {
		diff, err := Subtract(WordToBag(c.Minuend), WordToBag(c.Subtrahend))
		if (err == nil) == c.ExpectedError || diff != c.ExpectedDifference {
			t.Errorf("For '%s' - '%s', got %d, %s but expected %d, %s",
				c.Minuend,
				c.Subtrahend,
				diff, err,
				c.ExpectedDifference, c.ExpectedError)
		}
	}
}
