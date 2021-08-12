package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.RemCorreoUtils;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EnvioCorreoAsync implements Runnable {

	private List<String> mailsPara;
	private List<String> mailsCC;
	private String asunto;
	private String cuerpo;
	private List<DtoAdjuntoMail> adjuntos;
	private String userName = null;
	private List<String> mailsBCC;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;
	
	@Autowired
	private RemCorreoUtils remCorreoUtils;

	
	
	public EnvioCorreoAsync(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo,
			List<DtoAdjuntoMail> adjuntos,String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.mailsPara = mailsPara;
		this.mailsCC = mailsCC;
		this.asunto = asunto;
		this.cuerpo = cuerpo;
		this.adjuntos = adjuntos;
		this.userName = userName;
	}
	
	public EnvioCorreoAsync(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo,
			List<DtoAdjuntoMail> adjuntos,String userName, List<String> mailsBCC ) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.mailsPara = mailsPara;
		this.mailsCC = mailsCC;
		this.asunto = asunto;
		this.cuerpo = cuerpo;
		this.adjuntos = adjuntos;
		this.userName = userName;
		this.mailsBCC = mailsBCC;
	}

	@Override
	public void run() {
		try {
			restApi.doSessionConfig(this.userName);
		} catch (Exception e) {
			logger.error("error iniciandoi sesión en el hilo de los correos", e);
		}
		remCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, adjuntos,mailsBCC);
	}

}
