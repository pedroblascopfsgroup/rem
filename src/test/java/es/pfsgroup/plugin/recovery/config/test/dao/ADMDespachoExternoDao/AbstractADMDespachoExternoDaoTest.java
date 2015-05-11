package es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao;

import java.lang.reflect.Field;
import java.util.Properties;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl.ADMDespachoExternoDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public abstract class AbstractADMDespachoExternoDaoTest extends
		AccesoDatosTestPreconfigurado {

	protected ADMDespachoExternoDaoImpl dao;

	public AbstractADMDespachoExternoDaoTest() {
		super();
	}

	@Override
	protected void antesDelTest() throws Exception {
		dao = new ADMDespachoExternoDaoImpl();
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
		return "/dbunit-test-data/Gestores-Despachos_default.xml";
	}

}