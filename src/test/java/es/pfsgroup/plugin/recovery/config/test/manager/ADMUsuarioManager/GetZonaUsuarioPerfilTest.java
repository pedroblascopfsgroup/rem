package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import java.util.List;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;

public class GetZonaUsuarioPerfilTest extends AbstractADMUsuarioManagerTest{
	
	@Test
	public void testGetZonPefUsu() throws Exception {
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(100L));
		Usuario usu = new Usuario();
		List<ZonaUsuarioPerfil> expected = getTestData(ZonaUsuarioPerfil.class);
		usu.setZonaPerfil(expected);
		
		Mockito.when(usuarioDao.getByEntidad(1L,100L)).thenReturn(usu);
		
		List<ZonaUsuarioPerfil> result = admUsuarioManager.getZonaUsuarioPerfil(1L);
		
		Assert.assertNotNull(result);
		Assert.assertEquals(expected, result);
		Mockito.verify(usuarioDao).getByEntidad(1L,100L);
	}

}
