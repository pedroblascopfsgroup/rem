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
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class NotificatorServiceODocCEEAnalisisPeticion extends AbstractNotificatorService implements NotificatorService {
	
	private static final String CODIGO_T003_ANALISIS_PETICION = "T003_AnalisisPeticion";


	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T003_ANALISIS_PETICION};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {
		if(!Checks.esNulo(tramite) && !Checks.esNulo(tramite.getTrabajo()) 
			&& DDCartera.CODIGO_CARTERA_BANKIA.equals(tramite.getActivo().getCartera().getCodigo())) {
					
			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
			final String BUZON_PACI = "paci03";
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
						 
			Usuario buzonPaci = usuarioManager.getByUsername(BUZON_PACI);			    	
			String correos = !Checks.esNulo(buzonPaci) ? buzonPaci.getEmail() : "";
		    Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());
						
			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";
			String titulo = "Notificación de petición en REM (" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
			String contenido = "<p>Se le ha asignado una actuación técnica del tipo "+dtoSendNotificator.getTipoContrato()+", la cual se ha abierto en REM con "
	  		  		 + "el número de trabajo " +tramite.getTrabajo().getNumTrabajo() + ".</p>"
	  		  		 + "<p>El activo objeto de la actuación es el número " +dtoSendNotificator.getNumActivo() + ", situado en "+dtoSendNotificator.getDireccion()+"</p>"
	  		  		 + "<p>La fecha de finalización del trabajo por su parte es el "+dtoSendNotificator.getFechaFinalizacion()+"</p>"
	  		  		 + "<p>Por favor, entre en la aplicación REM y compruebe las condiciones del trabajo.</p>"
	  		  		 + "<p>Gracias.</p>";
			
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));		
		}				
	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		if(!Checks.esNulo(tramite) && !Checks.esNulo(tramite.getTrabajo()) &&
			!Checks.esNulo(tramite.getTrabajo().getSolicitante()) && !Checks.esNulo(tramite.getTrabajo().getSolicitante().getEmail())
			&& !tramite.getTrabajo().getSolicitante().equals(genericAdapter.getUsuarioLogado())) {

			//Notificacion al solicitante
			Usuario peticionario = null;
			if(!Checks.esNulo(tramite.getTrabajo()))
				peticionario = tramite.getTrabajo().getSolicitante();
			
			//El aviso NO se remite si el peticionario es el gestor del activo
			if (!Checks.esNulo(peticionario) && !gestorActivoApi.isGestorActivo(tramite.getActivo(), peticionario)){
				DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
				
				List<String> mailsPara = new ArrayList<String>();
				List<String> mailsCC = new ArrayList<String>();
				
				
			    String correos = peticionario.getEmail();
			    Collections.addAll(mailsPara, correos.split(";"));
				mailsCC.add(this.getCorreoFrom());
				
				String contenido = "";
				String titulo = "";
				String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";
				
				String motivo = null;
				
				if(DDSiNo.NO.equals(activoTramiteApi.getTareaValorByNombre(valores, "comboTramitar")))
					motivo = activoTramiteApi.getTareaValorByNombre(valores, "motivoDenegacion");
	
				if(motivo == null) {
					contenido = "<p>El gestor responsable de tramitar su petición la ha aceptado, por lo que se ha analizado la petición del certificado de CEE.</p>";
					titulo = "Notificación de aceptación de petición en REM (" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
				}
				else {
					contenido = "<p>El gestor responsable de tramitar su petición la ha rechazado indicando el siguiente motivo: "+motivo+".</p>";
					titulo = "Notificación de rechazo de petición en REM(" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
				}
					  
				genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
			}
		}
	}
	
}
