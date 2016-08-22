package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Component
public class NotificatorServiceProveedor extends AbstractNotificatorService implements NotificatorService {

	private static final String CODIGO_T004_RESULTADO_TARIFICADA = "T004_ResultadoTarificada";
	private static final String CODIGO_T004_RESULTADO_NOTARIFICADA = "T004_ResultadoNoTarificada";
	
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
		return new String[]{CODIGO_T004_RESULTADO_TARIFICADA, CODIGO_T004_RESULTADO_NOTARIFICADA};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {
		
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		
		
	    String correos = tramite.getTrabajo().getProveedorContacto().getEmail();
	    Collections.addAll(mailsPara, correos.split(";"));
		mailsCC.add(this.getCorreoFrom());
		
		String contenido = "";
		String titulo = "";
		String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";

		
		if(activoTramiteApi.numeroFijacionPlazos(tramite)>1){
			contenido = "<p>El gestor del activo "+dtoSendNotificator.getNumActivo()+" ha validado negativamente su ejecución del trabajo "+dtoSendNotificator.getTipoContrato()+" "
					 + "(Número REM "+tramite.getActivo().getNumActivoRem()+"), relativo al activo nº "+dtoSendNotificator.getNumActivo()+", situación en "+dtoSendNotificator.getDireccion()+"</p>"
					 + "<p>El motivo del rechazo es "+activoTramiteApi.obtenerMotivoDenegacion(tramite)+".</p>"
					 + "<p>Se le ha concedido un plazo para que subsane las deficiencias hasta el día "+dtoSendNotificator.getFechaFinalizacion()+"</p>"
	  		  		 + "<p>Por favor, entre en la aplicación REM y compruebe las condiciones del trabajo.</p>"
	  		  		 + "<p>Gracias.</p>";
			titulo = "Notificación de incorrección de ejecución de trabajo en REM (" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
		}else{
			contenido = "<p>Desde HAYA RE se le ha asignado una actuación técnica del tipo "+dtoSendNotificator.getTipoContrato()+", la cual se ha abierto en REM con "
	  		  		 + "el número de trabajo " +tramite.getTrabajo().getNumTrabajo() + ".</p>"
	  		  		 + "<p>El activo objeto de la actuación es el número " +dtoSendNotificator.getNumActivo() + ", situado en "+dtoSendNotificator.getDireccion()+"</p>"
	  		  		 + "<p>La fecha de finalización del trabajo por su parte es el "+dtoSendNotificator.getFechaFinalizacion()+"</p>"
	  		  		 + "<p>Por favor, entre en la aplicación REM y compruebe las condiciones del trabajo.</p>"
	  		  		 + "<p>Gracias.</p>";
			titulo = "Notificación de encargo de trabajo en REM (" + descripcionTrabajo + "Nº Trabajo "+tramite.getTrabajo().getNumTrabajo()+")";
		}
		
			  
		//genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpoCorreo(dtoSendNotificator, contenido));
		genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
	}

}