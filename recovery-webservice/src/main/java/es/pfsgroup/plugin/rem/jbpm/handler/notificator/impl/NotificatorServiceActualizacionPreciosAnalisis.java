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
		
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		String motivo = comprobarAceptacionTarea(valores);
		
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		String correos = null;
		
		correos = tramite.getTrabajo().getSolicitante().getEmail();
	    Collections.addAll(mailsPara, correos.split(";"));
		mailsCC.add(this.getCorreoFrom());
		
		String contenido = "";
		String titulo = "";
		String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";

		/**
		 * HREOS-763 Completar cuando haya más información para esta notificación
		 */
		if(Checks.esNulo(motivo)) {
			
			contenido = "<p>Desde HAYA RE le informamos de que el gestor del trabajo "+dtoSendNotificator.getNumTrabajo()+" ha validado positivamente su ejecución del trabajo "+dtoSendNotificator.getTipoContrato()+" "
					 + ", por lo que se procederá a la actualización de precios de los activos incluidos en el listado adjuntado del trabajo.</p>"
			  		 + "<p>Un saludo.</p>";
		
			titulo = "Notificación de aceptación de ejecución de trabajo en REM (" + descripcionTrabajo + " Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
			
		}
		else {
			contenido = "<p>Desde HAYA RE le informamos de que el gestor del trabajo "+dtoSendNotificator.getNumTrabajo()+" ha rechazado su ejecución del trabajo "+dtoSendNotificator.getTipoContrato()+" "
					 + ", por tanto, no habrá actualización de precios de los activos incluidos en el listado adjuntado del trabajo por el siguiente motivo:</p>"
					 + "<p><i>"+motivo+"</i></p>"
			  		 + "<p>Un saludo.</p>";
		
			titulo = "Notificación de rechazo de ejecución de trabajo en REM (" + descripcionTrabajo + " Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
		}

			  
		//genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpoCorreo(dtoSendNotificator, contenido));
		genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
	}
	
	/**
	 * El mensaje varía en caso de que se haya aceptado o no la tarea
	 * @param idTramite
	 * @return
	 */
	private String comprobarAceptacionTarea(List<TareaExternaValor> valores) {
		
		String motivo = null;

		for(TareaExternaValor tev : valores) {
			if(tev.getNombre().equalsIgnoreCase("motivoDenegacion")) {
				if(!Checks.esNulo(tev.getValor()) ) {
					motivo = tev.getValor();
				}
				break;
			}
		}
		
		return motivo;
	}

}
