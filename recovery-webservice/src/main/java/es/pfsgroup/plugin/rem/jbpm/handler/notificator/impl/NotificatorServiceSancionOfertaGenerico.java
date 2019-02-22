package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

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
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.utils.FileItemUtils;

public abstract class NotificatorServiceSancionOfertaGenerico extends AbstractNotificatorService
		implements NotificatorService {

	private static final String STR_MISSING_VALUE = "---";
	private final Log logger = LogFactory.getLog(getClass());

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
	private static final String GESTOR_BACKOFFICE_LOTE = "gestor-backoffice-lote";
	private static final String GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO = "gestor-comercial-backoffice-inmobiliario";
	private static final String GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LOTE = "gestor-comercial-backoffice-inmobiliario-lote";
	private static final String BUZON_REM = "buzonrem";
	private static final String BUZON_PFS = "buzonpfs";
	
	
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
	
	

	
	@Override
	public final void notificator(ActivoTramite tramite) {

	}

	protected void generaNotificacion(ActivoTramite tramite, boolean permieRechazar, boolean permiteNotificarAprobacion) {

		if(tramite.getActivo() != null && tramite.getTrabajo() != null){
			sendNotification(tramite, permieRechazar, getExpComercial(tramite), permiteNotificarAprobacion);
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

	private void sendNotification(ActivoTramite tramite, boolean permiteRechazar, ExpedienteComercial expediente, boolean permiteNotificarAprobacion) {

		ArrayList<String> destinatarios = new ArrayList<String>();
		
		Usuario buzonRem = usuarioManager.getByUsername(BUZON_REM);
		Usuario buzonPfs = usuarioManager.getByUsername(BUZON_PFS);
		Oferta oferta = null;
		if(expediente != null){
			oferta = expediente.getOferta();
		}
		
		if (!Checks.esNulo(oferta)) {
			Activo activo = oferta.getActivoPrincipal();
			if (permiteNotificarAprobacion && !Checks.esNulo(expediente)
					&& DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())) { // APROBACIÓN

				destinatarios = getDestinatariosNotificacion(activo, oferta, expediente);
				
				if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())){
					Usuario usuarioFicticioCajamar= usuarioManager.getByUsername(USUARIO_FICTICIO_OFERTA_CAJAMAR);
					if(usuarioFicticioCajamar != null && usuarioFicticioCajamar.getEmail() != null){
						destinatarios.add(usuarioFicticioCajamar.getEmail());
					}
					
					if (oferta.getPrescriptor() != null && oferta.getPrescriptor().getEmail() != null){
						destinatarios.add(oferta.getPrescriptor().getEmail());
					}
				}
				
				if(!Checks.esNulo(buzonRem)) {
					destinatarios.add(buzonRem.getEmail());
				}
				if(!Checks.esNulo(buzonPfs)) {
					destinatarios.add(buzonPfs.getEmail());
				}

				this.enviaNotificacionAceptar(tramite, oferta,
						expediente,
						destinatarios.toArray(new String[] {}));

			}else if (permiteRechazar
					&& DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) { // RECHAZO
				String prescriptor = getPrescriptor(activo, oferta);
				String gestorComercial = getGestorComercial(activo, oferta);
				if (!Checks.esNulo(prescriptor)) {
					destinatarios.add(prescriptor);
				}
				
				String gestorFormalizacion = null;
				if(ofertaApi.checkReserva(oferta)) {
					gestorFormalizacion = getGestorFormalizacion(activo,oferta, expediente);
				}
				
				if (!Checks.esNulo(gestorComercial)) {
					destinatarios.add(gestorComercial);
				}
				
				if (!Checks.esNulo(gestorFormalizacion)) {
					destinatarios.add(gestorFormalizacion);
				}
				
				if(!Checks.esNulo(buzonRem)) {
					destinatarios.add(buzonRem.getEmail());
				}
				if(!Checks.esNulo(buzonPfs)) {	
					destinatarios.add(buzonPfs.getEmail());
				}
				
				this.enviaNotificacionRechazar(tramite, activo, oferta, destinatarios.toArray(new String[] {}));
			}			
		}
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
		ExpedienteComercial eco = expedienteComercialDao.getExpedienteComercialByIdOferta(idOferta);
		sendNotification(tramiteSimulado, true, eco, true);
	}

	private String getPrescriptor(Activo activo, Oferta ofertaAceptada) {
		Map<String, String> gestores = getGestores(activo, ofertaAceptada, null, null, GESTOR_PRESCRIPTOR);
		return gestores.get(GESTOR_PRESCRIPTOR);
	}
	private String getGestorComercial(Activo activo, Oferta ofertaAceptada) {
		String comercial = getTipoGestorComercial(ofertaAceptada);
		if(!Checks.esNulo(ofertaAceptada.getAgrupacion())){
			ActivoLoteComercial activoLoteComercial= genericDao.get(ActivoLoteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "id", ofertaAceptada.getAgrupacion().getId()));
			Map<String, String> gestores = getGestores(activo, ofertaAceptada, activoLoteComercial, null, comercial);
			return gestores.get(comercial);
		}else if(Checks.esNulo(ofertaAceptada.getAgrupacion()) && GESTOR_COMERCIAL_ACTIVO.equals(comercial)) {
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
				|| activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_GIANTS)) {
			
			clavesGestores.addAll(Arrays.asList(GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial, GESTOR_COMERCIAL_ACTIVO_SUS));
			
			if(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())) {
				clavesGestores.addAll(Arrays.asList(GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, SUPERVISOR_BACKOFFICE_LIBERBANK));
			}
			
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo()) || DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
				clavesGestores.addAll(Arrays.asList(GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO));
			}
			
			if (formalizacion) {
				clavesGestores.addAll(Arrays.asList(GESTOR_FORMALIZACION, GESTOR_FORMALIZACION_SUS));
				clavesGestores.addAll(Arrays.asList(GESTOR_GESTORIA_FASE_3, GESTOR_GESTORIA_FASE_3_SUS));
			}

			// DESTINATARIOS SI ES CAJAMAR
		} else if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
			clavesGestores.addAll(
					Arrays.asList(GESTOR_PRESCRIPTOR, GESTOR_MEDIADOR, claveGestorComercial, GESTOR_BACKOFFICE, GESTOR_COMERCIAL_ACTIVO_SUS, GESTOR_BACKOFFICE_SUS, GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO));
			if (formalizacion) {
				clavesGestores.addAll(Arrays.asList(GESTOR_FORMALIZACION, GESTOR_FORMALIZACION_SUS));
				clavesGestores.addAll(Arrays.asList(GESTOR_GESTORIA_FASE_3, GESTOR_GESTORIA_FASE_3_SUS));
			}
		}
		clavesGestores.add(GESTOR_FORMALIZACION);
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
				if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(tipo.getCodigo())) {
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
						GESTOR_COMERCIAL_LOTE_RESTRINGIDO, GESTOR_COMERCIAL_LOTE_COMERCIAL, GESTOR_FORMALIZACION, GESTOR_BACKOFFICE, GESTOR_GESTORIA_FASE_3,SUPERVISOR_COMERCIAL};
		
		
		
		HashMap<String, String> gestores = new HashMap<String, String>();

		for (String s : claves) {
			if (GESTOR_PRESCRIPTOR.equals(s)) {
				ActivoProveedor prescriptor = ofertaApi.getPreescriptor(oferta);
				if (!Checks.esNulo(prescriptor)){
					addMail(s, extractEmailProveedor(prescriptor), gestores);
				}				
			} else if (GESTOR_MEDIADOR.equals(s)) {
				ActivoProveedor mediador = activoApi.getMediador(activo);
				if (!Checks.esNulo(mediador)){
					addMail(s, extractEmailProveedor(mediador), gestores);
				}	
			} else if (GESTOR_COMERCIAL_ACTIVO.equals(s) || GESTOR_COMERCIAL_LOTE_RESTRINGIDO.equals(s)) {
				Usuario gesComercial = gestorActivoApi.getGestorByActivoYTipo(activo, "GCOM");
				if (!Checks.esNulo(gesComercial)){
					addMail(s, extractEmail(gesComercial), gestores);
						
					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", gesComercial.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)){
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)){
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date()) && !Checks.esNulo(sgs.getFechaInicio()) 
										&& (sgs.getFechaInicio().before(new Date()) || sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_COMERCIAL_ACTIVO_SUS, extractEmail(sgs.getUsuarioGestorSustituto()), gestores);
								}
							}
						}
					}
				}				
				
			} else if (GESTOR_COMERCIAL_LOTE_COMERCIAL.equals(s)) {
				Usuario gesLoteComercial = loteComercial.getUsuarioGestorComercial();
				if (!Checks.esNulo(gesLoteComercial)){
					addMail(s, extractEmail(gesLoteComercial), gestores);
					
					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", gesLoteComercial.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)){
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)){
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date()) && !Checks.esNulo(sgs.getFechaInicio()) 
										&& (sgs.getFechaInicio().before(new Date()) || sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_COMERCIAL_LOTE_COMERCIAL_SUS, extractEmail(sgs.getUsuarioGestorSustituto()), gestores);
								}
							}
						}
					}
				}
					
			} else if (GESTOR_FORMALIZACION.equals(s)) {
				Usuario gesFormalizacion = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GFORM");
				if (!Checks.esNulo(gesFormalizacion)){
					addMail(s,extractEmail(gesFormalizacion), gestores);
					
					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", gesFormalizacion.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)){
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)){
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date()) && !Checks.esNulo(sgs.getFechaInicio()) 
										&& (sgs.getFechaInicio().before(new Date()) || sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_FORMALIZACION_SUS, extractEmail(sgs.getUsuarioGestorSustituto()), gestores);
								}
							}
						}
					}
				}
									
			} else if (GESTOR_BACKOFFICE.equals(s)) {
				Usuario gesBack = gestorActivoApi.getGestorByActivoYTipo(activo, "GBO");
				if (!Checks.esNulo(gesBack)){
					addMail(s,gestores.put(s, extractEmail(gesBack)), gestores);
					
					
					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", gesBack.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)){
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)){
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date()) && !Checks.esNulo(sgs.getFechaInicio()) 
										&& (sgs.getFechaInicio().before(new Date()) || sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_BACKOFFICE_SUS, extractEmail(sgs.getUsuarioGestorSustituto()), gestores);
								}
							}
						}
					}
				}				
				
			} else if (GESTOR_GESTORIA_FASE_3.equals(s)) {
				Usuario gesGesFase = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GIAFORM");
				if (!Checks.esNulo(gesGesFase)){
					addMail(s,gestores.put(s, extractEmail(gesGesFase)), gestores);
					
					Filter filterUsu = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", gesGesFase.getId());
					List<GestorSustituto> sgsList = genericDao.getList(GestorSustituto.class, filterUsu);
					if (!Checks.esNulo(sgsList)){
						for (GestorSustituto sgs : sgsList) {
							if (!Checks.esNulo(sgs)){
								if (!Checks.esNulo(sgs.getFechaFin()) && sgs.getFechaFin().after(new Date()) && !Checks.esNulo(sgs.getFechaInicio()) 
										&& (sgs.getFechaInicio().before(new Date()) || sgs.getFechaInicio().equals(new Date()))) {
									addMail(GESTOR_GESTORIA_FASE_3_SUS, extractEmail(sgs.getUsuarioGestorSustituto()), gestores);
								}
							}
						}
					}
				}
			} else if (SUPERVISOR_BACKOFFICE_LIBERBANK.equals(s)) {
				Usuario supBackLiberbank= gestorActivoApi.getGestorByActivoYTipo(activo, "SBACKOFFICEINMLIBER");
				if(!Checks.esNulo(supBackLiberbank)) {
					addMail(s, gestores.put(s, extractEmail(supBackLiberbank)), gestores);
				}
			} else if(GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO.equals(s)) {
				Usuario gesBackInmobiliario = null;
				if(loteComercial == null || loteComercial.getUsuarioGestorComercialBackOffice() == null){
					gesBackInmobiliario = gestorActivoApi.getGestorByActivoYTipo(activo, "HAYAGBOINM");
				}else{
					gesBackInmobiliario = loteComercial.getUsuarioGestorComercialBackOffice();
				}
				
				if(!Checks.esNulo(gesBackInmobiliario)) {
					addMail(s, gestores.put(s, extractEmail(gesBackInmobiliario)), gestores);
				}
				addMail(s,gestores.put(s, extractEmail(gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GIAFORM"))), gestores);				
			} else if (SUPERVISOR_COMERCIAL.equals(s)) {
				Usuario sComercial = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "SCOM");
				if(sComercial != null){
					addMail(s,gestores.put(s, extractEmail(sComercial)), gestores);
				}								
			}
		}
		
		
		
		return gestores;
	}
	
	private void addMail(String key, String email,HashMap<String, String> coleccion){
		if(email != null && !email.isEmpty()){
			coleccion.put(key, email);
		}
	}

	private String extractEmail(Usuario u) {
		String eMail = null;
		if (u != null) {
			if(u.getEmail() != null && !u.getEmail().isEmpty()){
				eMail = u.getEmail();
			}
		}
		return eMail;
	}
	
	private String extractEmailProveedor(ActivoProveedor activoProveedor){
		String eMail= null;
		if(activoProveedor != null){
			if(activoProveedor.getEmail() != null && !activoProveedor.getEmail().isEmpty()){
				eMail = activoProveedor.getEmail();
			}
		}
		return eMail;
	}
	

	private void enviaNotificacionAceptar(ActivoTramite tramite, Oferta oferta, ExpedienteComercial expediente,
			String... destinatarios) {
		boolean tieneReserva = false;
		boolean adjuntarInstrucciones = false;
		String codigoCartera = null;
		if (!Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getCartera())) {
			codigoCartera = tramite.getActivo().getCartera().getCodigo();			
		}
		
		String asunto = "Notificación de aprobación provisional de la oferta " + oferta.getNumOferta();
		String cuerpo = "<p>Nos complace comunicarle que la oferta " + oferta.getNumOferta()
				+ " a nombre de " + this.nombresOfertantes(expediente)
				+ " ha sido PROVISIONALMENTE ACEPTADA";
		
		if (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
			cuerpo = cuerpo + " hasta la formalización de las arras/reserva";
		}
		
		cuerpo = cuerpo + ". Adjunto a este correo encontrará el documento con las instrucciones a seguir para la reserva y formalización";
		
		if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera)) {
			cuerpo = cuerpo + ", así como la Ficha cliente a cumplimentar</p>";
		}else {
			cuerpo = cuerpo + ".</p>";
		}
		ActivoBancario activoBancario = genericDao.get(ActivoBancario.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", tramite.getActivo().getId())); 
		if (!Checks.esNulo(expediente.getId()) && !Checks.esNulo(expediente.getReserva()) && !Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())
				&& !DDClaseActivoBancario.CODIGO_FINANCIERO.equals(activoBancario.getClaseActivo().getCodigo())) {
			tieneReserva = true;
			String reservationKey = "";
			if(!Checks.esNulo(appProperties.getProperty("haya.reservation.pwd"))){
				reservationKey = String.valueOf(expediente.getId())
						.concat(appProperties.getProperty("haya.reservation.pwd"));
				reservationKey = this.computeKey(reservationKey);
			}
			String reservationUrl ="";
			if(!Checks.esNulo(appProperties.getProperty("haya.reservation.url"))){
				reservationUrl = appProperties.getProperty("haya.reservation.url");
			}
			
			Filter filterProp = genericDao.createFilter(FilterType.EQUALS, "activo.id", tramite.getActivo().getId());
			ActivoPropietarioActivo activoPropietario = genericDao.get(ActivoPropietarioActivo.class, filterProp);
			ActivoPropietario propietario = null;
			if(activoPropietario != null ){
				propietario = activoPropietario.getPropietario();
			}
			
			if(codigoCartera.equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
				if (propietario != null && !ActivoPropietario.CODIGO_FONDOS_TITULIZACION.equals(propietario.getCodigo()) && !ActivoPropietario.CODIGO_GIVP.equals(propietario.getCodigo()) 
						&& !ActivoPropietario.CODIGO_GIVP_II.equals(propietario.getCodigo())){					
					cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/" + reservationKey
							+ "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
				}
			} else {
				cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/" + reservationKey
						+ "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
			}
			
			
		}
		if(DDCartera.CODIGO_CARTERA_SAREB.equals(codigoCartera)) {
			cuerpo = cuerpo + "<p>A tal efecto le solicitamos a través de este documento que:</p>"
					+ "<p>- Confirme los datos de la oferta remitidos informando de cualquier error que detecte en los mismos.</p>" + 
					"<p>- Autorice a HAYA REAL ESTATE, S.A. para que a través de sus colaboradores pueda elevar en su nombre la documentación necesaria a la indicada herramienta ePBC.</p>";
		}		

		cuerpo = cuerpo + "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

		Usuario gestorComercial = null;

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

		cuerpo = cuerpo + String.format("<p>Gestor comercial: %s </p>", (gestorComercial != null) ? gestorComercial.getApellidoNombre() : STR_MISSING_VALUE );
		cuerpo = cuerpo + String.format("<p>%s</p>", (gestorComercial != null) ? gestorComercial.getEmail() : STR_MISSING_VALUE);

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		
		if (tieneReserva || DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
			adjuntarInstrucciones = true;
		}
		
		enviaNotificacionGenerico(tramite.getActivo(), asunto, cuerpoCorreo, adjuntarInstrucciones, oferta, destinatarios);
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

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		enviaNotificacionGenerico(tramite.getActivo(), asunto, cuerpoCorreo, false, oferta, destinatarios);
	}

	private void enviaNotificacionGenerico(Activo activo, String asunto, String cuerpoCorreo, boolean adjuntaInstrucciones, Oferta oferta,
			String... destinatarios) {
		List<String> mailsCC = new ArrayList<String>();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		
		FileItem f1 = null;
		FileItem f2 = null;
		FileItem f3 = null;
		
		Filter filterProp = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoPropietarioActivo activoPropietario = genericDao.get(ActivoPropietarioActivo.class, filterProp);
		ActivoPropietario propietario = null;
		if(activoPropietario != null){
			propietario = activoPropietario.getPropietario();
		}

		try {

			if (adjuntaInstrucciones) {
				//ADJUNTOS SI ES CAJAMAR
				if(DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {
					if (propietario != null && (ActivoPropietario.CODIGO_FONDOS_TITULIZACION.equals(propietario.getCodigo()) || ActivoPropietario.CODIGO_GIVP.equals(propietario.getCodigo()) 
							|| ActivoPropietario.CODIGO_GIVP_II.equals(propietario.getCodigo()))){
						if (oferta.getOfertaExpress()){
							f1 = FileItemUtils.fromResource("docs/20181001_Instrucciones_Reserva_CAJAMAR.pdf");
						}else {
							f1 = FileItemUtils.fromResource("docs/Instrucciones_Reserva_Formalizacion_estandar_072018.pdf");
						}					
					}else {
						f1 = FileItemUtils.fromResource("docs/20181001_Instrucciones_Reserva_CAJAMAR.pdf");
					}
					
					f2 = FileItemUtils.fromResource("docs/ficha_cliente.xlsx");
					f3 = FileItemUtils.fromResource("docs/manif_titular_real.doc");
					if(f1 != null){
						adjuntos.add(createAdjunto(f1, "Instrucciones_Reserva_Formalizacion_Cajamar.pdf"));
					}					
					if(f2 != null){
						adjuntos.add(createAdjunto(f2, "Ficha_cliente.xlsx"));
					}
					if(f3 != null){
						adjuntos.add(createAdjunto(f3, "Manif_Titular_Real.doc"));
					}
					
				}
				//ADJUNTOS SI ES SAREB
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)) {
					f1 = FileItemUtils.fromResource("docs/instrucciones_de_reserva.docx");
					if(f1 != null){
						adjuntos.add(createAdjunto(f1, "Instrucciones_de_reserva.docx"));
					}
					
				}
				//ADJUNTOS SI ES BANKIA
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)){
					f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_Bankia_v7.docx");
					if(f1 != null){
						adjuntos.add(createAdjunto(f1, "instrucciones_reserva_Bankia.docx"));
					}
					
				}
				//ADJUNTOS SI ES TANGO
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_TANGO)){
					f1 = FileItemUtils.fromResource("docs/contrato_reserva_Tango.docx");
					if(f1 != null){
						adjuntos.add(createAdjunto(f1, "contrato_reserva_Tango.docx"));
					}
				}
				//ADJUNTOS SI ES GIANTS
				//Comentamos esta parte del código hasta que tengamos contrato de reserva de GIANTS
				/*else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_GIANTS)){
					f1 = FileItemUtils.fromResource("docs/contrato_reserva_Giants.docx");
					adjuntos.add(createAdjunto(f1, "contrato_reserva_Giants.docx"));
				}*/
				//ADJUNTOS SI ES LIBERBANK
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_LIBERBANK)) {
					f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_y_formalizacion_Liberbank.docx");
					if(f1 != null){
						adjuntos.add(createAdjunto(f1, "instrucciones_reserva_y_formalizacion_Liberbank.docx"));
					}
					
				}
			}
			List<String> mailsPara = new ArrayList<String>();
			if(destinatarios != null && destinatarios.length > 0){
				mailsPara = Arrays.asList(destinatarios);
			}
			
				
			genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo, adjuntos);
		}finally {
			deleteFile(f1);
			deleteFile(f2);
		}
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
	
	public String creaCuerpoOfertaExpress(Oferta oferta){
		
		Filter filterExp = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filterExp);
		
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "activo.id", oferta.getActivoPrincipal().getId());
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filterAct);
		
		String codigoCartera = null;
		if (!Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getCartera())) {
			codigoCartera = tramite.getActivo().getCartera().getCodigo();			
		}
		
		String asunto = "Notificación de aprobación provisional de la oferta " + oferta.getNumOferta();
		String cuerpo = "<p>Nos complace comunicarle que la oferta " + oferta.getNumOferta()
				+ " a nombre de " + nombresOfertantes(expediente)
				+ " ha sido PROVISIONALMENTE ACEPTADA";
		
		if (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
			cuerpo = cuerpo + " hasta la formalización de las arras/reserva";
		}
		
		cuerpo = cuerpo + ". Adjunto a este correo encontrará el documento con las instrucciones a seguir para la reserva y formalización";
		
		if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera)) {
			cuerpo = cuerpo + ", así como la Ficha cliente a cumplimentar</p>";
		}else {
			cuerpo = cuerpo + ".</p>";
		}
		ActivoBancario activoBancario = genericDao.get(ActivoBancario.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", tramite.getActivo().getId())); 
		if (!Checks.esNulo(expediente.getId()) && !Checks.esNulo(expediente.getReserva()) 
				&& !DDClaseActivoBancario.CODIGO_FINANCIERO.equals(activoBancario.getClaseActivo().getCodigo())) {
			String reservationKey = "";
			if(!Checks.esNulo(appProperties.getProperty("haya.reservation.pwd"))){
				reservationKey = String.valueOf(expediente.getId())
						.concat(appProperties.getProperty("haya.reservation.pwd"));
				reservationKey = this.computeKey(reservationKey);
			}
			String reservationUrl ="";
			if(!Checks.esNulo(appProperties.getProperty("haya.reservation.url"))){
				reservationUrl = appProperties.getProperty("haya.reservation.url");
			}
			cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/" + reservationKey
					+ "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
		}

		cuerpo = cuerpo + "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

		Usuario gestorComercial = null;

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

		cuerpo = cuerpo + String.format("<p>Gestor comercial: %s </p>", (gestorComercial != null) ? gestorComercial.getApellidoNombre() : STR_MISSING_VALUE );
		cuerpo = cuerpo + String.format("<p>%s</p>", (gestorComercial != null) ? gestorComercial.getEmail() : STR_MISSING_VALUE);

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
		
		return cuerpoCorreo;
		
	}

}
