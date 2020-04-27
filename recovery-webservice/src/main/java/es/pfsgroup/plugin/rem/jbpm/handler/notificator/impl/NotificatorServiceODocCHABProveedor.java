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
public class NotificatorServiceODocCHABProveedor extends AbstractNotificatorService implements NotificatorService {

	private static final String CODIGO_T002_SOLICITUD_DOCUMENTO = "T008_SolicitudDocumento";

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
		return new String[]{CODIGO_T002_SOLICITUD_DOCUMENTO};
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
			Usuario proveedor = null;
			if(!Checks.esNulo(tramite.getTrabajo()) && !Checks.esNulo(tramite.getTrabajo().getProveedorContacto())) {
				proveedor =  tramite.getTrabajo().getProveedorContacto().getUsuario();
				if (proveedor!=null) {
					esProveedorExterno = proveedor.getUsuarioExterno();
				}
			}
			
			//Destinatario: El proveedor del trabajo (gestoría de Cédula de Habitabilidad en el caso de Bankia y Sareb
			// o el seleccionado por el gestor de activo en el caso de Cajamar)
			Activo activo = tramite.getActivo();
			DDCartera cartera = tramite.getActivo().getCartera();
			if ( cartera.equals(DDCartera.CODIGO_CARTERA_BANKIA) ||  
			     cartera.equals(DDCartera.CODIGO_CARTERA_SAREB)  || 
			     cartera.equals(DDCartera.CODIGO_CARTERA_TANGO)  ||
			     cartera.equals(DDCartera.CODIGO_CARTERA_GIANTS)) {
				proveedor = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTORIA_CEDULAS);
			}
//			if ( cartera.equals(DDCartera.CODIGO_CARTERA_CAJAMAR) ) {
//				return;
//			}

			if (Checks.esNulo(proveedor)) {
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
			if (!esProveedorExterno && proveedor != null && proveedor.equals(usuarioTareaActivo)) {
				return;
			}

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

			if(proveedor != null) {
				String correos = proveedor.getEmail();
			    Collections.addAll(mailsPara, correos.split(";"));
				mailsCC.add(this.getCorreoFrom());
			}
		    
			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";

			String contenido;
			String titulo;

			dtoSendNotificator.setTitulo("Notificación encargo de obtención de Cédula de Habitabilidad");
			contenido = "<p>Desde HAYA RE se le ha asignado un trabajo de obtención de una Cédula de Habitabilidad para el activo cuyos datos figuran más arriba. Por favor, entre en la aplicación REM y compruebe las condiciones del trabajo cuyos datos figuran asimismo en el cuadro superior. Gracias.</p>";
			titulo = "Notificación encargo de obtención de Cédula de Habitabilidad en REM (" + descripcionTrabajo + "Nº Trabajo " + dtoSendNotificator.getNumTrabajo()+")";


			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}
	
}
