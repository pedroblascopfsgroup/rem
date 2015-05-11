/**
 * 
 */
package es.capgemini.pfs.test.actitudAptitudActuacion;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.actitudAptitudActuacion.TipoAyudaActuacionManager;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * @author minigo
 *
 */
public class TipoAyudaActuacionManagerTest  extends CommonTestAbstract{
	
	@Autowired
	private TipoAyudaActuacionManager tipoAyudaActuacionManager;

	/**
	 * Test method for {@link es.capgemini.pfs.actitudAptitudActuacion.TipoAyudaActuacionManager#getList()}.
	 */
	@Test
	public void testGetList() {
		tipoAyudaActuacionManager.getList();
	}

	/**
	 * Test method for {@link es.capgemini.pfs.actitudAptitudActuacion.TipoAyudaActuacionManager#getByCodigo(java.lang.String)}.
	 */
	@Test
	public void testGetByCodigo() {
		tipoAyudaActuacionManager.getByCodigo("codigo");
	}

}
