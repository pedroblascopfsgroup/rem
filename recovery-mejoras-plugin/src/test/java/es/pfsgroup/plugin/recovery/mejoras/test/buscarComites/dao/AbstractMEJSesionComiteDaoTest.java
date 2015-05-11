package es.pfsgroup.plugin.recovery.mejoras.test.buscarComites.dao;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Properties;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dao.impl.MEJSesionComiteDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public abstract class AbstractMEJSesionComiteDaoTest extends
		AccesoDatosTestPreconfigurado {

	protected MEJSesionComiteDaoImpl dao;

	public AbstractMEJSesionComiteDaoTest() {
		/*
		super();
		*/
	}

	@Override
	protected void antesDelTest() throws Exception {
		/*
		dao = new MEJSesionComiteDaoImpl();
		dao.setSessionFactory(getSessionFactory());
		
		Properties appProperties = (Properties) getApplicationContext().getBean("appProperties");
		PaginationManager paginationManager = (PaginationManager)getApplicationContext().getBean("paginationManager");
		Field f = paginationManager.getClass().getDeclaredField("appProperties");
		f.setAccessible(true);
		f.set(paginationManager, appProperties);
		dao.setPaginationManager(paginationManager);
		*/
	}

	@Override
	protected void despuesDelTest() throws Exception {
		dao = null;
	}

	@Override
	protected String getFicheroDatos() {
		/*
		return "/dbunit-test-data/buscarComites.xml";
		*/
		return null;
	}
	
	protected <T> List<T> getTestData(Class<T> tipo) throws Exception{
		/*
		return TestData.create(tipo, getFicheroDatos()).getList();
		*/
		return null;
	}
	
	protected <T> List<T> getTestData(Class<T> tipo,TestDataCriteria ... criterios) throws Exception{
		/*
		return TestData.create(tipo, getFicheroDatos(),criterios).getList();
		*/
		return null;
	}

}