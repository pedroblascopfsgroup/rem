package es.pfsgroup.plugin.recovery.config.test.manager.ADMTipoDespachoExternoManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;

public class ObtenerTiposDeDespachoTest extends AbstractADMTipoDespachoExternoManagerTest{

	
	@Test
	public void testObtenerTipos() throws Exception {
		
		List<DDTipoDespachoExterno> listaDespachos = getTestData(DDTipoDespachoExterno.class);
		when(dao.getList()).thenReturn(listaDespachos );
		
		List<DDTipoDespachoExterno> result = manager.getList();
		
		assertEquals(listaDespachos, result);
	}
}
