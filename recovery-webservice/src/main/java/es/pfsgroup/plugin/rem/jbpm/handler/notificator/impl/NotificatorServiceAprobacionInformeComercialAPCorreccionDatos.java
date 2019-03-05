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
public class NotificatorServiceAprobacionInformeComercialAPCorreccionDatos extends AbstractNotificatorService implements NotificatorService {
	
	private static final String CODIGO_T011_AP_CORRECCION = "T011_AnalisisPeticionCorreccion";


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
		return new String[]{CODIGO_T011_AP_CORRECCION};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {
		
		/*
		if(!Checks.esNulo(tramite.getTrabajo().getProveedorContacto()) && !Checks.esNulo(tramite.getTrabajo().getProveedorContacto().getEmail())) {
			
			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
			
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			
			//Notificacion al Mediador y al Gestor de publicacion
			String correoMediador = null;
			if(!Checks.esNulo(tramite.getTrabajo().getMediador())){
				correoMediador = tramite.getTrabajo().getMediador().getEmail();
			}

			//TODO: Notificar al mediador, para ello habilitar la linea comentada "String correos" y quitar la actual.
			//TODO: Falta añadir al String de correos, el correo del Gestor de publicacion
		    //String correos = !Checks.esNulo(correoMediador) ? correoMediador : "pruebashrem@gmail.com";
			String correos = "pruebashrem@gmail.com";;
		    Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());
			
			String contenido = "";
			String titulo = "";
			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";
	

			contenido = "<p>El gestor del ....</p>";
			titulo = "Notificación de análisis de petición de trabajo en REM (" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
	
				  
			//genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpoCorreo(dtoSendNotificator, contenido));
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
		*/
	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
	}
}
