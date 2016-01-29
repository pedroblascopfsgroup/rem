package es.pfsgroup.plugins.test.web.menu;

import java.util.Map.Entry;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugins.PluginManager;
import es.pfsgroup.plugins.domain.EntidadPlugin;
import es.pfsgroup.plugins.web.menu.ElementoDinamicoPorFuncionYEntidad;
import es.pfsgroup.testfwk.DInjector;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

public class ElementoDinamicoPorFuncionYEntidadTest {
	
	private static final Object PARAMS = null;

	private static final String PLUGIN_CODE = "miplugin";
	private static final String PERMISSION = "MI-PLUGIN-FUNCION";

	private ElementoDinamicoPorFuncionYEntidad element;
	private FuncionManager funcionManager;
	private PluginManager pluginManager;
	private Executor executor;
	private Usuario mockUsuario;
	private Entidad mockEntidad;
	private EntidadPlugin mockEp;

	@Before
	public void setup() {
		element = new ElementoDinamicoPorFuncionYEntidad();
		executor = mock(Executor.class);
		pluginManager = mock(PluginManager.class);
		mockUsuario = mock(Usuario.class);
		mockEntidad = mock(Entidad.class);
		funcionManager = mock(FuncionManager.class);
		mockEp = mock(EntidadPlugin.class);
		DInjector di = new DInjector(element);
		di.inject("executor", executor);
		di.inject("pluginManager", pluginManager);
		di.inject("funcionManager", funcionManager);
		// comportamiento
		when(
				executor
						.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO))
				.thenReturn(mockUsuario);
		when(mockUsuario.getEntidad()).thenReturn(mockEntidad);
	}

	@After
	public void tearDown() {
		element = null;
		funcionManager = null;
		executor = null;
		pluginManager = null;
		mockUsuario = null;
		mockEntidad = null;
		mockEp = null;
	}
	
	@Test
	public void testSetPlugin() throws Exception {
		assertNull(element.getPlugin());
		element.setPlugin(PLUGIN_CODE);
		assertEquals(PLUGIN_CODE, element.getPlugin());
	}

	@Test
	public void testSinEspecificarPlugin_noValida() throws Exception {
		assertFalse(element.valid(PARAMS));
		verifyZeroInteractions(pluginManager);
		verifyZeroInteractions(funcionManager);
	}
	
	@Test
	public void testNoPluginParaEntidad_noValida() throws Exception {
		element.setPlugin(PLUGIN_CODE);
		when(pluginManager.getPluginPorEntidad(PLUGIN_CODE, mockEntidad)).thenReturn(null);
		
		assertFalse(element.valid(PARAMS));
		
		verify(pluginManager).getPluginPorEntidad(PLUGIN_CODE, mockEntidad);
		verifyNoMoreInteractions(pluginManager);
		verifyZeroInteractions(funcionManager);
	}
	
	@Test
	public void testSinEspecificarPermisos_valida() throws Exception {
		element.setPlugin(PLUGIN_CODE);
		when(pluginManager.getPluginPorEntidad(PLUGIN_CODE, mockEntidad)).thenReturn(mockEp);
		
		assertTrue(element.valid(PARAMS));
		
		verify(pluginManager).getPluginPorEntidad(PLUGIN_CODE, mockEntidad);
		verifyNoMoreInteractions(pluginManager);
		verifyZeroInteractions(funcionManager);
	}
	
	@Test
	public void testUsuarioSinPermisos_noValida() throws Exception {
		element.setPlugin(PLUGIN_CODE);
		element.setPermission(PERMISSION);
		when(pluginManager.getPluginPorEntidad(PLUGIN_CODE, mockEntidad)).thenReturn(mockEp);
		when(funcionManager.tieneFuncion(mockUsuario, PERMISSION)).thenReturn(false);
		
		assertFalse(element.valid(PARAMS));
		
		verify(pluginManager).getPluginPorEntidad(PLUGIN_CODE, mockEntidad);
		verify(funcionManager).tieneFuncion(mockUsuario, PERMISSION);
		verifyNoMoreInteractions(pluginManager);
		verifyNoMoreInteractions(funcionManager);
	}
	
	@Test
	public void testUsuarioConPermisos_valida() throws Exception {
		element.setPlugin(PLUGIN_CODE);
		element.setPermission(PERMISSION);
		when(pluginManager.getPluginPorEntidad(PLUGIN_CODE, mockEntidad)).thenReturn(mockEp);
		when(funcionManager.tieneFuncion(mockUsuario, PERMISSION)).thenReturn(true);
		
		assertTrue(element.valid(PARAMS));
		
		verify(pluginManager).getPluginPorEntidad(PLUGIN_CODE, mockEntidad);
		verify(funcionManager).tieneFuncion(mockUsuario, PERMISSION);
		verifyNoMoreInteractions(pluginManager);
		verifyNoMoreInteractions(funcionManager);
	}
}
