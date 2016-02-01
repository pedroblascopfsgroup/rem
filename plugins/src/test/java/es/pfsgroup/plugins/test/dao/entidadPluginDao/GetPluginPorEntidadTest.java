package es.pfsgroup.plugins.test.dao.entidadPluginDao;

import static org.junit.Assert.*;

import org.junit.Test;

import es.pfsgroup.plugins.domain.EntidadPlugin;

public class GetPluginPorEntidadTest extends AbstractEntidadPluginDaoTest{
	
	@Test
	public void testGetPluginPorEntidad() throws Exception {
		cargaDatos();
		EntidadPlugin result = dao.getPluginPorEntidad(PLUGIN_CODE, ENTITY_WITH_PLUGIN_ID);
		assertNotNull(result);
		assertEquals(PLUGIN_CODE, result.getPluginCode());
		assertEquals(ENTITY_WIT_PLUGIN_NAME, result.getEntidad().getDescripcion());
		assertNull(dao.getPluginPorEntidad(PLUGIN_CODE, ENTITY_WITHOUT_PLUGIN_ID));
		assertNull(dao.getPluginPorEntidad(PLUGIN_CODE.concat("AAAAAA"), ENTITY_WITH_PLUGIN_ID));
	}

}
