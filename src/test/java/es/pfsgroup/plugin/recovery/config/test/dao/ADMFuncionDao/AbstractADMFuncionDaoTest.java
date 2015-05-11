package es.pfsgroup.plugin.recovery.config.test.dao.ADMFuncionDao;

import es.pfsgroup.plugin.recovery.config.funciones.dao.impl.ADMFuncionDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public abstract class AbstractADMFuncionDaoTest extends
		AccesoDatosTestPreconfigurado {
	protected static final String TEST_DATA = "/dbunit-test-data/Funciones_default.xml";

	protected ADMFuncionDaoImpl dao;

	public AbstractADMFuncionDaoTest() {
		super();
	}

	@Override
	protected void antesDelTest() throws Exception {
		dao = new ADMFuncionDaoImpl();
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