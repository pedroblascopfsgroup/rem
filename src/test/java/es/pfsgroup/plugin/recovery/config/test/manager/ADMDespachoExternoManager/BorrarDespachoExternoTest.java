package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.*;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.testfwk.TestData;

public class BorrarDespachoExternoTest extends
		AbstractADMDespachoExternoManagerTest {

	@Test
	public void testBorrarDespacho() throws Exception {
		when(despachoExternoDao.get(2L)).thenReturn(new DespachoExterno());
		when(despachoExternoDao.buscarGestoresDespacho(2L)).thenReturn(
				new ArrayList<GestorDespacho>());
		admDespachoExternoManager.borrarDespachoExterno(2L);

		verify(despachoExternoDao).deleteById(2L);
		verify(despachoExternoDao).buscarGestoresDespacho(2L);
	}

	@Test
	public void testTieneGestores_excepcion() throws Exception {
		List<Long> ids = Arrays.asList(1L, 3L, 5L, 99L);
		when(despachoExternoDao.get(2L)).thenReturn(new DespachoExterno());
		when(despachoExternoDao.buscarGestoresDespacho(2L)).thenReturn(
				(List<GestorDespacho>) TestData.newTestCollectionByFieldCriteria(GestorDespacho.class,
						"id", ids));
		
		try{
			admDespachoExternoManager.borrarDespachoExterno(2L);
			fail("Se debería haber lanzado una excepción");
		}catch(BusinessOperationException e){}
		verify(despachoExternoDao).get(2L);
		verify(despachoExternoDao).buscarGestoresDespacho(2L);
		verifyNoMoreInteractions(despachoExternoDao);
	}

	@Test
	public void testIdNullLanzaExcepcion() throws Exception {
		try {
			admDespachoExternoManager.borrarDespachoExterno(null);
			fail("Se debería haber lanzado una excepcion");
		} catch (IllegalArgumentException e) {
		}
		verify(despachoExternoDao, never()).deleteById(anyLong());

	}

	@Test
	public void testIdNoExisteLanzaExcepcion() throws Exception {
		try {
			admDespachoExternoManager.borrarDespachoExterno(3L);
			fail("Se debería haber lanzado una excepcion");
		} catch (BusinessOperationException e) {
		}
		verify(despachoExternoDao, never()).deleteById(anyLong());
	}
}
