package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqArquetipoManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;

public class ListaArquetiposTest extends AbstractARQArquetipoManagerTest{
	
	@Test
	public void testListarArquetipos() throws Exception{
		List<ARQListaArquetipo> expected = new ArrayList<ARQListaArquetipo>();
		expected.add(new ARQListaArquetipo());
		expected.add(new ARQListaArquetipo());
		
		when(arquetipoDao.getList()).thenReturn(expected);
		
		List<ARQListaArquetipo> result = arqArquetipoManager.listaArquetipos();
		
		assertEquals(expected, result);
		
		verify(arquetipoDao, times(1)).getList();
	}

}
