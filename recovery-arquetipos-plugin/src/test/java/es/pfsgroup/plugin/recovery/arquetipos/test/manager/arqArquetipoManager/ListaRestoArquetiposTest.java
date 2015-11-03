package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqArquetipoManager;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.junit.Test;

import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

public class ListaRestoArquetiposTest extends AbstractARQArquetipoManagerTest {
	
	@Test
	public void testListarRestoArquetipos() throws Exception{
		
		List<ARQListaArquetipo> mockListArquetipos = mock (List.class);
		Set<ARQListaArquetipo> setArquetipos = new HashSet<ARQListaArquetipo>();
		
		ARQModeloArquetipo mockModeloArquetipo = mock(ARQModeloArquetipo.class);
		when(arquetipoDao.getList()).thenReturn(mockListArquetipos);
	}
		

}
