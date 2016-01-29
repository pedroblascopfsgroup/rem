package es.pfsgroup.testfwk;

import java.util.Properties;

import org.hibernate.EmptyInterceptor;

public class TestingHibernateInterceptor extends EmptyInterceptor {

	@Override
	public String onPrepareStatement(String sql) {
		String prepedStatement = super.onPrepareStatement(sql);
		// prepedStatement =
		// prepedStatement.replaceAll("\\$\\{entity\\.schema\\}\\.",
		// properties.getProperty("entity.schema"));
		prepedStatement = prepedStatement.replaceAll(
				"\\$\\{entity\\.schema\\}\\.", "");
		// prepedStatement =
		// prepedStatement.replaceAll("\\$\\{master\\.schema\\}\\.",
		// properties.getProperty("master.schema"));
		prepedStatement = prepedStatement.replaceAll("\\$\\{master\\.schema\\}\\.", "");
		return prepedStatement;
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = -6869152451836030682L;

	private Properties properties;

	public void setProperties(Properties properties) {
		this.properties = properties;
	}

}
