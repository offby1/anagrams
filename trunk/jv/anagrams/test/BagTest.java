import java.util.Hashtable;
import junit.framework.*;
/*
 * BagTest.java
 * JUnit based test
 *
 * Created on April 7, 2007, 12:00 AM
 */

/**
 *
 * @author Eric
 */
public class BagTest extends TestCase {
    Bag sam;
    Bag mas;
    public BagTest(String testName) {
        super(testName);
    }
    
    protected void setUp() throws Exception {
        sam = new Bag("sam");
        mas = new Bag("mas");
    }
    
    protected void tearDown() throws Exception {
        
    }
    
    public void testEmpty() {
        Bag b = new Bag("");
        assertTrue(b.empty());
        Bag c = new Bag("sam");
        assertFalse(c.empty());
    }
    public void testEquality(){
        assertTrue(mas.equals(sam));
    }
    public void testSubtract(){
        Bag actual = sam.subtract(new Bag("s"));
        Bag expected = new Bag("am");
        assertTrue(actual.equals(expected));
        actual = actual.subtract(new Bag("x"));
        assertNull(actual);
    }
    public void testHash(){
        int c1 = sam.hashCode();
        int c2 = mas.hashCode();
        assertEquals(c1, c2);
        Hashtable<Bag, String> ht = new Hashtable<Bag, String>();
        ht.put(sam, "hey");
        assertEquals( "hey", ht.get(mas));
    }
}