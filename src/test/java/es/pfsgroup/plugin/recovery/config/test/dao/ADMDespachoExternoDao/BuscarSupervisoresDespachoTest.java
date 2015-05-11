package es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao;

import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.testfwk.ColumnCriteria;
import es.pfsgroup.testfwk.JoinColumnCriteria;

/**
 * Este test comprueba que se busquen correctamente los supervisores de un
 * despacbho
 * 
 * @author bruno
 * 
 */
public class BuscarSupervisoresDespachoTest extends
		AbstractADMDespachoExternoDaoTest {

	/**
	 * Prueba el caso general
	 * 
	 * @throws Exception
	 */
	@Test
	public void testBuscarSupervisoresDespacho() throws Exception {
		cargaDatos();

		List<GestorDespacho> expected = getDatosPruebas(GestorDespacho.class,
				new JoinColumnCriteria("DES_ID", 1L), new ColumnCriteria(
						"USD_SUPERVISOR", 1));

		List<GestorDespacho> result = dao.buscarSupervisoresDespacho(1L);

		assertTrue("La cantidad de resultados no coincide.",
				expected.size() == result.size());

	}

	/**
	 * Verifica que si no hay datos se devuelva una lista vacía.
	 * @throws Exception 
	 */
	@Test
	public void testSinDatos_listaVacia() throws Exception {
		cambiaFicheroDatos("/dbunit-test-data/Gestores-Despachos_despachoSinGestores.xml");
		cargaDatos();
		List<GestorDespacho> result = dao.buscarSupervisoresDespacho(1L);

		assertNotNull(result);
		assertTrue("La lista debería estar vacía.",
				result.isEmpty());
	}
}
