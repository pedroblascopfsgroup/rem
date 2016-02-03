package es.pfsgroup.plugins.test.manager.pluginManager;

import java.util.ArrayList;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.plugins.PluginManager;
import es.pfsgroup.plugins.dao.PluginConfigDao;
import es.pfsgroup.plugins.domain.PluginConfig;
import es.pfsgroup.plugins.domain.PluginConfigurations;
import es.pfsgroup.testfwk.DInjector;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class GetPluginConfigurations {
	private static final String PLUGIN_CODE = "miplugin";
	private static final String CFG1_KEY = "CFG1_KEY";
	private static final String CFG1_VALUE = "CFG1_VALUE";
	private static final String CFG2_KEY = "CFG2_KEY";
	private static final String CFG2_VALUE = "CFG2_VALUE";
	
	private PluginManager manager;
	private PluginConfigDao pluginConfigDao;
	
	@Before
	public void setUp(){
		manager = new PluginManager();
		pluginConfigDao = mock(PluginConfigDao.class);
		DInjector di = new DInjector(manager);
		di.inject("pluginConfigDao", pluginConfigDao);
	}
	
	@After
	public void tearDown(){
		manager = null;
		pluginConfigDao = null;
	}
	
	@Test
	public void testGetPluginConfigurations() throws Exception {
		
		ArrayList<PluginConfig> configList = new ArrayList<PluginConfig>();
		configList.add(new PluginConfig(CFG1_KEY, CFG1_VALUE));
		configList.add(new PluginConfig(CFG2_KEY, CFG2_VALUE));
		when(pluginConfigDao.getPluginConfig(PLUGIN_CODE)).thenReturn(configList);
		
		PluginConfigurations result = manager.getConfig(PLUGIN_CODE);
		assertEquals(2, result.getAll().size());
		assertEquals(2, result.count());
		assertFalse(result.isEmpty());
		assertEquals(result.getConfig(CFG1_KEY).getKey(), CFG1_KEY);
		assertEquals(result.getConfig(CFG1_KEY).getValue(), CFG1_VALUE);
		assertEquals(result.getConfig(CFG2_KEY).getKey(), CFG2_KEY);
		assertEquals(result.getConfig(CFG2_KEY).getValue(), CFG2_VALUE);
		
	}
}
