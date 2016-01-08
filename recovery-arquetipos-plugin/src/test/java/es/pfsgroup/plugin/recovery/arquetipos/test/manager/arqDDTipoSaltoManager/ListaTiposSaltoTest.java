package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqDDTipoSaltoManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;

public class ListaTiposSaltoTest extends AbstractARQDDTipoSaltoManagerTest{
	
	@Test
	public void testListaTiposSalto() throws Exception{
		List<DDTipoSaltoNivel> expected = new ArrayList<DDTipoSaltoNivel>();
		expected.add(new DDTipoSaltoNivel());
		expected.add(new DDTipoSaltoNivel());
		
		Mockito.when(tipoSaltoDao.getList()).thenReturn(expected);
		List<DDTipoSaltoNivel> result = tipoSaltoManager.listaTiposSalto();
		
		assertEquals(expected, result);
		
		verify(tipoSaltoDao, times(1)).getList();
	}

}
