package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.recovery.Encriptador;

@Component
public class AgendaMultifuncionCorreoUtils {	

	
	private static final String MAIL_SMTP_USER = "mail.smtp.user";
	private static final String MAIL_SMTP_AUTH = "mail.smtp.auth";
	private static final String MAIL_SMTP_PORT = "mail.smtp.port";
	private static final String MAIL_SMTP_STARTTLS_ENABLE = "mail.smtp.starttls.enable";
	private static final String MAIL_SMTP_HOST = "mail.smtp.host";
	private static final String MAIL_SMTP_DEBUG = "false";
	private static final String TRANSPORT_SMTP = "smtp";

	
	// Entradas en devon.properties que servirán para componer el mensaje
	private static final String SERVIDOR_CORREO = "agendaMultifuncion.mail.server";
	private static final String PUERTO_CORREO = "agendaMultifuncion.mail.port";
	private static final String FROM = "agendaMultifuncion.mail.from";
	private static final String USUARIO_CORREO = "agendaMultifuncion.mail.usuario";
	private static final String PWD_CORREO = "agendaMultifuncion.mail.pwd";
	private static final String STARTTLS_ENABLE = "agendaMultifuncion.mail.starttls.enable";
	private static final String AUTH =  "agendaMultifuncion.mail.auth";
	
	@Resource
	private Properties appProperties;

	@Autowired
	private Executor executor;
	
	public void enviarCorreoConAdjuntos(String emailFrom, List<String> mailsPara, List<String> direccionesMailCc,
			String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) throws Exception {

		// Propiedades de la conexion
		Properties props = getPropiedades();

		
		// Preparamos la sesion
		Session session = Session.getDefaultInstance(props);
		session.setDebugOut(System.out);
		session.setDebug(false);

		MimeMessage message = new MimeMessage(session);

		// Carga el email FROM directamente del DEVON.PROP, si existe el
		// parametro
		if (Checks.esNulo(emailFrom)) {
			emailFrom = appProperties.getProperty(FROM);
		}

		for (String emailPara : mailsPara) {
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(emailPara));
		}

		if (direccionesMailCc != null && direccionesMailCc.size() > 0) {
			for (String emailCC : direccionesMailCc) {
				message.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC));
			}
		}

		message.setSubject(asuntoMail);

		// Si hay adjuntos los añadimos
		if (!Checks.esNulo(list) && !Checks.estaVacio(list)) {
			Multipart multipart = new MimeMultipart("mixed");
			for (DtoAdjuntoMail adj : list) {

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

		// Lo enviamos.
		Transport t = session.getTransport(TRANSPORT_SMTP);

		// validacion de usuario que envia
		String usuario = null;
		String passValueProp = null;
		String pass = null;

		String usuarioBD = null;
		String passValuePropBD = null;
		String passBB = null;

		// Variables desde el DEVON
		usuario = props.getProperty(MAIL_SMTP_USER);
		passValueProp = appProperties.getProperty(PWD_CORREO);

		try {

			// Obtenemos desde BBDD en primera instancia
			Parametrizacion usuarioBBDD = (Parametrizacion) executor.execute(
					ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
					Parametrizacion.ANOTACIONES_MAIL_SMTP_USER);
			Parametrizacion passValuePropBBDD = (Parametrizacion) executor.execute(
					ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
					Parametrizacion.ANOTACIONES_PWD_CORREO);
			Parametrizacion mailFromPropBBDD = (Parametrizacion) executor.execute(
					ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
					Parametrizacion.ANOTACIONES_EMAIL_FROM);

			// Variables desde BBDD
			usuarioBD = usuarioBBDD.getValor();
			passValuePropBD = passValuePropBBDD.getValor().trim();

			// Si existe el parametro FROM en BBDD, sobreescribe el valor tomado
			// del DEVON.PROP
			if (!Checks.esNulo(mailFromPropBBDD)) {
				if (!Checks.esNulo(mailFromPropBBDD.getValor())) {
					emailFrom = mailFromPropBBDD.getValor().trim();
				}
			}

			String passValueParsed = passValueProp.replaceAll("\\\\", "");
			pass = Encriptador.desencriptarPw(passValueParsed);
		} catch (Exception ee) {
			// Si da error la desencriptación o el parseo lo intentaremos
			// con el valor obtenido del properties directamente.
			pass = passValueProp;
			// logger.error("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos]
			// ee="+ ee.getMessage());
		}

		// Settea Email From cargado de BBDD o del devon.prop, con esa prioridad
		// en el origen del valor
		message.setFrom(new InternetAddress(emailFrom));

		if (!Checks.esNulo(usuarioBD)) {
			try {
				String passValueParsed = passValuePropBD.replaceAll("\\\\", "");
				passBB = Encriptador.desencriptarPw(passValueParsed);
			} catch (Exception ee) {
				// Si da error la desencriptación o el parseo lo
				// intentaremos con el valor obtenido del properties
				// directamente.
				passBB = passValuePropBD;
				// logger.error("[AgendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos]
				// ee="+ ee.getMessage());
			}
			try {
				envioCorreoGenerico(message, t, usuarioBD, passBB);
			} catch (Exception e) {
				envioCorreoGenerico(message, t, usuario, pass);
			}
		} else {
			envioCorreoGenerico(message, t, usuario, pass);
		}

	}

	private void envioCorreoGenerico(MimeMessage message, Transport t,
		String usuario, String pass) throws MessagingException {

		t.connect(usuario, pass);
		t.sendMessage(message, message.getAllRecipients());

		// Cierre.
		t.close();
	}
	
	
	private Properties getPropiedades() {	
					
		Properties props = new Properties();
		props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO));
		props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(PUERTO_CORREO));
		
		if(appProperties.getProperty(STARTTLS_ENABLE) != null) {
			props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, appProperties.getProperty(STARTTLS_ENABLE));
		}
		else {
			props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, "true");
		}
		
		if(appProperties.getProperty(AUTH) != null) {
			props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, appProperties.getProperty(AUTH));
		}
		else {
			props.setProperty(MAIL_SMTP_AUTH, "true");
		}
		
		props.setProperty(MAIL_SMTP_USER, appProperties.getProperty(USUARIO_CORREO));
		
		props.setProperty(MAIL_SMTP_DEBUG, "false");
		
		return props;
	}
	
}