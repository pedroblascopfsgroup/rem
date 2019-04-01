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
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Component
public class NotificatorServiceODocEncargoProveedor extends AbstractNotificatorService implements NotificatorService {

	private static final String CODIGO_T002_SOLICITUD_DOCUMENTO_PROVEEDOR = "T002_SolicitudDocumentoGestoria"; // solicitud documento por proveedor

	@Autowired
	private GenericAdapter genericAdapter;
	
		
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T002_SOLICITUD_DOCUMENTO_PROVEEDOR};
	}

	@Override
	public void notificator(ActivoTramite tramite) {

		if(!Checks.esNulo(tramite.getTrabajo().getProveedorContacto().getUsuario()) && !Checks.esNulo(tramite.getTrabajo().getProveedorContacto().getUsuario().getEmail())) {
 
			// Notificacion al proveedor
			Usuario proveedor = null;
			if(!Checks.esNulo(tramite.getTrabajo())) {
				proveedor = tramite.getTrabajo().getProveedorContacto().getUsuario();
			}

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

		    String correos = proveedor.getEmail();
		    Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());

			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";

			dtoSendNotificator.setTitulo("Notificación encargo de obtención de documento en REM");

			String contenido = "<p>Desde HAYA RE se le ha asignado un trabajo de obtención de un documento relativo al activo cuyos datos figuran más arriba. Por favor, entre en la aplicación REM y compruebe las condiciones del trabajo cuyos datos figuran asimismo en el cuadro superior. Gracias.</p>";
			String titulo = "Notificación encargo de obtención de documento en REM (" + descripcionTrabajo + "Nº Trabajo " + dtoSendNotificator.getNumTrabajo()+")";
			

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {

	}

}
