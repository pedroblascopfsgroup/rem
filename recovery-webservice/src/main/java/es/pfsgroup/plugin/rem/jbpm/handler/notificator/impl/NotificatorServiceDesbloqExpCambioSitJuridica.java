package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Component
public class NotificatorServiceDesbloqExpCambioSitJuridica extends AbstractNotificatorService implements NotificatorService {
	
	private static final String CODIGO_NONE = "NONE";


	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GestorExpedienteComercialManager gestorExpedienteComercialManager;

	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_NONE};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;
	
	protected static final Log logger = LogFactory.getLog(NotificatorServiceDesbloqExpCambioSitJuridica.class);

	@Override
	public void notificator(ActivoTramite tramite) {
		
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		
		ExpedienteComercial expediente = getExpedienteComercial(tramite);
		
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		
		if(!Checks.esNulo(expediente)) {
		
		    mailsPara = getEmailsToSend(expediente, expediente.getOferta());
			mailsCC.add(this.getCorreoFrom());
			
			String contenido = "";
			String titulo = "";
	
			String motivo = "Incumplimiento de condiciones jurídicas. Algún activo cambia su estado posesoria, el estado del título o la posesión";		
	
			contenido = "<p>El expediente "+expediente.getNumExpediente() +" se ha desbloqueado automáticamente por el motivo siguiente: "+motivo+".</p>";
			
			titulo = "Notificación REM: Desbloqueo del expediente comercial " + expediente.getNumExpediente();
			dtoSendNotificator.setTitulo(titulo);
	
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
			
			logger.debug("ENVIO NOTIFICACION: [TITULO " + titulo + " | CONTENIDO " + contenido + "| DESTINATARIOS " + mailsPara.toString() + " ]");
		}
	}
		
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {}
	

	private ExpedienteComercial getExpedienteComercial(ActivoTramite tramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(tramite.getId());

		if (activoTramite == null) {
			return null;
		}

		Trabajo trabajo = activoTramite.getTrabajo();

		if (trabajo == null) {
			return null;
		}

		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());

		if (expediente == null) {
			return null;
		}

		return expediente;
	}
	
	private List<String> getEmailsToSend(ExpedienteComercial expediente, Oferta oferta) {

		Activo activo = oferta.getActivoPrincipal();
		
		ActivoProveedor preescriptor= ofertaApi.getPreescriptor(oferta);
		ActivoProveedor mediador= activoApi.getMediador(activo);
		
		Usuario gestorComercial = null;
		if (!Checks.esNulo(oferta.getAgrupacion()) 
		        && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion())
		        && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {

			ActivoLoteComercial activoLoteComercial = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			gestorComercial = activoLoteComercial.getUsuarioGestorComercial();

		} else {
			// Activo
			gestorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
		}
		
		Usuario gestorFormalizacion = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GFORM");		
		Usuario gestoriaFormalizacion = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GIAFORM");



		List<String> mailsPara = new ArrayList<String>();

		if (preescriptor != null && !Checks.esNulo(preescriptor.getEmail())) {
			mailsPara.add(preescriptor.getEmail());
		}

		if (mediador != null && !Checks.esNulo(mediador.getEmail())) {
			mailsPara.add(mediador.getEmail());
		}
		
		if (gestorComercial != null && !Checks.esNulo(gestorComercial.getEmail())) {
			mailsPara.add(gestorComercial.getEmail());
		}
		
		if (gestorFormalizacion != null && !Checks.esNulo(gestorFormalizacion.getEmail())) {
			mailsPara.add(gestorFormalizacion.getEmail());
		}

		if (gestoriaFormalizacion != null && !Checks.esNulo(gestoriaFormalizacion.getEmail())) {
			mailsPara.add(gestoriaFormalizacion.getEmail());
		}
		
		
		return mailsPara;
	}
	
	public DtoSendNotificator rellenaDtoSendNotificator(ActivoTramite tramite){
		DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
		
		dtoSendNotificator.setNumActivo(tramite.getActivo().getNumActivo());
		dtoSendNotificator.setDireccion(this.generateDireccion(tramite.getActivo()));
		if(!Checks.esNulo(tramite.getTrabajo().getAgrupacion()))
			dtoSendNotificator.setNumAgrupacion(tramite.getTrabajo().getAgrupacion().getNumAgrupRem());
		
		return dtoSendNotificator;
	}

}
