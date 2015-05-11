package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.fail;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

public class CambiaGestorDefectoTest extends
AbstractADMDespachoExternoManagerTest {
	
	@Test
	public void testCambiaGestorDefecto() throws Exception {
		
		GestorDespacho mockNuevoGestor = mock(GestorDespacho.class);
		DespachoExterno mockDespacho = mock(DespachoExterno.class);
		List<GestorDespacho> listGestores = new ArrayList<GestorDespacho>();
		listGestores.add(mock(GestorDespacho.class));
		listGestores.add(mock(GestorDespacho.class));
		listGestores.add(mock(GestorDespacho.class));
		listGestores.add(mock(GestorDespacho.class));
		
		when(gestorDespachoDao.get(3L)).thenReturn(mockNuevoGestor);
		when(mockNuevoGestor.getDespachoExterno()).thenReturn(mockDespacho);
		when(mockDespacho.getId()).thenReturn(1L);
		
		
		when(despachoExternoDao.buscarGestoresDespacho(1L)).thenReturn(listGestores);
		
		GestorDespacho result = admDespachoExternoManager.cambiaGestorDefecto(3L);
		
		verify(mockNuevoGestor).setGestorPorDefecto(true);
		for (GestorDespacho mock :  listGestores){
			verify(mock).setGestorPorDefecto(false);
		}
		Assert.assertEquals(mockNuevoGestor, result);
		
	}
	
	@Test
	public void testSiIdGestorNuloLanzaExcepcion() throws Exception{
		
		try{
		admDespachoExternoManager.cambiaGestorDefecto(null);
		fail("Se debería haber lanzado una excepcion");
		}
		catch(IllegalArgumentException e){
		}
		verify(gestorDespachoDao,never()).get(anyLong());			
	}
	
	@Test
	public void testSiIdGestorNoExisteLanzaExcepcion() throws Exception{
		
		try{
		admDespachoExternoManager.cambiaGestorDefecto(7L);
		fail("Se debería haber lanzado una excepcion");
		}
		catch(BusinessOperationException e){
		}
					
	}

}
