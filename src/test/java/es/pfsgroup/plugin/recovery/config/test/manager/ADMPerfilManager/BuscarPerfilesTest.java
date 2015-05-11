package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;

import org.junit.Test;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.config.perfiles.dto.ADMDtoBuscaPerfil;
public class BuscarPerfilesTest extends AbstractADMPerfilManagerTest{
	
	@Test
	public void testBuscarPerfiles(){
		// Delegamos completamente al dao
		ADMDtoBuscaPerfil dto = new ADMDtoBuscaPerfil();
		Page mockPage = mock(Page.class);
		
		when(perfilDao.findPerfiles(dto)).thenReturn(mockPage );
		Page result = manager.findPerfiles(dto);
		
		assertEquals(mockPage, result);
		verifyZeroInteractions(mockPage);
	}

}
