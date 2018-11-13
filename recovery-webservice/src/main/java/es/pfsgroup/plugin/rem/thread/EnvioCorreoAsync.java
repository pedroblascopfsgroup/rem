package es.pfsgroup.plugin.rem.thread;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.AgendaMultifuncionCorreoUtils;

public class EnvioCorreoAsync implements Runnable {
	
	private List<String> mailsPara;
	private List<String> mailsCC;
	private String asunto;
	private String cuerpo;
	private List<DtoAdjuntoMail> adjuntos;

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Resource
	private Properties appProperties;
	
	private AgendaMultifuncionCorreoUtils agendaMultifuncionCorreoUtils = new AgendaMultifuncionCorreoUtils();
	
	private static final String SERVIDOR_CORREO = "agendaMultifuncion.mail.server";
	private static final String PUERTO_CORREO = "agendaMultifuncion.mail.port";
	
	public EnvioCorreoAsync(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo,
			List<DtoAdjuntoMail> adjuntos) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.mailsPara = mailsPara;
		this.mailsCC = mailsCC;
		this.asunto = asunto;
		this.cuerpo = cuerpo;
		this.adjuntos = adjuntos;
	}

	@Override
	public void run() {
		try {
			// AgendaMultifuncionCorreoUtils.dameInstancia(executor).enviarCorreoConAdjuntos(null,
			// mailsPara, mailsCC, asunto, cuerpo, null);
			// añado comprobacion para que no falle en local
			for (int i = 0; i < mailsPara.size(); i++) {
				if (Checks.esNulo(mailsPara.get(i)) || "null".equals(mailsPara.get(i).toLowerCase())) {
					mailsPara.remove(i);
				}
			}

			if (mailsPara.isEmpty()) {
				logger.warn("El correo de " + asunto + " no se va a enviar");
				return;
			}
			String servidorCorreo = appProperties.getProperty(SERVIDOR_CORREO);
			logger.info(servidorCorreo);
			String puertoCorreo = appProperties.getProperty(PUERTO_CORREO);
			logger.info(puertoCorreo);
			if (!Checks.esNulo(servidorCorreo) && !Checks.esNulo(puertoCorreo)) {
				agendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo,
						adjuntos);
			}
		} catch (Exception e) {
			// Sacamos log de los receptores y el asunto del mail para trazar
			// los errores
			logger.error("mailsPara: " + mailsPara + ", mailsCC: " + mailsCC + ", asunto: " + asunto);
			logger.error("error enviando correo", e);
		}

	}

}
