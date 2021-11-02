package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;

@Component
public class ComercialUserAssigantionService implements UserAssigantionService  {

	public static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	public static final String CODIGO_T013_PBC_RESERVA = "T013_PBCReserva";
	public static final String CODIGO_T013_FIRMA_PROPIETARIO = "T013_FirmaPropietario";
	public static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
	public static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";
	public static final String CODIGO_T013_RESPUESTA_OFERTANTE = "T013_RespuestaOfertante";
	public static final String CODIGO_T013_DOBLE_FIRMA = "T013_DobleFirma";
	public static final String CODIGO_T013_INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
	public static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	public static final String CODIGO_T013_RESOLUCION_TANTEO = "T013_ResolucionTanteo";
	public static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
	public static final String CODIGO_T013_POSICIONAMIENTO_FIRMA = "T013_PosicionamientoYFirma";
	public static final String CODIGO_T013_DEVOLUCION_LLAVES = "T013_DevolucionLlaves";
	public static final String CODIGO_T013_DOCUMENTOS_POSTVENTA = "T013_DocumentosPostVenta";
	public static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";
	public static final String CODIGO_T013_RATIFICACION_COMITE = "T013_RatificacionComite";
	public static final String CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION = "T013_RespuestaBankiaDevolucion";
	public static final String CODIGO_T013_PENDIENTE_DEVOLUCION = "T013_PendienteDevolucion";
	public static final String CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION = "T013_RespuestaBankiaAnulacionDevolucion";
	public static final String CODIGO_T013_VALIDACION_CLIENTES = "T013_ValidacionClientes";
	public static final String CODIGO_T017_DEFINICION_OFERTA = "T017_DefinicionOferta";
	public static final String CODIGO_T017_ANALISIS_PM ="T017_AnalisisPM";
	public static final String CODIGO_T017_RESOLUCION_CES ="T017_ResolucionCES";	
	public static final String CODIGO_T017_RATIFICACION_COMITE_CES ="T017_RatificacionComiteCES";
	//public static final String CODIGO_T017_RESPUESTA_OFERTANTE_PM ="T017_RespuestaOfertantePM";
	public static final String CODIGO_T017_RESPUESTA_OFERTANTE_CES ="T017_RespuestaOfertanteCES";
	public static final String CODIGO_T017_ADVISORY_NOTE ="T017_AdvisoryNote";
	public static final String CODIGO_T017_PBC_RESERVA ="T017_PBCReserva";
	public static final String CODIGO_T017_PBC_VENTA ="T017_PBCVenta";
	public static final String CODIGO_T017_RECOMENDACION_CES ="T017_RecomendCES";
	public static final String CODIGO_T017_RESOLUCION_PRO_MANZANA ="T017_ResolucionPROManzana";
	public static final String CODIGO_T017_RESOLUCION_EXPEDIENTE ="T017_ResolucionExpediente";
	public static final String CODIGO_T017_INSTRUCCIONES_RESERVA ="T017_InstruccionesReserva";
	public static final String CODIGO_T017_OBTENCION_CONTRATO_RESERVA ="T017_ObtencionContratoReserva";
	public static final String CODIGO_T017_POSICIONAMIENTO_FIRMA ="T017_PosicionamientoYFirma";
	public static final String CODIGO_T017_DOCUMENTOS_POSTVENTA ="T017_DocsPosVenta";
	public static final String CODIGO_T017_CIERRE_ECONOMICO ="T017_CierreEconomico";
	public static final String CODIGO_T017_RESOLUCION_DIVARIAN = "T017_ResolucionDivarian";
	public static final String CODIGO_T017_RESOLUCION_ARROW = "T017_ResolucionArrow";
	public static final String CODIGO_T017_AGENDAR_ARRAS = "T017_AgendarFechaFirmaArras";
	public static final String CODIGO_T017_CONFIRMAR_ARRAS = "T017_ConfirmarFechaFirmaArras";
	public static final String CODIGO_T017_AGENDAR_FIRMA = "T017_AgendarPosicionamiento";
	public static final String CODIGO_T017_CONFIRMAR_FIRMA = "T017_ConfirmarFechaEscritura";
	public static final String CODIGO_T017_FIRMA = "T017_FirmaContrato";
	public static final String CODIGO_T017_PBC_CN = "T017_PBC_CN";

	public static final String USUARIO_REST_BC_DEFAULT = "COMM_CBK";
	
	public static final String CODIGO_T017_BLOQUEOSCREENING = "T017_BloqueoScreening";
	
	public static final String CODIGO_T015_VERIFICAR_SCORING = "T015_VerificarScoring";
	public static final String CODIGO_T015_SCORING_BC = "T015_ScoringBC";
	public static final String CODIGO_T015_PBC = "T015_PBC";
	public static final String CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES = "T015_SolicitarGarantiasAdicionales";
	
	public class TramiteVentaAppleT017{
		public static final String CODIGO_T017_CONFIRMAR_FECHA_FIRMA_ARRAS = "T017_ConfirmarFechaFirmaArras";
		public static final String CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA = "T017_ConfirmarFechaEscritura";
		public static final String CODIGO_T017_PBC_CN = "T017_PBC_CN";
	}
	
	public class TramiteAlquilerT015{
		public static final String CODIGO_T015_ELEVAR_SANCION = "T015_ElevarASancion";
		public static final String CODIGO_T015_DEFINICION_OFERTA = "T015_DefinicionOferta";
		public static final String CODIGO_T015_BLOQUEOSCREENING = "T015_BloqueoScreening";
	}
	
	public class TramiteAlquilerNoComercialT018{
		public static final String CODIGO_T018_SOLICITAR_GARANTIAS_ADICIONALES = "T018_SolicitarGarantiasAdicionales";
		public static final String CODIGO_T018_SCORING = "T018_Scoring";
		public static final String CODIGO_T018_DEFINICION_OFERTA = "T015_DefinicionOferta";
		public static final String CODIGO_T018_ANALISIS_BC = "T018_AnalisisBc";
		public static final String CODIGO_T018_BLOQUEOSCREENING = "T018_BloqueoScreening";
		public static final String CODIGO_T018_PBC_ALQUILER = "T018_PbcAlquiler";
	}
	
	private static final Integer CODIGO_SI = 1;
	
	public static final String USUARIO_GESTOR_FORMALIZACION = "gestform";
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T013_DEFINICION_OFERTA, CODIGO_T013_FIRMA_PROPIETARIO, CODIGO_T013_CIERRE_ECONOMICO, CODIGO_T013_RESOLUCION_COMITE,
				 	CODIGO_T013_RESPUESTA_OFERTANTE, CODIGO_T013_DOBLE_FIRMA, CODIGO_T013_INSTRUCCIONES_RESERVA,
				 	CODIGO_T013_OBTENCION_CONTRATO_RESERVA, CODIGO_T013_RESOLUCION_TANTEO, CODIGO_T013_RESULTADO_PBC, CODIGO_T013_POSICIONAMIENTO_FIRMA, 
				 	CODIGO_T013_DEVOLUCION_LLAVES, CODIGO_T013_DOCUMENTOS_POSTVENTA, CODIGO_T013_RESOLUCION_EXPEDIENTE, CODIGO_T013_RATIFICACION_COMITE,
				 	CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, CODIGO_T013_PENDIENTE_DEVOLUCION, CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, 
				 	CODIGO_T013_VALIDACION_CLIENTES,CODIGO_T017_DEFINICION_OFERTA,CODIGO_T017_RESOLUCION_CES,CODIGO_T017_RESPUESTA_OFERTANTE_CES,
				 	CODIGO_T017_ADVISORY_NOTE,CODIGO_T017_PBC_RESERVA,CODIGO_T017_PBC_VENTA,CODIGO_T017_RECOMENDACION_CES,
				 	CODIGO_T017_RESOLUCION_PRO_MANZANA,CODIGO_T017_RESOLUCION_EXPEDIENTE,CODIGO_T017_INSTRUCCIONES_RESERVA,CODIGO_T017_OBTENCION_CONTRATO_RESERVA,
				 	CODIGO_T017_POSICIONAMIENTO_FIRMA,CODIGO_T017_DOCUMENTOS_POSTVENTA,CODIGO_T017_CIERRE_ECONOMICO, CODIGO_T017_RESOLUCION_DIVARIAN, CODIGO_T017_RESOLUCION_ARROW,
				 	CODIGO_T017_RATIFICACION_COMITE_CES, CODIGO_T017_AGENDAR_ARRAS, CODIGO_T017_CONFIRMAR_ARRAS, CODIGO_T017_AGENDAR_FIRMA, CODIGO_T017_CONFIRMAR_FIRMA,
					CODIGO_T017_FIRMA, CODIGO_T017_PBC_CN};

	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		String codigoCartera =tareaActivo.getActivo().getCartera().getCodigo();
		Usuario usuarioDevolver;
		
		boolean isFdv = this.isFuerzaVentaDirecta(tareaExterna);
		boolean isConFormalizacion = this.isConFormalizacion(tareaExterna);
		boolean isGiants = this.isActivoGiants(tareaActivo);
		boolean isLiberbank = this.isActivoLiberbank(tareaActivo);
		boolean isHayaLbk = false;
		boolean isActivoBankia = this.isActivoBankia(tareaActivo);
		boolean isActivoSareb = this.isActivoSareb(tareaActivo);
		boolean isRetail=this. isRetailActivo(tareaActivo);
		boolean isActivoApple = this.isActivoApple(tareaActivo);
		boolean isActivoTango = this.isActivoTango(tareaActivo);
		boolean isActivoGaleon = this.isActivoGaleon(tareaActivo);
		boolean isActivoThirdPartiesING = this.isActivoThirdPartiesING(tareaActivo);
		boolean isActivoHYT = this.isActivoHYT(tareaActivo);
		boolean isActivoEgeoZeus = this.isActivoEgeoZeus(tareaActivo);
		boolean isActivoYubai = this.isActivoYubai(tareaActivo);
		boolean isActivoArrow = this.isActivoArrow(tareaActivo);
		boolean isActivoOmega = this.isActivoOmega(tareaActivo);		
		boolean esActivoRemaining = this.isActivoRemaining(tareaActivo);
		boolean isActivoFinanciero = this.isFinancieroCajamar(tareaExterna);
		boolean isActivoBBVA = this.isActivoBBVA(tareaActivo);
		String codigoTarea = tareaExterna.getTareaProcedimiento().getCodigo();
		String codigoGestor; 
		ActivoLoteComercial loteComercial = this.obtenerLoteComercial(tareaActivo);
		EXTDDTipoGestor tipoGestor = null;
		ExpedienteComercial expediente = null;
		boolean tieneReserva = this.expedienteTieneReserva(expediente, tareaActivo);	
//		Boolean usaGestorController = usaGestorController(tareaActivo);
		Boolean usaGestorCierreVenta = usaGestorCierreVenta(tareaActivo);
		boolean isCerberus = this.isCerberus(tareaActivo);
		boolean isActivoEgeo = this.isActivoEgeo(tareaActivo);
		boolean isActivoJaipur = this.isActivoJaipur(tareaActivo);
		boolean isActivoAgora = this.isActivoAgora(tareaActivo);
		boolean tieneGBOAR = this.tieneGBOAR(tareaActivo);
		boolean isActivoBFA = this.isActivoBFA(tareaActivo);

		if(this.isTrabajoDeActivoOrLoteRestEntidad01(tareaActivo)) {
			if(null == loteComercial) {
				// Si no es un lote comercial comprobar si es financiero o inmobiliario.
				codigoGestor = this.getMapCodigoTipoGestorActivoAndLoteRestEntidad01(isActivoFinanciero,tieneReserva).get(codigoTarea);
			} else {
				// Si es un lote comercial comprobar si aplica formalizar.
				Boolean formalizacion = false;
				if(!Checks.esNulo(loteComercial) && !Checks.esNulo(loteComercial.getIsFormalizacion())) {
					formalizacion = (1 == loteComercial.getIsFormalizacion()) ? true : false;
				}
				codigoGestor = this.getMapCodigoTipoGestorActivoAndLoteRestEntidad01Formalizacion(formalizacion,tieneReserva).get(codigoTarea);
			}
		} else{
			expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(tareaActivo.getTramite().getTrabajo().getId());			
			DDComiteSancion comiteSancion = expediente.getComiteSancion();
			String codigoCalculo = (!Checks.esNulo(comiteSancion) ? comiteSancion.getCodigo() : null);

			isHayaLbk = DDComiteSancion.CODIGO_HAYA_LIBERBANK.equals(codigoCalculo);					
			
			codigoGestor = this.getMapCodigoTipoGestor(isFdv, isConFormalizacion, isGiants, isLiberbank, isHayaLbk, isActivoBankia, isActivoSareb, isRetail, 
					isActivoApple, isActivoTango, isActivoGaleon, isActivoThirdPartiesING, isActivoHYT, isActivoEgeoZeus, isActivoYubai, isActivoArrow, 
					isActivoOmega, esActivoRemaining,isActivoBBVA,tieneReserva,isCerberus, isActivoJaipur, isActivoEgeo, isActivoAgora, tieneGBOAR, isActivoBFA).get(codigoTarea);
		}

		if(isActivoBankia && isTareaGetUsuarioCaixa(codigoTarea)){
			Usuario user = getUsuarioByTareaCaixa(codigoTarea);
			if(user != null){
				return user;
			}
		}
		
		if(GestorActivoApi.CODIGO_GESTOR_BOARDING.equals(codigoGestor)) {
			return getGestorOrSupervisorExpedienteByCodigo(tareaExterna, codigoGestor);
		}
		
		if((CODIGO_T013_CIERRE_ECONOMICO.equals(codigoTarea)
				|| CODIGO_T017_CIERRE_ECONOMICO.equals(codigoTarea)) /*&& usaGestorController*/) {
			
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_CONTROLLER);
			
			tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
			
			if(tipoGestor != null) {
				return getGestorOrSupervisorExpedienteByCodigo(tareaExterna, tipoGestor.getCodigo());
			}	
		}
		
		if((CODIGO_T017_POSICIONAMIENTO_FIRMA.equals(codigoTarea)
				|| CODIGO_T017_DOCUMENTOS_POSTVENTA.equals(codigoTarea)) && usaGestorCierreVenta) {
			
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_CIERRE_VENTA);
			
			tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
			
			if(tipoGestor != null) {
				return getGestorOrSupervisorExpedienteByCodigo(tareaExterna, tipoGestor.getCodigo());
			}	
		}
		
		if((CODIGO_T017_POSICIONAMIENTO_FIRMA.equals(codigoTarea)
				|| CODIGO_T017_DOCUMENTOS_POSTVENTA.equals(codigoTarea)) && DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera)) {
			
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
			
			tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
			
			if(tipoGestor != null) {
				return getGestorOrSupervisorExpedienteByCodigo(tareaExterna, tipoGestor.getCodigo());
			}	
		}
		
		if((DDCartera.CODIGO_CARTERA_CERBERUS.equals(codigoCartera) && (CODIGO_T017_PBC_VENTA.equals(codigoTarea) || CODIGO_T017_PBC_RESERVA.equals(codigoTarea)))
				|| (DDCartera.CODIGO_CARTERA_BBVA.equals(codigoCartera) && (CODIGO_T017_PBC_VENTA.equals(codigoTarea) || CODIGO_T017_PBC_RESERVA.equals(codigoTarea)))
				|| ((DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)
						|| DDCartera.CODIGO_CARTERA_LIBERBANK.equals(codigoCartera)
						|| DDCartera.CODIGO_CARTERA_SAREB.equals(codigoCartera)
						|| DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera))
						&& CODIGO_T013_RESULTADO_PBC.equals(codigoTarea))) {		
			Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "username", USUARIO_GESTOR_FORMALIZACION);
			usuarioDevolver = genericDao.get(Usuario.class, filtroUsuario);
			
			if(usuarioDevolver != null) {
				return usuarioDevolver;
			}
		}
		
		
		if((CODIGO_T017_RESOLUCION_CES.equals(codigoTarea) || CODIGO_T017_RECOMENDACION_CES.equals(codigoTarea) 
				|| CODIGO_T017_RESOLUCION_PRO_MANZANA.equals(codigoTarea) || CODIGO_T017_RATIFICACION_COMITE_CES.equals(codigoTarea))
				&& !isActivoBBVA) {
			DDComiteSancion comite = null;
			if  ( tareaActivo != null && tareaActivo.getTramite() != null
					&& tareaActivo.getTramite().getTrabajo() != null ) {
				expediente = expedienteComercialApi.findOneByTrabajo(tareaActivo.getTramite().getTrabajo());
				if ( expediente != null ) {
					comite = expediente.getComiteSancion();
				}
			}
			if((CODIGO_T017_RESOLUCION_CES.equals(codigoTarea) || CODIGO_T017_RATIFICACION_COMITE_CES.equals(codigoTarea))
					&& (isActivoApple || esActivoRemaining) 
					&& (comite != null && (DDComiteSancion.CODIGO_HAYA_APPLE.equals(comite.getCodigo()) || (DDComiteSancion.CODIGO_HAYA_REMAINING.equals(comite.getCodigo()))))){		
				
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);
				tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
				
				if(Checks.esNulo(tipoGestor)) {
					return null;
				}
			}else {
				return gestorActivoApi.usuarioGrupoTareaT017(codigoTarea, isActivoApple, this.isActivoArrow(tareaActivo), this.isActivoRemaining(tareaActivo), tareaExterna);
			}
		} else {
			if(codigoGestor != null && !codigoGestor.isEmpty()) {
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);			
				tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
			}
			if(Checks.esNulo(tipoGestor))
				return null;
		}
		
		if(CODIGO_T017_RESOLUCION_DIVARIAN.equals(codigoTarea) || CODIGO_T017_RESOLUCION_ARROW.equals(codigoTarea)) {
			return gestorActivoApi.usuarioTareaDivarian(codigoTarea);
		}
			
		
		
		if(GestorActivoApi.CODIGO_GESTOR_FORMALIZACION.equals(codigoGestor) || GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION.equals(codigoGestor) 
				|| GestorActivoApi.CODIGO_GESTOR_RESERVA_CAJAMAR.equals(codigoGestor) || GestorActivoApi.CODIGO_GESTOR_MINUTA_CAJAMAR.equals(codigoGestor))
			return this.getGestorOrSupervisorExpedienteByCodigo(tareaExterna, codigoGestor);

		if(GestorActivoApi.CODIGO_GESTOR_COMERCIAL.equals(codigoGestor) && loteComercial != null && !Checks.esNulo(loteComercial.getUsuarioGestorComercial())) {
			return loteComercial.getUsuarioGestorComercial();
		}		
		
		if(GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO.equals(codigoGestor) && loteComercial != null && !Checks.esNulo(loteComercial.getUsuarioGestorComercialBackOffice())) {
			return loteComercial.getUsuarioGestorComercialBackOffice();
		}

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

	private Usuario getUsuarioByTareaCaixa(String codigoTarea) {
		return gestorActivoApi.getUsuarioByTareaCaixa(codigoTarea);
	}

	private boolean isTareaGetUsuarioCaixa(String codigoTarea) {
		return CODIGO_T017_DEFINICION_OFERTA.equals(codigoTarea) || CODIGO_T017_PBC_CN.equals(codigoTarea) || CODIGO_T017_RESOLUCION_CES.equals(codigoTarea)
				|| CODIGO_T017_PBC_RESERVA.equals(codigoTarea) || CODIGO_T017_AGENDAR_ARRAS.equals(codigoTarea) || CODIGO_T017_CONFIRMAR_ARRAS.equals(codigoTarea)
				|| CODIGO_T017_INSTRUCCIONES_RESERVA.equals(codigoTarea) || CODIGO_T017_OBTENCION_CONTRATO_RESERVA.equals(codigoTarea) || CODIGO_T017_PBC_VENTA.equals(codigoTarea)
				|| CODIGO_T017_AGENDAR_FIRMA.equals(codigoTarea) || CODIGO_T017_CONFIRMAR_FIRMA.equals(codigoTarea) || CODIGO_T017_FIRMA.equals(codigoTarea)
				|| CODIGO_T017_DOCUMENTOS_POSTVENTA.equals(codigoTarea) || CODIGO_T017_CIERRE_ECONOMICO.equals(codigoTarea);
	}

	public boolean expedienteTieneReserva(ExpedienteComercial expediente,TareaActivo tareaActivo) {
		boolean tieneReserva = false;
		expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(tareaActivo.getTramite().getTrabajo().getId());	
		if(expediente!=null && expediente.getCondicionante()!=null && CODIGO_SI.equals(expediente.getCondicionante().getSolicitaReserva())) {				
				tieneReserva = true;			
			}
		
		return tieneReserva;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		boolean isFuerzaVentaDirecta = this.isFuerzaVentaDirecta(tareaExterna);
		boolean isActivoFinanciero = this.isFinancieroCajamar(tareaExterna);
		boolean isLiberbank = this.isActivoLiberbank(tareaActivo);
		boolean isBankia = this.isActivoBankia(tareaActivo);
		boolean isSareb = this.isActivoSareb(tareaActivo);
		boolean isActivoApple = this.isActivoApple(tareaActivo);
		boolean isActivoTango = this.isActivoTango(tareaActivo);
		boolean isActivoGaleon = this.isActivoGaleon(tareaActivo);
		boolean isActivoThirdPartiesING = this.isActivoThirdPartiesING(tareaActivo);
		boolean isActivoHYT = this.isActivoHYT(tareaActivo);
		boolean isActivoGiants = this.isActivoGiants(tareaActivo);
		boolean isActivoEgeoZeus = this.isActivoEgeoZeus(tareaActivo);
		boolean isActivoDivarian = this.isActivoArrow(tareaActivo) || this.isActivoRemaining(tareaActivo);
		boolean isActivoBBVA = this.isActivoBBVA(tareaActivo);
		String codigoTarea = tareaExterna.getTareaProcedimiento().getCodigo();
		String codigoSupervisor = null;
		ActivoLoteComercial loteComercial = this.obtenerLoteComercial(tareaActivo);
		EXTDDTipoGestor tipoGestor = null;
		boolean isActivoEgeo = this.isActivoEgeo(tareaActivo);
		boolean isActivoJaipur = this.isActivoJaipur(tareaActivo);
		boolean isActivoAgora = this.isActivoAgora(tareaActivo);
		boolean isBFA = this.isActivoBFA(tareaActivo);

		if(this.isTrabajoDeActivoOrLoteRestEntidad01(tareaActivo)) {
			if(null == loteComercial) {
				// Si no es un lote comercial comprobar si es financiero o inmobiliario.
				codigoSupervisor = this.getMapCodigoTipoSupervisorActivoAndLoteRestEntidad01(isActivoFinanciero).get(codigoTarea);
			} else {
				// Si es un lote comercial comprobar si aplica formalizar.
				Boolean formalizacion = false;
				if(!Checks.esNulo(loteComercial) && !Checks.esNulo(loteComercial.getIsFormalizacion())) {
					formalizacion = (1 == loteComercial.getIsFormalizacion()) ? true : false;
				}
				
				codigoSupervisor = this.getMapCodigoTipoSupervisorActivoAndLoteRestEntidad01Formalizacion(formalizacion).get(codigoTarea);
			}
		}else {
			codigoSupervisor = this.getMapCodigoTipoSupervisor(isFuerzaVentaDirecta, isLiberbank, isBankia, isSareb, isRetailActivo(tareaActivo), isActivoApple, isActivoTango, isActivoGaleon, isActivoThirdPartiesING, isActivoHYT, isActivoEgeoZeus, isActivoGiants, isActivoDivarian, isActivoBBVA, isActivoJaipur, isActivoEgeo, isActivoAgora, isBFA).get(codigoTarea);
		}

		if((CODIGO_T013_CIERRE_ECONOMICO.equals(codigoTarea)
				|| CODIGO_T017_CIERRE_ECONOMICO.equals(codigoTarea)) /*&& usaGestorController*/) {

			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_CONTROLLER);

			tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

			if(tipoGestor != null) {
				return getGestorOrSupervisorExpedienteByCodigo(tareaExterna, tipoGestor.getCodigo());
			}
		}

		if((CODIGO_T017_RESOLUCION_CES.equals(codigoTarea) || CODIGO_T017_RECOMENDACION_CES.equals(codigoTarea) 
				|| CODIGO_T017_RESOLUCION_PRO_MANZANA.equals(codigoTarea) || CODIGO_T017_RATIFICACION_COMITE_CES.equals(codigoTarea)) && !isActivoBBVA) {
			return gestorActivoApi.supervisorTareaApple(codigoTarea);
		} else {
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoSupervisor);
			if(codigoSupervisor != null) {
				tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);	
			}
			
			if(Checks.esNulo(tipoGestor))
				return null;
		}
		
		if(GestorActivoApi.CODIGO_GESTOR_FORMALIZACION.equals(codigoSupervisor) || GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION.equals(codigoSupervisor)
				|| GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION.equals(codigoSupervisor) 
				|| GestorActivoApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR.equals(codigoSupervisor) || GestorActivoApi.CODIGO_SUPERVISOR_MINUTA_CAJAMAR.equals(codigoSupervisor))
			return this.getGestorOrSupervisorExpedienteByCodigo(tareaExterna, codigoSupervisor);

		if(GestorActivoApi.CODIGO_GESTOR_COMERCIAL.equals(codigoSupervisor) && loteComercial != null && !Checks.esNulo(loteComercial.getUsuarioGestorComercial())) {
			return loteComercial.getUsuarioGestorComercial();
		}

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
			
	}
	
	/**
	 * Comprueba si el tramite de la tarea es de un solo activo o de una agrupacion restringida, pertenecientes a CAJAMAR
	 * @param tareaActivo
	 * @return
	 */
	private boolean isTrabajoDeActivoOrLoteRestEntidad01(TareaActivo tareaActivo) {
		
		Trabajo trabajo = tareaActivo.getTramite().getTrabajo();
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		if(!Checks.esNulo(trabajo) && !Checks.esNulo(codCarteraActivo) && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codCarteraActivo)) 
		{	
			if(Checks.esNulo(trabajo.getAgrupacion()) || ( !Checks.esNulo(trabajo.getAgrupacion().getTipoAgrupacion()) && 
							DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(trabajo.getAgrupacion().getTipoAgrupacion().getCodigo())))
				return true;
		}

		return false;
	}
	/*
	 * Comprueba si el activo es de Cartera Giants
	 */
	private boolean isActivoGiants(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_GIANTS.equals(codCarteraActivo);
	}
	
	/*
	 * Comprueba si el activo es de Cartera Liberbank
	 */
	private boolean isActivoLiberbank(TareaActivo tareaActivo) {
		
		//Trabajo trabajo = tareaActivo.getTramite().getTrabajo();
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_LIBERBANK.equals(codCarteraActivo);
	}
	
	private boolean isActivoBankia(TareaActivo tareaActivo) {
		
		//Trabajo trabajo = tareaActivo.getTramite().getTrabajo();
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_BANKIA.equals(codCarteraActivo);
	}
	
	private boolean isActivoSareb(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return  DDCartera.CODIGO_CARTERA_SAREB.equals(codCarteraActivo);
	}
	
	private boolean isRetailActivo(TareaActivo tareaActivo) {
		Activo activo = tareaActivo.getActivo();
		return !Checks.esNulo(activo) && activo.getTipoComercializar() != null && DDTipoComercializar.CODIGO_RETAIL.equals(activo.getTipoComercializar().getCodigo());
	}
	
	private boolean isActivoApple(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(codSubcarteraActivo);
	}
	
	private boolean isActivoBBVA(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_BBVA.equals(codCarteraActivo);
	}
	
	
	private boolean isActivoTango(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_TANGO.equals(codCarteraActivo);
	}
	
	private boolean isActivoGaleon(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_GALEON.equals(codCarteraActivo);
	}
	
	private boolean isActivoThirdPartiesING(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(codCarteraActivo) 
				&& (DDSubcartera.CODIGO_THIRD_PARTIES_QUITAS_ING.equals(codSubcarteraActivo) || DDSubcartera.CODIGO_THIRD_PARTIES_COMERCIAL_ING.equals(codSubcarteraActivo)); 
	}
	
	private boolean isActivoHYT(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_HYT.equals(codCarteraActivo); 
	}
	
	private boolean isActivoEgeoZeus(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_EGEO.equals(codCarteraActivo) && DDSubcartera.CODIGO_ZEUS.equals(codSubcarteraActivo);
	}	
	
	private boolean isActivoYubai(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDSubcartera.CODIGO_YUBAI.equals(codSubcarteraActivo);
	}
	
	private boolean isActivoOmega(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(codCarteraActivo) && DDSubcartera.CODIGO_OMEGA.equals(codSubcarteraActivo);		
	}
	
	private boolean isActivoArrow(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCarteraActivo) && DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(codSubcarteraActivo); 
	}

	private boolean isActivoRemaining(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCarteraActivo) && DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(codSubcarteraActivo); 
	}
	
	private boolean isCerberus(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCarteraActivo);
	}
	
	private boolean isActivoJaipur(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCarteraActivo) && (DDSubcartera.CODIGO_JAIPUR_FINANCIERO.equals(codSubcarteraActivo) 
																				|| DDSubcartera.CODIGO_JAIPUR_INMOBILIARIO.equals(codSubcarteraActivo)); 
	}
	
	private boolean isActivoEgeo(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCarteraActivo) && DDSubcartera.CODIGO_EGEO.equals(codSubcarteraActivo); 
	}

	private boolean isActivoAgora(TareaActivo tareaActivo) {
	
	Activo activo = tareaActivo.getActivo();
	String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
	String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
	
	return DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCarteraActivo) && (DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(codSubcarteraActivo) 
																			|| DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(codSubcarteraActivo)); 
}
	
	private boolean tieneGBOAR(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		String codSubcarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getSubcartera()) ? activo.getSubcartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_BBVA.equals(codCarteraActivo) || DDCartera.CODIGO_CARTERA_BANKIA.equals(codCarteraActivo) ||
				DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codCarteraActivo) || DDCartera.CODIGO_CARTERA_LIBERBANK.equals(codCarteraActivo) ||
				DDCartera.CODIGO_CARTERA_SAREB.equals(codCarteraActivo) || (DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCarteraActivo) && 
				(DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(codSubcarteraActivo) || DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(codSubcarteraActivo) 
						|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(codSubcarteraActivo))) || DDCartera.CODIGO_CARTERA_BFA.equals(codCarteraActivo); 
	}
	
	private boolean isActivoBFA(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return DDCartera.CODIGO_CARTERA_BFA.equals(codCarteraActivo);
	}

	//  --- Mapas con la relación Tarea - Tipo Gestor/supervisor  -------------------------------------------------
	private HashMap<String,String> getMapCodigoTipoGestor(boolean isFdv, boolean isConFormalizacion, boolean isGiants, boolean isLiberbank, boolean isHayaLbk, 
			/*boolean isLiberbankInmobiliaria, boolean isLiberbankTerciaria,*/ boolean isActivoBankia, boolean isActivoSareb, boolean isRetail, boolean isActivoApple, boolean isActivoTango,
			boolean isActivoGaleon, boolean isActivoThirdPartiesING, boolean isActivoHYT, boolean isActivoEgeoZeus, boolean isActivoYubai, boolean isActivoArrow, boolean isActivoOmega,boolean isActivoRemaining, 
			boolean isActivoBBVA,boolean tieneReserva, boolean isCerberus, boolean isActivoJaipur, boolean isActivoEgeo, boolean isActivoAgora, boolean tieneGBOAR, boolean isActivoBFA) {
		
HashMap<String,String> mapa = new HashMap<String,String>();
		
		if(!isFdv){			
			if(isGiants){
				mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_GOLDEN_TREE);
			}else{
				mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			}	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RATIFICACION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		}else{
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RATIFICACION_COMITE, GestorActivoApi.CODIGO_FVD_NEGOCIO);
			if(isGiants){
				mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_GOLDEN_TREE);
			}else if (isActivoBankia || isActivoBFA) {
				mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			}
			else{
				mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_FVD_NEGOCIO);
			}
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_FVD_NEGOCIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_FVD_NEGOCIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_FVD_BKOFERTA);
		}
		
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESULTADO_PBC, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_TANTEO, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEVOLUCION_LLAVES, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		
		if(isLiberbank){
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_CAPA_CONTROL_LIBERBANK);

			if(isHayaLbk) {
				mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			}
		}
		
		if(isActivoSareb || isActivoBFA) {

			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RATIFICACION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_VALIDACION_CLIENTES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if(isActivoSareb) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if(isActivoApple || isActivoRemaining || isActivoBankia) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_CES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);				
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESPUESTA_OFERTANTE_CES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RATIFICACION_COMITE_CES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);		
			if (isActivoRemaining) {
				mapa.put(ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			} else {
				mapa.put(ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
			}			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_ADVISORY_NOTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_VENTA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION); 
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_CONTROLLER); 
		}
		
		if (isActivoJaipur || isActivoEgeo || isActivoAgora) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);		
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RATIFICACION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);				
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
		}
		
		if (isActivoBBVA) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_CES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);				
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESPUESTA_OFERTANTE_CES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RATIFICACION_COMITE_CES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);		
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_VENTA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION); 
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_CONTROLLER); 
		}
		
		if(isActivoArrow) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_DIVARIAN, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_ARROW, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESPUESTA_OFERTANTE_CES, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_ADVISORY_NOTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_VENTA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION); 
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);  
		}
		
		if (isActivoTango) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoGaleon) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoThirdPartiesING) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoHYT) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isGiants) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoEgeoZeus) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoYubai) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoOmega) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESULTADO_PBC, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_PBC_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_CONTROLLER);		
		}
		
		if(tieneReserva && tieneGBOAR) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			
			if (isActivoBBVA || isCerberus) {
				mapa.put(ComercialUserAssigantionService.CODIGO_T017_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
				mapa.put(ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
				mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			}
		}
		
		return mapa;
	}
	
	/**
	 * La entidad 01, cajamar, para activos o lotes restringidos tiene una configuración diferente
	 * @return
	 */
	private HashMap<String,String> getMapCodigoTipoGestorActivoAndLoteRestEntidad01(boolean isFinanciero,boolean tieneReserva) {
		
		HashMap<String,String> mapa = new HashMap<String,String>();		
		
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_PBC_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
				
		if(tieneReserva) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_BOARDING);
		}else {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);		
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESULTADO_PBC, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_TANTEO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEVOLUCION_LLAVES, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		
		if(isFinanciero){
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_FINANCIERO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_FINANCIERO);
		}
		
		return mapa;
	}

	/**
	 * Si viene de una agrupación de tipo comercial y es de cajamar se aplica este filtro sobre los gestores.
	 * 
	 * @param formalizacion: indica si tiene formalización la agrupación o no.
	 * @return Devuelve un mapa asociando las tareas del trámite y sus gestores respectivos.
	 */
	private HashMap<String,String> getMapCodigoTipoGestorActivoAndLoteRestEntidad01Formalizacion(boolean formalizacion,boolean tieneReserva) {

		HashMap<String,String> mapa = new HashMap<String,String>();		

		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);		
		
	
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		if(tieneReserva) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_BOARDING);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_GESTOR_BOARDING);
		}else {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_RESERVA_CAJAMAR);
		}
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESULTADO_PBC, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_TANTEO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEVOLUCION_LLAVES, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);

		if(formalizacion){
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		} else {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_FINANCIERO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_FINANCIERO);
		}

		return mapa;
	}
	
	private HashMap<String,String> getMapCodigoTipoSupervisor(boolean isFdv, boolean isLiberbank, boolean isBankia, boolean isSareb, boolean isRetail, boolean isActivoApple, boolean isActivoTango, 
			boolean isActivoGaleon, boolean isActivoThirdPartiesING, boolean isActivoHYT, boolean isActivoEgeoZeus, boolean isActivoGiants, boolean isActivoDivarian, boolean isActivoBBVA, 
			boolean isActivoJaipur, boolean isActivoEgeo, boolean isActivoAgora, boolean isBFA) {

		HashMap<String,String> mapa = new HashMap<String,String>();		
		
		
		if(!isFdv){
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		}else {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_FVD);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_FVD);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_FVD);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_FVD);
		}
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RATIFICACION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESULTADO_PBC, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_TANTEO, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEVOLUCION_LLAVES, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_VALIDACION_CLIENTES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		
		
		if(isLiberbank){
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LIBERBANK);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LIBERBANK);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LIBERBANK);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LIBERBANK);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LIBERBANK);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LIBERBANK);
		}
		
		if(isBankia && isRetail || isBFA) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RATIFICACION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if(isSareb) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		//Asignar supervisor apple
		if(isActivoApple || isActivoBBVA || isBankia) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RATIFICACION_COMITE_CES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESPUESTA_OFERTANTE_CES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_ADVISORY_NOTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_VENTA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_CN, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_AGENDAR_ARRAS, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_CONFIRMAR_ARRAS, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_AGENDAR_FIRMA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_CONFIRMAR_FIRMA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_FIRMA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION); 
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL); 
			
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_CES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RECOMENDACION_CES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_PRO_MANZANA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoJaipur || isActivoEgeo || isActivoAgora) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);		
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RATIFICACION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);			
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);				
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
		}
		
		if(isActivoDivarian) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_DIVARIAN, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_ARROW, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESPUESTA_OFERTANTE_CES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_ADVISORY_NOTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_PBC_VENTA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_CES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);  
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION); 
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);  
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RECOMENDACION_CES, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_PRO_MANZANA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);

		}
		
		if (isActivoTango) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoGaleon) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoThirdPartiesING) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoHYT) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoGiants) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		
		if (isActivoEgeoZeus) {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}		
		return mapa;
	}

	/**
	 * La entidad 01 para activos o lotes restringidos tiene una configuración diferente
	 * @return
	 */
	private HashMap<String,String> getMapCodigoTipoSupervisorActivoAndLoteRestEntidad01(boolean isFinanciero) {
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESULTADO_PBC, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_TANTEO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEVOLUCION_LLAVES, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		
		if(isFinanciero){
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_FINANCIERO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_FINANCIERO);
		}
		
		return mapa;
	}

	/**
	 * Si viene de una agrupación de tipo comercial y es de cajamar se aplica este filtro sobre los supervisores.
	 * 
	 * @param formalizacion: indica si tiene formalización la agrupación o no.
	 * @return Devuelve un mapa asociando las tareas del trámite y sus supervisores respectivos.
	 */
	private HashMap<String,String> getMapCodigoTipoSupervisorActivoAndLoteRestEntidad01Formalizacion(boolean formalizacion) {

		HashMap<String,String> mapa = new HashMap<String,String>();

		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_OFERTANTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);	
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_COMITE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_INSTRUCCIONES_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, GestorActivoApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_CIERRE_ECONOMICO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DOCUMENTOS_POSTVENTA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESULTADO_PBC, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_TANTEO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEVOLUCION_LLAVES, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_POSICIONAMIENTO_FIRMA, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		mapa.put(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		if(formalizacion){
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_FINANCIERO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_FINANCIERO);
		} else {
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			mapa.put(ComercialUserAssigantionService.CODIGO_T013_FIRMA_PROPIETARIO, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}

		return mapa;
	}

	// ------------------------------------------------------------------------------------------------------------
	
	 //Obtención de usuarios desde el expediente comecial
	private Usuario getGestorOrSupervisorExpedienteByCodigo(TareaExterna tareaExterna, String codigo) {
		
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		if(!Checks.esNulo(tareaActivo.getTramite().getTrabajo())) {
			
			ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(tareaActivo.getTramite().getTrabajo().getId());
			return gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, codigo);
		}
		
		return null;
	}
	
	private ActivoLoteComercial obtenerLoteComercial(TareaActivo tareaActivo){
		List<ActivoAgrupacionActivo> listaAgrupaciones = tareaActivo.getActivo().getAgrupaciones();
		if(!Checks.estaVacio(listaAgrupaciones)){
			for(ActivoAgrupacionActivo agr : listaAgrupaciones){
				DDTipoAgrupacion tipoAgrupacion = agr.getAgrupacion().getTipoAgrupacion();
				if(!Checks.esNulo(tipoAgrupacion)){
					if(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(tipoAgrupacion.getCodigo())){
						if(Checks.esNulo(agr.getAgrupacion().getFechaBaja()))
							return genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", agr.getAgrupacion().getId()));
					}
				}
			}
		}
		return null;
	}
	
	/**
	 * ¿La oferta lleguen del canal "FVD" o "Gestión directa"?
	 * Ademas comprueba que no sea financiero, ni pertenezca a la cartera cajamar
	 * HREOS-2303
	 * 
	 * @param tareaExterna
	 */
	private boolean isFuerzaVentaDirecta(TareaExterna tareaExterna) {
		boolean esFdv = false;
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		Activo activo = tareaActivo.getTramite().getTrabajo().getActivo();
		if(activo==null && tareaActivo.getTramite().getActivos().size()>0){
			activo = tareaActivo.getTramite().getActivos().get(0);
		}
		
		if (!Checks.esNulo(tareaActivo) && !Checks.esNulo(tareaActivo.getTramite())
				&& !Checks.esNulo(tareaActivo.getTramite().getTrabajo())) {
			String codCarteraActivo = !Checks.esNulo(activo)
					? (!Checks.esNulo(tareaActivo.getActivo().getCartera())
							? tareaActivo.getActivo().getCartera().getCodigo() : null)
					: null;
			boolean carteraCajaMar = false;
			if (!Checks.esNulo(tareaActivo.getTramite().getTrabajo()) && !Checks.esNulo(codCarteraActivo)
					&& DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codCarteraActivo)) {
				if (Checks.esNulo(tareaActivo.getTramite().getTrabajo().getAgrupacion())
						|| (!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getAgrupacion().getTipoAgrupacion())
								&& DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(tareaActivo.getTramite().getTrabajo()
										.getAgrupacion().getTipoAgrupacion().getCodigo())))
					carteraCajaMar = true;
			}
			ActivoBancario activoBancario = new ActivoBancario();
			if(!Checks.esNulo(activo)){
				activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
			}

			boolean esFinanciero = false;
			if (!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())
					&& activoBancario.getClaseActivo().getCodigo().equals(DDClaseActivoBancario.CODIGO_FINANCIERO)) {
				esFinanciero = true;
			}
			boolean esSingular = false;
			String tipoFormalizacion = null;
			if(!Checks.esNulo(activo)){
				tipoFormalizacion = activoApi.getCodigoTipoComercializacionFromActivo(activo);
			}
			if(!Checks.esNulo(tipoFormalizacion) && DDTipoComercializar.CODIGO_SINGULAR.equals(tipoFormalizacion)){
				esSingular = true;
			}
			
			Oferta oferta = ofertaApi.tareaExternaToOferta(tareaExterna);
			if (!Checks.esNulo(oferta)
					&& !Checks.esNulo(oferta.getPrescriptor())
					&& !Checks.esNulo(oferta.getPrescriptor().getTipoProveedor())) {
				if ((oferta.getPrescriptor().getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA) 
						|| oferta.getPrescriptor().getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_WEB_HAYA)
						|| oferta.getPrescriptor().getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_CAT)
						|| oferta.getPrescriptor().getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_SALESFORCE)
						|| oferta.getPrescriptor().getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_HAYA)
						|| oferta.getPrescriptor().getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_PORTAL_WEB))
						&& !carteraCajaMar && !esFinanciero && !esSingular) {
					esFdv = true;
				}
			}
		}
		return esFdv;
	}
	//Comprobar si el activo es de Cajamar y Financiero
	private boolean isFinancieroCajamar(TareaExterna tareaExterna) {

		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		if (!Checks.esNulo(tareaActivo) && !Checks.esNulo(tareaActivo.getTramite())
				&& !Checks.esNulo(tareaActivo.getTramite().getTrabajo())) {
			String codCarteraActivo = !Checks.esNulo(tareaActivo.getActivo())
					? (!Checks.esNulo(tareaActivo.getActivo().getCartera())
							? tareaActivo.getActivo().getCartera().getCodigo() : null)
					: null;
			boolean carteraCajaMar = false;
			if (!Checks.esNulo(tareaActivo.getTramite().getTrabajo()) && !Checks.esNulo(codCarteraActivo)
					&& DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codCarteraActivo)) {
				if (Checks.esNulo(tareaActivo.getTramite().getTrabajo().getAgrupacion())
						|| (!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getAgrupacion().getTipoAgrupacion())
								&& DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(tareaActivo.getTramite().getTrabajo()
										.getAgrupacion().getTipoAgrupacion().getCodigo())))
					carteraCajaMar = true;
			}
			Activo activo = tareaActivo.getActivo();
			if(activo==null && tareaActivo.getTramite().getActivos().size()>0){
				activo = tareaActivo.getTramite().getActivos().get(0);
			}
			ActivoBancario activoBancario = new ActivoBancario();
			if(activo != null){
				activoBancario = activoApi.getActivoBancarioByIdActivo(tareaActivo.getActivo().getId());
			}
			
			boolean esFinanciero = false;
			if (activoBancario != null && !Checks.esNulo(activoBancario.getClaseActivo())
					&& activoBancario.getClaseActivo().getCodigo().equals(DDClaseActivoBancario.CODIGO_FINANCIERO)) {
				esFinanciero = true;
			}
			if(carteraCajaMar && esFinanciero) {
				return true;
			}
		
		}
		return false;
	}
	
	// Comprobar si el activo es Con Formalización
	private boolean isConFormalizacion(TareaExterna tareaExterna) {
		boolean esConFormalizacion = false;
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		if (!Checks.esNulo(tareaActivo) && !Checks.esNulo(tareaActivo.getTramite())
				&& !Checks.esNulo(tareaActivo.getTramite().getTrabajo())) {

			Activo activo = tareaActivo.getActivo();
			if (activo == null && !tareaActivo.getTramite().getActivos().isEmpty()) {
				activo = tareaActivo.getTramite().getActivos().get(0);
			}
			PerimetroActivo perimetro = new PerimetroActivo();
			if (activo != null) {
				perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
			}

			if (perimetro != null && perimetro.getAplicaFormalizar() != null && BooleanUtils.toBoolean(perimetro.getAplicaFormalizar())) {
				esConFormalizacion = true;
			}

		}
		return esConFormalizacion;
	}
	
	// Comprobar que el activo tiene atribuciones 
	private boolean isConAtribuciones(TareaExterna tareaExterna) {
		boolean esConAtribucion = false;
		esConAtribucion = ofertaApi.checkAtribuciones(tareaExterna);
		if(esConAtribucion) {
			return true;
		}
		return false;
	}

	private boolean isActivoThirdParties(TareaActivo tareaActivo) {
		
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		return !Checks.esNulo(codCarteraActivo) && DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(codCarteraActivo);
	}
	
	/*
	 * Comprueba si reune las condiciones para usar el Gestor Controller en Cierre económico
	 */
/*	public Boolean usaGestorController(TareaActivo tareaActivo) {
		return isActivoOmega(tareaActivo) || isActivoBankia(tareaActivo) || isActivoSareb(tareaActivo)
				|| isTrabajoDeActivoOrLoteRestEntidad01(tareaActivo) || isActivoThirdParties(tareaActivo)
				|| isActivoArrow(tareaActivo) || isActivoRemaining(tareaActivo) 
				|| isFinanciero(tareaActivo.getActivo());
	}
*/
	/*
	 * Comprueba si reune las condiciones para usar el Gestor Controller en Cierre económico
	 */
	public Boolean usaGestorCierreVenta(TareaActivo tareaActivo) {
		return isActivoArrow(tareaActivo) || isActivoRemaining(tareaActivo);
	}
	
	/*
	 * Comprobar si es un activo financiero de cualquier cartera
	 */
	private Boolean isFinanciero(Activo activo) {
		Boolean esFinanciero = false;

		ActivoBancario activoBancario = null;
		if(activo != null){
			activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
		}
		
		if (activoBancario != null && activoBancario.getClaseActivo() != null
				&& activoBancario.getClaseActivo().getCodigo().equals(DDClaseActivoBancario.CODIGO_FINANCIERO)) {
			esFinanciero = true;
		}
		return esFinanciero;
	}
}
