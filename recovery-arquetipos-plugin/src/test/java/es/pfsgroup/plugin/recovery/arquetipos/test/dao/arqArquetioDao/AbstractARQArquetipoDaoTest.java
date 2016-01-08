package es.pfsgroup.plugin.recovery.arquetipos.test.dao.arqArquetioDao;

import java.lang.reflect.Field;
import java.util.Properties;

import org.junit.Test;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.impl.ARQArquetipoDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public class AbstractARQArquetipoDaoTest extends AccesoDatosTestPreconfigurado{

	protected ARQArquetipoDaoImpl dao;
	
	public AbstractARQArquetipoDaoTest(){
		super();
	}
	
	@Test
	public void testSinTests(){
		
	}
	
	
	@Override
	protected void antesDelTest() throws Exception {
		dao = new ARQArquetipoDaoImpl();
		dao.setSessionFactory(getSessionFactory());
		
		Properties appProperties = (Properties) getApplicationContext().getBean("appProperties");
		PaginationManager paginationManager = (PaginationManager)getApplicationContext().getBean("paginationManager");
		Field f = paginationManager.getClass().getDeclaredField("appProperties");
		f.setAccessible(true);
		f.set(paginationManager, appProperties);
		
	}

	@Override
	protected void despuesDelTest() throws Exception {
		dao = null ;
		
	}

	@Override
	protected String getFicheroDatos() {
		
		return "/dbunit-test-data/Arquetipos_default.xml";
		
	}
	

}
