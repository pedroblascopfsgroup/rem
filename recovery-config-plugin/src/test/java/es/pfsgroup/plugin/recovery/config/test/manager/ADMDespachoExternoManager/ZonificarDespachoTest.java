package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.plugin.recovery.config.PluginConfigBusinessOperations;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class ZonificarDespachoTest extends
		AbstractADMDespachoExternoManagerTest {

	private static final Long ARG_ID_DESPACHO = 1L;
	private static final Long ARG_ID_ZONA = 1L;

	@Test
	public void testZonificarDespacho() throws Exception {

		DespachoExterno mockDespacho = mock(DespachoExterno.class);
		DDZona zona = TestData.newTestObject(DDZona.class);

		prepareTest(mockDespacho, zona);

		admDespachoExternoManager.zonificarDespacho(ARG_ID_DESPACHO,
				ARG_ID_ZONA);

		verify(mockDespacho).setZona(zona);
		verify(despachoExternoDao).saveOrUpdate(mockDespacho);

	}

	private void prepareTest(DespachoExterno mockDespacho, DDZona zona) {
		when(despachoExternoDao.get(ARG_ID_DESPACHO)).thenReturn(mockDespacho);
		when(
				executor
						.execute(
								PluginConfigBusinessOperations.ZONA_MGR_GET, ARG_ID_ZONA)).thenReturn(zona);
	}

	@Test
	public void testZonificarDespacho_nullArguments_excepcion()
			throws Exception {
		TestTemplate test = new NullArgumentsTest(admDespachoExternoManager,
				"zonificarDespacho", Long.class, Long.class);
		test.run();
	}

	@Test
	public void testZonificarDespacho_noExisteDespacho_exception()
			throws Exception {
		DDZona zona = TestData.newTestObject(DDZona.class);
		prepareTest(null, zona);
		try {
			admDespachoExternoManager.zonificarDespacho(ARG_ID_DESPACHO,
					ARG_ID_ZONA);
			fail("Debería haberse lanzado una excepción");
		} catch (BusinessOperationException e) {

		}

		verify(despachoExternoDao, never()).saveOrUpdate(
				any(DespachoExterno.class));
	}
	
	@Test
	public void testZonificarDespacho_noExisteZona_exception()
			throws Exception {
		DespachoExterno mockDespacho = mock(DespachoExterno.class);
		prepareTest(mockDespacho, null);
		try {
			admDespachoExternoManager.zonificarDespacho(ARG_ID_DESPACHO,
					ARG_ID_ZONA);
			fail("Debería haberse lanzado una excepción");
		} catch (BusinessOperationException e) {

		}

		verify(mockDespacho, never()).setZona(any(DDZona.class));
		verify(despachoExternoDao, never()).saveOrUpdate(
				any(DespachoExterno.class));
	}
}
