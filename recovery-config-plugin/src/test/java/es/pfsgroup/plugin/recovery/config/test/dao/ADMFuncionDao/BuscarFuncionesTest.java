package es.pfsgroup.plugin.recovery.config.test.dao.ADMFuncionDao;

import static org.junit.Assert.*;

import org.junit.Test;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.config.funciones.dto.ADMDtoBuscarFunciones;

public class BuscarFuncionesTest extends AbstractADMFuncionDaoTest{

	@Test
	public void testDevolverTodasFunciones() throws Exception {
		cargaDatos();
		
		Page result = dao.findAll(setupPage(new ADMDtoBuscarFunciones()));
		assertEquals(3, result.getResults().size());
		assertEquals(result.getResults().size(), result.getTotalCount());
	}
	
	public void testSinDatos_paginaVacia() throws Exception {
		Page result = dao.findAll(setupPage(new ADMDtoBuscarFunciones()));
		assertNotNull(result);
		assertEquals(0, result.getResults().size());
	}
}
