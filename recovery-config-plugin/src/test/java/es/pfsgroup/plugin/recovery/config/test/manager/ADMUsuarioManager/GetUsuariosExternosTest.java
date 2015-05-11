package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import java.util.List;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.testfwk.ColumnCriteria;

public class GetUsuariosExternosTest extends AbstractADMUsuarioManagerTest{
	
	@Test
	public void testListarUsuariosExternos() throws Exception{
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(1L));
		List<Usuario> listUsu = getTestData(Usuario.class, new ColumnCriteria("USU_EXTERNO", 1));
		Mockito.when(usuarioDao.getUsuariosExternos(1L)).thenReturn(listUsu);
		
		List<Usuario> result = admUsuarioManager.getUsuariosExternos();
		
		Assert.assertEquals(listUsu, result);
	}
	

}
