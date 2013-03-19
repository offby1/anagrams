package bag

import "testing"
import "math/big"

func TestLetterToPrime(t *testing.T) {
	b := lettertoprime('b')

	if b != 3 {
		t.Errorf("got %d; wanted 3", b)
	}

	bang := lettertoprime('!')
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
		actual := FromString(c.Input)
		if !actual.SameAsInt(c.ExpectedOutput) {
			t.Errorf("For word '%s', got %v but expected %v",
				c.Input,
				actual.z,
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
		TestCase{"a", "", FromString("a").z, false},
		TestCase{"", "a", big.NewInt(1), true},
		TestCase{"cat", "a", FromString("ct").z, false},
		TestCase{"caat", "a", FromString("cat").z, false},
	}

	for _, c := range cases {
		minuend := FromString(c.Minuend)
		subtrahend := FromString(c.Subtrahend)
		diff, err := minuend.Subtract(subtrahend)

		if (err == nil) == c.ExpectedError || diff.z.Cmp(c.ExpectedDifference) != 0 {
			t.Errorf("For '%s' - '%s', got %d, %s but expected %d, %s",
				c.Minuend,
				c.Subtrahend,
				diff, err,
				c.ExpectedDifference, c.ExpectedError)
		}
	}
}

func TestEmpty(t *testing.T) {
	empty := FromString("")
	not_empty := FromString("frotz!!")

	if not_empty.Empty() {
		t.Errorf("%v otta be non-empty but isn't", not_empty)
	}

	if !empty.Empty() {
		t.Errorf("%v otta be empty but isn't", empty.z)
	}
}
