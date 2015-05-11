package es.pfsgroup.plugin.recovery.config.test.manager.ADMFuncionManager;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.plugin.recovery.config.funciones.dto.ADMDtoBuscarFunciones;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;

/**
 * Verifica la búsqueda de funciones
 * @author bruno
 *
 */
public class BuscarFuncionesTest extends AbstractADMFuncionManagerTest{

	/**
	 * Prueba del caso normal
	 * @throws Exception 
	 */
	@Test
	public void testBuscarFunciones() throws Exception{
		// Devolvemos lo mismo que nos da el DAO
		ADMDtoBuscarFunciones dto = new ADMDtoBuscarFunciones();
		List<Funcion> expected = new ArrayList<Funcion>();
		PageHibernate ph = TestData.newTestObject(PageHibernate.class);
		ph.setResults(expected);
		when(dao.findAll(dto)).thenReturn(ph);
		
		Page result = manager.buscaFunciones(dto);
		
		assertEquals(expected, result.getResults());
		
		verify(dao,times(1)).findAll(dto);
		verifyNoMoreInteractions(dao);
	}
}
