package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqModeloArquetipoManager;

import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

public class GetModeloArquetipoTest extends AbstractARQModeloArquetipoManagerTest {
	
	@Test
	public void testGetModeloArquetipo() throws Exception{
		ARQModeloArquetipo expected = new ARQModeloArquetipo();
		Mockito.when(modeloArquetipoDao.get(2L)).thenReturn(expected);
		
		ARQModeloArquetipo result = arqModeloArquetipoManager.getModeloArquetipo(2L);
		
		Assert.assertNotNull(result);
		Assert.assertEquals(expected, result);
		Mockito.verify(modeloArquetipoDao).get(2L);
		
	}

}
