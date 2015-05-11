package es.pfsgroup.plugin.recovery.mejoras.test.cliente.MEJClienteDaoImpl;

import java.lang.reflect.Field;
import java.util.Properties;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.pfsgroup.plugin.recovery.mejoras.cliente.MEJClienteDaoImpl;
import es.pfsgroup.testdata.mainmodel.RecoveryTestDataMainDatafiles;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

/**
 * Clase genérica de inicialización de los tests del MEJClienteDaoImpl
 * @author bruno
 *
 */
public abstract class AbstractMEJClienteDaoImplTests extends AccesoDatosTestPreconfigurado{
	
	public static final String FICHERO_DATOS_CLIENTES_TEST = RecoveryTestDataMainDatafiles.CLIENTES_DATAFILE;
	
	protected MEJClienteDaoImpl dao;

	@Override
	protected void antesDelTest() throws Exception {
		dao = new MEJClienteDaoImpl();
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
		return FICHERO_DATOS_CLIENTES_TEST;
	}

}
