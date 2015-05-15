package es.pfsgroup.recovery;

import java.security.spec.KeySpec;
import java.text.DecimalFormat;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;

import org.apache.commons.codec.binary.Base64;

/**
 * Clase que encripta y desencripta las constraseñas de bases de datos
 * Usa el algorimo TripleDES (a.k.a. DESede)
 * 
 * @author pedro
 *
 */
public class Encriptador {

	private static final String REGEXP_URL = "^.*/.*[0-9]{8}@.*$";
	
	private static final String CLAVE_SECRETA = "2014eNcRiPta$$$pFs&&&bAnKiA===06???17";
	private static final String UNICODE_FORMAT = "UTF8";
	public static final String DESEDE_ENCRYPTION_SCHEME = "DESede";
	private KeySpec myKeySpec;
	private SecretKeyFactory mySecretKeyFactory;
	private Cipher cipher;
	byte[] keyAsBytes;
	private String myEncryptionKey;
	private String myEncryptionScheme;
	private SecretKey key;

	private static final long MAX_RANDOM = 100000000L;
	private static final int LONGITUD_RANDOM = 8;
	private static DecimalFormat df = new DecimalFormat("00000000");
	
	private Encriptador() throws Exception {
		myEncryptionKey = CLAVE_SECRETA;
		myEncryptionScheme = DESEDE_ENCRYPTION_SCHEME;
		keyAsBytes = myEncryptionKey.getBytes(UNICODE_FORMAT);
		myKeySpec = new DESedeKeySpec(keyAsBytes);
		mySecretKeyFactory = SecretKeyFactory.getInstance(myEncryptionScheme);
		cipher = Cipher.getInstance(myEncryptionScheme);
		key = mySecretKeyFactory.generateSecret(myKeySpec);
	}

	/**
	 * Método que encripta una cadena de texto
	 * 
	 * Privado: no se va a usar desde fuera
	 */
	private String encrypt(String unencryptedString) {
		String encryptedString = null;
		try {
			cipher.init(Cipher.ENCRYPT_MODE, key);
			byte[] plainText = unencryptedString.getBytes(UNICODE_FORMAT);
			byte[] encryptedText = cipher.doFinal(plainText);
			Base64 base64encoder = new Base64();
			encryptedString = bytes2String(base64encoder.encode(encryptedText));
			encryptedString = encryptedString.concat(generaNumeroAleatorio());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return encryptedString;
	}

	/**
	 * Método que desencripta una cadena de texto
	 * @throws Exception 
	 */
	private String decrypt(String encryptedString) throws Exception {
		String decryptedText = null;
		try {
			//System.out.println("[Encriptador] Cadena a desencriptar:" + encryptedString);
			// Detectamos que está encriptada la contraseña 
			// 	(Esto es necesario porque el batch invoca sucesivamente varias veces a recuperar la contraseña -que ya está encriptada-)
			if (encryptedString.length() > LONGITUD_RANDOM && encryptedString.matches(".*[0-9]{8}")) {
				encryptedString = encryptedString.substring(0, encryptedString.length()-LONGITUD_RANDOM);
				cipher.init(Cipher.DECRYPT_MODE, key);
				Base64 base64decoder = new Base64();
				byte[] encryptedText = base64decoder.decode(encryptedString
						.getBytes(UNICODE_FORMAT));
				byte[] plainText = cipher.doFinal(encryptedText);
				decryptedText = bytes2String(plainText);
			} else {
				throw new Exception("[Encriptador] La cadena no sigue las especificaciones.");
			}
		} catch (Exception e) {
			throw e;
		}
		return decryptedText;
	}

	/**
	 * Método privado que retorna un string a partir de un array de bytes
	 */
	private static String bytes2String(byte[] bytes) {
		StringBuffer stringBuffer = new StringBuffer();
		for (int i = 0; i < bytes.length; i++) {
			if (bytes[i] != 13 && bytes[i] != 10 ) {
				stringBuffer.append((char) bytes[i]);
			}
		}
		return stringBuffer.toString();
	}

	/**
	 * Método privado para devolver un número aleatorio que se descartará al desencriptar
	 * 
	 */
	private static String generaNumeroAleatorio() {
		String resultado = "98704562";
		try {
			long numero = (int)(Math.random() * MAX_RANDOM);
			if (numero >= MAX_RANDOM) {
				numero = MAX_RANDOM - 1;
			}
			resultado = df.format(numero);
		} catch (Exception e) {}
		return resultado;
	}
	
	/**
	 * Método principal: se recupera un argumento (que es la cadena a codificar)
	 * y se escribe en la salida estándar la cadena encriptada 
	 */
	public static void main(String args[]) throws Exception {
		
		if (args.length != 1) {
			System.out.println("Uso: java -jar rec-encrypt-xxxxxx.jar <cadena_a_encriptar>");
			System.exit(1);
		} else {
			Encriptador myEncryptor = new Encriptador();
			String stringToEncrypt = args[0];
			String encrypted = myEncryptor.encrypt(stringToEncrypt);
			System.out.println("********* ********* ********* ********* ********* ********* ********* ********* ********* ********* ********* ********* ");
			System.out.println("Resultado:" + encrypted);
			String desencriptada = myEncryptor.decrypt(encrypted);
			System.out.println("Por favor, compruebe que la clave introducida coincide con esta:" + desencriptada);
			System.out.println("Si no coinciden, la causa posible es que la clave introducida contenga caracteres particulares de Linux ($, &, etc.)");
			System.out.println("En ese caso, introduzca la clave delimitada por comillas simples");
			System.out.println("********* ********* ********* ********* ********* ********* ********* ********* ********* ********* ********* ********* ");
		}

	}

	/**
	 * Método estático usado para desencriptar una contraseña
	 */
	public static String desencriptarPw(String encriptada) throws Exception {

		Encriptador myEncryptor = new Encriptador();
		return myEncryptor.decrypt(encriptada);
		
	}

	/**
	 * Método estático usado para comprobar si es posible desencriptar una contraseña
	 */
	public static boolean isPwEncriptada(String encriptada) {

		boolean estaEncriptada = true;
		try {
			desencriptarPw(encriptada);
		} catch (Exception e) {
			estaEncriptada = false;
		}
		return estaEncriptada;
	}

	/**
	 * Método estático usado para desencriptar la contraseña de una URL de conexión de BD
     * Ejemplo: url = 'jdbc:oracle:thin:BANKMASTER/j0b3d2CHe3I=67569785@//localhost:1521/orcl11g'
	 * retornaria desencriptarPw('j0b3d2CHe3I=67569785')
	 */
	public static String desencriptarPwUrl(String url) {
		
		String resultado = url;
		if (resultado.matches(REGEXP_URL)) {
			try {
				String password = resultado.substring(resultado.indexOf("/") + 1 , resultado.indexOf("@"));
				resultado = resultado.replace(password, desencriptarPw(password));
			} catch (Exception e) {}
		}
		
		return resultado;
		
	}
}
