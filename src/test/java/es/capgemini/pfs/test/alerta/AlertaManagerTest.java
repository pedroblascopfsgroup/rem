/**
 * 
 */
package es.capgemini.pfs.test.alerta;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.alerta.AlertaManager;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * @author minigo
 *
 */
public class AlertaManagerTest extends CommonTestAbstract {
	
	@Autowired
	private AlertaManager alertaManager;

	/**
	 * Test method for {@link es.capgemini.pfs.alerta.AlertaManager#getDtoAlertasActivas()}.
	 */
	@Test
	public final void testGetDtoAlertasActivas() {
		alertaManager.getDtoAlertasActivas();
	}

}
