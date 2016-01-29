package es.pfsgroup.testfwk;

import org.hibernate.SessionFactory;

public abstract class AccesoDatosTestPreconfigurado extends AccesoDatosTest {

	public static final String SPRING_DAO_CFG = "/spring-dao-cfg.xml";
	public static final String SQL_SCHEMA = "/test-schema.sql";

	private SessionFactory sessionFactory;

	@Override
	protected String getContextoTest() {
		if (this.getClass().getResourceAsStream(SPRING_DAO_CFG) == null) {
			throw new RuntimeException(
					SPRING_DAO_CFG
							.concat(": no se ha podido encontrar el recurso en el classpath"));
		}
		return SPRING_DAO_CFG;
	}

	@Override
	protected String getFicheroSchema() {
		if (this.getClass().getResourceAsStream(SQL_SCHEMA) == null) {
			throw new RuntimeException(
					SQL_SCHEMA
							.concat(": no se ha podido encontrar el recurso en el classpath"));
		}
		return SQL_SCHEMA;
	}

	public final void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	protected final SessionFactory getSessionFactory() {
		return this.sessionFactory;
	}

	protected abstract void antesDelTest() throws Exception;

	protected abstract void despuesDelTest() throws Exception;


	@Override
	protected final void onSetUp() throws Exception {
		super.onSetUp();
		antesDelTest();
	}

	@Override
	protected final void onTearDown() throws Exception {
		super.onTearDown();
		despuesDelTest();
	}

}
