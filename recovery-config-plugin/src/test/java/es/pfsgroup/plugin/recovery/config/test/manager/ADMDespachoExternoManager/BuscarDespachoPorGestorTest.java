package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.testfwk.ColumnCriteria;
import es.pfsgroup.testfwk.TestData;

public class BuscarDespachoPorGestorTest extends AbstractADMDespachoExternoManagerTest{
	
	@Test
	public void testBuscarDespachoPorGestor() throws Exception{
		DespachoExterno expected = getTestData(DespachoExterno.class, new ColumnCriteria("DES_ID", 2L)).get(0);
		
		Mockito.when(despachoExternoDao.buscarPorGestor(4L)).thenReturn(expected);
		DespachoExterno result = admDespachoExternoManager.buscaPorGestor(4L);
		
		Assert.assertEquals(expected, result);
		Mockito.verify(despachoExternoDao).buscarPorGestor(4L);
	}
	
	@Test
	public void testDespachoNoExiste(){
		Mockito.when(despachoExternoDao.buscarPorGestor(4L)).thenReturn(null);
		
		DespachoExterno result = admDespachoExternoManager.buscaPorGestor(4L);
		
		Assert.assertNull(result);
		
		Mockito.verify(despachoExternoDao).buscarPorGestor(4L);
	}

}
