/**
 * 
 */
package es.capgemini.pfs.test.acuerdo;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.acuerdo.AcuerdoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * @author minigo
 *
 */
public class AcuerdoManagerTest extends CommonTestAbstract {
	
	@Autowired
	private AcuerdoManager acuerdoManager;

	/**
	 * Test method for {@link es.capgemini.pfs.acuerdo.AcuerdoManager#getAcuerdoById(java.lang.Long)}.
	 */
	@Test
	public final void testGetAcuerdoById() {
		acuerdoManager.getAcuerdoById(1L);
	}

}
