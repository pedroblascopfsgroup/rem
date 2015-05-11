package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import java.util.List;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.testfwk.ColumnCriteria;

public class GetUsuariosNoExternosTest extends AbstractADMUsuarioManagerTest{
	
	@Test
	public void testListarUsuariosNoExternos() throws Exception{
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(1L));
		List<Usuario> listUsu = getTestData(Usuario.class, new ColumnCriteria("USU_EXTERNO", 0));
		Mockito.when(usuarioDao.getUsuariosNoExternos(1L)).thenReturn(listUsu);
		
		List<Usuario> result = admUsuarioManager.getUsuariosNoExternos();
		
		Assert.assertEquals(listUsu, result);
	}
	

}
