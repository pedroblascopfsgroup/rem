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
public class NotificatorServiceODocCHABSolicitanteCierre extends AbstractNotificatorService implements NotificatorService {

	private static final String CODIGO_T008_CIERRE_ECONOMICO = "T008_CierreEconomico";

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
		return new String[]{CODIGO_T008_CIERRE_ECONOMICO};
	}

	@Override
	public void notificator(ActivoTramite tramite) {

	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Boolean esProveedorExterno = false;

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
			if (!Checks.esNulo(peticionario) && peticionario.equals(gestorAdmin) && ( cartera.equals(DDCartera.CODIGO_CARTERA_BANKIA)  ||  
																						cartera.equals(DDCartera.CODIGO_CARTERA_SAREB) || 
																						cartera.equals(DDCartera.CODIGO_CARTERA_TANGO) || 
																						cartera.equals(DDCartera.CODIGO_CARTERA_GIANTS))) {
				return;
			}
			if (!Checks.esNulo(peticionario) && peticionario.equals(gestorAct) &&  cartera.equals(DDCartera.CODIGO_CARTERA_CAJAMAR )) {
				return;
			}

			Usuario usuarioTareaActivo = null;
			if (!valores.isEmpty() 
					&& valores.get(0).getTareaExterna() != null 
					&& valores.get(0).getTareaExterna().getTareaPadre() != null 
					&& valores.get(0).getTareaExterna().getTareaPadre() instanceof TareaActivo) {

				usuarioTareaActivo  = ((TareaActivo) valores.get(0).getTareaExterna().getTareaPadre()).getUsuario();	
			}

			Usuario proveedor = null;
			if(!Checks.esNulo(tramite.getTrabajo()) && !Checks.esNulo(tramite.getTrabajo().getProveedorContacto())) {
				proveedor =  tramite.getTrabajo().getProveedorContacto().getUsuario();
				if (proveedor!=null) {
					esProveedorExterno = proveedor.getUsuarioExterno();
				}
			}
			

			// si es gestor interno y el solicitante es igual que el usuario de la tarea actual, no se envia el correo.
			if (!esProveedorExterno && !Checks.esNulo(peticionario) && peticionario.equals(usuarioTareaActivo)) {
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

			dtoSendNotificator.setTitulo("Notificación encargo de obtención de Cédula de Habitabilidad");
			contenido = "<p>Le informamos de que ha finalizado el trabajo solicitado por usted para la obtención de la Cédula de Habitabilidad del activo cuyos datos figuran en el cuadro superior. Por favor, entre en la aplicación REM para obtener más información y consultar el documento obtenido. Gracias.</p>";
			titulo = "Notificación encargo de obtención de Cédula de Habitabilidad en REM (" + descripcionTrabajo + "Nº Trabajo " + dtoSendNotificator.getNumTrabajo()+")";


			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}
	
}
