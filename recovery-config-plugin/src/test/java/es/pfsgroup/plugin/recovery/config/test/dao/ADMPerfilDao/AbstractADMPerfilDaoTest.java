package es.pfsgroup.plugin.recovery.config.test.dao.ADMPerfilDao;

import java.lang.reflect.Field;
import java.util.Properties;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.impl.ADMPerfilDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public abstract class AbstractADMPerfilDaoTest extends
		AccesoDatosTestPreconfigurado {
	protected static final String TEST_DATA = "/dbunit-test-data/Perfiles_default.xml";

	protected ADMPerfilDaoImpl dao;

	public AbstractADMPerfilDaoTest() {
		super();
	}

	@Override
	protected void antesDelTest() throws Exception {
		dao = new ADMPerfilDaoImpl();
		dao.setSessionFactory(getSessionFactory());
		Properties appProperties = (Properties) getApplicationContext().getBean("appProperties");
		PaginationManager paginationManager = (PaginationManager)getApplicationContext().getBean("paginationManager");
		Field f = paginationManager.getClass().getDeclaredField("appProperties");
		f.setAccessible(true);
		f.set(paginationManager, appProperties);
		dao.setPaginationManager(paginationManager);
	}

	@Override
	protected void despuesDelTest() throws Exception {
		dao = null;
	}

	@Override
	protected String getFicheroDatos() {
		return TEST_DATA;
	}

}