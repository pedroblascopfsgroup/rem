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
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Component
public class NotificatorServiceODocCierreEconomico extends AbstractNotificatorService implements NotificatorService {

	private static final String CODIGO_T002_CIERRE_ECONOMICO = "T002_CierreEconomico";

	@Autowired
	private GenericAdapter genericAdapter;
	
		
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T002_CIERRE_ECONOMICO};
	}

	@Override
	public void notificator(ActivoTramite tramite) {

		if(!Checks.esNulo(tramite.getTrabajo().getSolicitante()) 
				&& !Checks.esNulo(tramite.getTrabajo().getSolicitante().getEmail())) {
 
			//Notificacion al solicitante
			Usuario peticionario = null;
			if(!Checks.esNulo(tramite.getTrabajo())) {
				peticionario = tramite.getTrabajo().getSolicitante();	
			}

			Usuario usuarioTareaActivo = null;
			for (TareaActivo tareaActivo : tramite.getTareas()) {
				if (CODIGO_T002_CIERRE_ECONOMICO.equals(tareaActivo.getCodigo())) {
					usuarioTareaActivo = tareaActivo.getUsuario();
				}
			}

			// si es gestor interno y el solicitante es igual que el usuario de la tarea actual, no se envia el correo.
			if (peticionario.equals(usuarioTareaActivo)) {
				return;
			}

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

		    String correos = peticionario.getEmail();
		    Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());

			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";

			dtoSendNotificator.setTitulo("Notificación finalización trabajo de obtención de documento");
			String contenido = "<p>Le informamos de que ha finalizado el trabajo solicitado por usted para la obtención de un documento relacionado con el activo cuyos datos figuran en el cuadro superior. Por favor, entre en la aplicación REM para obtener más información y consultar el documento obtenido. Gracias.</p>";
			String titulo = "Notificación finalización trabajo de obtención de documento (" + descripcionTrabajo + "Nº Trabajo " + dtoSendNotificator.getNumTrabajo()+")";

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}

	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
	}
	
}
