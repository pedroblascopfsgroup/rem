package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.RemCorreoUtils;

public class EnvioCorreoAsync implements Runnable {

	private List<String> mailsPara;
	private List<String> mailsCC;
	private String asunto;
	private String cuerpo;
	private List<DtoAdjuntoMail> adjuntos;

	protected final Log logger = LogFactory.getLog(getClass());

	
	private RemCorreoUtils remCorreoUtils = new RemCorreoUtils();

	
	public EnvioCorreoAsync(List<String> mailsPara, List<String> mailsCC, String asunto,
			String cuerpo, List<DtoAdjuntoMail> adjuntos) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.mailsPara = mailsPara;
		this.mailsCC = mailsCC;
		this.asunto = asunto;
		this.cuerpo = cuerpo;
		this.adjuntos = adjuntos;
	}

	@Override
	public void run() {
		remCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, adjuntos);
	}

}
