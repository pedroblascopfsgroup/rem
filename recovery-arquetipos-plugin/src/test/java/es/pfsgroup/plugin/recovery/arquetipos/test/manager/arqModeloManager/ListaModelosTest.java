package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqModeloManager;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;

public class ListaModelosTest extends AbstractARQModeloManagerTest{
	
	/**
	 *  Prueba del caso normal
	 * @throws Exception
	 */
	@Test
	public void testListarModelos() throws Exception{
		List<ARQModelo> expected = new ArrayList<ARQModelo>();
		when(modeloDao.getList()).thenReturn(expected);
		
		List<ARQModelo> result = arqModeloManager.listaModelos();
		
		assertEquals(expected, result);
		verify(modeloDao, times(1)).getList();
		
	}

}
