package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import java.util.List;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

public class GetDespachosSupervisorTest extends AbstractADMUsuarioManagerTest {
	
	@Test
	public void testListarDespachosSupervisor() throws Exception{
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(1L));
		List<DespachoExterno> listDesp = getTestData(DespachoExterno.class);
		Mockito.when(usuarioDao.findDespachoSupervisor(1L, 1L)).thenReturn(listDesp);
		
		List<DespachoExterno> result = admUsuarioManager.getDespachosSupervisor(1L);
		
		Assert.assertEquals(listDesp, result);
	}

}
