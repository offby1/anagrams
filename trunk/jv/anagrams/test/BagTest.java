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
    public BagTest(String testName) {
        super(testName);
    }
    
    protected void setUp() throws Exception {
        sam = new Bag("sam");
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
        Bag mas = new Bag("mas");
        assertTrue(mas.equals(sam));
    }
    public void testSubtract(){
        Bag actual = sam.subtract(new Bag("s"));
        Bag expected = new Bag("am");
        assertTrue(actual.equals(expected));
        actual = actual.subtract(new Bag("x"));
        assertNull(actual);
    }
}