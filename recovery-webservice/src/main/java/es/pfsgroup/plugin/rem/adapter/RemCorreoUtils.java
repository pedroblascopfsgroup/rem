package es.pfsgroup.plugin.rem.adapter;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.model.CorreoSaliente;
import es.pfsgroup.recovery.Encriptador;

@Component
public class RemCorreoUtils {

	private static final String MAIL_SMTP_USER = "mail.smtp.user";
	private static final String MAIL_SMTP_AUTH = "mail.smtp.auth";
	private static final String MAIL_SMTP_PORT = "mail.smtp.port";
	private static final String MAIL_SMTP_STARTTLS_ENABLE = "mail.smtp.starttls.enable";
	private static final String MAIL_SMTP_HOST = "mail.smtp.host";
	private static final String MAIL_SMTP_DEBUG = "mail.smtp.debug";
	private static final String TRANSPORT_SMTP = "smtp";

	// Entradas en devon.properties que servirán para componer el mensaje
	private static final String SERVIDOR_CORREO = "agendaMultifuncion.mail.server";
	private static final String PUERTO_CORREO = "agendaMultifuncion.mail.port";
	private static final String FROM = "agendaMultifuncion.mail.from";
	private static final String USUARIO_CORREO = "agendaMultifuncion.mail.usuario";
	private static final String PWD_CORREO = "agendaMultifuncion.mail.pwd";
	private static final String STARTTLS_ENABLE = "agendaMultifuncion.mail.starttls.enable";
	private static final String AUTH = "agendaMultifuncion.mail.auth";

	@Resource
	private Properties appProperties;

	@Autowired
	private GenericABMDao genericDao;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

	protected final Log logger = LogFactory.getLog(getClass());

	public void enviarCorreoConAdjuntos(String emailFrom, List<String> mailsPara, List<String> direccionesMailCc,
			String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) throws Exception {
		
		CorreoSaliente traza = obtenerTrazaCorreoSaliente(emailFrom, mailsPara, direccionesMailCc, asuntoMail,
				cuerpoEmail, list);

		try {
			
				emailFrom = emailFrom(emailFrom);
				for (int i = 0; i < mailsPara.size(); i++) {
					if (Checks.esNulo(mailsPara.get(i)) || "null".equals(mailsPara.get(i).toLowerCase())) {
						mailsPara.remove(i);
					}
				}
				if (mailsPara == null || mailsPara.isEmpty()) {
					throw new Exception("La lista de destinatorios no puede ser null");
				}

				// Propiedades de la conexion
				Properties props = getPropiedades();

				// Preparamos la sesion
				Session session = Session.getDefaultInstance(props);
				session.setDebugOut(System.out);
				session.setDebug(false);

				MimeMessage message = new MimeMessage(session);

				prepararDestinatarios(message, mailsPara, direccionesMailCc);

				message.setSubject(asuntoMail);

				prepararBodyMensaje(message, list, cuerpoEmail);

				message.setFrom(new InternetAddress(emailFrom));

				// Lo enviamos.
				if (esCorreoActivado()) {
					doSend(message, session, props);
				}				
				traza.setResultado(true);
		} catch (Exception e) {
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			traza.setResultado(false);
			traza.setError(errors.toString());
			logger.error("Error enviando correo", e);
		} finally {
			persistirTrazaCorreoSaliente(traza);
		}

	}

	private CorreoSaliente obtenerTrazaCorreoSaliente(String emailFrom, List<String> mailsPara,
			List<String> direccionesMailCc, String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) {
		CorreoSaliente traza = new CorreoSaliente();
		traza.setAsunto(asuntoMail);
		traza.setCuerpo(cuerpoEmail);
		if (mailsPara != null && mailsPara.size() > 0) {
			String paraAcumulado = "";
			int i = 0;
			for (String para : mailsPara) {
				if (para != null && para.length() > 0) {
					if (i > 0) {
						paraAcumulado = paraAcumulado.concat(",");
					}
					paraAcumulado = paraAcumulado.concat(para);
					i++;
				}
			}
			traza.setTo(paraAcumulado);
		}
		traza.setFrom(emailFrom);

		return traza;
	}

	private void persistirTrazaCorreoSaliente(CorreoSaliente traza) {
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			genericDao.save(CorreoSaliente.class, traza);
			transactionManager.commit(transaction);
			
		} catch (Exception e) {
			logger.error("Error persistiendo traza de correo", e);
			transactionManager.rollback(transaction);

		}
	}

	private void doSend(MimeMessage message, Session session, Properties props) throws MessagingException {
		// Lo enviamos.
		Transport t = session.getTransport(TRANSPORT_SMTP);

		// validacion de usuario que envia
		String usuario = props.getProperty(MAIL_SMTP_USER);;
		String pass = obtenerPass();;

		envioCorreoGenerico(message, t, usuario, pass);
	}

	private void prepararDestinatarios(MimeMessage message, List<String> mailsPara, List<String> direccionesMailCc)
			throws AddressException, MessagingException {
		for (String emailPara : mailsPara) {
			if (validarCorreo(emailPara)) {
				message.addRecipient(Message.RecipientType.TO, new InternetAddress(emailPara));
			}

		}

		if (direccionesMailCc != null && direccionesMailCc.size() > 0) {
			for (String emailCC : direccionesMailCc) {
				if (validarCorreo(emailCC)) {
					message.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC));
				}

			}
		}
	}
	
	private boolean validarCorreo(String email) {
		boolean resultado = false;

		if (email != null && !email.isEmpty()) {
			// Patrón para validar el email
			Pattern pattern = Pattern.compile(
					"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$");

			Matcher mather = pattern.matcher(email);

			if (mather.find() == true) {
				resultado = true;
			}
		}

		return resultado;
	}

	private void prepararBodyMensaje(MimeMessage message, List<DtoAdjuntoMail> list, String cuerpoEmail)
			throws IOException, MessagingException {
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
	}

	private String obtenerPass() {
		String pass = null;
		String passValueProp = appProperties.getProperty(PWD_CORREO);
		try {
			String passValueParsed = passValueProp.replaceAll("\\\\", "");
			pass = Encriptador.desencriptarPw(passValueParsed);
		} catch (Exception ee) {
			// Si da error la desencriptación o el parseo lo intentaremos
			// con el valor obtenido del properties directamente.
			pass = passValueProp;
		}

		return pass;
	}

	private String emailFrom(String emailFrom) {
		if (Checks.esNulo(emailFrom)) {
			emailFrom = appProperties.getProperty(FROM);
		}
		return emailFrom;
	}

	private boolean esCorreoActivado() {
		boolean resultado = false;
		String servidorCorreo = appProperties.getProperty(SERVIDOR_CORREO);
		String puertoCorreo = appProperties.getProperty(PUERTO_CORREO);
		if (!Checks.esNulo(servidorCorreo) && !Checks.esNulo(puertoCorreo)) {
			resultado = true;
		}
		return resultado;
	}

	private void envioCorreoGenerico(MimeMessage message, Transport t, String usuario, String pass)
			throws MessagingException {

		t.connect(usuario, pass);
		t.sendMessage(message, message.getAllRecipients());

		// Cierre.
		t.close();
	}

	private Properties getPropiedades() {

		Properties props = new Properties();
		if (appProperties.getProperty(SERVIDOR_CORREO) != null) {
			props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO));
		}
		
		if (appProperties.getProperty(SERVIDOR_CORREO) != null) {
			props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(SERVIDOR_CORREO));
		}
		
		

		if (appProperties.getProperty(STARTTLS_ENABLE) != null) {
			props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, appProperties.getProperty(STARTTLS_ENABLE));
		} else {
			props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, "true");
		}

		if (appProperties.getProperty(AUTH) != null) {
			props.setProperty(MAIL_SMTP_STARTTLS_ENABLE, appProperties.getProperty(AUTH));
		} else {
			props.setProperty(MAIL_SMTP_AUTH, "true");
		}

		props.setProperty(MAIL_SMTP_USER, appProperties.getProperty(USUARIO_CORREO));

		props.setProperty(MAIL_SMTP_DEBUG, "false");

		return props;
	}

}