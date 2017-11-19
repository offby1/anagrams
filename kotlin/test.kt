import org.junit.Assert
import org.junit.Test
import org.junit.BeforeClass

class TestStart {
    companion object {
        lateinit var sam: Bag
    	lateinit var mas: Bag

        @BeforeClass @JvmStatic fun setup() {
            sam = Bag("sam")
            mas = Bag("mas")
    	}
    }

    @Test fun testEmpty() {
        val b = Bag("")
        Assert.assertTrue(b.empty())
        val c = Bag("sam")
		Assert.assertFalse(c.empty())
    }
    @Test fun testEquality() {
        Assert.assertTrue(mas == sam)
    }
    @Test fun testSubtract() {
        var actual = sam - Bag("s")
        Assert.assertEquals(actual, Bag("am"))
        actual = actual?.minus(Bag("x"))
        Assert.assertNull(actual)
    }
    @Test fun testHash() {
        val c1 = sam.hashCode()
        val c2 = mas.hashCode()
        Assert.assertEquals(c1, c2)
        val ht = HashMap<Bag, String>()
        ht.put(sam, "hey")
        Assert.assertEquals("hey", ht.get(mas))
	}

    @Test fun testWordAcceptable() {
        Assert.assertTrue(word_acceptable("dog"))
		Assert.assertFalse(word_acceptable("C3PO"))
    }
}
