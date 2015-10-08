package es.pfgroup.monioring.bach.load.dao.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import es.pfsgroup.recovery.Encriptador;

/**
 * Fachada con las operaciones más comunes para conectar por JDBC a Oracle. Esta
 * clase se diferencia de {@link OracleJdbcFacade} en que espera que el password
 * de la BBDD esté encriptado.
 * 
 * @author bruno
 * 
 */
public class OracleJdbcEncryptedFacade implements JDBCConnectionFacace {

	private static final String URL_KEY = "url";

	private static final String PASSWORD_KEY = "password";

	private final Properties appPropertiesDecrypted;

	private final String url;

	private final ArrayList<Connection> connections = new ArrayList<Connection>();

	private final ArrayList<PreparedStatement> statements = new ArrayList<PreparedStatement>();

	private final ArrayList<ResultSet> resultsets = new ArrayList<ResultSet>();

	public OracleJdbcEncryptedFacade(final Properties appProperties) {
		super();
		try {
			this.appPropertiesDecrypted = decryptPassword(appProperties);
		} catch (Exception e) {
			throw new OracleJdbcFacadeException(
					"Cannot decrypt password provided.", e);
		}
		this.url = this.appPropertiesDecrypted.getProperty(URL_KEY);
	}

	private Properties decryptPassword(final Properties appProperties)
			throws Exception {
		assert appProperties != null;
		assert appProperties.containsKey(PASSWORD_KEY);
		assert appProperties.containsKey(URL_KEY);

		final Properties decrypted = (Properties) appProperties.clone();
		decrypted.setProperty(PASSWORD_KEY,
				Encriptador.desencriptarPw(appProperties.getProperty(PASSWORD_KEY)));
		decrypted.setProperty(URL_KEY, Encriptador.desencriptarPwUrl(appProperties.getProperty(URL_KEY)));
		return decrypted;

	}

	/**
	 * Se conecta a la base de datos y ejecuta una query.
	 * 
	 * @param query
	 * @return
	 * @throws SQLException
	 */
	public ResultSet connectAndExecute(final String query) throws SQLException {
		final Connection conn = DriverManager.getConnection(url,
				appPropertiesDecrypted);
		connections.add(conn);
		final PreparedStatement preStatement = conn.prepareStatement(query);
		statements.add(preStatement);
		final ResultSet rs = preStatement.executeQuery();
		resultsets.add(rs);
		return rs;

	}

	/**
	 * Cierra todas las conexiones.
	 * 
	 * @throws SQLException
	 */
	public void close() throws SQLException {
		try {
			for (ResultSet r : resultsets) {
				r.close();
			}
		} finally {
			resultsets.clear();
			try {
				for (PreparedStatement st : statements) {
					st.close();
				}
			} finally {
				statements.clear();
				try {
					for (Connection cn : connections) {
						cn.close();
					}
				} finally {
					connections.clear();
				}
			}
		}

	}
}
