package es.capgemini.pfs.security.manager;

/**
 * <p>Title: RSA Security</p>
 * Description: This class generates a RSA private and public key, reinstantiates
 * the keys from the corresponding key files.It also generates compatible .Net Public Key,
 * which we will read later in C# program using .Net Securtiy Framework
 * The reinstantiated keys are used to sign and verify the given data.</p>
 *
 * @author Shaheryar
 * @version 1.0
 */

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.SignatureException;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.EncodedKeySpec;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPrivateKeySpec;
import java.security.spec.RSAPublicKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

@Component
public class RSASecurityManager {

	private KeyPairGenerator keyGen; // Key pair generator for RSA
	private PrivateKey privateKey; // Private Key Class
	private PublicKey publicKey; // Public Key Class
	private KeyPair keypair; // KeyPair Class
	private Signature sign; // Signature, used to sign the data
	private String PRIVATE_KEY_FILE; // Private key file.
	private String PUBLIC_KEY_FILE; // Public key file.
	private String DOT_NET_PUBLIC_KEY_FILE; // File to store .Net Compatible Key
											// Data

	/**
	 * Default Constructor. Instantiates the key paths and signature algorithm.
	 */
	public RSASecurityManager() {
		try {

			// Get the instance of Signature Engine.
			sign = Signature.getInstance("SHA1withRSA");
			DOT_NET_PUBLIC_KEY_FILE = "c:\\netpublic.key"; // Location of
															// generated .Net
															// Public Key File
		} catch (NoSuchAlgorithmException nsa) {
			System.out.println("" + nsa.getMessage());
		}
	}

	/**
	 * Initialize only the private key.
	 */
	private void initializePrivateKey() {
		try {

			privateKey = readPrivateKeyFromFile(PRIVATE_KEY_FILE);

		} catch (IOException io) {
			System.out.println("Private Key File Not found." + io.getCause());
		}

	}

	/**
	 * Initializes the public and private keys.
	 */
	private void initializeKeys() {
		try {

			privateKey = readPrivateKeyFromFile(PRIVATE_KEY_FILE);

			publicKey = readPublicKeyFromFile(PUBLIC_KEY_FILE);

		} catch (IOException io) {
			System.out.println("Public/ Private Key File Not found."
					+ io.getCause());
		}
	}

	PublicKey readPublicKeyFromFile(String keyFileName) throws IOException {
		InputStream in = new FileInputStream(keyFileName);
		// ServerConnection.class.getResourceAsStream(keyFileName);
		ObjectInputStream oin = new ObjectInputStream(new BufferedInputStream(
				in));
		try {
			BigInteger m = (BigInteger) oin.readObject();
			BigInteger e = (BigInteger) oin.readObject();
			RSAPublicKeySpec keySpec = new RSAPublicKeySpec(m, e);
			KeyFactory fact = KeyFactory.getInstance("RSA");
			PublicKey pubKey = fact.generatePublic(keySpec);
			return pubKey;
		} catch (Exception e) {
			throw new RuntimeException("Spurious serialisation error", e);
		} finally {
			oin.close();
		}
	}

	PrivateKey readPrivateKeyFromFile(String keyFileName) throws IOException {
		InputStream in = new FileInputStream(keyFileName);
		// ServerConnection.class.getResourceAsStream(keyFileName);
		ObjectInputStream oin = new ObjectInputStream(new BufferedInputStream(
				in));
		try {
			BigInteger m = (BigInteger) oin.readObject();
			BigInteger e = (BigInteger) oin.readObject();
			RSAPrivateKeySpec keySpec = new RSAPrivateKeySpec(m, e);
			KeyFactory fact = KeyFactory.getInstance("RSA");
			PrivateKey privKey = fact.generatePrivate(keySpec);
			return privKey;
		} catch (Exception e) {
			throw new RuntimeException("Spurious serialisation error", e);
		} finally {
			oin.close();
		}
	}

	/**
	 * Signs the data and return the signature for a given data.
	 * 
	 * @param toBeSigned
	 *            Data to be signed
	 * @return byte[] Signature
	 */
	public byte[] signData(byte[] toBeSigned) {
		if (privateKey == null) {
			initializePrivateKey();
		}
		try {
			Signature rsa = Signature.getInstance("SHA1withRSA");
			rsa.initSign(privateKey);
			rsa.update(toBeSigned);
			return rsa.sign();
		} catch (NoSuchAlgorithmException ex) {
			System.out.println(ex);
		} catch (InvalidKeyException in) {
			System.out
					.println("Invalid Key file.Please check the key file path"
							+ in.getCause());
		} catch (SignatureException se) {
			System.out.println(se);
		}
		return null;
	}

	/**
	 * Verifies the signature for the given bytes using the public key.
	 * 
	 * @param signature
	 *            Signature
	 * @param data
	 *            Data that was signed
	 * @return boolean True if valid signature else false
	 */
	public boolean verifySignature(byte[] signature, byte[] data) {
		try {
			initializeKeys();
			sign.initVerify(publicKey);
			sign.update(data);
			return sign.verify(signature);
		} catch (SignatureException e) {
			e.printStackTrace();
		} catch (InvalidKeyException e) {
		}

		return false;
	}

	/**
	 * Utility method to delete the leading zeros from the modulus.
	 * 
	 * @param a
	 *            modulus
	 * @return modulus
	 */
	private byte[] stripLeadingZeros(byte[] a) {
		int lastZero = -1;
		for (int i = 0; i < a.length; i++) {
			if (a[i] == 0) {
				lastZero = i;
			} else {
				break;
			}
		}
		lastZero++;
		byte[] result = new byte[a.length - lastZero];
		System.arraycopy(a, lastZero, result, 0, result.length);
		return result;
	}

	public void writeBytesToFile(byte[] data, String file) {
		try {
			OutputStream out = new FileOutputStream(file);
			out.write(data);
			out.close();
		} catch (IOException ioe) {
			System.out.println("Exception occured while writing file"
					+ ioe.getMessage());
		}
	}

	public byte[] rsaEncrypt(byte[] data) {
		initializeKeys();
		PublicKey pubKey = publicKey;
		Cipher cipher;
		try {
			cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
			cipher.init(Cipher.ENCRYPT_MODE, pubKey);
			byte[] cipherData = cipher.doFinal(data);
			return cipherData;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		} catch (NoSuchPaddingException e) {
			e.printStackTrace();
			return null;
		} catch (InvalidKeyException e) {
			e.printStackTrace();
			return null;
		} catch (IllegalBlockSizeException e) {
			e.printStackTrace();
			return null;
		} catch (BadPaddingException e) {
			e.printStackTrace();
			return null;
		}

	}

	public byte[] rsaDesEncrypt(byte[] data) {
		initializePrivateKey();
		PrivateKey privKey = privateKey;
		Cipher cipher;
		try {
			cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
			cipher.init(Cipher.DECRYPT_MODE, privKey);
			byte[] cipherData = cipher.doFinal(data);
			return cipherData;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		} catch (NoSuchPaddingException e) {
			e.printStackTrace();
			return null;
		} catch (InvalidKeyException e) {
			e.printStackTrace();
			return null;
		} catch (IllegalBlockSizeException e) {
			e.printStackTrace();
			return null;
		} catch (BadPaddingException e) {
			e.printStackTrace();
			return null;
		}

	}

	public String getPRIVATE_KEY_FILE() {
		return PRIVATE_KEY_FILE;
	}

	public void setPRIVATE_KEY_FILE(String pRIVATEKEYFILE) {
		PRIVATE_KEY_FILE = pRIVATEKEYFILE;
	}

	public String getPUBLIC_KEY_FILE() {
		return PUBLIC_KEY_FILE;
	}

	public void setPUBLIC_KEY_FILE(String pUBLICKEYFILE) {
		PUBLIC_KEY_FILE = pUBLICKEYFILE;
	}

}