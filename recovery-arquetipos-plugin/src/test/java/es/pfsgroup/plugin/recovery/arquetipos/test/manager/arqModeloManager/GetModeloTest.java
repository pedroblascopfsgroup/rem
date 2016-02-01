package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqModeloManager;


import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;

public class GetModeloTest extends AbstractARQModeloManagerTest{
	
	@Test
	public void testGetModelo() throws Exception{
		ARQModelo expected = new ARQModelo();
		Mockito.when(modeloDao.get(1L)).thenReturn(expected);
		
		ARQModelo result = arqModeloManager.getModelo(1L);
		
		Assert.assertNotNull(result);
		Assert.assertEquals(expected, result);
		Mockito.verify(modeloDao).get(1L);
		
		
	}

}
