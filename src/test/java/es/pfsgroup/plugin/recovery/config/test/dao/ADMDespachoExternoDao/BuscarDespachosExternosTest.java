package es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao;

import static org.junit.Assert.*;

import org.junit.Test;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoBusquedaDespachoExterno;
import es.pfsgroup.testfwk.ColumnCriteria;
import es.pfsgroup.testfwk.JoinColumnCriteria;

/**
 * Esta clase comprueba la búsqueda de despachos externos
 * 
 * @author bruno
 * 
 */
public class BuscarDespachosExternosTest extends
		AbstractADMDespachoExternoDaoTest {

	/**
	 * Verifica que si no hay datos se devuelva una página vacía.
	 */
	@Test
	public void testSinDatos_PaginaVacia() {
		ADMDtoBusquedaDespachoExterno dto = new ADMDtoBusquedaDespachoExterno();
		Page result = dao.findDespachosExternos(dto);

		assertNotNull("El resultado no debería haber sido NULL", result);
		assertTrue("No se deberían haber devuelto resultados", result
				.getTotalCount() == 0);
		assertTrue("No se deberían haber devuelto resultados", result
				.getResults().isEmpty());
	}

	/**
	 * Verifica que si no se especifican criterios de búsqueda debuelve todos
	 * los despachos externos
	 * 
	 * @throws Exception
	 */
	@Test
	public void testSinCriteriosBusqueda_todosLosResultados() throws Exception {

		int numDespachos = 3;
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = new ADMDtoBusquedaDespachoExterno();
		dto = setupPage(dto);
		Page result = dao.findDespachosExternos(dto);

		assertNotNull("El resultado no debería haber sido NULL", result);
		assertEquals("No se han devuelto los resultado esperados",
				numDespachos, result.getResults().size());

	}
	
	@Test
	public void testOrdenarResultados() throws Exception {

		int numDespachos = 3;
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = new ADMDtoBusquedaDespachoExterno();
		dto = setupPage(dto);
		dto.setDir("ASC");
		dto.setSort("despacho");
		Page result = dao.findDespachosExternos(dto);

		assertNotNull("El resultado no debería haber sido NULL", result);
		assertEquals("No se han devuelto los resultado esperados",
				numDespachos, result.getResults().size());

	}

	/**
	 * Verifica la búsqueda de despachos por nombre del despacho
	 * 
	 * @throws Exception
	 */
	@Test
	public void testBuscarPorNombreDespacho() throws Exception {
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = setupPage(new ADMDtoBusquedaDespachoExterno());
		dto.setDespacho("name1");
		Page result1 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result1.getResults().size());
		assertTrue("No se ha devuelto el resultado esperado",
				((DespachoExterno) result1.getResults().get(0)).getId().equals(
						1L));

		dto.setDespacho("name2");
		Page result2 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result2.getResults().size());
		assertTrue("No se ha devuelto el resultado esperado",
				((DespachoExterno) result2.getResults().get(0)).getId().equals(
						2L));

		dto.setDespacho("name2".toUpperCase());
		Page result3 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result3.getResults().size());
		assertTrue("No se ha devuelto el resultado esperado",
				((DespachoExterno) result3.getResults().get(0)).getId().equals(
						2L));
	}

	/**
	 * Verifica la búsqueda de despachos por username
	 * 
	 * @throws Exception
	 */
	@Test
	public void testBuscarPorUsername() throws Exception {
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = setupPage(new ADMDtoBusquedaDespachoExterno());

		dto.setUsername("TEST1");
		Page result1 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result1.getResults().size());
		assertTrue("No se ha devuelto el resultado esperado",
				((DespachoExterno) result1.getResults().get(0)).getId().equals(
						1L));

		dto.setUsername("TEST4");
		Page result2 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result2.getResults().size());
		assertTrue("No se ha devuelto el resultado esperado",
				((DespachoExterno) result2.getResults().get(0)).getId().equals(
						2L));

		dto.setUsername("TEST4".toLowerCase());
		Page result3 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result3.getResults().size());
		assertTrue("No se ha devuelto el resultado esperado",
				((DespachoExterno) result3.getResults().get(0)).getId().equals(
						2L));
	}

	@Test
	public void testBuscarPorUsername_usuarioBorrado() throws Exception {
		cambiaFicheroDatos("/dbunit-test-data/Gestores-Despachos_usuarioBorrado.xml");
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = setupPage(new ADMDtoBusquedaDespachoExterno());

		dto.setUsername("BORRADO");
		Page result = dao.findDespachosExternos(dto);
		assertNotNull("El resultado no debería haber sido NULL", result);
		assertTrue("No se deberían haber devuelto resultados", result
				.getTotalCount() == 0);
		assertTrue("No se deberían haber devuelto resultados", result
				.getResults().isEmpty());
		
	}

	/**
	 * Verifica la búsqueda de despachos por username
	 * 
	 * @throws Exception
	 */
	@Test
	public void testBuscarDespachosSupervisadosPorUsuario() throws Exception {
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = setupPage(new ADMDtoBusquedaDespachoExterno());
		dto.setSupervisor(2L);
		Page result1 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result1.getResults().size());
		assertTrue("No se ha devuelto el resultado esperado",
				((DespachoExterno) result1.getResults().get(0)).getId().equals(
						1L));

		dto.setSupervisor(5L);
		Page result2 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 2,
				result2.getResults().size());
	}

	/**
	 * Verifica que se pueda encontrar un despacho aunque no tenga gestores
	 * asociados.
	 * 
	 * @throws Exception
	 */
	@Test
	public void testBuscarDespachoSinGestores_debeEntontrarDespacho()
			throws Exception {
		cambiaFicheroDatos("/dbunit-test-data/Gestores-Despachos_despachoSinGestores.xml");
		cargaDatos();
		ADMDtoBusquedaDespachoExterno dto = setupPage(new ADMDtoBusquedaDespachoExterno());
		Page result = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado", 1,
				result.getResults().size());
	}

	@Test
	public void testBuscarPorTipoDespacho() throws Exception {

		ADMDtoBusquedaDespachoExterno dto = setupPage(new ADMDtoBusquedaDespachoExterno());
		int numDespachosExternos = 2;
		int numDespachosProcuradores = 1;

		cargaDatos();
		dto.setTipoDespacho(1L);
		Page result1 = dao.findDespachosExternos(dto);

		dto.setTipoDespacho(2L);
		Page result2 = dao.findDespachosExternos(dto);

		assertEquals("No se ha devuelto el número de resultados esperado",
				numDespachosExternos, result1.getResults().size());

		assertEquals("No se ha devuelto el número de resultados esperado",
				numDespachosProcuradores, result2.getResults().size());
	}

}
