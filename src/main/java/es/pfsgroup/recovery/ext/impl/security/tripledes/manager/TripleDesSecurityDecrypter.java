package es.pfsgroup.recovery.ext.impl.security.tripledes.manager;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import sun.misc.BASE64Decoder;

@Component
public class TripleDesSecurityDecrypter {

	@Autowired
	private TripleDesSecurityManager securityManager;
	
	public byte[] encriptar(String cadena){
		
		//byte[] b = securityManager.encrypt(cadena.getBytes());
//		return b;
		return null;
	}
	
	public TripleDesDecripterStatus desencriptar(String workingCode, String clave) {
		boolean ok = false;
		String username = null;
		String timestamp = null;
		try {
			//workingCode = workingCode.replace(' ', '+');
			
			//BASE64Decoder decoder  = new BASE64Decoder();
			byte[] workingCodeByte;
			//workingCodeByte = decoder.decodeBuffer(workingCode);
			workingCodeByte = hexStringToByteArray(workingCode);
			
			byte[] des = securityManager.desencripta(workingCodeByte, clave);
			
			if(des != null){
				ok  = true;
				String cadena = new String(des);
				String[] vector = cadena.split(";");
				username = vector[0];
				timestamp = vector[4];
			}
		} catch(Exception e){
			e.printStackTrace();
			ok = false;
		}
		
		
		return new TripleDesDecripterStatus(username, timestamp, ok);
	}
	
	public TripleDesDecripterStatus desencriptar(byte[] workingCode) {
//		boolean ok = false;
//		String username = null;
//		String timestamp = null;
//		System.out.println("WorkingCode "+workingCode);
//		try{
//			byte[] des = securityManager.desEncrypt(workingCode);
//			
//			if(des != null){
//				ok  = true;
//				String cadena = new String(des);
//				String[] vector = cadena.split(";");
//				username = vector[0];
//				System.out.println("username "+username);
//				timestamp = vector[1];
//				System.out.println("Timestamp "+timestamp);
//			}
//		}catch(Exception e){
//			e.printStackTrace();
//			ok = false;
//		}
		
		//return new TripleDesDecripterStatus(username, timestamp, ok);
		return null;
	}
	
	public static byte[] hexStringToByteArray(String s) {
	    int len = s.length();
	    byte[] data = new byte[len / 2];
	    for (int i = 0; i < len; i += 2) {
	        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
	                             + Character.digit(s.charAt(i+1), 16));
	    }
	    return data;
	}
}
