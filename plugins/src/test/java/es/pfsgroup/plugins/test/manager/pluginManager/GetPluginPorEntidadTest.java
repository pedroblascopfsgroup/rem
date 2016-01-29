package es.pfsgroup.plugins.test.manager.pluginManager;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.plugins.PluginManager;
import es.pfsgroup.plugins.dao.EntidadPluginDao;
import es.pfsgroup.plugins.domain.EntidadPlugin;
import es.pfsgroup.testfwk.DInjector;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

public class GetPluginPorEntidadTest {
	private static final String PLUGIN_CODE = "miplugin";
	private static final Long ID_ENTIDAD = 19897989L;

	private EntidadPluginDao entidadPluginDao;

	private PluginManager manager;

	private Entidad mockEntidad;

	@Before
	public void setUp() {
		entidadPluginDao = mock(EntidadPluginDao.class);
		manager = new PluginManager();
		mockEntidad = mock(Entidad.class);
		DInjector di = new DInjector(manager);
		di.inject("entidadPluginDao", entidadPluginDao);
		// comportamiento
		when(mockEntidad.getId()).thenReturn(ID_ENTIDAD);
	}

	@After
	public void tearDown() {
		entidadPluginDao = null;
		manager = null;
		mockEntidad = null;
	}

	@Test
	public void testGetPluginPorEntidad() throws Exception {
		EntidadPlugin ep = new EntidadPlugin();
		when(entidadPluginDao.getPluginPorEntidad(PLUGIN_CODE, ID_ENTIDAD))
				.thenReturn(ep);
		assertEquals(ep, manager.getPluginPorEntidad(PLUGIN_CODE, mockEntidad));
		verify(entidadPluginDao).getPluginPorEntidad(PLUGIN_CODE, ID_ENTIDAD);
		verifyNoMoreInteractions(entidadPluginDao);
	}
	
	@Test
	public void tetNullArguments_exception() throws Exception {
		NullArgumentsTest test = new NullArgumentsTest(manager, "getPluginPorEntidad", String.class,Entidad.class);
		test.run();
	}
}
