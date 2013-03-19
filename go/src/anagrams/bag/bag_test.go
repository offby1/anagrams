package bag

import (
	"testing"
)

func TestWordsToBags(t *testing.T) {
	type TestCase struct {
		Input          string
		ExpectedOutput string
	}

	var cases = []TestCase{
		TestCase{"", ""},
		TestCase{"cat", "act"},
		TestCase{" Cat ! ... ", "act"},
		TestCase{"CAT", "act"},
		TestCase{"tac", "act"},
		TestCase{"acat", "aact"},
	}

	for _, c := range cases {
		actual := FromString(c.Input)
		if string(actual.letters) != c.ExpectedOutput {
			t.Errorf("For word '%s', got %v but expected %v",
				c.Input,
				actual.letters,
				c.ExpectedOutput)
		}
	}
}

func TestSubtraction(t *testing.T) {
	type TestCase struct {
		Minuend            string
		Subtrahend         string
		ExpectedDifference string
		ExpectedStatus     bool
	}

	var cases = []TestCase{
		TestCase{"", "", "", true},
		TestCase{"a", "", "a", true},
		TestCase{"", "a", "", false},
		TestCase{"cat", "a", "ct", true},
		TestCase{"caat", "a", "act", true},
	}

	for _, c := range cases {
		minuend := FromString(c.Minuend)
		subtrahend := FromString(c.Subtrahend)
		diff, ok := minuend.Subtract(subtrahend)

		if ok != c.ExpectedStatus || string(diff.letters) != c.ExpectedDifference {
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
		t.Errorf("%v otta be empty but isn't", empty)
	}
}
