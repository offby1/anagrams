package bag

import (
	"math/big"
	"testing"
)

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
		if !actual.same_as_int(c.ExpectedOutput) {
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
		ExpectedStatus     bool
	}

	var cases = []TestCase{
		TestCase{"", "", big.NewInt(1), true},
		TestCase{"a", "", FromString("a").z, true},
		TestCase{"", "a", big.NewInt(1), false},
		TestCase{"cat", "a", FromString("ct").z, true},
		TestCase{"caat", "a", FromString("cat").z, true},
	}

	for _, c := range cases {
		minuend := FromString(c.Minuend)
		subtrahend := FromString(c.Subtrahend)
		diff, ok := minuend.Subtract(subtrahend)

		if ok != c.ExpectedStatus || diff.z.Cmp(c.ExpectedDifference) != 0 {
			t.Errorf("For '%s' - '%s', got %d, %s but expected %d, %s",
				c.Minuend,
				c.Subtrahend,
				diff, ok,
				c.ExpectedDifference, c.ExpectedStatus)
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

func TestGobs(t *testing.T) {
	b := FromString("frotz!!")
	gob, _ := b.GobEncode()

	roundtripped := new(Bag)

	roundtripped.GobDecode(gob)

	better_be_empty, better_be_true := b.Subtract(*roundtripped)

	if !better_be_true {
		t.Errorf("WTF!!")
	}
	if !better_be_empty.Empty() {
		t.Errorf("%v otta be empty but isn't", better_be_empty)
	}

}
