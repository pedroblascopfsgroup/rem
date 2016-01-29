package es.pfsgroup.plugins.test.dao.entidadPluginDao;

import es.pfsgroup.plugins.dao.impl.EntidadPluginDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public abstract class AbstractEntidadPluginDaoTest extends
		AccesoDatosTestPreconfigurado {
	
	protected final String PLUGIN_CODE = "miplugin";
	protected final Long ENTITY_WITH_PLUGIN_ID = 1L;
	protected final Long ENTITY_WITHOUT_PLUGIN_ID = 2L;
	protected final String ENTITY_WIT_PLUGIN_NAME = "ENTIDAD TEST";
	
	protected EntidadPluginDaoImpl dao;

	public AbstractEntidadPluginDaoTest() {
		super();
	}

	@Override
	protected void antesDelTest() throws Exception {
		dao = new EntidadPluginDaoImpl();
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