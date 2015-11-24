package es.pfsgroup.recovery.recobroCommon.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import es.pfsgroup.recovery.Encriptador;

public class CorreoUtils {

	private static final String DEVON_HOME_BANKIA = "datos/usuarios/recovecp";
	private static final String PROPIEDAD_ENTORNO = "entorno";
	private static final String DEVON_HOME = "DEVON_HOME";
	private static final String MAIL_SMTP_USER = "mail.smtp.user";
	private static final String MAIL_SMTP_AUTH = "mail.smtp.auth";
	private static final String MAIL_SMTP_PORT = "mail.smtp.port";
	private static final String MAIL_SMTP_STARTTLS_ENABLE = "mail.smtp.starttls.enable";
	private static final String MAIL_SMTP_HOST = "mail.smtp.host";
	private static final String TRANSPORT_SMTP = "smtp";
	// Nos basamos en los posibles valores definidos en SSA.properties (que se
	// encuentra en $HOME)
	private static final String ENTORNO_DESA = "PU";
	private static final String ENTORNO_PRE = "PI";
	private static final String ENTORNO_PRO = "RE";
	private static final String ENTORNO_LOCAL = "LO";

	private static final String SSA_PROPERTIES = "SSA.properties";
	private static final String DEVON_PROPERTIES = "devon.properties";
	
	// Entradas en devon.properties que servirán para componer el mensaje
	private static final String DEFAULT_TO = "mail.acuerdo.defaultTo";
	private static final String MAIL_FROM = "mail.acuerdo.from";
	private static final String MAIL_FROM_PW = "mail.acuerdo.pwFrom";
	private static final String SERVIDOR_CORREO_LOCAL = "mail.acuerdo.serverLocal";
	private static final String SERVIDOR_CORREO_DESA = "mail.acuerdo.serverDesa";
	private static final String SERVIDOR_CORREO_PRE = "mail.acuerdo.serverPre";
	private static final String SERVIDOR_CORREO_PRO = "mail.acuerdo.serverPro";
	private static final String PUERTO_CORREO_LOCAL = "mail.acuerdo.portLocal";
	private static final String PUERTO_CORREO_DESA = "mail.acuerdo.portDesa";
	private static final String PUERTO_CORREO_PRE = "mail.acuerdo.portPre";
	private static final String PUERTO_CORREO_PRO = "mail.acuerdo.portPro";
	private static final String USUARIO_CORREO_TEST = "mail.acuerdo.usuarioTest";
	private static final String USUARIO_CORREO_REAL = "mail.acuerdo.usuario";
	
	private static final String DIRECCION_CC = "G021309@bankia.com";
	private static final String NOMBRE_DIRECCION_CC = "Control de Sociedades Cobro";
	
	private Properties appProperties;

	private static CorreoUtils correo;
	
	//private static final String MSG_FROM = "pedro.blasco@pfsgroup.es"; //"sv00154@cm.es"
	// Message.RecipientType.TO,new InternetAddress("cplazag@bankia.com"));
	
	public static CorreoUtils dameInstancia() {
		if (correo == null) {
			correo = new CorreoUtils();
		}
		return correo;
	}
	
	public CorreoUtils() {
		this.appProperties = cargarProperties(DEVON_PROPERTIES);
	}
	
	public void enviarCorreo(String to, String subject, String body) throws Exception {

		try {

			// Propiedades de la conexión
			Properties props = getPropiedades();
			//System.out.println("[CorreoUtils.enviarCorreo] props=" + props.toString());
			
			// Preparamos la sesion
			Session session = Session.getDefaultInstance(props);
			session.setDebugOut(System.out);
			session.setDebug(false);
			
			// Construimos el mensaje
			MimeMessage message = new MimeMessage(session);
			String from = appProperties.getProperty(MAIL_FROM);
			message.setFrom(new InternetAddress(from));
			
			if (appProperties.containsKey(DEFAULT_TO)) {
				if (appProperties.getProperty(DEFAULT_TO) != null && !("".equals(appProperties.getProperty(DEFAULT_TO)))) {
					to = appProperties.getProperty(DEFAULT_TO);
				}
			}
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
			message.addRecipient(Message.RecipientType.CC, new InternetAddress(DIRECCION_CC, NOMBRE_DIRECCION_CC));
			
			message.setSubject(subject);
			message.setText(body, "UTF-8");

			//System.out.println("[CorreoUtils.enviarCorreo] mensaje=" + to + "," + from + "," + subject);

			// Lo enviamos.
			Transport t = session.getTransport(TRANSPORT_SMTP);

			// validacion de usuario que envia
			String usuarioSmtp = props.getProperty(MAIL_SMTP_USER);
			String fromPwProp = appProperties.getProperty(MAIL_FROM_PW);
			String fromPwPropTrat = fromPwProp;
			try {
				fromPwPropTrat = fromPwProp.replaceAll("\\\\", "");
			} catch (Exception ee) {
				ee.printStackTrace();
				//System.out.println("[CorreoUtils.enviarCorreo] ee=" + ee.getMessage());
			}
			String fromPw = Encriptador.desencriptarPw(fromPwPropTrat);
			//System.out.println("[CorreoUtils.enviarCorreo] usuario=" + usuarioSmtp + "." + fromPwProp + "." + fromPwPropTrat + "." + fromPw);
			t.connect(usuarioSmtp, fromPw);
			//System.out.println("[CorreoUtils.enviarCorreo] Autenticado");
			t.sendMessage(message, message.getAllRecipients());
			
			// Cierre.
			t.close();
		}

		catch (Exception e) {
			//System.out.println("\n" + e.getMessage() + "\n");
			e.printStackTrace();
			throw new Exception(e);
		}
	}

	private Properties getPropiedades() {

		String entornoSSA = cargarEntornoSSA();

		if (entornoSSA.equals(ENTORNO_DESA)) {
			return getPropiedadesDesa();
		} else if (entornoSSA.equals(ENTORNO_PRE)) {
			return getPropiedadesPre();
		} else if (entornoSSA.equals(ENTORNO_PRO)) {
			return getPropiedadesPro();
		} else {
			return getPropiedadesLocal();
		}
	}

	
	private Properties getPropiedadesLocal() {
				
		Properties props = new Properties();
		props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO_LOCAL));
		props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(PUERTO_CORREO_LOCAL));
		props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, "true");
		props.setProperty(MAIL_SMTP_AUTH, "true");		
		props.setProperty(MAIL_SMTP_USER, appProperties.getProperty(USUARIO_CORREO_TEST));
		// correo de usuario que envia
		//props.setProperty("mail.password", "Pedrosco1969?");
		return props;
	}

	private Properties getPropiedadesDesa() {
		
		Properties props = new Properties();
		props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO_DESA));
		props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(PUERTO_CORREO_DESA));
		//props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, "true");
		//props.setProperty(MAIL_SMTP_AUTH, "true");		
		props.setProperty(MAIL_SMTP_USER, appProperties.getProperty(USUARIO_CORREO_REAL));
		return props;
	}

	private Properties getPropiedadesPre() {
		
		Properties props = new Properties();
		props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO_PRE));
		props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(PUERTO_CORREO_PRE));
		props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, "true");
		props.setProperty(MAIL_SMTP_AUTH, "true");		
		props.setProperty(MAIL_SMTP_USER, appProperties.getProperty(USUARIO_CORREO_REAL));
		return props;
	}

	private Properties getPropiedadesPro() {
		
		Properties props = new Properties();
		props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO_PRO));
		props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(PUERTO_CORREO_PRO));
		props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, "true");
		props.setProperty(MAIL_SMTP_AUTH, "true");		
		props.setProperty(MAIL_SMTP_USER, appProperties.getProperty(USUARIO_CORREO_REAL));
		return props;
	}

	private String cargarEntornoSSA() {
		
		String resultado = ENTORNO_LOCAL;
		
		Properties prop = cargarProperties(SSA_PROPERTIES);
		if (prop != null && prop.containsKey(PROPIEDAD_ENTORNO)) {
			resultado = prop.getProperty(PROPIEDAD_ENTORNO);
		}
		return resultado;
	}
	
	private Properties cargarProperties(String nombreProps) {

		InputStream input = null;
		Properties prop = new Properties();
		
		String devonHome = DEVON_HOME_BANKIA;
		if (System.getenv(DEVON_HOME) != null) {
			devonHome = System.getenv(DEVON_HOME);
		}
		
		try {
			input = new FileInputStream("/" + devonHome + "/" + nombreProps);
			prop.load(input);
		} catch (IOException ex) {
			//System.out.println("[CorreoUtils.cargarProperties]: " + ex.getMessage() + " /" + devonHome + "/" + nombreProps);
			ex.printStackTrace();
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
					//System.out.println("[CorreoUtils.cargarProperties]: " + e.getMessage());
				}
			}
		}
		return prop;
	}
	
}
