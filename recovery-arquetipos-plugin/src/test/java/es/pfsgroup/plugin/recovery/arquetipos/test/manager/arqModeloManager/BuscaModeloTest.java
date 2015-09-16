package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqModeloManager;

import junit.framework.Assert;

import org.junit.Test;
import static org.mockito.Mockito.*;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dto.ARQDtoBusquedaModelo;

public class BuscaModeloTest extends AbstractARQModeloManagerTest {
	
	@Test
	public void testBuscaModelos() throws Exception{
		// Delegamos completamente al dao
		ARQDtoBusquedaModelo dto = new ARQDtoBusquedaModelo();
		Page mockPage= mock(Page.class);
		
		when(modeloDao.findModelos(dto)).thenReturn(mockPage);
		Page result = arqModeloManager.buscaModelos(dto);
		
		Assert.assertEquals(mockPage, result);
		verifyZeroInteractions(mockPage);
	}

}
