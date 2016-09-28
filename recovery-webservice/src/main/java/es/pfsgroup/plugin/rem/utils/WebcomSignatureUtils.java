package es.pfsgroup.plugin.rem.utils;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class WebcomSignatureUtils {
	
	private static final Log logger = LogFactory.getLog(WebcomSignatureUtils.class);
	
	public static String computeSignatue(String apiKey, String ipAddress, String body) throws UnsupportedEncodingException, NoSuchAlgorithmException {
		logger.debug("Cálculo del sginature");
		logger.debug("------------- INICIO FIRMA -----------------");
		String firma = (apiKey.concat(ipAddress).concat(body));
		logger.debug(firma);
		logger.debug("-------------  FIN FIRMA   -----------------");
		byte[] bytesOfMessage = firma.getBytes("UTF-8");

		MessageDigest md = MessageDigest.getInstance("MD5");
		md.update(bytesOfMessage);
		byte[] thedigest = md.digest();
		StringBuffer hexString = new StringBuffer();
		for (int i = 0; i < thedigest.length; i++) {
			if ((0xff & thedigest[i]) < 0x10) {
				hexString.append("0" + Integer.toHexString((0xFF & thedigest[i])));
			} else {
				hexString.append(Integer.toHexString(0xFF & thedigest[i]));
			}
		}
		firma = hexString.toString();
		return firma;
	}
}
