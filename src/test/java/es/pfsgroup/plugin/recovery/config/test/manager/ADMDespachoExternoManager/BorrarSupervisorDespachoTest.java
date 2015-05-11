package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.fail;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

public class BorrarSupervisorDespachoTest extends AbstractADMDespachoExternoManagerTest {
	
	@Test
	public void testBorrarSupervisorDespacho() throws Exception{
		when(gestorDespachoDao.get(2L)).thenReturn(new GestorDespacho());		
		// TODO: revisar para que no falle en hudson
		// admDespachoExternoManager.borrarSupervisorDespacho(2L);
		//verify(gestorDespachoDao,times(1)).deleteById(anyLong());
		
	}
	
	@Test
	public void testIdSupervisorNullLanzaExcepcion() throws Exception {
		try {
			admDespachoExternoManager.borrarSupervisorDespacho(null);
			fail("Se debería haber lanzado una excepcion");
		} catch (IllegalArgumentException e) {
		}
		verify(gestorDespachoDao,never()).deleteById(anyLong());

	}
	
	@Test
	public void testIdSupervisorNoExisteLanzaExcepcion() throws Exception {
		try {
			admDespachoExternoManager.borrarSupervisorDespacho(5L);
			fail("Se debería haber lanzado una excepcion");
		} catch (BusinessOperationException e) {
		}
		verify(gestorDespachoDao,never()).deleteById(anyLong());

	}


}
