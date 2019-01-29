package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaCompradoresExpediente;
import es.pfsgroup.plugin.rem.model.VListadoActivosExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class NotificatorServiceGtam extends AbstractNotificatorService implements NotificatorService {

	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	private static final String NPLREO_SUPPORT = "NPLREOSupport";
	private static final String MAILTRACKER_SUPPORT = "MailTracker";

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	List<TareaExternaValor> valores = null;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { };
	}

	@SuppressWarnings("unchecked")
	@Override
	public void notificator(ActivoTramite tramite) {
		ExpedienteComercial expediente = getExpedienteComercial(tramite);
		Usuario gestor = null;
		Boolean enviar = false;
		if(tramite.getTareas() != null && tramite.getTareas().size() > 0){
			for (TareaActivo tareaActivo : tramite.getTareas()) {				
				if (CODIGO_T013_DEFINICION_OFERTA.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
					if(tareaActivo.getFechaFin()!= null){
						enviar = true;
					}
					gestor = tareaActivo.getUsuario();
				}
			}
		}
		
		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null
				&& DDCartera.CODIGO_CARTERA_GIANTS.equals(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo()) && enviar) {
			
			String gestorNombre = "SIN_DATOS_NOMBRE_APELLIDO_GESTOR";
			String gestorEmail = "SIN_DATOS_EMAIL_GESTOR";
			if (gestor != null && gestor.getApellidoNombre() != null ) {
				gestorNombre = gestor.getApellidoNombre();
			}
			if (gestor != null && gestor.getEmail() != null ) {
				gestorEmail = gestor.getEmail();
			}
			
			Usuario nPLREOSupport = genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "username", NPLREO_SUPPORT));
			Usuario mailTracker = genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "username", MAILTRACKER_SUPPORT));
			String titulo = "La Oferta #numoferta ha sido TRAMITADA";
			String contenido = "<p> Le informamos que la citada propuesta ha sido TRAMITADA.</p>";
			
			
			DtoPage dto = expedienteComercialApi.getActivosExpedienteVista(expediente.getId());
			
			if(dto != null && dto.results.size() > 0){
				contenido += "<p><b>Activos de la oferta</b></p>";
				List<VListadoActivosExpediente> activos = (List<VListadoActivosExpediente>)dto.results;
				for (VListadoActivosExpediente activoOferta : activos) {
					contenido += "<p>Activo: " + activoOferta.getNumActivo()
							+ ", Tipo : " + activoOferta.getTipoActivo() 
							+ ", Municipio : " + activoOferta.getMunicipio()
							+ ", Direcci&oacute;n : " + activoOferta.getDireccion()
							+ ", &Iacute;mporte participaci&oacute;n : " + activoOferta.getImporteParticipacion()+ "euros"
							+ ", Precio m&iacute;nimo autorizado : " + activoOferta.getPrecioMinimo()+ "euros"
							+"</p>";
				}
			}

			WebDto dtopage = new WebDto();
			dtopage.setLimit(100);
			 Page pagina = expedienteComercialApi.getCompradoresByExpediente(expediente.getId(), dtopage);
			 List<VBusquedaCompradoresExpediente> compradores = (List<VBusquedaCompradoresExpediente>) pagina.getResults();
			 
			 if(compradores != null && compradores.size() > 0){
				 contenido += "<p><b>Compradores</b></p>";
				 for (VBusquedaCompradoresExpediente comprador : compradores) {
					 contenido += "<p>Nombre o raz&oacute;n social: " + comprador.getNombreComprador()
						+ ", Documento : " + comprador.getNumDocumentoComprador() 
						+ ", % compra : " + comprador.getPorcentajeCompra()
						+"</p>";
					 
				 }
			 }
			

			CondicionanteExpediente condiciones = expediente.getCondicionante();

			if (condiciones != null) {
				if (condiciones.getTipoImpuesto() != null && condiciones.getTipoAplicable() != null) {
					contenido += "<p><b>Condiciones fiscales</b></p>";
					contenido += "<p>Tipo de impuesto: " + condiciones.getTipoImpuesto().getDescripcion()
							+ ", Tipo aplicable: " + condiciones.getTipoAplicable().toString() +"</p>";
				}
			}

			contenido += "<p> Quedamos a su disposición para cualquier consulta o aclaración.</p>"
					+ "<p> Saludos cordiales.</p>" + "<p> Fdo: #gestorTarea </p>" + "<p> Email: #mailGestorTarea </p>";
			
			contenido = contenido.replace("#gestorTarea", gestorNombre)
					 .replace("#mailGestorTarea", gestorEmail);

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			mailsCC.add(this.getCorreoFrom());

			List<Usuario> usuarios = new ArrayList<Usuario>();
			if (!Checks.esNulo(nPLREOSupport)) {
				usuarios.add(nPLREOSupport);
			}
			if (!Checks.esNulo(mailTracker)) {
				usuarios.add(mailTracker);
			}

			mailsPara = getEmailsNotificacion(usuarios);

			titulo = titulo.replace("#numoferta", expediente.getOferta().getNumOferta().toString());
			dtoSendNotificator.setTitulo(titulo);
			dtoSendNotificator.setNumTrabajo(null);

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}

	}

	private List<String> getEmailsNotificacion(List<Usuario> usuarios) {
		List<String> mailsPara = new ArrayList<String>();
		for (Usuario usuario : usuarios) {
			if (usuario != null && !Checks.esNulo(usuario.getEmail())) {
				mailsPara.add(usuario.getEmail());
			}
		}
		return mailsPara;
	}

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

	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		this.valores = valores;
		this.notificator(tramite);

	}

}
