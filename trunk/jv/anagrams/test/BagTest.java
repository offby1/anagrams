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
    
    public BagTest(String testName) {
        super(testName);
    }

    protected void setUp() throws Exception {
    }

    protected void tearDown() throws Exception {
    }
    
    public void testYow() {
        Bag b = new Bag("");
        assertTrue(b.empty());
    }
}
