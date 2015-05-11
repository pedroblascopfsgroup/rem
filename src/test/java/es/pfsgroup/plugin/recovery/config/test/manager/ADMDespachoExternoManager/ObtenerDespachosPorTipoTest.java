package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class ObtenerDespachosPorTipoTest extends
		AbstractADMDespachoExternoManagerTest {

	@Test
	public void testObtenerDespachosPorTipo_delegarDao() throws Exception {
		
		List<DespachoExterno> expected = new ArrayList<DespachoExterno>();
		when(despachoExternoDao.getByTipo(1L)).thenReturn(expected );

		List<DespachoExterno> result = admDespachoExternoManager
				.getDespachoExternoByTipo(1L);
		
		assertEquals(expected, result);
		
		verify(despachoExternoDao,times(1)).getByTipo(1L);
	}

	@Test
	public void testNullArgument_exception() throws Exception {
		TestTemplate template = new NullArgumentsTest(admDespachoExternoManager,"getDespachoExternoByTipo",Long.class);
		template.run();
	}
}
