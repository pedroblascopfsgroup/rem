package es.pfsgroup.plugin.recovery.config.test.bugtracking.dao.ADMDespachoExternoDao;

import org.junit.Test;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoBusquedaDespachoExterno;
import es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao.AbstractADMDespachoExternoDaoTest;

/**
 * Esta clase comprueba la búsqueda de despachos externos
 * 
 * @author bruno
 * 
 */
public class BuscarDespachosExternosBugsTest extends
		AbstractADMDespachoExternoDaoTest {

	/**
	 * Este test comrpueba que el contador de resultados del objeto Page sea
	 * correcto.
	 * 
	 * @throws Exception
	 */
	@Test
	public void testTotalCount_esCorrecto() throws Exception {
		int totalDespachos = 2;
		
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = setupPage(new ADMDtoBusquedaDespachoExterno());
		dto.setUsername("U");
		Page result = dao.findDespachosExternos(dto);

		assertNotNull("El resultado no debería haber sido NULL", result);
		// Esta comprobación la hacemos a causa de un bug encontrado el
		// 29/10/2009 por el cual el contador del objeto Page no contenia el
		// valor correcto en consultas con distinct
		assertEquals("Total Count no es correcto", totalDespachos, result.getTotalCount());
	}

}
