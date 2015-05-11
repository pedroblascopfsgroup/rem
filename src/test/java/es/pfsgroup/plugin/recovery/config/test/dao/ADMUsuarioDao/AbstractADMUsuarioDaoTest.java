package es.pfsgroup.plugin.recovery.config.test.dao.ADMUsuarioDao;

import java.lang.reflect.Field;
import java.util.Properties;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl.ADMDespachoExternoDaoImpl;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMUsuarioDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.impl.ADMUsuarioDaoImpl;
import es.pfsgroup.testfwk.AccesoDatosTestPreconfigurado;

public abstract class AbstractADMUsuarioDaoTest extends
		AccesoDatosTestPreconfigurado {

	protected ADMUsuarioDaoImpl dao;

	public AbstractADMUsuarioDaoTest() {
		super();
	}

	@Override
	protected void antesDelTest() throws Exception {
		dao = new ADMUsuarioDaoImpl();
		dao.setSessionFactory(getSessionFactory());
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