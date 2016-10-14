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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Component
public class NotificatorServicePropuestaPreciosSancion extends AbstractNotificatorService implements NotificatorService {
	
	private static final String CODIGO_T009_SANCIO_CARGA_PROPUESTA = "T009_SancionCargaPropuesta";


	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T009_SANCIO_CARGA_PROPUESTA};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {
	
	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();

		String contenido = "";
		String titulo = "";
		String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion()) ? (tramite.getTrabajo().getDescripcion() + " - ") : "";
		
		
		if(!Checks.esNulo(tramite.getTrabajo().getSolicitante()) && !Checks.esNulo(tramite.getTrabajo().getSolicitante().getEmail()) 
				&& !tramite.getTrabajo().getSolicitante().equals(genericAdapter.getUsuarioLogado())) {

			contenido = "<p>Ha finalizado la tramitación del trámite de propuesta de precios iniciado por usted, que se inició como consecuencia de la petición formalizada.</p>";
			titulo = "Notificación de finalización de trámite de propuesta de precios (" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
	
			String correos = tramite.getTrabajo().getSolicitante().getEmail();
		    Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());
			
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
		
		String emailPropietario = activoTramiteApi.getValorTareasAnteriorByCampo(valores.get(0).getTareaExterna().getTokenIdBpm(),"emailPropietario");
		
		if(!Checks.esNulo(emailPropietario)) {
			
			String fechaTarea = activoTramiteApi.getTareaValorByNombre(valores,"fechaSancion");
			
			contenido = "<p>Los precios de los activos contenidos en la propuesta de precios sancionada por usted en fecha " + fechaTarea + " han sido actualizados correctamente.</p>";
			titulo = "Notificación de finalización de trámite de propuesta de precios (" + descripcionTrabajo + "Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
			
			mailsPara.removeAll(mailsPara);
			mailsCC.removeAll(mailsCC);
			
		    Collections.addAll(mailsPara, emailPropietario.split(";"));
			mailsCC.add(this.getCorreoFrom());
			
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}
	
}
