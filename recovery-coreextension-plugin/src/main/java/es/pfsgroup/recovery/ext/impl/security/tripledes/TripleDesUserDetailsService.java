package es.pfsgroup.recovery.ext.impl.security.tripledes;

import java.util.Calendar;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.security.DefaultUserDetailsService;
import es.pfsgroup.recovery.ext.impl.security.tripledes.manager.TripleDesDecripterStatus;
import es.pfsgroup.recovery.ext.impl.security.tripledes.manager.TripleDesSecurityDecrypter;

public class TripleDesUserDetailsService extends DefaultUserDetailsService {

	@Autowired
	private TripleDesSecurityDecrypter securityDecripter;

	@Resource
	private Properties appProperties;

	@Override
	public TripleDesUserDetails loadUserByUsernameAndEntity(String username,
			String workingCode) {
		String clave = appProperties
				.getProperty("security.claveTripleDes");
		TripleDesDecripterStatus dc = securityDecripter.desencriptar(workingCode, clave);
		if (dc == null) return null;
		
		if (dc.isOk()) {
			String user = dc.getUsername();
			String timestamp = dc.getTimestamp();
			if (user != null && timestamp != null) {
				if (user.equalsIgnoreCase(username)) {
					if (comprobarTimeStamp(timestamp)){
						user = user.replaceFirst("^0*", "");
						return new TripleDesUserDetails(
								super.loadUserByUsername(user), dc);
					}else
						return null;
				}
			}
			return null;

		} else
			return null;

	}

//	public boolean comprobarTimeStampParametro(String timeStampParametro,
//			DecripterStatus decryptStatus) {
//
//		return timeStampParametro.equals(decryptStatus.getTimestamp());
//	}

	private boolean comprobarTimeStamp(String timeStamp) {
		boolean res = false;
		Calendar ahora = Calendar.getInstance();
		String validez = appProperties.getProperty("security.validezTimeStamp");
		int validezInt = Integer.parseInt(validez);

		Calendar recibido = Calendar.getInstance();
		recibido.set(Calendar.YEAR, Integer.parseInt(timeStamp.substring(0,2))+2000);
		recibido.set(Calendar.MONTH,
				Integer.parseInt(timeStamp.substring(2, 4)) - 1);
		recibido.set(Calendar.DAY_OF_MONTH,
				Integer.parseInt(timeStamp.substring(4, 6)));
		recibido.set(Calendar.HOUR_OF_DAY,
				Integer.parseInt(timeStamp.substring(6, 8)));
		recibido.set(Calendar.MINUTE,
				Integer.parseInt(timeStamp.substring(8, 10)));
		recibido.set(Calendar.SECOND, 0);

		long diferencia = 0;

		if (recibido.after(ahora)) {
			diferencia = recibido.getTimeInMillis() - ahora.getTimeInMillis();
		} else {
			diferencia = ahora.getTimeInMillis() - recibido.getTimeInMillis();
		}

		System.out.println("Timestamp diff : " + diferencia);
		
		res = (diferencia <= validezInt);
		
		System.out.println("Timestamp  check : " + res);

		return res;
	}

}
