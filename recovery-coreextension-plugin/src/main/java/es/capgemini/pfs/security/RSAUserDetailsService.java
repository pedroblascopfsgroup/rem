package es.capgemini.pfs.security;

import java.util.Calendar;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.security.manager.RSADecripterStatus;
import es.capgemini.pfs.security.manager.RSASecurityDecrypter;

public class RSAUserDetailsService extends DefaultUserDetailsService {

	@Autowired
	private RSASecurityDecrypter securityDecripter;

	@Resource
	private Properties appProperties;
	
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public RSAUserDetails loadUserByUsernameAndEntity(String username,
			String workingCode) {
		String rutaPrivada = appProperties
				.getProperty("security.rutaClavePrivada");
		RSADecripterStatus dc = securityDecripter.desencriptar(workingCode,
				rutaPrivada);
		if (dc.isOk()) {
			String user = dc.getUsername();
			String timestamp = dc.getTimestamp();
			if (user != null && timestamp != null) {
				if (user.equalsIgnoreCase(username)) {
					if (comprobarTimeStamp(timestamp))
						return new RSAUserDetails(
								super.loadUserByUsername(user), dc);
					else
						return null;
				}
			}
			return null;

		} else
			return null;

	}

	public boolean comprobarTimeStampParametro(String timeStampParametro,
			RSADecripterStatus decryptStatus) {

		return timeStampParametro.equals(decryptStatus.getTimestamp());
	}

	private boolean comprobarTimeStamp(String timeStamp) {
		boolean res = false;
		Calendar ahora = Calendar.getInstance();
		String validez = appProperties.getProperty("security.validezTimeStamp");
		int validezInt = Integer.parseInt(validez);

		Calendar recibido = Calendar.getInstance();
		recibido.set(Calendar.YEAR, Integer.parseInt(timeStamp.substring(0, 4)));
		recibido.set(Calendar.MONTH,
				Integer.parseInt(timeStamp.substring(4, 6)) - 1);
		recibido.set(Calendar.DAY_OF_MONTH,
				Integer.parseInt(timeStamp.substring(6, 8)));
		recibido.set(Calendar.HOUR_OF_DAY,
				Integer.parseInt(timeStamp.substring(8, 10)));
		recibido.set(Calendar.MINUTE,
				Integer.parseInt(timeStamp.substring(10, 12)));
		recibido.set(Calendar.SECOND, 0);

		long diferencia = 0;

		if (recibido.after(ahora)) {
			diferencia = recibido.getTimeInMillis() - ahora.getTimeInMillis();
		} else {
			diferencia = ahora.getTimeInMillis() - recibido.getTimeInMillis();
		}

		//System.out.println("Timestamp diff : " + diferencia);
		
		res = (diferencia <= validezInt);
		
		//System.out.println("Timestamp  check : " + res);
		
		logger.info("Timestamp diff : " + diferencia + " ---> " + "Timestamp  check : " + res);

		return res;
	}

}
