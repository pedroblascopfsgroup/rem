package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorSustituto;
import es.pfsgroup.plugin.rem.model.GrupoUsuario;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCanalPrescripcion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.model.DestinatariosRest;
import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;
import es.pfsgroup.plugin.rem.utils.FileItemUtils;

public abstract class NotificatorServiceSancionOfertaGenerico extends AbstractNotificatorService
		implements NotificatorService {

	private static final String STR_MISSING_VALUE = "---";
	private final Log logger = LogFactory.getLog(getClass());
	SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");

	private static final String GESTOR_PRESCRIPTOR = "prescriptor";
	private static final String GESTOR_MEDIADOR = "mediador";
	private static final String GESTOR_COMERCIAL_ACTIVO = "gestor-comercial-activo";
	private static final String GESTOR_COMERCIAL_ACTIVO_SUS = "gestor-comercial-activo-sustituto";
	private static final String GESTOR_COMERCIAL_LOTE_RESTRINGIDO = "gestor-comercial-lote-restringido";
	private static final String GESTOR_COMERCIAL_LOTE_COMERCIAL = "gestor-comercial-lote-comercial";
	private static final String GESTOR_COMERCIAL_LOTE_COMERCIAL_SUS = "gestor-comercial-lote-comercial-sustituto";
	private static final String GESTOR_FORMALIZACION = "gestor-formalizacion";
	private static final String GESTOR_FORMALIZACION_SUS = "gestor-formalizacion-sustituto";
	private static final String SUPERVISOR_COMERCIAL = "supervisor-comercial";
	private static final String GESTOR_GESTORIA_FASE_3 = "gestoria-fase-3";
	private static final String GESTOR_GESTORIA_FASE_3_SUS = "gestoria-fase-3-sustituto";
	private static final String USUARIO_FICTICIO_OFERTA_CAJAMAR = "ficticioOfertaCajamar";
	private static final String SUPERVISOR_BACKOFFICE_LIBERBANK = "supervisor-backoffice-liberbank";
	private static final String GESTOR_BACKOFFICE_SUS = "gestor-backoffice-sustituto";
	private static final String GESTOR_BACKOFFICE = "gestor-backoffice";
	private static final String GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO = "gestor-comercial-backoffice-inmobiliario";
	private static final String GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_SUS = "gestor-comercial-backoffice-inmobiliario-sustituto";
	private static final String SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO = "supervisor-comercial-backoffice-inmobiliario";
	private static final String SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_SUS = "supervisor-comercial-backoffice-inmobiliario-sustituto";
	
	//Variables de buzones	
	private static final String BUZON_REM = "buzonrem";
	private static final String BUZON_RESERVA_HAYA = "reservashaya";
	public static final String BUZON_PFS = "buzonpfs";
	private static final String BUZON_FDV = "buzonfdv";
	private static final String BUZON_OFR_APPLE = "buzonofrapple";
	private static final String BUZON_FOR_APPLE = "buzonforapple";
	private static final String BUZON_CES_APPLE = "buzoncesapple";
	private static final String BUZON_BOARDING = "buzonboarding";
	private static final String BUZON_OFR_SAREB = "buzonofrsareb";
	private static final String BUZON_OFR_JAGUAR = "buzonofrjaguar";
	
	//Variables de tareas
	private static final String CODIGO_T017_ANALISIS_PM = "T017_AnalisisPM";
	private static final String CODIGO_T017_RESOLUCION_CES = "T017_ResolucionCES";
	private static final String CODIGO_T017_ADVISORY_NOTE = "T017_AdvisoryNote";
	private static final String CODIGO_T017_RECOMENDACION_CES = "T017_RecomendCES";
	private static final String CODIGO_T017_RESOLUCION_PRO_MANZANA = "T017_ResolucionPROManzana";

	private static final String MENSAJE_BC = "Para el Número del inmueble BC: ";
	private static final String CODIGO_TRAMITE_T017 = "T017";
	@Resource
	private Properties appProperties;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private UsuarioRemApi usuarioRemApiImpl;
	
	@Override
	public final void notificator(ActivoTramite tramite) {

	}
	//genera notificacion llegada
	public void generaNotificacionLlegadaDesdeUpdater(ActivoTramite tramite, boolean correoLlegadaTarea, String codTareaActual) {
		generaNotificacion(tramite, false, false, correoLlegadaTarea, codTareaActual);
	}

	protected void generaNotificacion(ActivoTramite tramite, boolean permiteRechazar,
			boolean permiteNotificarAprobacion, boolean correoLlegadaTarea, String codTareaActual) {

		ExpedienteComercial eco = getExpComercial(tramite);
		Oferta oferta =null;
		if(eco != null) {
			oferta = eco.getOferta();
		}
		
		if (tramite.getActivo() != null && tramite.getTrabajo() != null && oferta != null) {
			sendNotification(tramite, permiteRechazar,oferta, permiteNotificarAprobacion, correoLlegadaTarea, codTareaActual);
		}

	}
	
	protected void generaNotificacionReserva(ActivoTramite tramite, Date fechaFirma) {

		if (tramite != null && tramite.getActivo() != null && tramite.getTrabajo() != null) {
			sendNotificationReserva(tramite, getExpComercial(tramite), fechaFirma);
		}

	}

	private ExpedienteComercial getExpComercial(ActivoTramite tramite) {

		if (tramite == null) {
			return null;
		}

		Trabajo trabajo = tramite.getTrabajo();

		if (trabajo == null) {
			return null;
		}

		return expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
	}

	public void sendNotification(ActivoTramite tramite, boolean permiteRechazar, Oferta oferta,
			boolean permiteNotificarAprobacion, boolean correoLlegadaTarea, String codTareaActual) {

		ArrayList<String> destinatarios = new ArrayList<String>();

		Usuario buzonRem = usuarioManager.getByUsername(BUZON_REM);
		Usuario buzonPfs = usuarioManager.getByUsername(BUZON_PFS);
		Usuario buzonfdv = usuarioManager.getByUsername(BUZON_FDV);
		Usuario buzonOfertaApple = usuarioManager.getByUsername(BUZON_OFR_APPLE);
		Usuario buzonFormApple = usuarioManager.getByUsername(BUZON_FOR_APPLE);
		Usuario buzonBoarding = usuarioManager.getByUsername(BUZON_BOARDING);
		Usuario buzonOfertaSareb = usuarioManager.getByUsername(BUZON_OFR_SAREB);
		Usuario buzonOfertaJaguar = usuarioManager.getByUsername(BUZON_OFR_JAGUAR);
		Usuario usuarioBackOffice = null;
		Usuario supervisorComercial = null;
		ActivoProveedor proveedor = oferta.getPrescriptor();
		String codProveedor = null;
		Usuario gestorBackoffice = null;
		Usuario supervisorBackOffice = null;
		Usuario gestorForm = null;
		Usuario supervisorFormalizacion = null;
		Usuario gestor = null;
		ActivoProveedor preescriptor= null;

		
		if (!Checks.esNulo(oferta)) {
			ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdOferta(oferta.getId());
			Activo activo = oferta.getActivoPrincipal();
			
			if (permiteNotificarAprobacion && !Checks.esNulo(expediente)
					&& (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA.equals(expediente.getEstado().getCodigo())
							|| (oferta.getOfertaExpress() && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())))) { // APROBACIÓN
				destinatarios = getDestinatariosNotificacion(activo, oferta, expediente);
				
				if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {
					Usuario usuarioFicticioCajamar = usuarioManager.getByUsername(USUARIO_FICTICIO_OFERTA_CAJAMAR);
					if (usuarioFicticioCajamar != null && usuarioFicticioCajamar.getEmail() != null) {
						destinatarios.add(usuarioFicticioCajamar.getEmail());
					}

					if (oferta.getPrescriptor() != null && oferta.getPrescriptor().getEmail() != null) {
						destinatarios.add(oferta.getPrescriptor().getEmail());
					}
				}else if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getSubcartera()) 
						&& (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
							|| DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()))) {
					if (oferta.getPrescriptor() != null && oferta.getPrescriptor().getEmail() != null) {
						destinatarios.add(oferta.getPrescriptor().getEmail());
					}
				}

				if (!Checks.esNulo(buzonRem)) {
					destinatarios.add(buzonRem.getEmail());
				}
				if (!Checks.esNulo(buzonPfs)) {
					destinatarios.add(buzonPfs.getEmail());
				}
				
				if(!Checks.esNulo(proveedor)) {					
					codProveedor = Checks.esNulo(proveedor.getTipoProveedor()) ? null : proveedor.getTipoProveedor().getCodigo();
					if(DDCartera.CODIGO_CARTERA_HYT.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
							&& !Checks.esNulo(proveedor.getEmail()) 
							&& !destinatarios.contains(proveedor.getEmail())){
							destinatarios.add(proveedor.getEmail());
						}
					}
				
				if(DDCartera.CODIGO_CARTERA_HYT.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
						&& !Checks.esNulo(oferta.getCustodio()) 
						&& !Checks.esNulo(oferta.getCustodio().getEmail())
						&& !destinatarios.contains(oferta.getCustodio().getEmail())){
					destinatarios.add(oferta.getCustodio().getEmail());
					}				
				
				if (!Checks.esNulo(buzonfdv) && (DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA.equals(codProveedor) || DDTipoProveedor.COD_CAT.equals(codProveedor))) {
					destinatarios.add(buzonfdv.getEmail());
				}
				if(!Checks.esNulo(buzonOfertaApple) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
					destinatarios.add(buzonOfertaApple.getEmail());
				}
				if(!Checks.esNulo(buzonOfertaJaguar) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()))) {
					destinatarios.add(buzonOfertaJaguar.getEmail());
				}
				if(!Checks.esNulo(buzonFormApple) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
					destinatarios.add(buzonFormApple.getEmail());
				}
				if(!Checks.esNulo(buzonOfertaSareb)&& (!Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo()))) {
					destinatarios.add(buzonOfertaSareb.getEmail());
				}

				if(oferta.getActivoPrincipal() != null){
					usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
					if(!Checks.esNulo(usuarioBackOffice)){
						destinatarios.add(usuarioBackOffice.getEmail());
					}	
					if(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
							|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())){
						preescriptor= ofertaApi.getPreescriptor(oferta);
						gestorBackoffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
						supervisorBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
						gestorForm = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
						supervisorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
						gestor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);

						if(!Checks.esNulo(gestorBackoffice) && !Checks.esNulo(gestorBackoffice.getEmail())){
							destinatarios.add(gestorBackoffice.getEmail());
						}

						if(!Checks.esNulo(supervisorBackOffice) && !Checks.esNulo(supervisorBackOffice.getEmail())){
							destinatarios.add(supervisorBackOffice.getEmail());
						}

						if(!Checks.esNulo(gestorForm) && !Checks.esNulo(gestorForm.getEmail())){
							destinatarios.add(gestorForm.getEmail());
						}

						if(!Checks.esNulo(supervisorFormalizacion) && !Checks.esNulo(supervisorFormalizacion.getEmail())){
							destinatarios.add(supervisorFormalizacion.getEmail());
						}

						if(!Checks.esNulo(gestor) && !Checks.esNulo(gestor.getEmail())){
							destinatarios.add(gestor.getEmail());
						}

						if(!Checks.esNulo(preescriptor) && !Checks.esNulo(preescriptor.getEmail())){
							destinatarios.add(preescriptor.getEmail());
						}

					}
				}
				
				supervisorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
				
				if(!Checks.esNulo(supervisorComercial)) {
					destinatarios.add(supervisorComercial.getEmail());
				}
				
				if(DDCartera.CODIGO_CARTERA_TANGO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_HYT.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_ZEUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_CAJAMAR.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_JAGUAR.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
					this.enviaSegundaNotificacionAceptar(tramite, oferta, expediente, destinatarios.toArray(new String[] {}));
					destinatarios.clear();
					if(!Checks.esNulo(buzonBoarding)){
						destinatarios.add(buzonBoarding.getEmail());
					}
				}

				this.enviaNotificacionAceptar(tramite, oferta, expediente, destinatarios.toArray(new String[] {}));
				
			} else if (permiteRechazar
					&& DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) { // RECHAZO
				String prescriptor = getPrescriptor(activo, oferta);
				String gestorComercial = getGestorComercial(activo, oferta);
				Usuario gestorBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
				if (!Checks.esNulo(prescriptor)) {
					destinatarios.add(prescriptor);
				}
				
				if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getSubcartera()) && 
					(!DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
					|| !DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()))) {
					String gestorFormalizacion = null;
					if (ofertaApi.checkReserva(oferta)) {
						gestorFormalizacion = getGestorFormalizacion(activo, oferta, expediente);
					}

					if (!Checks.esNulo(gestorFormalizacion)) {
						destinatarios.add(gestorFormalizacion);
					}
				}	
				
				if (!Checks.esNulo(gestorComercial)) {
					destinatarios.add(gestorComercial);
				}
				
				if(!Checks.esNulo(gestorBackOffice) && !Checks.esNulo(gestorBackOffice.getEmail())) {
					destinatarios.add(gestorBackOffice.getEmail());
				}

				if (!Checks.esNulo(buzonRem)) {
					destinatarios.add(buzonRem.getEmail());
				}
				if (!Checks.esNulo(buzonPfs)) {
					destinatarios.add(buzonPfs.getEmail());
				}
				if(!Checks.esNulo(buzonOfertaApple) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
					destinatarios.add(buzonOfertaApple.getEmail());
				}
				if(!Checks.esNulo(buzonOfertaJaguar) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()))) {
					destinatarios.add(buzonOfertaJaguar.getEmail());
				}

				if(oferta.getActivoPrincipal() != null){
					if(DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
							|| DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
							|| DDCartera.CODIGO_CARTERA_GIANTS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
							|| DDCartera.CODIGO_CARTERA_TANGO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
							|| DDCartera.CODIGO_CARTERA_GALEON.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
							|| DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
							|| DDCartera.CODIGO_CARTERA_EGEO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
							|| DDCartera.CODIGO_CARTERA_HYT.equals(oferta.getActivoPrincipal().getCartera().getCodigo())){
						usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
						if(!Checks.esNulo(usuarioBackOffice)){
							destinatarios.add(usuarioBackOffice.getEmail());
						}	
					}

					if(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
							|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())){
						supervisorBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
						gestorForm = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
						supervisorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
						supervisorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);

						if(!Checks.esNulo(supervisorBackOffice) && !Checks.esNulo(supervisorBackOffice.getEmail())){
							destinatarios.add(supervisorBackOffice.getEmail());
						}

						if(!Checks.esNulo(gestorForm) && !Checks.esNulo(gestorForm.getEmail())){
							destinatarios.add(gestorForm.getEmail());
						}

						if(!Checks.esNulo(supervisorFormalizacion) && !Checks.esNulo(supervisorFormalizacion.getEmail())){
							destinatarios.add(supervisorFormalizacion.getEmail());
						}

						if(!Checks.esNulo(supervisorComercial) && !Checks.esNulo(supervisorComercial.getEmail())){
							destinatarios.add(supervisorComercial.getEmail());
						}
					}
				}

				this.enviaNotificacionRechazar(tramite, activo, oferta, destinatarios.toArray(new String[] {}));
			}
			
			//Si se pide notificacion de entrada a la siguiente tarea, se monta en el siguiente método
			if(!Checks.esNulo(correoLlegadaTarea) && correoLlegadaTarea && !Checks.esNulo(codTareaActual)) {
				enviaNotificacionLlegadaTarea(tramite, codTareaActual, activo, oferta);
			}
		}
	}
	
	private void sendNotificationReserva(ActivoTramite tramite, ExpedienteComercial expediente, Date fechaFirma) {		
		String asunto = null, cuerpo = null;
		
		Oferta oferta = expediente.getOferta();

		Activo activo = oferta.getActivoPrincipal();
		
		ArrayList<String> destinatarios = getDestinatariosNotificacion(oferta.getActivoPrincipal(), oferta, expediente);
		
		Usuario buzonRem = usuarioManager.getByUsername(BUZON_REM);
		Usuario buzonPfs = usuarioManager.getByUsername(BUZON_PFS);
		Usuario buzonReservaHaya = usuarioManager.getByUsername(BUZON_RESERVA_HAYA);
		Usuario buzonOfertaApple = null;
		Usuario buzonOfertaJaguar = null;
		ActivoProveedor preescriptor= null;
		Usuario gestorBackoffice = null;
		Usuario supervisorBackOffice = null;
		Usuario gestorForm = null;
		Usuario supervisorFormalizacion = null;
		Usuario gestor = null;
		Usuario supervisorComercial = null;

		if(activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_APPLE_INMOBILIARIO)) {
			buzonOfertaApple = usuarioManager.getByUsername(BUZON_OFR_APPLE);
		}
		if(activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_JAGUAR)) {
			buzonOfertaJaguar = usuarioManager.getByUsername(BUZON_OFR_JAGUAR);
		}
		
		asunto = "Notificación de reserva de la oferta " + oferta.getNumOferta();
		
		cuerpo = "La oferta " + oferta.getNumOferta() + " ha sido reservada a fecha de " + formato.format(fechaFirma);
		
		cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);
		
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(oferta,tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		
		if (!Checks.esNulo(buzonRem) && (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo()) 
				|| DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo()))) {
			destinatarios.add(buzonRem.getEmail());
		}
		if (buzonReservaHaya != null && !DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo()) 
				&& !DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo())
				&& !DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo())) {
			destinatarios.add(buzonReservaHaya.getEmail());
		}
		
		if (!Checks.esNulo(buzonPfs)) {
			destinatarios.add(buzonPfs.getEmail());
		}
		if(buzonOfertaApple != null) {
			destinatarios.add(buzonOfertaApple.getEmail());
		}
		if(buzonOfertaJaguar != null) {
			destinatarios.add(buzonOfertaJaguar.getEmail());
		}

		if(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
				|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())){
			preescriptor = ofertaApi.getPreescriptor(oferta);
			gestorBackoffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			supervisorBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			gestorForm = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			supervisorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			gestor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			supervisorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);

			if(!Checks.esNulo(gestorBackoffice) && !Checks.esNulo(gestorBackoffice.getEmail())){
				destinatarios.add(gestorBackoffice.getEmail());
			}

			if(!Checks.esNulo(supervisorBackOffice) && !Checks.esNulo(supervisorBackOffice.getEmail())){
				destinatarios.add(supervisorBackOffice.getEmail());
			}

			if(!Checks.esNulo(gestorForm) && !Checks.esNulo(gestorForm.getEmail())){
				destinatarios.add(gestorForm.getEmail());
			}

			if(!Checks.esNulo(supervisorFormalizacion) && !Checks.esNulo(supervisorFormalizacion.getEmail())){
				destinatarios.add(supervisorFormalizacion.getEmail());
			}

			if(!Checks.esNulo(gestor) && !Checks.esNulo(gestor.getEmail())){
				destinatarios.add(gestor.getEmail());
			}

			if(!Checks.esNulo(supervisorComercial) && !Checks.esNulo(supervisorComercial.getEmail())){
				destinatarios.add(supervisorComercial.getEmail());
			}

			if(!Checks.esNulo(preescriptor) && !Checks.esNulo(preescriptor.getEmail())){
				destinatarios.add(preescriptor.getEmail());
			}
		}

		enviaNotificacionGenerico(tramite.getActivo(), asunto, cuerpoCorreo, false, oferta, destinatarios.toArray(new String[] {}));
	}

	protected void generaNotificacionSinTramite(Long idOferta) {

		Oferta oferta = ofertaApi.getOfertaById(idOferta);
		Activo activo = oferta.getActivoPrincipal();

		// ya que se trata de una notificacion sin tramite simulamos uno para
		// cumplir con la definicion de los metodos comunes
		// ya que la idea es que se genere exactamente la misma notificacion
		// como si viniera de un tramite
		ActivoTramite tramiteSimulado = new ActivoTramite();
		tramiteSimulado.setActivo(activo);
		
		sendNotification(tramiteSimulado, true, oferta, true, false, null);
	}

	private String getPrescriptor(Activo activo, Oferta ofertaAceptada) {
		Map<String, String> gestores = getGestores(activo, ofertaAceptada, null, null, GESTOR_PRESCRIPTOR);
		return gestores.get(GESTOR_PRESCRIPTOR);
	}

	private String getGestorComercial(Activo activo, Oferta ofertaAceptada) {
		String comercial = getTipoGestorComercial(ofertaAceptada);
		if (!Checks.esNulo(ofertaAceptada.getAgrupacion())) {
			ActivoLoteComercial activoLoteComercial = genericDao.get(ActivoLoteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "id", ofertaAceptada.getAgrupacion().getId()));
			Map<String, String> gestores = getGestores(activo, ofertaAceptada, activoLoteComercial, null, comercial);
			return gestores.get(comercial);
		} else if (Checks.esNulo(ofertaAceptada.getAgrupacion()) && GESTOR_COMERCIAL_ACTIVO.equals(comercial)) {
			Map<String, String> gestores = getGestores(activo, ofertaAceptada, null, null, comercial);
			return gestores.get(comercial);
		}
		return null;

	}

	private String getGestorFormalizacion(Activo activo, Oferta ofertaAceptada, ExpedienteComercial expediente) {
		Map<String, String> gestores = getGestores(activo, ofertaAceptada, null, expediente, GESTOR_FORMALIZACION);
		return gestores.get(GESTOR_FORMALIZACION);
	}

	private String[] getGestoresANotificar(Activo activo, Oferta ofertaAceptada) {
		boolean formalizacion = checkFormalizar(activo.getId());
		ArrayList<String> clavesGestores = new ArrayList<String>();
		String claveGestorComercial = this.getTipoGestorComercial(ofertaAceptada);

		// DESTINATARIOS SI ES SAREB, BANKIA o TANGO o GIANTS o LIBERBANK
		if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)
				|| activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)
				|| activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_TANGO)
				|| activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)
				|| activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_GIANTS)
				|| activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)) {

			clavesGestores.addAll(Arrays.asList(GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial,
					GESTOR_COMERCIAL_ACTIVO_SUS));

			if (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())) {
				clavesGestores.addAll(
						Arrays.asList(GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, SUPERVISOR_BACKOFFICE_LIBERBANK));
			}

			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo())) {
				clavesGestores.addAll(Arrays.asList(GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_SUS));
			}
			if(DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo())) {
				clavesGestores.addAll(Arrays.asList(SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_SUS));
			}

			if (formalizacion) {
				clavesGestores.addAll(Arrays.asList(GESTOR_FORMALIZACION, GESTOR_FORMALIZACION_SUS));
				clavesGestores.addAll(Arrays.asList(GESTOR_GESTORIA_FASE_3, GESTOR_GESTORIA_FASE_3_SUS));
			}

			// DESTINATARIOS SI ES CAJAMAR
		} else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
			clavesGestores.addAll(Arrays.asList(GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial,
					GESTOR_BACKOFFICE, GESTOR_COMERCIAL_ACTIVO_SUS, GESTOR_BACKOFFICE_SUS,
					GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_SUS));
			if (formalizacion) {
				clavesGestores.addAll(Arrays.asList(GESTOR_FORMALIZACION, GESTOR_FORMALIZACION_SUS));
				clavesGestores.addAll(Arrays.asList(GESTOR_GESTORIA_FASE_3, GESTOR_GESTORIA_FASE_3_SUS));
			}
		} else if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getSubcartera()) 
				&& ( DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
				|| DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()))) {
			clavesGestores.addAll(Arrays.asList(claveGestorComercial, GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, GESTOR_GESTORIA_FASE_3));
		}
		clavesGestores.add(GESTOR_FORMALIZACION);
		if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getSubcartera()) 
			&& (!DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
			|| !DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()))) {
			clavesGestores.add(SUPERVISOR_COMERCIAL);
		
		} else if (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()) 
					|| DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()) ) {
			clavesGestores.addAll(Arrays.asList(GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO));
		}

		clavesGestores.addAll(Arrays.asList(GESTOR_FORMALIZACION));
		clavesGestores.add(SUPERVISOR_COMERCIAL);

		return clavesGestores.toArray(new String[] {});
	}

	private ArrayList<String> getDestinatariosNotificacion(Activo activo, Oferta ofertaAceptada,
			ExpedienteComercial expediente) {
		String[] clavesGestores = getGestoresANotificar(activo, ofertaAceptada);
		Map<String, String> gestores = getGestores(activo, ofertaAceptada, this.getLoteComercial(ofertaAceptada),
				expediente, clavesGestores);
		ArrayList<String> destinatarios = new ArrayList<String>();
		for (String clave : clavesGestores) {
			String value = gestores.get(clave);
			if ((value != null) && (!destinatarios.contains(value))) {
				destinatarios.add(value);
			}
		}
		return destinatarios;
	}

	private ActivoLoteComercial getLoteComercial(Oferta oferta) {
		if ((oferta != null) && (oferta.getAgrupacion() != null)) {
			return genericDao.get(ActivoLoteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
		} else {
			return null;
		}
	}

	private String getTipoGestorComercial(Oferta oferta) {
		if (oferta != null) {
			if (Checks.esNulo(oferta.getAgrupacion())) {
				return GESTOR_COMERCIAL_ACTIVO;
			} else {
				DDTipoAgrupacion tipo = oferta.getAgrupacion().getTipoAgrupacion();
				if (tipo == null) {
					throw new IllegalStateException(
							"La agrupación no tiene tipo [" + oferta.getAgrupacion().getClass().getSimpleName()
									+ ", id=" + oferta.getAgrupacion().getId() + "]");
				}
				if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(tipo.getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(tipo.getCodigo()) 
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(tipo.getCodigo())) {
					return GESTOR_COMERCIAL_LOTE_RESTRINGIDO;
				} else if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(tipo.getCodigo())) {
					return GESTOR_COMERCIAL_LOTE_COMERCIAL;
				} else {
					return null;
				}
			}
		} else {
			return null;
		}
	}

	private boolean checkFormalizar(Long id) {
		if (id == null) {
			throw new IllegalArgumentException("'id' no puede ser NULL");
		}

		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(id);
		if (perimetro != null) {
			Integer check = perimetro.getAplicaFormalizar();
			return (check != null) && (check == 1);
		} else {
			return false;
		}
	}

	private Map<String, String> getGestores(Activo activo, Oferta oferta, ActivoLoteComercial loteComercial,
			ExpedienteComercial expediente, String... filtroGestores) {
		String[] claves = filtroGestores != null ? filtroGestores
				: new String[] { GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, GESTOR_COMERCIAL_ACTIVO,
						GESTOR_COMERCIAL_LOTE_RESTRINGIDO, GESTOR_COMERCIAL_LOTE_COMERCIAL, GESTOR_FORMALIZACION,
						GESTOR_BACKOFFICE, GESTOR_GESTORIA_FASE_3, SUPERVISOR_COMERCIAL };

		HashMap<String, String> gestores = new HashMap<String, String>();

		for (String s : claves) {
			if (GESTOR_PRESCRIPTOR.equals(s)) {
				ActivoProveedor prescriptor = ofertaApi.getPreescriptor(oferta);
				if (!Checks.esNulo(prescriptor)) {
					addMail(s, extractEmailProveedor(prescriptor), gestores);
				}
			} else if (GESTOR_MEDIADOR.equals(s)) {
				ActivoProveedor mediador = activoApi.getMediador(activo);
				if (!Checks.esNulo(mediador)) {
					addMail(s, extractEmailProveedor(mediador), gestores);
				}
			} else if (GESTOR_COMERCIAL_ACTIVO.equals(s) || GESTOR_COMERCIAL_LOTE_RESTRINGIDO.equals(s)) {
				Usuario gesComercial = gestorActivoApi.getGestorByActivoYTipo(activo, "GCOM");
				if (!Checks.esNulo(gesComercial)) {
					addMail(s, extractEmail(gesComercial), gestores);

					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id",
							gesComercial.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)) {
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)) {
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date())
										&& !Checks.esNulo(sgs.getFechaInicio())
										&& (sgs.getFechaInicio().before(new Date())
												|| sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_COMERCIAL_ACTIVO_SUS, extractEmail(sgs.getUsuarioGestorSustituto()),
											gestores);
								}
							}
						}
					}
				}

			} else if (GESTOR_COMERCIAL_LOTE_COMERCIAL.equals(s)) {
				Usuario gesLoteComercial = loteComercial.getUsuarioGestorComercial();
				if (!Checks.esNulo(gesLoteComercial)) {
					addMail(s, extractEmail(gesLoteComercial), gestores);

					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id",
							gesLoteComercial.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)) {
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)) {
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date())
										&& !Checks.esNulo(sgs.getFechaInicio())
										&& (sgs.getFechaInicio().before(new Date())
												|| sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_COMERCIAL_LOTE_COMERCIAL_SUS,
											extractEmail(sgs.getUsuarioGestorSustituto()), gestores);
								}
							}
						}
					}
				}

			} else if (GESTOR_FORMALIZACION.equals(s)) {
				Usuario gesFormalizacion = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente,
						"GFORM");
				if (!Checks.esNulo(gesFormalizacion)) {
					addMail(s, extractEmail(gesFormalizacion), gestores);

					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id",
							gesFormalizacion.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)) {
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)) {
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date())
										&& !Checks.esNulo(sgs.getFechaInicio())
										&& (sgs.getFechaInicio().before(new Date())
												|| sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_FORMALIZACION_SUS, extractEmail(sgs.getUsuarioGestorSustituto()),
											gestores);
								}
							}
						}
					}
				}

			} else if (GESTOR_BACKOFFICE.equals(s)) {
				Usuario gesBack = gestorActivoApi.getGestorByActivoYTipo(activo, "GBO");
				if (!Checks.esNulo(gesBack)) {
					addMail(s, gestores.put(s, extractEmail(gesBack)), gestores);

					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id",
							gesBack.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)) {
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)) {
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date())
										&& !Checks.esNulo(sgs.getFechaInicio())
										&& (sgs.getFechaInicio().before(new Date())
												|| sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_BACKOFFICE_SUS, extractEmail(sgs.getUsuarioGestorSustituto()),
											gestores);
								}
							}
						}
					}
				}

			} else if (GESTOR_GESTORIA_FASE_3.equals(s)) {
				Usuario gesGesFase = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente,
						"GIAFORM");
				if (!Checks.esNulo(gesGesFase)) {
					addMail(s, gestores.put(s, extractEmail(gesGesFase)), gestores);

					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id",
							gesGesFase.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)) {
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)) {
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date())
										&& !Checks.esNulo(sgs.getFechaInicio())
										&& (sgs.getFechaInicio().before(new Date())
												|| sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_GESTORIA_FASE_3_SUS, extractEmail(sgs.getUsuarioGestorSustituto()),
											gestores);
								}
							}
						}
					}
				}
			} else if (SUPERVISOR_BACKOFFICE_LIBERBANK.equals(s)) {
				Usuario supBackLiberbank = gestorActivoApi.getGestorByActivoYTipo(activo, "SBACKOFFICEINMLIBER");
				if (!Checks.esNulo(supBackLiberbank)) {
					addMail(s, gestores.put(s, extractEmail(supBackLiberbank)), gestores);
				}
			} else if (GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO.equals(s)) {
				Usuario gesBackInmobiliario = null;
				if (loteComercial == null || loteComercial.getUsuarioGestorComercialBackOffice() == null) {
					gesBackInmobiliario = gestorActivoApi.getGestorByActivoYTipo(activo, "HAYAGBOINM");
				} else {
					gesBackInmobiliario = loteComercial.getUsuarioGestorComercialBackOffice();
				}

				if (!Checks.esNulo(gesBackInmobiliario)) {
					addMail(s, gestores.put(s, extractEmail(gesBackInmobiliario)), gestores);
				}
				addMail(s, gestores.put(s, extractEmail(
						gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GIAFORM"))),
						gestores);
				
				Filter filterUsu = null;
				
				if(!Checks.esNulo(gesBackInmobiliario)) {
					filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id",
							gesBackInmobiliario.getId());
					
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)) {
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)) {
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date())
										&& !Checks.esNulo(sgs.getFechaInicio())
										&& (sgs.getFechaInicio().before(new Date())
												|| sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_SUS, extractEmail(sgs.getUsuarioGestorSustituto()),
											gestores);
								}
							}
						}
					}
				}
			} else if (SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO.equals(s)) {
				Usuario gesBackInmobiliario = null;
				if (loteComercial == null || loteComercial.getUsuarioGestorComercialBackOffice() == null) {
					gesBackInmobiliario = gestorActivoApi.getGestorByActivoYTipo(activo, "HAYASBOINM");
				} else {
					gesBackInmobiliario = loteComercial.getUsuarioGestorComercialBackOffice();
				}

				if (!Checks.esNulo(gesBackInmobiliario)) {
					addMail(s, gestores.put(s, extractEmail(gesBackInmobiliario)), gestores);
				}
			
				Filter filterUsu = null;
				
				if(!Checks.esNulo(gesBackInmobiliario)) {
					filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id",
							gesBackInmobiliario.getId());
					
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)) {
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)) {
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date())
										&& !Checks.esNulo(sgs.getFechaInicio())
										&& (sgs.getFechaInicio().before(new Date())
												|| sgs.getFechaInicio().equals(new Date()))) {
									addMail(SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_SUS, extractEmail(sgs.getUsuarioGestorSustituto()),
											gestores);
								}
							}
						}
					}
				}
			} else if (SUPERVISOR_COMERCIAL.equals(s)) {
				Usuario sComercial = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente,
						"SCOM");
				if (sComercial != null) {
					addMail(s, gestores.put(s, extractEmail(sComercial)), gestores);
				}
			}
		}

		return gestores;
	}

	private void addMail(String key, String email, HashMap<String, String> coleccion) {
		if (email != null && !email.isEmpty()) {
			coleccion.put(key, email);
		}
	}

	private String extractEmail(Usuario u) {
		String eMail = null;
		if (u != null) {
			if (u.getEmail() != null && !u.getEmail().isEmpty()) {
				eMail = u.getEmail();
			}
		}
		return eMail;
	}

	private String extractEmailProveedor(ActivoProveedor activoProveedor) {
		String eMail = null;
		if (activoProveedor != null) {
			if (activoProveedor.getEmail() != null && !activoProveedor.getEmail().isEmpty()) {
				eMail = activoProveedor.getEmail();
			}
		}
		return eMail;
	}

	private void enviaNotificacionAceptar(ActivoTramite tramite, Oferta oferta, ExpedienteComercial expediente,
			String... destinatarios) {
		try {
			boolean tieneReserva = false;
			boolean adjuntarInstrucciones = false;
			String codigoCartera = "";
			String numOferta = STR_MISSING_VALUE;
			if(oferta != null){
				numOferta = oferta.getNumOferta().toString();
			}
			if (tramite != null && !Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getCartera())) {
				codigoCartera = tramite.getActivo().getCartera().getCodigo();
			} else if(oferta != null && oferta.getActivoPrincipal() != null){
				codigoCartera = oferta.getActivoPrincipal().getCartera().getCodigo();
			}
			String asunto = "Notificación de aprobación provisional de la oferta " + numOferta;
			String cuerpo = "<p>Nos complace comunicarle que la oferta " + numOferta + " a nombre de "
					+ this.nombresOfertantes(expediente) + " ha sido PROVISIONALMENTE ACEPTADA";

			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
				cuerpo = cuerpo + " hasta la formalización de las arras/reserva";
			}
			
			if (!DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera)) {
				cuerpo = cuerpo
						+ ". Adjunto a este correo encontrará el documento con las instrucciones a seguir para la reserva y formalización";
			}

			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera)) {
				cuerpo = cuerpo + ", así como la Ficha cliente a cumplimentar</p>";
			} else {
				cuerpo = cuerpo + ".</p>";
			}
			
			ActivoBancario activoBancario = null;
			ActivoPropietarioActivo activoPropietario = null;
			ActivoPropietario propietario = null;
			if(oferta != null && oferta.getActivoPrincipal() != null){
				activoBancario = genericDao.get(ActivoBancario.class,
						genericDao.createFilter(FilterType.EQUALS, "activo.id",  oferta.getActivoPrincipal().getId()));
				Filter filterProp = genericDao.createFilter(FilterType.EQUALS, "activo.id",
						oferta.getActivoPrincipal().getId());
				activoPropietario = genericDao.get(ActivoPropietarioActivo.class, filterProp);
				if (activoPropietario != null) {
					propietario = activoPropietario.getPropietario();
				}
			}
			
			if (expediente != null && !Checks.esNulo(expediente.getId()) && !Checks.esNulo(expediente.getReserva())
					&& !Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())
					&& !DDClaseActivoBancario.CODIGO_FINANCIERO.equals(activoBancario.getClaseActivo().getCodigo())) {
				tieneReserva = true;
				String reservationKey = "";
				if (!Checks.esNulo(appProperties.getProperty("haya.reservation.pwd"))) {
					reservationKey = String.valueOf(expediente.getId())
							.concat(appProperties.getProperty("haya.reservation.pwd"));
					reservationKey = this.computeKey(reservationKey);
				}
				String reservationUrl = "";
				if (!Checks.esNulo(appProperties.getProperty("haya.reservation.url"))) {
					reservationUrl = appProperties.getProperty("haya.reservation.url");
				}
				
				
				if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera)) {
					if (propietario != null
							&& !ActivoPropietario.CODIGO_FONDOS_TITULIZACION.equals(propietario.getCodigo())
							&& !ActivoPropietario.CODIGO_GIVP.equals(propietario.getCodigo())
							&& !ActivoPropietario.CODIGO_GIVP_II.equals(propietario.getCodigo())) {
						cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/"
								+ reservationKey + "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
					}
				} else if (!DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera)){
					cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/"
							+ reservationKey + "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
				}

			}
			
			if (DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera) && !tieneReserva) {
				cuerpo = cuerpo + "<p> En los próximos días recibirá un e-mail con un enlace web en el que se le requerirá la información y documentación necesaria para la formalización de la operación, relativos a los siguientes puntos: </p>";
			}
			
			if (DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera) && tieneReserva) {
				cuerpo = cuerpo + "<p> En los próximos días recibirá un e-mail con un enlace web en el que se le requerirá la información y documentación necesaria para la reserva y formalización de la operación, relativos a los siguientes puntos: </p>";
			}
			
			if (DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera)) {
				cuerpo = cuerpo + "<p> - Documentación identificativa de los compradores (DNI, NIE, CIF…)</p>"
								+ "<p> - Origen de los fondos (por actividad, financiación bancaria o no bancaria, ahorros…)</p>"
								+ "<p> - Forma de pago empleados en la compra.</p>"
								+ "<p> En cualquier caso, se le asignará un gestor de formalización específico que le guiará durante todo el proceso de compra.</p>";
			}
			
			if (DDCartera.CODIGO_CARTERA_SAREB.equals(codigoCartera)) {
				cuerpo = cuerpo + "<p>A tal efecto le solicitamos a través de este documento que:</p>"
						+ "<p>- Confirme los datos de la oferta remitidos informando de cualquier error que detecte en los mismos.</p>"
						+ "<p>- Autorice a HAYA REAL ESTATE, S.A. para que a través de sus colaboradores pueda elevar en su nombre la documentación necesaria a la indicada herramienta ePBC.</p>";
			}
			
			

			cuerpo = cuerpo
					+ "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

			Usuario gestorComercial = null;
			Usuario gestorBackOffice = null;
			Usuario gestorFormalizacion = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GFORM");

			if (!Checks.esNulo(oferta.getAgrupacion())
					&& !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion() != null)) {
				if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL
						.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())
						&& oferta.getAgrupacion() instanceof ActivoLoteComercial) {
					ActivoLoteComercial activoLoteComercial = (ActivoLoteComercial) oferta.getAgrupacion();
					gestorComercial = activoLoteComercial.getUsuarioGestorComercial();
					gestorBackOffice = activoLoteComercial.getUsuarioGestorComercialBackOffice();
				} else {
					// Lote Restringido
					gestorComercial = gestorActivoManager.getGestorByActivoYTipo(oferta.getActivoPrincipal(), "GCOM");
					gestorBackOffice = gestorActivoManager.getGestorByActivoYTipo(oferta.getActivoPrincipal(), "HAYAGBOINM");
				}
			} else {
				gestorComercial = gestorActivoManager.getGestorByActivoYTipo(oferta.getActivoPrincipal(), "GCOM");
				gestorBackOffice = gestorActivoManager.getGestorByActivoYTipo(oferta.getActivoPrincipal(), "HAYAGBOINM");
			}
			
			cuerpo = cuerpo + String.format("<p>Gestor comercial: %s </p>",
					(gestorComercial != null) ? gestorComercial.getApellidoNombre() : STR_MISSING_VALUE);
			cuerpo = cuerpo + String.format("<p>%s</p>",
					(gestorComercial != null) ? gestorComercial.getEmail() : STR_MISSING_VALUE);
			
			cuerpo = cuerpo + String.format("<p>Gestor Comercial Backoffice Inmobiliario: %s </p>",
					(gestorBackOffice != null) ? gestorBackOffice.getApellidoNombre() : STR_MISSING_VALUE);
			cuerpo = cuerpo + String.format("<p>%s</p>",
					(gestorBackOffice != null) ? gestorBackOffice.getEmail() : STR_MISSING_VALUE);
			
			if(!Checks.esNulo(gestorFormalizacion)){
				
				if (!Checks.estaVacio(usuarioRemApiImpl.getGestorSustitutoUsuario(gestorFormalizacion))){
					if(!Checks.esNulo(usuarioRemApiImpl.getApellidoNombreSustituto(gestorFormalizacion))) {
						cuerpo = cuerpo + String.format("<p>Gestor formalización Sustituto: %s </p>",
								(gestorFormalizacion != null) ? usuarioRemApiImpl.getApellidoNombreSustituto(gestorFormalizacion) : STR_MISSING_VALUE);
						}
						cuerpo = cuerpo + String.format("<p>%s</p>",
							(gestorFormalizacion != null) ? usuarioRemApiImpl.getGestorSustitutoUsuario(gestorFormalizacion) : STR_MISSING_VALUE);
				}else{
					cuerpo = cuerpo + String.format("<p>Gestor formalización: %s </p>",
							(gestorFormalizacion != null) ? gestorFormalizacion.getApellidoNombre() : STR_MISSING_VALUE);
					cuerpo = cuerpo + String.format("<p>%s</p>",
							(gestorFormalizacion != null) ? gestorFormalizacion.getEmail() : STR_MISSING_VALUE);
				}
			}

			cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(oferta,tramite);
			dtoSendNotificator.setTitulo(asunto);

			String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);

			if (tieneReserva || DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
				adjuntarInstrucciones = true;
			}

			enviaNotificacionGenerico(oferta.getActivoPrincipal(), asunto, cuerpoCorreo, adjuntarInstrucciones, oferta,
					destinatarios);
		} catch (Exception e) {
			logger.error("Error creando mail de aprobacion",e);
			correoError(oferta, e);
		}
	}
	
	private void enviaSegundaNotificacionAceptar(ActivoTramite tramite, Oferta oferta, ExpedienteComercial expediente,
			String... destinatarios) {
		try {
			String numOferta = STR_MISSING_VALUE;
			if(oferta != null){
				numOferta = oferta.getNumOferta().toString();
			}

			String asunto = "Notificación de aprobación provisional de la oferta " + numOferta;
			String cuerpo = "<p>Nos complace comunicarle que la oferta " + numOferta + " a nombre de "
					+ this.nombresOfertantes(expediente) + " ha sido PROVISIONALMENTE ACEPTADA";


			cuerpo = cuerpo
					+ ". En los próximos días le comunicaremos la resolución, y en el caso de que sea favorable le remitiremos las instrucciones y el contrato de reserva.";
			

			cuerpo = cuerpo
					+ "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

			cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);
			
			if(oferta != null) {
				DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(oferta,tramite);
				dtoSendNotificator.setTitulo(asunto);

				String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);

				enviaNotificacionGenerico(oferta.getActivoPrincipal(), asunto, cuerpoCorreo, false, oferta,
						destinatarios);
			}
			
		} catch (Exception e) {
			logger.error("Error creando segundo mail de aprobacion",e);
			correoError(oferta, e);
		}
	}
	
	private void correoError(Oferta oferta,Exception e){
		String numOferta = "...";
		if(oferta != null && oferta.getNumOferta() != null){
			numOferta = oferta.getNumOferta().toString();
		}
		List<DestinatariosRest> destinatariosRest = genericDao.getList(DestinatariosRest.class);
		List<String> destinatarios = new ArrayList<String>();
		if (!Checks.estaVacio(destinatariosRest)){
			for (DestinatariosRest dRest : destinatariosRest){
				destinatarios.add(dRest.getCorreo());
			}
		}
		
		if (Checks.estaVacio(destinatarios)) {
			throw new IllegalArgumentException("No se ha encontrado destinatarios para la notificación. ");
		}
		
		List<String> mailsCC = new ArrayList<String>();
		String asunto = "[Notificator] Error enviando correo de aprobacion de la oferta "+numOferta+"</p>";
		StringWriter errors = new StringWriter();
		e.printStackTrace(new PrintWriter(errors));
		String message = errors.toString();
		String cuerpo = "<p>" + message + "</p>";
		
		genericAdapter.sendMail(destinatarios, mailsCC, asunto, cuerpo);
	}

	private void enviaNotificacionRechazar(ActivoTramite tramite, Activo activo, Oferta oferta,
			String... destinatarios) {
		String numAgrupacion = "";
		if (oferta.getAgrupacion() != null) {
			numAgrupacion = " / #" + oferta.getAgrupacion().getNumAgrupRem();
		}
		String asunto = "Notificación de rechazo de oferta " + oferta.getNumOferta();
		String cuerpo = "La oferta #" + oferta.getNumOferta() + " presentada por el activo #" + activo.getNumActivo()
				+ numAgrupacion + " ha sido rechazada.";

		cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(oferta,tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		enviaNotificacionGenerico(tramite.getActivo(), asunto, cuerpoCorreo, false, oferta, destinatarios);
	}
	
	private void enviaNotificacionLlegadaTarea(ActivoTramite tramite, String codTareaActual, Activo activo, Oferta oferta) {
		String asunto = null, cuerpo = null;
		
		ArrayList<String> destinatarios = new ArrayList<String>();
		
		String tareaAPasar = CODIGO_T017_ANALISIS_PM.equals(codTareaActual) ? "Resolución CES" 
				: CODIGO_T017_ADVISORY_NOTE.equals(codTareaActual) ? "Recomendación CES"
				: CODIGO_T017_RECOMENDACION_CES.equals(codTareaActual) ? "Resolución Promontoria Manzana"
				: "";
		
		asunto = "La oferta " + oferta.getNumOferta() + " ha llegado a la tarea " + tareaAPasar;
		
		cuerpo = asunto + " en REM.";

		cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);
		
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(oferta,tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		
		String buzon = (CODIGO_T017_ANALISIS_PM.equals(codTareaActual) || CODIGO_T017_ADVISORY_NOTE.equals(codTareaActual)) ? BUZON_CES_APPLE : null;
		
		if(!Checks.esNulo(buzon)) {
			Usuario buzonces = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_CES_APPLE));
			if(!Checks.esNulo(buzon)) {
				destinatarios.add(buzonces.getEmail());
			}
		}else{
			List<GrupoUsuario> grupoManzana = genericDao.getList(GrupoUsuario.class, genericDao.createFilter(FilterType.EQUALS, "grupo.username", GrupoUsuario.GRUPO_MANZANA));
			
			for(GrupoUsuario usuario: grupoManzana) {
				if(!Checks.esNulo(usuario)) {
					destinatarios.add(usuario.getUsuario().getEmail());
				}
			}
			
		}
		
		Usuario buzonpfs = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_PFS));
		Usuario buzonrem = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_REM));
		ActivoProveedor preescriptor = null;
		Usuario gestorBackoffice = null;
		Usuario supervisorBackOffice = null;
		Usuario gestorForm = null;
		Usuario supervisorFormalizacion = null;
		Usuario gestor = null;
		Usuario supervisorComercial = null;
		
		if(!Checks.esNulo(buzonpfs)) {
			destinatarios.add(buzonpfs.getEmail());
		}
		if(!Checks.esNulo(buzonrem)) {
			destinatarios.add(buzonrem.getEmail());
		}

		if(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
				|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())){
			preescriptor = ofertaApi.getPreescriptor(oferta);
			gestorBackoffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			supervisorBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			gestorForm = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			supervisorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			gestor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			supervisorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);

			if(!Checks.esNulo(gestorBackoffice) && !Checks.esNulo(gestorBackoffice.getEmail())){
				destinatarios.add(gestorBackoffice.getEmail());
			}

			if(!Checks.esNulo(supervisorBackOffice) && !Checks.esNulo(supervisorBackOffice.getEmail())){
				destinatarios.add(supervisorBackOffice.getEmail());
			}

			if(!Checks.esNulo(gestorForm) && !Checks.esNulo(gestorForm.getEmail())){
				destinatarios.add(gestorForm.getEmail());
			}

			if(!Checks.esNulo(supervisorFormalizacion) && !Checks.esNulo(supervisorFormalizacion.getEmail())){
				destinatarios.add(supervisorFormalizacion.getEmail());
			}

			if(!Checks.esNulo(gestor) && !Checks.esNulo(gestor.getEmail())){
				destinatarios.add(gestor.getEmail());
			}

			if(!Checks.esNulo(supervisorComercial) && !Checks.esNulo(supervisorComercial.getEmail())){
				destinatarios.add(supervisorComercial.getEmail());
			}

			if(!Checks.esNulo(preescriptor) && !Checks.esNulo(preescriptor.getEmail())){
				destinatarios.add(preescriptor.getEmail());
			}
		}
		
		enviaNotificacionGenerico(tramite.getActivo(), asunto, cuerpoCorreo, false, oferta, destinatarios.toArray(new String[] {}));
	}

	private void enviaNotificacionGenerico(Activo activo, String asunto, String cuerpoCorreo,
			boolean adjuntaInstrucciones, Oferta oferta, String... destinatarios) {
		List<String> mailsCC = new ArrayList<String>();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();

		FileItem f1 = null;
		FileItem f2 = null;
		FileItem f3 = null;

		Filter filterProp = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoPropietarioActivo activoPropietario = genericDao.get(ActivoPropietarioActivo.class, filterProp);
		ActivoPropietario propietario = null;
		if (activoPropietario != null) {
			propietario = activoPropietario.getPropietario();
		}
		if (adjuntaInstrucciones) {
			// ADJUNTOS SI ES CAJAMAR
			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {

				if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getPrescriptor()) && DDTipoProveedor.COD_OFICINA_CAJAMAR.equals(oferta.getPrescriptor().getTipoProveedor().getCodigo())) {
				
					f1 = FileItemUtils.fromResource("docs/Instrucciones_Reserva_Formalizacion_Cajamar_Oficinas.docx");
				} else {
					f1 = FileItemUtils.fromResource("docs/Instrucciones_Reserva_Formalizacion_Cajamar_Apis.docx");
				}

				f2 = FileItemUtils.fromResource("docs/ficha_cliente.xlsx");
				f3 = FileItemUtils.fromResource("docs/manif_titular_real.doc");
				if (f1 != null) {
					adjuntos.add(createAdjunto(f1, "Instrucciones_Reserva_Formalizacion_Cajamar.docx"));
				}
				if (f2 != null) {
					adjuntos.add(createAdjunto(f2, "Ficha_cliente.xlsx"));
				}
				if (f3 != null) {
					adjuntos.add(createAdjunto(f3, "Manif_Titular_Real.doc"));
				}

			}
			// ADJUNTOS SI ES SAREB
			else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)) {
				f1 = FileItemUtils.fromResource("docs/Instrucciones_de_reserva_v4.docx");
				if (f1 != null) {
					adjuntos.add(createAdjunto(f1, "Instrucciones_de_reserva.docx"));
				}

			}
			// ADJUNTOS SI ES BANKIA
			else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)) {
				f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_CaixaBank_v11.docx");
				if (f1 != null) {
					adjuntos.add(createAdjunto(f1, "instrucciones_reserva_CaixaBank.docx"));
				}

			}
			// ADJUNTOS SI ES TANGO
			else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_TANGO)) {
				f1 = FileItemUtils.fromResource("docs/contrato_reserva_Tango.docx");
				if (f1 != null) {
					adjuntos.add(createAdjunto(f1, "contrato_reserva_Tango.docx"));
				}
			}
			// ADJUNTOS SI ES GIANTS
			// Comentamos esta parte del código hasta que tengamos contrato
			// de reserva de GIANTS
			/*
			 * else if(activo.getCartera().getCodigo().equals(DDCartera.
			 * CODIGO_CARTERA_GIANTS)){ f1 = FileItemUtils.fromResource(
			 * "docs/contrato_reserva_Giants.docx");
			 * adjuntos.add(createAdjunto(f1, "contrato_reserva_Giants.docx"));
			 * }
			 */
			// ADJUNTOS SI ES LIBERBANK
			else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)) {
				f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_y_formalizacion_Unicaja_v3.docx");
				if (f1 != null) {
					adjuntos.add(createAdjunto(f1, "instrucciones_reserva_y_formalizacion_Unicaja.docx"));
				}
				// ADJUNTOS SI ES CERBERUS APPLE
			} else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CERBERUS)
					&& DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())) {
				f2 = FileItemUtils.fromResource("docs/instrucciones_reserva_y_formalizacion_APPLE_v3.docx");
				if ( f2 != null ) {
					adjuntos.add(createAdjunto(f2, "instrucciones_reserva_y_formalizacion_APPLE.docx"));
				}
			}
		}
		List<String> mailsPara = new ArrayList<String>();
		if (destinatarios != null && destinatarios.length > 0) {
			mailsPara = Arrays.asList(destinatarios);
		}

		genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo, adjuntos);

	}

	private void deleteFile(FileItem fileitem) {
		if ((fileitem != null) && (fileitem.getFile() != null)) {
			boolean deleted = fileitem.getFile().delete();
			// boolean deleted = false;
			if (!deleted) {
				logger.warn("No se ha borrado el fichero: " + fileitem.getFile().getAbsolutePath()
						+ ". Se ha quedado basurilla.");
			}
		}
	}

	private DtoAdjuntoMail createAdjunto(FileItem fileitem, String name) {
		DtoAdjuntoMail adjMail = new DtoAdjuntoMail();
		Adjunto adjunto = new Adjunto(fileitem);
		adjMail.setAdjunto(adjunto);
		adjMail.setNombre(name);
		return adjMail;
	}

	public String creaCuerpoOfertaExpress(Oferta oferta) {

		Filter filterExp = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filterExp);

		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "activo.id", oferta.getActivoPrincipal().getId());
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filterAct);

		String codigoCartera = null;
		if (!Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getCartera())) {
			codigoCartera = tramite.getActivo().getCartera().getCodigo();
		}

		String asunto = "Notificación de aprobación provisional de la oferta " + oferta.getNumOferta();
		String cuerpo = "<p>Nos complace comunicarle que la oferta " + oferta.getNumOferta() + " a nombre de "
				+ nombresOfertantes(expediente) + " ha sido PROVISIONALMENTE ACEPTADA";

		if (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
			cuerpo = cuerpo + " hasta la formalización de las arras/reserva";
		}

		cuerpo = cuerpo
				+ ". Adjunto a este correo encontrará el documento con las instrucciones a seguir para la reserva y formalización";

		if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera)) {
			cuerpo = cuerpo + ", así como la Ficha cliente a cumplimentar</p>";
		} else {
			cuerpo = cuerpo + ".</p>";
		}
		ActivoBancario activoBancario = genericDao.get(ActivoBancario.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", tramite.getActivo().getId()));
		if (!Checks.esNulo(expediente.getId()) && !Checks.esNulo(expediente.getReserva())
				&& !DDClaseActivoBancario.CODIGO_FINANCIERO.equals(activoBancario.getClaseActivo().getCodigo())) {
			String reservationKey = "";
			if (!Checks.esNulo(appProperties.getProperty("haya.reservation.pwd"))) {
				reservationKey = String.valueOf(expediente.getId())
						.concat(appProperties.getProperty("haya.reservation.pwd"));
				reservationKey = this.computeKey(reservationKey);
			}
			String reservationUrl = "";
			if (!Checks.esNulo(appProperties.getProperty("haya.reservation.url"))) {
				reservationUrl = appProperties.getProperty("haya.reservation.url");
			}
			cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/" + reservationKey
					+ "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
		}

		cuerpo = cuerpo + "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

		Usuario gestorComercial = null;
		Usuario gestorFormalizacion = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GFORM");

		if (!Checks.esNulo(oferta.getAgrupacion())
				&& !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion() != null)) {
			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL
					.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())
					&& oferta.getAgrupacion() instanceof ActivoLoteComercial) {
				ActivoLoteComercial activoLoteComercial = (ActivoLoteComercial) oferta.getAgrupacion();
				gestorComercial = activoLoteComercial.getUsuarioGestorComercial();
			} else {
				// Lote Restringido
				gestorComercial = gestorActivoManager.getGestorByActivoYTipo(tramite.getActivo(), "GCOM");
			}
		} else {
			gestorComercial = gestorActivoManager.getGestorByActivoYTipo(tramite.getActivo(), "GCOM");
		}

		cuerpo = cuerpo + String.format("<p>Gestor comercial: %s </p>",
				(gestorComercial != null) ? gestorComercial.getApellidoNombre() : STR_MISSING_VALUE);
		cuerpo = cuerpo + String.format("<p>%s</p>",
				(gestorComercial != null) ? gestorComercial.getEmail() : STR_MISSING_VALUE);
		
		if(!Checks.esNulo(gestorFormalizacion)){
			
			if (!Checks.estaVacio(usuarioRemApiImpl.getGestorSustitutoUsuario(gestorFormalizacion))){
				if(!Checks.esNulo(usuarioRemApiImpl.getApellidoNombreSustituto(gestorFormalizacion))) {
					cuerpo = cuerpo + String.format("<p>Gestor formalización Sustituto: %s </p>",
							(gestorFormalizacion != null) ? usuarioRemApiImpl.getApellidoNombreSustituto(gestorFormalizacion) : STR_MISSING_VALUE);
					}
					cuerpo = cuerpo + String.format("<p>%s</p>",
						(gestorFormalizacion != null) ? usuarioRemApiImpl.getGestorSustitutoUsuario(gestorFormalizacion) : STR_MISSING_VALUE);
			}else{
				cuerpo = cuerpo + String.format("<p>Gestor formalización: %s </p>",
						(gestorFormalizacion != null) ? gestorFormalizacion.getApellidoNombre() : STR_MISSING_VALUE);
				cuerpo = cuerpo + String.format("<p>%s</p>",
						(gestorFormalizacion != null) ? gestorFormalizacion.getEmail() : STR_MISSING_VALUE);
			}
		}

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		dtoSendNotificator.setTitulo(asunto);

		cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);
		
		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);

		return cuerpoCorreo;

	}
	
	private String tieneNumeroInmuebleBC(String cuerpo, ActivoTramite tramite) {
		if ((tramite.getTipoTramite() == null || CODIGO_TRAMITE_T017.equals(tramite.getTipoTramite().getCodigo())) 
			&& DDCartera.isCarteraBk(tramite.getActivo().getCartera())
			&& !Checks.esNulo(tramite.getActivo().getNumActivoCaixa())) {
			cuerpo = MENSAJE_BC + tramite.getActivo().getNumActivoCaixa() + ",\n" + cuerpo;
		}
		return cuerpo;
	}

}
