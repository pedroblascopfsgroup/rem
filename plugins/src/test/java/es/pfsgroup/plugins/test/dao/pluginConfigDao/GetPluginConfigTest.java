package es.pfsgroup.plugins.test.dao.pluginConfigDao;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import es.pfsgroup.plugins.domain.PluginConfig;

public class GetPluginConfigTest extends AbstractPluginConfigDaoTest{

	
	@Test
	public void testGetPluginConfigTest() throws Exception {
		cargaDatos();
		List<PluginConfig> result = dao.getPluginConfig(PLUGIN_CODE);
		assertEquals(CFG_KEY1, result.get(0).getKey());
		assertEquals(CFG_VALUE1, result.get(0).getValue());
		assertEquals(CFG_KEY2, result.get(1).getKey());
		assertEquals(CFG_VALUE2, result.get(1).getValue());
	}
}
