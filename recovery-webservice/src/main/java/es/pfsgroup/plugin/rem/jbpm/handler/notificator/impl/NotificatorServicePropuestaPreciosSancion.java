package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Component
public class NotificatorServicePropuestaPreciosSancion extends AbstractNotificatorService implements NotificatorService {
	
	private static final String CODIGO_T009_SANCIO_CARGA_PROPUESTA = "T009_SancionCargaPropuesta";


	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T009_SANCIO_CARGA_PROPUESTA};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {
		
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		
		
	    String correos = tramite.getTrabajo().getSolicitante().getEmail();
	    Collections.addAll(mailsPara, correos.split(";"));
		mailsCC.add(this.getCorreoFrom());
		
		String contenido = "";
		String titulo = "";
		String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";

		/**
		 * HREOS-763 Completar cuando haya más información para esta notificación
		 */
		contenido = "<p>El gestor del ....</p>";
		titulo = "Notificación de análisis de petición de trabajo en REM (" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";

			  
		//genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpoCorreo(dtoSendNotificator, contenido));
		genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
	}
}
