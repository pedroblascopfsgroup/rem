package es.capgemini.pfs.security.manager;

import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import sun.misc.BASE64Decoder;

@Component
public class RSASecurityDecrypter {

	@Autowired
	private RSASecurityManager securityManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	public byte[] encriptar(String cadena){
		
		byte[] b = securityManager.rsaEncrypt(cadena.getBytes());
		return b; 
	}
	
	public RSADecripterStatus desencriptar(String workingCode,String rutaPrivada) {
		boolean ok = false;
		String username = null;
		String timestamp = null;
		try {
			workingCode = workingCode.replace(' ', '+');
			
			securityManager.setPRIVATE_KEY_FILE(rutaPrivada);
			BASE64Decoder decoder  = new BASE64Decoder();
			byte[] workingCodeByte;
			workingCodeByte = decoder.decodeBuffer(workingCode);
			
			byte[] des = securityManager.rsaDesEncrypt(workingCodeByte);
			
			if(des != null){
				ok  = true;
				String cadena = new String(des);
				String[] vector = cadena.split(";");
				username = vector[0];
				timestamp = vector[1];
			}
		} catch (IOException e1) {
			logger.error(e1.getMessage());
			ok = false;
		}
		catch(Exception e){
			logger.error(e.getMessage());
			ok = false;
		}
		
		
		return new RSADecripterStatus(username, timestamp, ok);
	}
	
	public RSADecripterStatus desencriptar(byte[] workingCode) {
		boolean ok = false;
		String username = null;
		String timestamp = null;
		System.out.println("WorkingCode "+workingCode);
		try{
			byte[] des = securityManager.rsaDesEncrypt(workingCode);
			
			if(des != null){
				ok  = true;
				String cadena = new String(des);
				String[] vector = cadena.split(";");
				username = vector[0];
				System.out.println("username "+username);
				timestamp = vector[1];
				System.out.println("Timestamp "+timestamp);
			}
		}catch(Exception e){
			logger.error(e.getMessage());
			ok = false;
		}
		
		return new RSADecripterStatus(username, timestamp, ok);
	}
}
