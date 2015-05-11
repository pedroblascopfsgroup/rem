package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import java.util.List;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

public class ListarDespachosExternos extends AbstractADMDespachoExternoManagerTest{

	@Test
	public void testListarDespachosExternos() throws Exception{
		List<DespachoExterno> expected = getTestData(DespachoExterno.class);
		Mockito.when(despachoExternoDao.getList()).thenReturn(expected);
		
		List<DespachoExterno> result = admDespachoExternoManager.buscaDespachosExternos();
		
		Assert.assertEquals(expected, result);
		Mockito.verify(despachoExternoDao,Mockito.times(1)).getList();
	}
}
