package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.fail;
import static org.mockito.Mockito.mock;

import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.testfwk.ColumnCriteria;
import es.pfsgroup.testfwk.JoinColumnCriteria;

public class ObtenerGestorDefectoTest extends
		AbstractADMDespachoExternoManagerTest {
	@Test
	public void testObtenerGestorDefecto() throws Exception {
		List<GestorDespacho> gd = getTestData(GestorDespacho.class,
				new JoinColumnCriteria("DES_ID", 1L), new ColumnCriteria(
						"USD_SUPERVISOR", 0));
		Mockito.doReturn(gd).when(despachoExternoDao)
				.buscarGestoresDespacho(1L);

		GestorDespacho result = admDespachoExternoManager
				.dameGestorDefecto(1L);

		Mockito.verify(despachoExternoDao).buscarGestoresDespacho(1L);
		Assert.assertNotNull(result);
		Assert.assertEquals((Long) 1L, (Long) result.getId());
	}

	@Test
	public void testSinGestores() throws Exception {

		Mockito.doReturn(new ArrayList<GestorDespacho>()).when(
				despachoExternoDao).buscarGestoresDespacho(1L);

		GestorDespacho result = admDespachoExternoManager
				.dameGestorDefecto(1L);

		Mockito.verify(despachoExternoDao).buscarGestoresDespacho(1L);
		Assert.assertNull(result);
	}

	@Test
	public void testGestorDefectoDuplicado() throws Exception {
		List<GestorDespacho> listGestores = new ArrayList<GestorDespacho>();
		listGestores.add(mock(GestorDespacho.class));
		listGestores.add(mock(GestorDespacho.class));
		listGestores.add(mock(GestorDespacho.class));
		for (GestorDespacho gd : listGestores){
			Mockito.when(gd.getGestorPorDefecto()).thenReturn(true);
		}
		
		Mockito.doReturn(listGestores).when(despachoExternoDao).buscarGestoresDespacho(1L);
		try {
			admDespachoExternoManager.dameGestorDefecto(1L);;
			fail("Se debería haber lanzado una excepcion");
		}catch (BusinessOperationException e){	
			
		}
		
	}
		

}
