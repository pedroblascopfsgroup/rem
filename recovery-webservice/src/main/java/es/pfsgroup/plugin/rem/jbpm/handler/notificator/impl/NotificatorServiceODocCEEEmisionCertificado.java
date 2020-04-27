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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Component
public class NotificatorServiceODocCEEEmisionCertificado extends AbstractNotificatorService implements NotificatorService {
	
	private static final String CODIGO_T003_EMISION_CERTIFICADO = "T003_EmisionCertificado";


	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T003_EMISION_CERTIFICADO};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {

	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		if(!Checks.esNulo(tramite.getTrabajo().getSolicitante()) && !Checks.esNulo(tramite.getTrabajo().getSolicitante().getEmail())
				&& !tramite.getTrabajo().getSolicitante().equals(genericAdapter.getUsuarioLogado())) {

			//Notificacion al proveedor
			Usuario peticionario = null;
			if(!Checks.esNulo(tramite.getTrabajo()) && !Checks.esNulo(tramite.getTrabajo().getProveedorContacto()))
				peticionario = tramite.getTrabajo().getProveedorContacto().getUsuario();
			
			//El aviso NO se remite si el proveedor es el gestor del activo
			if (!Checks.esNulo(peticionario) && !gestorActivoApi.isGestorActivo(tramite.getActivo(), peticionario)){
				DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
				
				List<String> mailsPara = new ArrayList<String>();
				List<String> mailsCC = new ArrayList<String>();
				
				if(peticionario != null) {
					String correos = peticionario.getEmail();
				    Collections.addAll(mailsPara, correos.split(";"));
					mailsCC.add(this.getCorreoFrom());
				}
				
				String contenido = "";
				String titulo = "";
				String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";
				
				String motivo = null;
				
				if(DDSiNo.NO.equals(activoTramiteApi.getTareaValorByNombre(valores, "comboEmision")))
					motivo = activoTramiteApi.getTareaValorByNombre(valores, "motivoNoEmision");
	
				if(motivo == null) {
					contenido = "<p>El gestor responsable de tramitar su petición la ha aceptado, por lo que se ha emitido un certificado de CEE.</p>";
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
