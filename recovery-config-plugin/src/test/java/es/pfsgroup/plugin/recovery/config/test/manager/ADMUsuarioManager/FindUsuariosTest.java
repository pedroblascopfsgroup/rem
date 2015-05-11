package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;

import org.junit.Test;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDtoBusquedaUsuario;
import static org.mockito.Mockito.*;

public class FindUsuariosTest extends AbstractADMUsuarioManagerTest {
	
	@Test
	public void testEncontrarUsuarios() throws Exception {
		// Delegamos completamente al dao
		ADMDtoBusquedaUsuario dto = spy(new ADMDtoBusquedaUsuario());
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(1L));
		
		
		Page mockPage = mock(Page.class);
		
		when(usuarioDao.findUsuarios(dto)).thenReturn(mockPage );
		Page result = admUsuarioManager.findUsuarios(dto);
		
		verify(dto).setIdEntidad(1L);
		
		assertEquals(mockPage, result);
		verifyZeroInteractions(mockPage);
		
	}
	
}
