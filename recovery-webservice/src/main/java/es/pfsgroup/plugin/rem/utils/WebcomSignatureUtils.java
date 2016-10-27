package es.pfsgroup.plugin.rem.utils;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class WebcomSignatureUtils {
	
	private static final Log logger = LogFactory.getLog(WebcomSignatureUtils.class);
	private static final int MAX_CHARS_DEBUG_FIRMA = 5000;
	
	public static String computeSignatue(String apiKey, String ipAddress, String body) throws UnsupportedEncodingException, NoSuchAlgorithmException {
		logger.debug("Cálculo del sginature");
		logger.debug("------------- INICIO FIRMA -----------------");
		String firma = apiKey;
		if(ipAddress!=null && !ipAddress.isEmpty()){
			firma = firma.concat(ipAddress);
		}
		if(body!=null && !body.isEmpty()){
			firma = firma.concat(body);
		}
		
		logger.debug(firma.length() <= MAX_CHARS_DEBUG_FIRMA ? firma : firma.substring(0, MAX_CHARS_DEBUG_FIRMA) + " [...]" );
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
