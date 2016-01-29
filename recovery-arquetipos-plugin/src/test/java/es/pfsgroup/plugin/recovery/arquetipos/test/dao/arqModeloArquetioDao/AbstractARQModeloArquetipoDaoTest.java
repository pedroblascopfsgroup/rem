package es.pfsgroup.plugin.recovery.arquetipos.test.dao.arqModeloArquetioDao;

import java.lang.reflect.Field;
import java.util.Properties;

import org.junit.Test;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dao.impl.ARQModeloArquetipoDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public class AbstractARQModeloArquetipoDaoTest extends AccesoDatosTestPreconfigurado{

	protected ARQModeloArquetipoDaoImpl dao;
	
	public AbstractARQModeloArquetipoDaoTest(){
		super();
	}
	
	@Test
	public void testSinTests(){
		
	}
	
	@Override
	protected void antesDelTest() throws Exception {
		dao = new ARQModeloArquetipoDaoImpl();
		dao.setSessionFactory(getSessionFactory());
		
		Properties appProperties = (Properties) getApplicationContext().getBean("appProperties");
		PaginationManager paginationManager = (PaginationManager)getApplicationContext().getBean("paginationManager");
		Field f = paginationManager.getClass().getDeclaredField("appProperties");
		f.setAccessible(true);
		f.set(paginationManager, appProperties);
		
		
	}

	@Override
	protected void despuesDelTest() throws Exception {
		dao = null;
	}

	@Override
	protected String getFicheroDatos() {
		
		return "/dbunit-test-data/Arquetipos_default.xml";
	}

}
