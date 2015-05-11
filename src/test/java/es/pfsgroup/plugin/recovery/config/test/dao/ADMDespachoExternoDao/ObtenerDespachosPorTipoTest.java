package es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao;

import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.testfwk.JoinColumnCriteria;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class ObtenerDespachosPorTipoTest extends AbstractADMDespachoExternoDaoTest{

	
	
	@Test
	public void testObtenerDespachosPorTipo() throws Exception {
		
		int expected1 = 2;
		int expected2 = 1;
		
		cargaDatos();
		
		List<DespachoExterno> result1 = dao.getByTipo(1L);
		List<DespachoExterno> result2 = dao.getByTipo(2L);
		
		assertEquals(expected1, result1.size());
		assertEquals(expected2, result2.size());
		
	}
	
	@Test
	public void testNullArguments_excepcion() throws Exception {
		TestTemplate template = new NullArgumentsTest(dao,"getByTipo",Long.class);
		template.run();
	}
	
	@Test
	public void testTipoNoExiste_listaVacia() throws Exception {
		cargaDatos();
		assertEquals(0L, dao.getByTipo(100L).size());
	}
	
	public void testSinDatos_listaVacia() throws Exception {
		assertEquals(0L, dao.getByTipo(1L).size());
	}
}
