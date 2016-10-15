package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Component
public class NotificatorServiceActualizacionPreciosAnalisis extends AbstractNotificatorService implements NotificatorService {
	
	private static final String CODIGO_T010_ANALISIS_PETICION_CARGA = "T010_AnalisisPeticionCargaList";


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
		return new String[]{CODIGO_T010_ANALISIS_PETICION_CARGA};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {

	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		//Comprobamos que quien solicitó el trabajo y quien realiza la tarea no sean el mismo usuario
		if(!Checks.esNulo(tramite.getTrabajo().getSolicitante()) && !Checks.esNulo(tramite.getTrabajo().getSolicitante().getEmail()) 
				&& !tramite.getTrabajo().getSolicitante().equals(genericAdapter.getUsuarioLogado()) )
		{
		
			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
			
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			String correos = null;
			
			correos = tramite.getTrabajo().getSolicitante().getEmail();
		    Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());
			
			String contenido = "";
			String titulo = "";
			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";
	
			String motivo = null;
			if(activoTramiteApi.getTareaValorByNombre(valores, "comboAceptacion").equalsIgnoreCase(DDSiNo.NO))
				motivo = activoTramiteApi.getTareaValorByNombre(valores, "motivoDenegacion");
			
			if(motivo == null) {
				
				contenido = "<p>El gestor responsable de tramitar su petición la ha aceptado, por lo que se ha procedido a actualizar la información solicitada en los activos correspondientes.</p>";
			
				titulo = "Notificación de aceptación de petición en REM (" + descripcionTrabajo + " Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
				
			}
			else {
				contenido = "<p>El gestor responsable de tramitar su petición la ha rechazado indicando el siguiente motivo: "+motivo+".</p>";
			
				titulo = "Notificación de rechazo de petición en REM (" + descripcionTrabajo + " Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
			}
	
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}

}
