package es.pfsgroup.recovery.ext.impl.security.tripledes.manager;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Component;

@Component
public class TripleDesSecurityManager {
	
	private static final byte[] ivBytes=new byte[]{(byte)0xCE, (byte)0xCA, (byte)0x19,
		(byte)0x98, (byte)0xCE,(byte)0xCA,(byte)0x19, (byte)0x98};


	public byte[] desencripta(byte[] encrypted, String clave) {
		IvParameterSpec dps = new IvParameterSpec(ivBytes);
		
		if(encrypted == null){
			throw new IllegalArgumentException("'encrypted' no puede ser NULL");
		}
		
		if(clave == null){
			throw new IllegalArgumentException("'clave' no puede ser NULL");
		}
		
		// Desencriptado
		Cipher dcipher;
		try {
			byte[] keyBytes = clave.getBytes();
			SecretKeySpec key = new SecretKeySpec(keyBytes, "DESede");
			dcipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
			dcipher.init(Cipher.DECRYPT_MODE, key, dps);

			byte desencrypted[] = dcipher.doFinal(encrypted);
			return desencrypted;
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return  null;
		} catch (NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return  null;
		} catch (InvalidKeyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return  null;
		} catch (InvalidAlgorithmParameterException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return  null;
		} catch (IllegalBlockSizeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return  null;
		} catch (BadPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return  null;
		}
		
	}
}
