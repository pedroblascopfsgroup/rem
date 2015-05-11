package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.testfwk.ColumnCriteria;

public class ObtenerDespachoExterno extends AbstractADMDespachoExternoManagerTest{

	@Test
	public void testObtenerDespachoExterno() throws Exception{
		DespachoExterno expected = getTestData(DespachoExterno.class, new ColumnCriteria("DES_ID", 2L)).get(0);
		Mockito.when(despachoExternoDao.get(2L)).thenReturn(expected);
		
		DespachoExterno result = admDespachoExternoManager.getDespachoExterno(2L);
		
		Assert.assertNotNull(result);
		Assert.assertEquals(expected, result);
		Mockito.verify(despachoExternoDao).get(2L);
	}
}
