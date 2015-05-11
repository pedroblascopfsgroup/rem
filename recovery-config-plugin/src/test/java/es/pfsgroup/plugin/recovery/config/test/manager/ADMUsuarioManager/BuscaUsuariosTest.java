package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import static org.junit.Assert.*;

import java.util.List;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.testfwk.JoinColumnCriteria;

public class BuscaUsuariosTest extends AbstractADMUsuarioManagerTest{
	
	@Test
	public void testBuscaUsuarios_filtraPorEntidad() throws Exception {
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(1L));
		List <Usuario> expected = getTestData (Usuario.class);
		Mockito.when(usuarioDao.getListByEntidad(1L)).thenReturn(expected);
		
		List <Usuario> result = admUsuarioManager.buscaUsuarios();
		
		Mockito.verify(usuarioDao,Mockito.times(1)).getListByEntidad(1L);
		Assert.assertNotNull(result);
		Assert.assertEquals(expected, result);
		
	}

}
