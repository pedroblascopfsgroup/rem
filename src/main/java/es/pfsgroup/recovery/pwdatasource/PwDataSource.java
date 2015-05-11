package es.pfsgroup.recovery.pwdatasource;

import java.sql.SQLException;
import java.util.Properties;

import org.apache.commons.dbcp.BasicDataSource;

import es.capgemini.pfs.dsm.DataSourceManager;
import es.pfsgroup.recovery.Encriptador;

import javax.sql.DataSource;

public class PwDataSource extends BasicDataSource {

	@javax.annotation.Resource
	private Properties appProperties;

	@Override
	public <T> T unwrap(Class<T> iface) throws SQLException {
		return null;
	}

	@Override
	public boolean isWrapperFor(Class<?> iface) throws SQLException {
		return false;
	}

	protected synchronized DataSource createDataSource() throws SQLException {
		
		if (appProperties.getProperty(DataSourceManager.CLAVE_PASSWORD,
				DataSourceManager.PW_NO_CODIFICADA).equalsIgnoreCase(
				DataSourceManager.PW_CODIFICADA)) {
			String pw = super.getPassword();
			if (Encriptador.isPwEncriptada(pw)) {
				String pwDesencriptada = desencriptarPassword(pw);
				String urlConPwDesencriptada = desencriptarUrl(super.getUrl(),
						pw, pwDesencriptada);
				super.setPassword(pwDesencriptada);
				super.setUrl(urlConPwDesencriptada);

			
			
			}
		}
		return super.createDataSource();
		
	}

	private String desencriptarPassword(String password) {

		String password_desencriptada = password;
		try {
			password_desencriptada = Encriptador.desencriptarPw(password);
		} catch (Exception e1) {
			System.out.println("Error al desencriptar password de " + username
					+ ": " + e1.getMessage());
		}
		return password_desencriptada;
	}

	private String desencriptarUrl(String url, String password,
			String pwDesencriptada) {
		String resultado = url;
		if (resultado.indexOf(password) > 0) {
			resultado = resultado.replace(password, pwDesencriptada);
		}
		return resultado;
	}

}
