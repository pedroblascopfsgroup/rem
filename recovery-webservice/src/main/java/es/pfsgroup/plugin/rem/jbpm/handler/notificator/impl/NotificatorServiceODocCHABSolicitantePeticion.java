package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class NotificatorServiceODocCHABSolicitantePeticion extends AbstractNotificatorService implements NotificatorService {

	private static final String COMBO_TRAMITAR = "comboTramitar";
	private static final String CODIGO_T002_OBTENCION_DOCUMENTO = "T008_ObtencionDocumento";
	public static final String CODIGO_GESTOR_ACTIVO = "GACT";
	public static final String CODIGO_GESTOR_ADMISION = "GADM";

	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
		
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T002_OBTENCION_DOCUMENTO};
	}

	@Override
	public void notificator(ActivoTramite tramite) {

	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Boolean aceptacion = false;
		Boolean esProveedorExterno = false;

		for (TareaExternaValor valor : valores) {
			if (COMBO_TRAMITAR.equals(valor.getNombre()) && "01".equals(valor.getValor())) {
				aceptacion = true;
			}
		}

		if(!Checks.esNulo(tramite.getTrabajo().getSolicitante()) 
				&& !Checks.esNulo(tramite.getTrabajo().getSolicitante().getEmail())) {

			//Notificacion al solicitante
			Usuario peticionario = null;
			if(!Checks.esNulo(tramite.getTrabajo())) {
				peticionario = tramite.getTrabajo().getSolicitante();	
			}
			
			//Destinatario: El peticionario del trabajo. Excepción: No se envía si el peticionario es el gestor de admisión y el activo es de Sareb/Bankia;
			//y no se envía si el peticionario es el gestor de activo y el activo es de Cajamar.
			Activo activo = tramite.getActivo();
			DDCartera cartera = tramite.getActivo().getCartera();
			Usuario gestorAdmin = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ADMISION);
			Usuario gestorAct = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
			if (peticionario != null && peticionario.equals(gestorAdmin) && ( cartera.equals(DDCartera.CODIGO_CARTERA_BANKIA)  ||
																						cartera.equals(DDCartera.CODIGO_CARTERA_SAREB) ||
																						cartera.equals(DDCartera.CODIGO_CARTERA_TANGO) ||
																						cartera.equals(DDCartera.CODIGO_CARTERA_GIANTS))) {
				return;
			}
			if (peticionario != null && peticionario.equals(gestorAct) && cartera.equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
				return;
			}

			Usuario usuarioTareaActivo = null;
			if (!valores.isEmpty() 
					&& valores.get(0).getTareaExterna() != null 
					&& valores.get(0).getTareaExterna().getTareaPadre() != null 
					&& valores.get(0).getTareaExterna().getTareaPadre() instanceof TareaActivo) {

				usuarioTareaActivo  = ((TareaActivo) valores.get(0).getTareaExterna().getTareaPadre()).getUsuario();	
			}

			// si es gestor interno y el solicitante es igual que el usuario de la tarea actual, no se envia el correo.
			if (!esProveedorExterno && peticionario != null && peticionario.equals(usuarioTareaActivo)) {
				return;
			}

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

		    String correos = peticionario.getEmail();
		    Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());

			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";

			String contenido;
			String titulo;

			if (aceptacion) {
				dtoSendNotificator.setTitulo("Notificación aceptación petición Cédula de Habitabilidad");
				contenido = "<p>Le informamos de que su petición de obtención de una Cédula de Habitabilidad para el activo de referencia ha sido aceptada por el gestor encargado de su gestión y va a ser tramitada con el número de trabajo que asimismo consta más arriba. Un saludo.</p>";
				titulo = "Notificación aceptación petición Cédula de Habitabilidad en REM (" + descripcionTrabajo + "Nº Trabajo " + dtoSendNotificator.getNumTrabajo()+")";
			} else {
				dtoSendNotificator.setTitulo("Notificación rechazo petición Cédula de Habitabilidad");
				contenido = "<p>Le informamos de que su petición de obtención de una Cédula de Habitabilidad para el activo de referencia ha sido rechazada por el gestor encargado de su gestión. Puede consultar el trabajo de referencia para obtener más información sobre el motivo del rechazo de su petición. Gracias.</p>";
				titulo = "Notificación rechazo petición Cédula de Habitabilidad en REM (" + descripcionTrabajo + "Nº Trabajo " + dtoSendNotificator.getNumTrabajo()+")";
			}

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}
	
}
