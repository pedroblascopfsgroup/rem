package es.pfsgroup.plugins.test.dao.pluginConfigDao;

import es.pfsgroup.plugins.dao.impl.PluginConfigDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public abstract class AbstractPluginConfigDaoTest extends AccesoDatosTestPreconfigurado {
	
	protected static final String PLUGIN_CODE = "miplugin";
	protected static final Long ENTIDAD_ID = 1L;
	protected static final String CFG_KEY1="CFG_KEY1";
	protected static final String CFG_VALUE1="CFG_VALUE1";
	protected static final String CFG_KEY2="CFG_KEY2";
	protected static final String CFG_VALUE2="CFG_VALUE2";
	
	protected PluginConfigDaoImpl dao;

	@Override
	protected void antesDelTest() throws Exception {
		dao = new PluginConfigDaoImpl();
		dao.setSessionFactory(getSessionFactory());

	}

	@Override
	protected void despuesDelTest() throws Exception {
		dao = null;

	}

	@Override
	protected String getFicheroDatos() {
		return "/dbunit-test-data/EntidadPlugin_default.xml";
	}

}
