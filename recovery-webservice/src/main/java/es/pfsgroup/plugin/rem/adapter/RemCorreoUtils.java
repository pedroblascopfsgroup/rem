package es.pfsgroup.plugin.rem.adapter;

import java.io.IOException;
import java.util.List;
import java.util.Properties;

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

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
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
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;

	protected final Log logger = LogFactory.getLog(getClass());

	public void enviarCorreoConAdjuntos(String emailFrom, List<String> mailsPara, List<String> direccionesMailCc,
			String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) throws Exception {

		emailFrom = emailFrom(emailFrom);
		CorreoSaliente traza = obtenerTrazaCorreoSaliente(emailFrom, mailsPara, direccionesMailCc, asuntoMail, cuerpoEmail, list);

		for(int i = 0; i < mailsPara.size(); i++) {
			if(Checks.esNulo(mailsPara.get(i)) || "null".equals(mailsPara.get(i).toLowerCase())) {
				mailsPara.remove(i);
			}
		}
		if (mailsPara == null || mailsPara.isEmpty()) {
			return;
		}

		try {
			if (esCorreoActivado()) {

				
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
				doSend(message, session, props);
			}			
		} catch (Exception e) {
			logger.error("Error enviando correo",e);
		}finally{
			persistirTrazaCorreoSaliente(traza);
		}

	}

	private CorreoSaliente obtenerTrazaCorreoSaliente(String emailFrom, List<String> mailsPara, List<String> direccionesMailCc,
			String asuntoMail, String cuerpoEmail, List<DtoAdjuntoMail> list) {
		CorreoSaliente traza = new CorreoSaliente();
		traza.setAsunto(asuntoMail);
		traza.setCuerpo(cuerpoEmail);
		if(mailsPara != null && mailsPara.size() > 0){
			String paraAcumulado = "";
			int i= 0;
			for(String para : mailsPara){
				if(i > 0){
					paraAcumulado = paraAcumulado.concat(",");
				}
				paraAcumulado = paraAcumulado.concat(para);				
				i++;
			}
			traza.setTo(paraAcumulado);
		}
		traza.setFrom(emailFrom);
		
		return traza;
	}

	private void persistirTrazaCorreoSaliente(CorreoSaliente traza) {
		genericDao.save(CorreoSaliente.class, traza);
	}

	private void doSend(MimeMessage message, Session session, Properties props) throws MessagingException {
		// Lo enviamos.
		Transport t = session.getTransport(TRANSPORT_SMTP);

		// validacion de usuario que envia
		String usuario = null;
		String pass = null;

		String usuarioBD = null;
		String passBB = null;

		// Variables desde el DEVON
		usuario = props.getProperty(MAIL_SMTP_USER);

		usuarioBD = obtenerUsuarioBD();

		// Settea Email From cargado de BBDD o del devon.prop, con esa

		if (!Checks.esNulo(usuarioBD)) {
			passBB = obtenerPassBd();
			pass = obtenerPass();
			try {
				envioCorreoGenerico(message, t, usuarioBD, passBB);
			} catch (Exception e) {
				envioCorreoGenerico(message, t, usuario, pass);
			}
		} else {
			envioCorreoGenerico(message, t, usuario, pass);
		}
	}

	private void prepararDestinatarios(MimeMessage message, List<String> mailsPara, List<String> direccionesMailCc)
			throws AddressException, MessagingException {
		for (String emailPara : mailsPara) {
			if (emailPara != null) {
				message.addRecipient(Message.RecipientType.TO, new InternetAddress(emailPara));
			}

		}

		if (direccionesMailCc != null && direccionesMailCc.size() > 0) {
			for (String emailCC : direccionesMailCc) {
				if (emailCC != null) {
					message.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC));
				}

			}
		}
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

	private String obtenerUsuarioBD() {
		String usuarioBD = null;
		try {
			Parametrizacion usuarioBBDD = (Parametrizacion) executor.execute(
					ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
					Parametrizacion.ANOTACIONES_MAIL_SMTP_USER);
			usuarioBD = usuarioBBDD.getValor();
		} catch (Exception e) {
			logger.error("error obteniendo el usuarioBd", e);
		}
		return usuarioBD;
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
		try {
			Parametrizacion mailFromPropBBDD = (Parametrizacion) executor.execute(
					ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
					Parametrizacion.ANOTACIONES_EMAIL_FROM);
			if (!Checks.esNulo(mailFromPropBBDD)) {
				if (!Checks.esNulo(mailFromPropBBDD.getValor())) {
					emailFrom = mailFromPropBBDD.getValor().trim();
				}
			}
			// Carga el email FROM directamente del DEVON.PROP, si existe el
			// parametro
			if (Checks.esNulo(emailFrom)) {
				emailFrom = appProperties.getProperty(FROM);
			}
		} catch (Exception e) {
			logger.error("error obteniendo el mail from de properties", e);
		}
		return emailFrom;
	}

	private String obtenerPassBd() {
		String passBB = null;
		String passValuePropBD = null;
		try {
			Parametrizacion passValuePropBBDD = (Parametrizacion) executor.execute(
					ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
					Parametrizacion.ANOTACIONES_PWD_CORREO);
			passValuePropBD = passValuePropBBDD.getValor().trim();
			String passValueParsed = passValuePropBD.replaceAll("\\\\", "");
			passBB = Encriptador.desencriptarPw(passValueParsed);
		} catch (Exception ee) {
			passBB = passValuePropBD;
		}
		return passBB;
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
		props.setProperty(MAIL_SMTP_HOST, appProperties.getProperty(SERVIDOR_CORREO));
		props.setProperty(MAIL_SMTP_PORT, appProperties.getProperty(PUERTO_CORREO));

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