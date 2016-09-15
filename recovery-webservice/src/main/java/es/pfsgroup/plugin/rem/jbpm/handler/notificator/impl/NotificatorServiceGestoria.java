package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class NotificatorServiceGestoria implements NotificatorService {

	private static final String CODIGO_T002_SOLICITUD_DOCUMENTO_GESTORIA = "T002_SolicitudDocumentoGestoria";
	private static final String CODIGO_T008_SOLICITUD_DOCUMENTO = "T008_SolicitudDocumento";
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	List<String> mailsPara = new ArrayList<String>();
	List<String> mailsCC = new ArrayList<String>();
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T002_SOLICITUD_DOCUMENTO_GESTORIA,CODIGO_T008_SOLICITUD_DOCUMENTO};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {
		
		mailsPara.add("pruebashrem@gmail.com");
		mailsCC.add("pruebashrem@gmail.com");
		
		String cuerpo = "Trámite afectado: "+ tramite.getId();
		
		genericAdapter.sendMail(mailsPara, mailsCC, "Notificación a la gestoría", cuerpo);
	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
	}


}