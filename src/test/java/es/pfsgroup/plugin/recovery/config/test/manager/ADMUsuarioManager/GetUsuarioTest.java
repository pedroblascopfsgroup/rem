package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.testfwk.ColumnCriteria;

public class GetUsuarioTest extends AbstractADMUsuarioManagerTest {
	
	@Test
	public void testObtenerUsuario() throws Exception {
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(3L));
		Usuario expected = getTestData(Usuario.class, new ColumnCriteria("USU_ID", 1L)).get(0);
		Mockito.when(usuarioDao.getByEntidad(1L,3L)).thenReturn(expected);
		
		Usuario result = admUsuarioManager.getUsuario(1L);
		
		Assert.assertNotNull(result);
		Assert.assertEquals(expected, result);
		Mockito.verify(usuarioDao).getByEntidad(1L,3L);
	}

}
