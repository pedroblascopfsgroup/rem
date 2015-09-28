package org.cajamar;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Properties;

public class PruebaWSCajamar {

	protected static void configuraCertificados(String[] args) {
		if ((args.length < 1) || ("".equals(args[0]))) {
			System.err.println("Introduce el certificado, por favor.");
			printUsage(System.err);
			System.exit(1);
		}
		if (!args[0].endsWith(".pkcs12")) {
			System.err.println("El primer argumento debe ser el certificado.");
			printUsage(System.err);
			System.exit(1);
		}

		if ((args.length < 2) || ("".equals(args[0]))) {
			System.err.println("Introduce el password, por favor.");
			printUsage(System.err);
			System.exit(1);
		}

		String keyStore = args[0];
		String keyStorePassword = args[1];

		System.setProperty("javax.net.ssl.keyStore", keyStore);
		System.setProperty("javax.net.ssl.keyStoreType", "pkcs12");
		System.setProperty("javax.net.ssl.keyStorePassword", keyStorePassword);

		// Cargamos el certificado del servidor
		System.setProperty("javax.net.ssl.trustStore", "multidesa.515.trustore");

		String trustStore = System.getProperty("javax.net.ssl.trustStore");
		if (trustStore == null) {
			System.out.println("javax.net.ssl.trustStore is not defined");
			System.exit(1);
		} else {
			System.out.println("javax.net.ssl.trustStore = " + trustStore);
		}
	}

	protected static void testConnection(String connectionUrl)
			throws MalformedURLException, IOException {
		System.out.println("Trying URL...");
		URL myURL = new URL(connectionUrl);
		URLConnection myURLConnection = myURL.openConnection();
		myURLConnection.connect();
		System.out.println("Connected... OK!");
	}

	protected static void printObject(Object objeto) {
		System.out.println("");
		System.out.println("Estado del objeto: " + objeto);
		System.out.println("------------------------------");

		for (Method m : objeto.getClass().getDeclaredMethods()) {
			if (m.getName().startsWith("get")
					&& (m.getParameterTypes().length == 0)) {
				m.setAccessible(true);
				try {
					Object val = m.invoke(objeto);
					String value = val != null ? val.toString() : "null";
					System.out.println(m.getName() + " = " + value.toString());
				} catch (Exception e) {
					System.err.println(m.getName()
							+ ": Se ha producido un error del tipo "
							+ e.getClass().getName());
				}
			}
		}

	}

	private static void printUsage(PrintStream stream) {
		stream.println("Uso: java -jar TestWebService-x.y.z.jar <Certificado> <Password>");
	}

	protected static void populateObject(Object objeto, String fileName)
			throws IOException, IllegalAccessException,
			IllegalArgumentException, InvocationTargetException {
		try {
			Properties prop = new Properties();
			prop.load(new FileInputStream(fileName));

			for (Method m : objeto.getClass().getDeclaredMethods()) {
				if (m.getName().startsWith("set")
						&& (m.getParameterTypes().length == 1)) {
					String value = prop.getProperty(m.getName());
					if (value == null) {
						// Hacemos esto para mandar todos los campos en el
						// mensaje aunque no tengan datos
						value = "";
					}
					m.invoke(objeto, value);
				}
			}

		} catch (FileNotFoundException e) {
			System.err.println(fileName + ": El fichero no existe");
			System.exit(1);
		}

	}

	protected static void showResult(Object input, Object output) {
		printObject(input);
		System.out.println("");
		printObject(output);
	}

	public PruebaWSCajamar() {
		super();
	}

}