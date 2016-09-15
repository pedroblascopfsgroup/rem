package es.pfsgroup.plugin.rem.utils;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;

public class WebcomSignatureUtils {
	
	public static String computeSignatue(String apiKey, String ipAddress, String body) throws UnsupportedEncodingException, NoSuchAlgorithmException {
		String firma = (apiKey.concat(ipAddress).concat(body)).toLowerCase();
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
