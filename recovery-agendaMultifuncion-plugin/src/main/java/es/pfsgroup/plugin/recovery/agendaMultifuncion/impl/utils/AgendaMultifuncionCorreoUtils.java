package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.recovery.Encriptador;

public class AgendaMultifuncionCorreoUtils {	

	private final Log logger = LogFactory.getLog(getClass());

	private static final String DEVON_HOME_BANKIA = "datos/usuarios/recovecp";
	private static final String DEVON_HOME = "DEVON_HOME";
	private static final String MAIL_SMTP_USER = "mail.smtp.user";
	private static final String MAIL_SMTP_AUTH = "mail.smtp.auth";
	private static final String MAIL_SMTP_PORT = "mail.smtp.port";
	private static final String MAIL_SMTP_STARTTLS_ENABLE = "mail.smtp.starttls.enable";
	private static final String MAIL_SMTP_HOST = "mail.smtp.host";
	private static final String TRANSPORT_SMTP = "smtp";

	private static final String DEVON_PROPERTIES = "devon.properties";
	
	// Entradas en devon.properties que servirán para componer el mensaje

	private static final String SERVIDOR_CORREO = "mailManager.host";
	private static final String PUERTO_CORREO = "mailManager.port";
	private static final String USUARIO_CORREO = "mail.acuerdo.from";
	private static final String PWD_CORREO = "mail.acuerdo.pwFrom";
	
	private Properties appProperties;

	private static AgendaMultifuncionCorreoUtils agendaMultifuncionCorreo;
	
	
	public static AgendaMultifuncionCorreoUtils dameInstancia() {
		if (agendaMultifuncionCorreo == null) {
			agendaMultifuncionCorreo = new AgendaMultifuncionCorreoUtils();
		}
		return agendaMultifuncionCorreo;
	}
	
	public AgendaMultifuncionCorreoUtils() {
		this.appProperties = cargarProperties(DEVON_PROPERTIES);
	}
	
	public void enviarCorreoConAdjuntos(String emailFrom, List<String> mailsPara
			,List<String> direccionesMailCc, String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) throws Exception {

		try {
			
			// Propiedades de la conexión
			Properties props = getPropiedades();
			//logger.debug("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos] props=" + props.toString());
			
			// Preparamos la sesion
			Session session = Session.getDefaultInstance(props);
			session.setDebugOut(System.out);
			session.setDebug(true);
			
			// Construimos el mensaje
			MimeMessage message = new MimeMessage(session);
			
			message.setFrom(new InternetAddress(emailFrom));
			
			for (String emailPara: mailsPara) {				
				message.addRecipient(Message.RecipientType.TO, new InternetAddress(emailPara));				
			}

			if (direccionesMailCc != null && direccionesMailCc.size() > 0) {				
				for (String emailCC: direccionesMailCc) {					
					message.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC));					
				}
			}
			
			message.setSubject(asuntoMail);

			// Si hay adjuntos reconfiguramos el mensaje para añadirlos junto al texto html del email		
			if(!Checks.esNulo(list) && !Checks.estaVacio(list)){
				
				 Multipart multipart = new MimeMultipart("mixed");
				 for(DtoAdjuntoMail adj : list){
					 
						MimeBodyPart messageAttachment = new MimeBodyPart();    
			            messageAttachment.attachFile(adj.getAdjunto().getFileItem().getFile());
				        messageAttachment.setFileName(adj.getNombre());
				        multipart.addBodyPart(messageAttachment);
				 }	
				 
				 MimeBodyPart htmlPart = new MimeBodyPart();
				 htmlPart.setContent(cuerpoEmail, "text/html; charset=utf-8");			     
				 multipart.addBodyPart(htmlPart);
				 message.setContent(multipart);

			} else {
				
				message.setText(cuerpoEmail, "UTF-8", "html");		
			}

			logger.debug("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos] mensaje=" + emailFrom + ", " + mailsPara.toString() + "," + direccionesMailCc.toString() + "," + asuntoMail);

			// Lo enviamos.
			Transport t = session.getTransport(TRANSPORT_SMTP);

			// validacion de usuario que envia
			String usuario = props.getProperty(MAIL_SMTP_USER);
			String pass = null;
			String passValueProp = appProperties.getProperty(PWD_CORREO);
			try {
				String passValueParsed = passValueProp.replaceAll("\\\\", "");
				pass = Encriptador.desencriptarPw(passValueParsed);
			} catch (Exception ee) {
				// Si da error la desencriptación o el parseo lo intentaremos con el valor obtenido del properties directamente.
				pass = passValueProp;
				logger.error("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos] ee=" + ee.getMessage());
			}	
			
			//logger.debug("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos] usuario=" + usuario + ", pass= " + pass);
			t.connect(usuario, pass);
			logger.debug("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos] Autenticado");
			t.sendMessage(message, message.getAllRecipients());
			
			// Cierre.
			t.close();
		}

		catch (Exception e) {
			logger.error("\n" + e.getMessage() + "\n");
			throw new Exception(e);
		}
	}


	
	private Properties getPropiedades() {	
					
		Properties props = new Properties();
		props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO));
		props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(PUERTO_CORREO));
		props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, "true");
		props.setProperty(MAIL_SMTP_AUTH, "true");		
		props.setProperty(MAIL_SMTP_USER, appProperties.getProperty(USUARIO_CORREO));

		return props;
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
			logger.error("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos]: " + ex.getMessage() + " /" + devonHome + "/" + nombreProps);
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					logger.error("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos]: " + e.getMessage());
				}
			}
		}
		return prop;
	}
	
}