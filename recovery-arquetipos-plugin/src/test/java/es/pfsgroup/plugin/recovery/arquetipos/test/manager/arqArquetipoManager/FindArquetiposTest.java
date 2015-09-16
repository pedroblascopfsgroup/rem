package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqArquetipoManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dto.ARQDtoBusquedaArquetipo;

public class FindArquetiposTest  extends AbstractARQArquetipoManagerTest{
	
	
	@Test
	public void testEncontrarArquetipo () throws Exception {
		
		ARQDtoBusquedaArquetipo dto = new ARQDtoBusquedaArquetipo();
		Page mockPage = Mockito.mock(Page.class);
		
		when(arquetipoDao.findArquetipo(dto)).thenReturn(mockPage );
		Page result = arqArquetipoManager.findArquetipos(dto);
		
		assertEquals(mockPage, result);
		verifyZeroInteractions(mockPage);
		
	}

}
