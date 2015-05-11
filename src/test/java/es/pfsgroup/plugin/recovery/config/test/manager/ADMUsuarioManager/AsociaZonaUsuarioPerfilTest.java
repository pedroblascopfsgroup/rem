package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import static org.junit.Assert.fail;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Arrays;
import java.util.Collection;

import junit.framework.Assert;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.plugin.recovery.config.usuarios.ADMUsuarioManager;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

public class AsociaZonaUsuarioPerfilTest extends AbstractADMUsuarioManagerTest {

	@Test
	public void testAsociaZonPefUsu() throws Exception {
		ADMUsuarioManager mockManager = spy(admUsuarioManager);

		Collection<Long> listZona = Arrays.asList(1L, 2L, 3L, 4L);
		EXTPerfil mockPerfil = mock(EXTPerfil.class);
		Usuario mockUsuario = mock(Usuario.class);
		DDZona mockZona = mock(DDZona.class);
		ZonaUsuarioPerfil mockZonpefusu = mock(ZonaUsuarioPerfil.class);

		Entidad entidad = creaEntidadPruebas(1L);
		obtenUsuarioLogadoDeExecutor(entidad);
		when(mockManager.createNewZonaUsuarioPerfil())
				.thenReturn(mockZonpefusu);
		when(usuarioDao.get(1L)).thenReturn(mockUsuario);
		when(mockUsuario.getEntidad()).thenReturn(entidad);
		when(perfilDao.get(1L)).thenReturn(mockPerfil);
		when(zonaDao.get(anyLong())).thenReturn(mockZona);

		mockManager.asociaZonaUsuarioPerfil(listZona, 1L, 1L);
		verify(mockManager, times(listZona.size()))
				.createNewZonaUsuarioPerfil();
		verify(mockZonpefusu, times(listZona.size())).setUsuario(mockUsuario);
		verify(mockZonpefusu, times(listZona.size())).setPerfil(mockPerfil);
		verify(mockZonpefusu, times(listZona.size())).setZona(mockZona);
		verify(zonaUsuarioPerfilDao, times(listZona.size()))
				.save(mockZonpefusu);
	}

	@Test
	public void testUsuarioDeOtraEntidad_excepcion() throws Exception {
		Collection<Long> listZona = Arrays.asList(1L, 2L, 3L, 4L);
		Entidad entidad1 = creaEntidadPruebas(1L);
		Entidad entidad2 = creaEntidadPruebas(2L);
		Usuario mockUsuario = mock(Usuario.class);
		when(usuarioDao.get(1L)).thenReturn(mockUsuario);
		when(mockUsuario.getEntidad()).thenReturn(entidad2);
		obtenUsuarioLogadoDeExecutor(entidad1);
		
		try{
			admUsuarioManager.asociaZonaUsuarioPerfil(listZona, 1L, 1L);
			fail("No se ha lanzado la excepci�n");
		}catch(BusinessOperationException e){}
		
	}

	@Test
	public void testCreateNewZonPefUsu() throws Exception {
		ZonaUsuarioPerfil zonpefusu = admUsuarioManager
				.createNewZonaUsuarioPerfil();
		Assert.assertNotNull(zonpefusu);
		Assert.assertTrue(zonpefusu instanceof ZonaUsuarioPerfil);
	}

}
