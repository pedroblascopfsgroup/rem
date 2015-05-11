package es.pfsgroup.plugin.recovery.config.test.dao.ADMFuncionPerfilDao;

import es.pfsgroup.plugin.recovery.config.perfiles.dao.impl.ADMFuncionPerfilDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public abstract class AbstractADMFuncionPerfilDaoTest extends
		AccesoDatosTestPreconfigurado {
	protected static final String TEST_DATA = "/dbunit-test-data/Perfiles_default.xml";

	protected ADMFuncionPerfilDaoImpl dao;

	public AbstractADMFuncionPerfilDaoTest() {
		super();
	}

	@Override
	protected void antesDelTest() throws Exception {
		dao = new ADMFuncionPerfilDaoImpl();
		dao.setSessionFactory(getSessionFactory());
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