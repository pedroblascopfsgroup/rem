package es.pfsgroup.plugin.recovery.mejoras.acuerdos;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dao.DDTipoAcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AcuerdoConfigAsuntoUsers;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDMotivoRechazoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDPeriodicidadAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoPagoAcuerdo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.termino.dao.TerminoAcuerdoDao;
import es.capgemini.pfs.termino.dao.TerminoOperacionesDao;
import es.capgemini.pfs.termino.dto.ListadoTerminosAcuerdoDto;
import es.capgemini.pfs.termino.model.DDEstadoGestionTermino;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.termino.model.TerminoOperaciones;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.ACDAcuerdoDerivaciones;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tareas.EXTDtoGenerarTareaIdividualizadaImpl;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Component
public class MEJAcuerdoManager implements MEJAcuerdoApi {
	
	static final String CODIGO_CIERRE_ACUERDO_ANUAL = "ANY";
	static final String CODIGO_CIERRE_ACUERDO_MENSUAL = "MES";
	static final String CODIGO_CIERRE_ACUERDO_SEMESTRAL = "SEI";
	static final String CODIGO_CIERRE_ACUERDO_TRIMESTRAL = "TRI";
	static final String CODIGO_CIERRE_ACUERDO_BIMESTRAL ="BI";
	static final String CODIGO_CIERRE_ACUERDO_SEMANAL = "SEM";
	static final String CODIGO_CIERRE_ACUERDO_UNICO ="UNI";
	
	static final String CODIGO_TIPO_ACUERDO_PLAN_PAGO = "PLAN_PAGO";

	public static final String BO_ACUERDO_MGR_UGAS_GUARDAR_ACUERDO = "mejacuerdomanager.guardarAcuerdo";
	public static final String BO_ACUERDO_MGR_GET_LISTADO_ACUERDOS_BY_ASU_ID = "mejacuerdomanager.getListadoAcuedosByAsuId";
	public static final String BO_ACUERDO_MGR_GET_LISTADO_CONTRATOS_ACUERDO_ASUNTO = "mejacuerdo.obtenerListadoContratosAcuerdoByAsuId";
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TERMINOS_ACUERDO_ASUNTO = "mejacuerdo.obtenerListadoTerminosAcuerdoByAcuId";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TIPO_ACUERDO = "mejacuerdo.getListTipoAcuerdo";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TIPO_PRODUCTO = "mejacuerdo.getListTipoProducto";	
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_ACUERDO = "mejacuerdo.saveTerminoAcuerdo";	
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_CONTRATO = "mejacuerdo.saveTerminoContrato";	
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_BIEN = "mejacuerdo.saveTerminoBien";		
	public static final String BO_ACUERDO_MGR_GET_LISTADO_BIENES_ASUNTO = "mejacuerdo.obtenerListadoBienesAcuerdoByAsuId";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_BIENES_TERMINO = "mejacuerdo.obtenerListadoBienesAcuerdoByTeaId";	
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_ACUERDO = "mejacuerdo.deleteTerminoAcuerdo";			
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_CONTRATO = "mejacuerdo.deleteTerminoContrato";			
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_BIEN = "mejacuerdo.deleteTerminoBien";	
	public static final String BO_ACUERDO_MGR_VIGENTE_ACUERDO = "mejacuerdoManager.vigenteAcuerdo";
	public static final String BO_ACUERDO_MGR_FINALIZAR_ACUERDO = "mejacuerdoManager.finalizarAcuerdo";
	public static final String BO_ACUERDO_MGR_ACEPTAR_ACUERDO = "mejacuerdoManager.aceptarAcuerdo";
	public static final String BO_ACUERDO_MGR_PROPONER_ACUERDO = "mejacuerdoManager.proponerAcuerdo";
	public static final String BO_ACUERDO_MGR_CANCELAR_ACUERDO = "mejacuerdoManager.cancelarAcuerdo";
	public static final String BO_ACUERDO_MGR_SAVE_ACTUACION_REALIZADA_EXPEDIENTE = "mejacuerdoManager.saveActuacionesRealizadasExpediente";
    public static final String BO_ACUERDO_MGR_ACTUALIZACIONES_REALIZADAS_EXPEDIENTE = "mejacuerdoManager.getActuacionExpediente";
	
		
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;

	@Autowired
	private AcuerdoDao acuerdoDao;
	
	@Autowired
	private TerminoAcuerdoDao terminoAcuerdoDao;
	
	@Autowired
	private TerminoOperacionesDao terminoOperacionesDao;	
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private FuncionManager funcionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private TareaNotificacionDao tareaNotificacionDao;
	
	@Autowired
	IntegracionBpmService integracionBpmService;
	
	@Autowired
	DDTipoAcuerdoDao tipoAcuerdoDao;
		
	/**
	 * Pasa un acuerdo a estado Rechazado.
	 * 
	 * @param idAcuerdo
	 *            el id del acuerdo a rechazar
	 */
	@Override
	@BusinessOperation(BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO)
	@Transactional(readOnly = false)
	public void rechazarAcuerdoMotivo(Long idAcuerdo, Long idMotivo, String observacionesMotivo) {

		EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
		DDMotivoRechazoAcuerdo motivoRechazo = genericDao.get(DDMotivoRechazoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idMotivo));
		DDEstadoAcuerdo estadoAcuerdoRechazado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_RECHAZADO);

		acuerdo.setEstadoAcuerdo(estadoAcuerdoRechazado);
		acuerdo.setFechaEstado(new Date());
		acuerdo.setMotivo(observacionesMotivo);
		if(!Checks.esNulo(motivoRechazo)){
			acuerdo.setMotivoRechazo(motivoRechazo);
		}
		acuerdoDao.save(acuerdo);
		// Cancelo las tareas del supervisor
		
		
		cancelarTareasAcuerdo(acuerdo);
		
		StringBuffer observaciones = new StringBuffer();
		observaciones.append("El acuerdo ha sido rechazado por ");
//		if(!Checks.esNulo(motivo))
//			observaciones.append(" Motivo rechazo: " + motivo);
//		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_ACUERDO_RECHAZADO,
//				observaciones.toString());
		
		GestorDespacho gesDesProp = getUsuarioDestinatarioTarea(acuerdo, "proponente");
		GestorDespacho gesDesVal = getUsuarioDestinatarioTarea(acuerdo, "validador");
		GestorDespacho gesDesDec = getUsuarioDestinatarioTarea(acuerdo, "decisor");
		
		Usuario userProponente = gesDesProp.getUsuario();
		Usuario userValidador = gesDesVal.getUsuario();
		Usuario userDecisor = gesDesDec.getUsuario();
		
			////Es validador
			if(usuarioLogadoEsDelTipoDespacho(gesDesDec.getDespachoExterno().getTipoDespacho())){
				
				observaciones.append(userDecisor.getNombre()+" ");
				if(!Checks.esNulo(observacionesMotivo)) observaciones.append(" Debido a " + observacionesMotivo);
				
				try {
						crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observaciones.toString(), userValidador.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Rechazado del acuerdo por parte del decisor");
					if(!userValidador.equals(userProponente)){
						crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observaciones.toString(), userProponente.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Rechazado del acuerdo por parte del decisor");
					}
				} catch (EXTCrearTareaException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			////Es decisor
			}else if(usuarioLogadoEsDelTipoDespacho(gesDesVal.getDespachoExterno().getTipoDespacho())){
			
				observaciones.append(userValidador.getNombre()+" ");
				if(!Checks.esNulo(observacionesMotivo)) observaciones.append(" Debido a " + observacionesMotivo);
				
				try {
					crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observaciones.toString(), userProponente.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Rechazado del acuerdo por parte del validador");
				} catch (EXTCrearTareaException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		
		
		
	}

	
	private void cancelarTareasAcuerdo(Acuerdo acuerdo) {
		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if ( SubtipoTarea.CODIGO_ACEPTACION_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea()) || SubtipoTarea.CODIGO_REVISION_ACUERDO_ACEPTADO.equals(tarea.getSubtipoTarea().getCodigoSubtarea()) || SubtipoTarea.CODIGO_ACUERDO_GESTIONES_CIERRE.equals(tarea.getSubtipoTarea().getCodigoSubtarea()) || SubtipoTarea.CODIGO_CUMPLIMIENTO_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
				if(tarea.getTareaFinalizada()==null || !tarea.getTareaFinalizada()){
					EXTTareaNotificacion tareaNot = genericDao.get(EXTTareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "id", tarea.getId()));
					tareaNot.setTareaFinalizada(true);
					tareaNot.setFechaFin(new Date());
					tareaNotificacionDao.save(tareaNot);
				}
			}
		}
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_EXT_ACUERDO_MGR_GUARDAR_ACUERDO)
	public Long guardarAcuerdo(DtoAcuerdo dto) {

		// NO PUEDE HABER OTROS ACUERDOS VIGENTES.
		if (DDEstadoAcuerdo.ACUERDO_ACEPTADO.equals(dto.getEstado()) && acuerdoDao.hayAcuerdosVigentes(dto.getIdAsunto(), dto.getIdAcuerdo())) {
			throw new BusinessOperationException("acuerdos.hayOtrosVigentes");
		}
		
		Usuario user = usuarioManager.getUsuarioLogado();
		
		EXTAcuerdo acuerdo;
		if (dto.getIdAcuerdo() == null) {
			acuerdo = new EXTAcuerdo();
			acuerdo.setFechaPropuesta(new Date());
			acuerdo.setProponente(user);
			
		} else {
			acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdAcuerdo()));
		}
		
		
		if(!dto.esPropuesta()){
			
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getIdAsunto());
			
			acuerdo.setAsunto(asunto);
			
			Order order = new Order(OrderType.ASC, "id");
			List<EXTGestorAdicionalAsunto> gestoresAsunto =  genericDao.getListOrdered(EXTGestorAdicionalAsunto.class,order, genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id", user.getId()), genericDao.createFilter(FilterType.EQUALS, "asunto.id",asunto.getId()));
			
			if(gestoresAsunto.size()==0){
				///No esta asignado el usuario como proponente al asunto
		        
				///Obtenemos el tipo de gestor
				EXTDDTipoGestor tipoGestorProponente = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROPONENTE_ACUERDO));
				
				///Obtenemos el despacho externo
				Order orderGestDes = new Order(OrderType.ASC, "id");
				List<GestorDespacho> gestdesp = genericDao.getListOrdered(GestorDespacho.class,orderGestDes, genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId()));
		        
		        try {
		        	///Asignamos el gestor al asunto
					if(gestdesp!=null && gestdesp.size()>0){
						proxyFactory.proxy(coreextensionApi.class).insertarGestorAdicionalAsunto(tipoGestorProponente.getId(),asunto.getId(),user.getId(), gestdesp.get(0).getDespachoExterno().getId());
						gestoresAsunto =  genericDao.getListOrdered(EXTGestorAdicionalAsunto.class,order, genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id", user.getId()), genericDao.createFilter(FilterType.EQUALS, "asunto.id",asunto.getId()));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			EXTGestorAdicionalAsunto gestorAsunto = null;
			if(gestoresAsunto.size()==1){
				gestorAsunto = gestoresAsunto.get(0);
			}else if(gestoresAsunto.size()>1){
				gestorAsunto = gestoresAsunto.get(0);
				for(EXTGestorAdicionalAsunto gaa : gestoresAsunto){
					if(gaa.getGestor().getGestorPorDefecto()){
						gestorAsunto = gaa;
						break;
					}
				}
			}

			if(gestorAsunto != null){
				acuerdo.setGestorDespacho(gestorAsunto.getGestor());
			}

		} else {
			Expediente exp = genericDao.get(Expediente.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdExpediente()));
			if(!Checks.esNulo(exp)) acuerdo.setExpediente(exp);
		}

		
		
		DDEstadoAcuerdo estadoAcuerdo = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAcuerdo.class, dto.getEstado());
		acuerdo.setEstadoAcuerdo(estadoAcuerdo);
		acuerdo.setFechaEstado(new Date());
		if (dto.getImportePago() != null) {
			acuerdo.setImportePago(Double.valueOf(dto.getImportePago()));
		}
		acuerdo.setObservaciones(dto.getObservaciones());
		DDSolicitante solicitante = (DDSolicitante) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDSolicitante.class, dto.getSolicitante());
		acuerdo.setSolicitante(solicitante);
		DDTipoAcuerdo tipoAcuerdo = (DDTipoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoAcuerdo.class, dto.getTipoAcuerdo());
		acuerdo.setTipoAcuerdo(tipoAcuerdo);
		if (dto.getTipoPago() != null) {
			DDTipoPagoAcuerdo tipoPagoAcuerdo = (DDTipoPagoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoPagoAcuerdo.class, dto.getTipoPago());

			acuerdo.setTipoPagoAcuerdo(tipoPagoAcuerdo);
		}
		if (dto.getPeriodicidad() != null) {
			DDPeriodicidadAcuerdo periodicidadAcuerdo = (DDPeriodicidadAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDPeriodicidadAcuerdo.class, dto.getPeriodicidad());
			acuerdo.setPeriodicidadAcuerdo(periodicidadAcuerdo);
		}
		acuerdo.setPeriodo(dto.getPeriodo());
		

		// Fecha limite
		SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy");
		try {
			if(dto.getFechaLimite()!= null && !"".equals(dto.getFechaLimite())){
				acuerdo.setFechaLimite(sdf2.parse(dto.getFechaLimite()));
			}
		} catch (ParseException e) {
			logger.error("Error parseando la fecha", e);
		}		
		
		if (!Checks.esNulo(dto.getImporteCostas())) {
			acuerdo.setImporteCostas(dto.getImporteCostas());
		}
		
		acuerdoDao.saveOrUpdate(acuerdo);
		
		
		return acuerdo.getId();
	}
	
	/**
     * @param id Long
     * @return Acuerdo
     */
    @BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_ACUERDOS_BY_ASU_ID)
    public List<EXTAcuerdo> getAcuerdosDelAsunto(Long id) {
        logger.debug("Obteniendo acuerdos del asunto" + id);
        Order order = new Order(OrderType.ASC, "id");
        return (List<EXTAcuerdo>) genericDao.getListOrdered(EXTAcuerdo.class,order, genericDao.createFilter(FilterType.EQUALS, "asunto.id", id));
    }
    
	/**
	 * Obtiene un listados de los contratos de los acuerdos de un asunto
	 * 
	 * @param idAsunto
	 *            el id del asunto
	 */
    @BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_CONTRATOS_ACUERDO_ASUNTO)
    public List<Contrato> obtenerListadoContratosAcuerdoByAsuId(Long idAsunto) {
        logger.debug("Obteniendo contratos del asunto" + idAsunto);
        //List<EXTContrato> listaContratosAsunto;
        Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		List<Contrato> listaContratosAsunto = new ArrayList<Contrato>();
		if (!Checks.esNulo(asunto)) {
			listaContratosAsunto.addAll(asunto.getContratos());
		}

        return listaContratosAsunto;
        //return (List<EXTContrato>) genericDao.getList(EXTContrato.class, genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto));
    } 
    
	/**
	 * Obtiene un listado de los terminos asociados a un acuerdo
	 * 
	 *  
	 * @param idAcuerdo
	 *            el id del acuerdo
	 */
    @BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_TERMINOS_ACUERDO_ASUNTO)
    public List<ListadoTerminosAcuerdoDto> obtenerListadoTerminosAcuerdoByAcuId(Long idAcuerdo) {
        logger.debug("Obteniendo terminos del acuerdo" + idAcuerdo);
        ArrayList<TerminoAcuerdo> listaTerminosAcuerdo =  (ArrayList<TerminoAcuerdo>) genericDao.getList(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "acuerdo.id", idAcuerdo));
        ArrayList<ListadoTerminosAcuerdoDto> terminosAcuerdos = new ArrayList<ListadoTerminosAcuerdoDto>(); 
        for (TerminoAcuerdo termino : listaTerminosAcuerdo) {
        	ListadoTerminosAcuerdoDto dtoTerAcu = new ListadoTerminosAcuerdoDto();
        	dtoTerAcu.setId(termino.getId());
        	dtoTerAcu.setComisiones(termino.getComisiones());
        	dtoTerAcu.setImporte(termino.getImporte());
        	dtoTerAcu.setTipoAcuerdo(termino.getTipoAcuerdo());
        	dtoTerAcu.setSubTipoAcuerdo(termino.getSubtipoAcuerdo());
        	
        	List<TerminoContrato> listaContratosTermino = (List<TerminoContrato>) genericDao.getList(TerminoContrato.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", termino.getId()));
        	ArrayList<EXTContrato> listaContratos = new ArrayList<EXTContrato>();
        	for (TerminoContrato terminoCnt : listaContratosTermino) {
        		listaContratos.add((EXTContrato)terminoCnt.getContrato());
        	}
        	
        	dtoTerAcu.setContratosTermino(listaContratos);
        	
        	dtoTerAcu.setEstadoGestion(termino.getEstadoGestion());
        	
        	terminosAcuerdos.add(dtoTerAcu);
        }
 
        return terminosAcuerdos;

    }   
    
    /**
     * 
     * Obtiene el listado de los tipos de acuerdo
     * 
     * @return
     */
	@BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_TIPO_ACUERDO)
	public List<DDTipoAcuerdo> getListTipoAcuerdo(String entidad) {

		//Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		DDEntidadAcuerdo fambito = null;
		DDEntidadAcuerdo fambitoAmbas = genericDao.get(DDEntidadAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEntidadAcuerdo.CODIGO_ENTIDAD_AMBAS));
		
		if(entidad.equals("asunto")){
			fambito = genericDao.get(DDEntidadAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEntidadAcuerdo.CODIGO_ENTIDAD_ASUNTO));
		}else if(entidad.equals("expediente")){
			fambito = genericDao.get(DDEntidadAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEntidadAcuerdo.CODIGO_ENTIDAD_EXPEDIENTE));
		}
		//List<DDTipoAcuerdo> listado = (ArrayList<DDTipoAcuerdo>) genericDao.getList(DDTipoAcuerdo.class, fBorrado, fambito);
		List<DDTipoAcuerdo> listado = tipoAcuerdoDao.buscarTipoAcuerdoPorFiltro(fambito.getId(), fambitoAmbas.getId());
		
		return listado;
	}   
	
    /**
     * 
     * Obtiene el listado de los subtipos de acuerdo
     * 
     * @return
     */
	@BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_SUB_TIPO_ACUERDO)
	public List<DDSubTipoAcuerdo> getListSubTipoAcuerdo() {

		Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDSubTipoAcuerdo> listado = (ArrayList<DDSubTipoAcuerdo>) genericDao.getList(DDSubTipoAcuerdo.class, fBorrado);

		return listado;
	} 
	
	   /**
     * 
     * Obtiene el listado de los tipos de acuerdo
     * 
     * @return
     */
	@BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_TIPO_PRODUCTO)
	public List<DDTipoProducto> getListTipoProducto() {

		Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDTipoProducto> listado = (ArrayList<DDTipoProducto>) genericDao.getList(DDTipoProducto.class, fBorrado);

		return listado;
	}  
	
	/**
     * @param ta TerminoAcuerdo
     * @return 
     */
    @BusinessOperation(BO_ACUERDO_MGR_SAVE_TERMINO_ACUERDO)
    @Transactional(readOnly = false)
    public TerminoAcuerdo saveTerminoAcuerdo(TerminoAcuerdo ta) {

    	terminoAcuerdoDao.saveOrUpdate(ta);    	
    	integracionBpmService.enviarDatos(ta);

    	return ta;

    }	
    
	/**
     * @param tc TerminoContrato
     * @return 
     */
    @BusinessOperation(BO_ACUERDO_MGR_SAVE_TERMINO_CONTRATO)
    @Transactional(readOnly = false)
    public void saveTerminoContrato(TerminoContrato tc) {
    	genericDao.save(TerminoContrato.class, tc);
    }	
    
	/**
     * @param tb TerminoBien
     * @return 
     */
    @BusinessOperation(BO_ACUERDO_MGR_SAVE_TERMINO_BIEN)
    @Transactional(readOnly = false)
    public void saveTerminoBien(TerminoBien tb) {
    	genericDao.save(TerminoBien.class, tb);
    }	    
    
	/**
	 * Obtiene un listados de los bienes asociados a los procedimientos
	 * de una asunto
	 * 
	 * @param idAsunto  el id del asunto
	 * 
	 */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	@BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_BIENES_ASUNTO)
    public List<Bien> obtenerListadoBienesAcuerdoByAsuId(Long idAsunto) {
        logger.debug("Obteniendo bienes asociados a un asunto" + idAsunto);
        //List<EXTContrato> listaContratosAsunto;        
        Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
        List<Procedimiento> listaProcsAsunto = asunto.getProcedimientos();
        TreeMap<Long, Bien> bienesAsuntoMap = new TreeMap<Long, Bien>();
        List<Bien> listaBienesProc;        
        
        // Obtenemos los bienes asociados a cada procedimiento
        for (Procedimiento proc : listaProcsAsunto) {
        	listaBienesProc = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, proc.getId());
        	
        	// Recorremos los bienes y los guardamos en un TreeMap para que no se almacenen duplicados
        	for (Bien bien : listaBienesProc){
        		bienesAsuntoMap.put(bien.getId(), bien);
        	}		
		}

        // Convertir el Map con los bienes en una lista
        List<Bien> listaBienesAsunto = new ArrayList<Bien>();
        Bien bienL;
        for(Iterator it = bienesAsuntoMap.keySet().iterator(); it.hasNext();) {
        	bienL = (Bien)it.next();
        	listaBienesAsunto.add(bienL);
       	}        
        
        return listaBienesAsunto;
    } 

    /**
     * Obtiene la lista de los bienes asociados a un termino
     * 
     * @param idTermino
     * 
     */   
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_BIENES_TERMINO)
	public List<Bien> obtenerListadoBienesAcuerdoByTeaId(Long idTermino) {
        logger.debug("Obteniendo bienes asociados a un termino" + idTermino);
        List<Bien> listaBienesT = new ArrayList<Bien>();
        
    	List<TerminoBien> listaBienesTermino = (List<TerminoBien>) genericDao.getList(TerminoBien.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTermino));
    	Bien bien;
    	for (TerminoBien tb : listaBienesTermino){
    		bien = tb.getBien();
    		listaBienesT.add(bien);
    	}
        
        return listaBienesT;
		
	}; 
	
	/**
     * @param ta TerminoAcuerdo
     * @return 
     */
    @BusinessOperation(BO_ACUERDO_MGR_DELETE_TERMINO_ACUERDO)
    @Transactional(readOnly = false)
    public void deleteTerminoAcuerdo(TerminoAcuerdo ta) {
    	genericDao.deleteById(TerminoAcuerdo.class, ta.getId());
    	
		integracionBpmService.enviarDatos(ta);
	}	
    
	/**
     * @param to TerminoOperaciones
     * @return 
     */
    @BusinessOperation(BO_ACUERDO_MGR_DELETE_TERMINO_OPERACIONES)
    @Transactional(readOnly = false)
    public void deleteTerminoOperaciones(TerminoOperaciones to) {
    	//genericDao.deleteById(TerminoAcuerdo.class, ta.getId());
    	terminoOperacionesDao.delete(to);
    }	    
    
	/**
     * @param tc TerminoContrato
     * @return 
     */
    @BusinessOperation(BO_ACUERDO_MGR_DELETE_TERMINO_CONTRATO)
    @Transactional(readOnly = false)
    public void deleteTerminoContrato(TerminoContrato tc) {
    	genericDao.deleteById(TerminoContrato.class, tc.getId());
    }	  	    
    
	/**
     * @param tb TerminoBien
     * @return 
     */
    @BusinessOperation(BO_ACUERDO_MGR_DELETE_TERMINO_BIEN)
    @Transactional(readOnly = false)
    public void deleteTerminoBien(TerminoBien tb) {
    	genericDao.deleteById(TerminoBien.class, tb.getId());
    }

    @BusinessOperation(BO_ACUERDO_MGR_GET_TERMINO_ACUERDO)
	public TerminoAcuerdo getTerminoAcuerdo(Long idTermino) {
    	return genericDao.get(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idTermino));
	}	  
    
    
    /**
     * Pasa un acuerdo a estado Vigente.
     * @param idAcuerdo el id del acuerdo a aceptar.
     * @throws EXTCrearTareaException 
     */
    @BusinessOperation(BO_ACUERDO_MGR_VIGENTE_ACUERDO)
    @Transactional(readOnly = false)
    public void vigenteAcuerdo(Long idAcuerdo) throws EXTCrearTareaException {
        EXTAcuerdo acuerdo =  genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
        //NO PUEDE HABER OTROS ACUERDOS VIGENTES.
        if (acuerdoDao.hayAcuerdosVigentes(acuerdo.getAsunto().getId(), idAcuerdo)) { throw new BusinessOperationException(
                "acuerdos.hayOtrosVigentes"); }
        DDEstadoAcuerdo estadoAcuerdoVigente = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_VIGENTE);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoVigente);
        acuerdo.setFechaEstado(new Date());
        
        //Cancelo las tareas
        cancelarTareasAcuerdo(acuerdo);

        
		
		GestorDespacho gestorDespachoProponente = getUsuarioDestinatarioTarea(acuerdo, "proponente");
		GestorDespacho gestorDespachoValidador = getUsuarioDestinatarioTarea(acuerdo, "validador");
		GestorDespacho gestorDespachoDecisor = getUsuarioDestinatarioTarea(acuerdo, "decisor");
		 
		///Obtenemos el letrado del asunto
		Usuario letradoAsunto = obtenerLetradoDelAsunto(acuerdo.getAsunto().getId());
		

    	Long idJBPM = crearTarea(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, "Gestiones de cierre del acuerdo "+acuerdo.getId(), gestorDespachoProponente.getUsuario().getId(), true, SubtipoTarea.CODIGO_ACUERDO_GESTIONES_CIERRE, acuerdo.getFechaLimite());
        acuerdo.setIdJBPM(idJBPM);	
        EXTSubtipoTarea subtipotarea = genericDao.get(EXTSubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", SubtipoTarea.CODIGO_ACUERDO_GESTIONES_CIERRE));
        try {
			proxyFactory.proxy(coreextensionApi.class).insertarGestorAdicionalAsunto(subtipotarea.getTipoGestor().getId(),acuerdo.getAsunto().getId(),gestorDespachoProponente.getUsuario().getId(), gestorDespachoProponente.getDespachoExterno().getId());
		} catch (Exception e) {
			e.printStackTrace();
		}
        
        ////Comprobamos si tiene el termino plan de pagos
        List<TerminoAcuerdo> terminosPlanPago = genericDao.getList(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "acuerdo.id", idAcuerdo), genericDao.createFilter(FilterType.EQUALS, "tipoAcuerdo.codigo", CODIGO_TIPO_ACUERDO_PLAN_PAGO));
        if(terminosPlanPago.size()>0){
        	Date fechaPlnPg = new Date();
        	if(terminosPlanPago.get(0).getOperaciones().getFechaPlanPago() != null){fechaPlnPg = terminosPlanPago.get(0).getOperaciones().getFechaPlanPago();}
        	Long idJBPMplpg = crearTarea(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, "Cumplimiento del acuerdo "+acuerdo.getId(), gestorDespachoProponente.getUsuario().getId(), true, SubtipoTarea.CODIGO_CUMPLIMIENTO_ACUERDO, fechaPlnPg);
            acuerdo.setIdJBPM(idJBPMplpg);	
            EXTSubtipoTarea subtipotareaPlnPg = genericDao.get(EXTSubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", SubtipoTarea.CODIGO_CUMPLIMIENTO_ACUERDO));
            try {
    			proxyFactory.proxy(coreextensionApi.class).insertarGestorAdicionalAsunto(subtipotareaPlnPg.getTipoGestor().getId(),acuerdo.getAsunto().getId(),gestorDespachoProponente.getUsuario().getId(), gestorDespachoProponente.getDespachoExterno().getId());
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
            
        }
        
        
		if(letradoAsunto!=null){

			String observacionesLetrado = "Tras la aprobaci�n por parte de "+gestorDespachoDecisor.getUsuario().getNombre()+" el acuerdo ha pasado a estado vigente. Deber�a analizar si es necesario paralizar o finalizar alg�n tr�mite pendiente del acreditado.";
			crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesLetrado, letradoAsunto.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Aprobaci�n del acuerdo por el decisor");
		}
		
		String observaciones = "Tras la aprobaci�n por parte de "+gestorDespachoDecisor.getUsuario().getNombre()+" el acuerdo ha pasado a estado vigente.";
		if(gestorDespachoValidador != null){
			crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observaciones, gestorDespachoValidador.getUsuario().getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Aprobaci�n del acuerdo por el decisor");
		}
		
		if(gestorDespachoProponente != null && !(usuarioLogadoEsDelTipoDespacho(gestorDespachoProponente.getDespachoExterno().getTipoDespacho()) && usuarioLogadoEsDelTipoDespacho(gestorDespachoValidador.getDespachoExterno().getTipoDespacho()))){
			crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observaciones, gestorDespachoProponente.getUsuario().getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Aprobaci�n del acuerdo por el decisor");
		}
    	
        

        acuerdoDao.save(acuerdo);
    }
    
    
    @BusinessOperation(BO_ACUERDO_MGR_GET_TIPOS_DESPACHO_ACUERDO_ASUNTO)
    @Transactional(readOnly = false)
	public  Map<String, DDTipoDespachoExterno> getTiposDespachoAcuerdoAsunto(Long idTipoDespachoProponente) {
    	
    	AcuerdoConfigAsuntoUsers config = null; 
    			
    	if(!Checks.esNulo(idTipoDespachoProponente)){
    		config = genericDao.get(AcuerdoConfigAsuntoUsers.class, genericDao.createFilter(FilterType.EQUALS, "proponente.id", idTipoDespachoProponente));	
    	}   	
    	
    	Map<String, DDTipoDespachoExterno> tiposDespacho = new HashMap<String, DDTipoDespachoExterno>();
    	
    	if(!Checks.esNulo(config)){
    		tiposDespacho.put("proponente", config.getProponente());
    		tiposDespacho.put("validador", config.getValidador());
    		tiposDespacho.put("decisor", config.getDecisor());	
    	}
    	
    	
    	return tiposDespacho;
    	
	}

    @BusinessOperation(BO_ACUERDO_MGR_GET_PUEDE_EDITAR_ACUERDO_ASUNTO)
    @Transactional(readOnly = false)
	public boolean puedeEditar(Long idAcuerdo) {
    	
    	EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
    	Usuario user = usuarioManager.getUsuarioLogado();
    	
    	if(acuerdo.getEstadoAcuerdo().getId().equals(Long.parseLong(DDEstadoAcuerdo.ACUERDO_EN_CONFORMACION)) && user.getId().equals(acuerdo.getProponente().getId())){
    		return true;
    	}
    	
    	
    	Map<String, DDTipoDespachoExterno> config = null;
    	
    	
    	if(acuerdo.getGestorDespacho() !=null && acuerdo.getGestorDespacho().getDespachoExterno() !=null && acuerdo.getGestorDespacho().getDespachoExterno().getTipoDespacho() !=null){
    		DDTipoDespachoExterno tipoDespachoProponente = acuerdo.getGestorDespacho().getDespachoExterno().getTipoDespacho();
    		config =  getTiposDespachoAcuerdoAsunto(tipoDespachoProponente.getId());
    	}
	
    	Order order = new Order(OrderType.ASC, "id");
		List<EXTGestorAdicionalAsunto> gestoresAsunto =  genericDao.getListOrdered(EXTGestorAdicionalAsunto.class,order, genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id", user.getId()), genericDao.createFilter(FilterType.EQUALS, "asunto.id",acuerdo.getAsunto().getId()));
		
		DDTipoDespachoExterno extTipoDespachoAsunto = null;

		if(gestoresAsunto.size()==1){
			
			extTipoDespachoAsunto = gestoresAsunto.get(0).getGestor().getDespachoExterno().getTipoDespacho();
			
		}else if(gestoresAsunto.size()>1){
			
			extTipoDespachoAsunto = gestoresAsunto.get(0).getGestor().getDespachoExterno().getTipoDespacho();
			for(EXTGestorAdicionalAsunto gaa : gestoresAsunto){
				if(gaa.getGestor().getGestorPorDefecto()){
					extTipoDespachoAsunto = gaa.getGestor().getDespachoExterno().getTipoDespacho();
					break;
				}
			}
		}
    	
    	if(extTipoDespachoAsunto!=null && config!=null && acuerdo.getEstadoAcuerdo().getId().equals(Long.parseLong(DDEstadoAcuerdo.ACUERDO_PROPUESTO)) && (extTipoDespachoAsunto.getId().equals(config.get("validador").getId())  || extTipoDespachoAsunto.getId().equals(config.get("decisor").getId()))){
    		return true;
    	}
    	
    	if(extTipoDespachoAsunto!=null && config!=null && acuerdo.getEstadoAcuerdo().getId().equals(Long.parseLong(DDEstadoAcuerdo.ACUERDO_ACEPTADO)) && extTipoDespachoAsunto.getId().equals(config.get("decisor").getId())){
    		return true;
    	}
    	
		return false;
	}
    
    
    /**
     * Pasa un acuerdo a estado Finalizado.
     * @param idAcuerdo el id del acuerdo a finalizar
     */
    @BusinessOperation(BO_ACUERDO_MGR_FINALIZAR_ACUERDO)
    @Transactional(readOnly = false)
    public void finalizarAcuerdo(Long id, String fechaPago, String cumplidoSiNO, String observaciones) {
    	
    	boolean cumplido = false;
		if(DDSiNo.SI.equals(cumplidoSiNO)){
			cumplido = true;
		}
        
        EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
        
        if (acuerdo.getEstadoAcuerdo().getCodigo() == DDEstadoAcuerdo.ACUERDO_CANCELADO) { throw new BusinessOperationException("acuerdos.cancelado"); }
        
		Usuario userValidador = getUsuarioDestinatarioTarea(acuerdo, "validador").getUsuario();
		Usuario userDecisor = getUsuarioDestinatarioTarea(acuerdo, "decisor").getUsuario();
		Usuario userProponente = getUsuarioDestinatarioTarea(acuerdo, "proponente").getUsuario();
		Usuario userLetrado = obtenerLetradoDelAsunto(acuerdo.getAsunto().getId());
		
		List<TerminoAcuerdo> terminosPlanPagoDacionCompraventa = genericDao.getList(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "acuerdo.id", id), genericDao.createFilter(FilterType.EQUALS, "tipoAcuerdo.codigo", "DA_CV"));
        
        String estado = null;
        if(cumplido){
        	estado = DDEstadoAcuerdo.ACUERDO_CUMPLIDO;
        	String observacionesPropDeci = userProponente.getNombre()+" ha dado por cumplido el acuerdo";
        	String observacionesLet = userProponente.getNombre()+" ha dado por cumplido el acuerdo. Deber�a analizar si es necesario finalizar alg�n tr�mite pendiente del acreditado";
        	String observacionesLetDacionCompraventa = "Ha finalizado el t�rmino de Daci�n / Compra venta, del acuerdo. Por favor compruebe si corresponde iniciar el tr�mite 'Tr�mite de mandamiento de cancelaci�n de cargas'";

        	try {
				crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesPropDeci, userValidador.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Cumplimiento del acuerdo por el proponente");
				crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesPropDeci, userDecisor.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Cumplimiento del acuerdo por el proponente");
				if(terminosPlanPagoDacionCompraventa.size() > 0){
					if(!Checks.esNulo(userLetrado)){crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesLetDacionCompraventa, userLetrado.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Cumplimiento del acuerdo por el proponente");}
				}else{
					if(!Checks.esNulo(userLetrado)){crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesLet, userLetrado.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Cumplimiento del acuerdo por el proponente");}
				}
				
			} catch (EXTCrearTareaException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }else{
        	estado = DDEstadoAcuerdo.ACUERDO_INCUMPLIDO;
        	String observacionesPropDeci = userProponente.getNombre()+" ha dado por incumplido el acuerdo. Observaciones: "+observaciones;
        	String observacionesLet = userProponente.getNombre()+" ha dado por incumplido el acuerdo. Deber�a analizar si es necesario desparalizar alg�n tr�mite pendiente del acreditado o iniciar un nuevo tr�mite";

			try {
				crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesPropDeci, userValidador.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Incumplimiento del acuerdo por el proponente");
				crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesPropDeci, userDecisor.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Incumplimiento del acuerdo por el proponente");
				if(!Checks.esNulo(userLetrado)){crearNotificacion(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, observacionesLet, userLetrado.getId(), true, EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS, null,"Incumplimiento del acuerdo por el proponente");}
			} catch (EXTCrearTareaException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
        
        Date fechaEstado = null;
        if(!Checks.esNulo(fechaPago)){
        	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        	try {
				fechaEstado =  formatter.parse(fechaPago);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }else{
        	fechaEstado = new Date();
        }
        
        DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, estado);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);
        acuerdo.setFechaEstado(fechaEstado);
        acuerdoDao.save(acuerdo);
        //Cancelo las tareas 
        cancelarTareasAcuerdo(acuerdo);
        

    }
    
    /**
     * Pasa un Acuerdo en estado En Conformación a Propuesto.
     * @param idAcuerdo el id del acuerdo
     * @throws EXTCrearTareaException 
     */
    @BusinessOperation(BO_ACUERDO_MGR_PROPONER_ACUERDO)
    @Transactional(readOnly = false)
    public void proponerAcuerdo(Long idAcuerdo) throws EXTCrearTareaException {
        EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
        DDEstadoAcuerdo estadoAcuerdoPropuesto = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_PROPUESTO);
        acuerdo.setEstadoAcuerdo(estadoAcuerdoPropuesto);    

		GestorDespacho gestorDespachoProponente = getUsuarioDestinatarioTarea(acuerdo, "proponente");
		GestorDespacho gestorDespachoValidador = getUsuarioDestinatarioTarea(acuerdo, "validador");
		GestorDespacho gestorDespachoDecisor = getUsuarioDestinatarioTarea(acuerdo, "decisor");
		
		acuerdoDao.save(acuerdo);
		
		if(!Checks.esNulo(gestorDespachoDecisor) && !Checks.esNulo(gestorDespachoValidador) && !Checks.esNulo(gestorDespachoProponente) && usuarioLogadoEsDelTipoDespacho(gestorDespachoDecisor.getDespachoExterno().getTipoDespacho())){
			vigenteAcuerdo(acuerdo.getId());
		}else if(!Checks.esNulo(gestorDespachoDecisor) && !Checks.esNulo(gestorDespachoValidador) && !Checks.esNulo(gestorDespachoProponente) && usuarioLogadoEsDelTipoDespacho(gestorDespachoValidador.getDespachoExterno().getTipoDespacho())){
			aceptarAcuerdo(acuerdo.getId());
		}else if(!Checks.esNulo(gestorDespachoProponente) && !Checks.esNulo(gestorDespachoValidador) && usuarioLogadoEsDelTipoDespacho(gestorDespachoProponente.getDespachoExterno().getTipoDespacho())){
			
	    	Calendar calendar = new GregorianCalendar();
	    	calendar.add(Calendar.DAY_OF_MONTH, 15);

	    	Long idJBPM = crearTarea(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, "Aceptaci�n del acuerdo "+acuerdo.getId(), gestorDespachoValidador.getUsuario().getId(), true, SubtipoTarea.CODIGO_ACEPTACION_ACUERDO, calendar.getTime());

	        acuerdo.setIdJBPM(idJBPM);	
	        acuerdoDao.save(acuerdo);
	        EXTSubtipoTarea subtipotarea = genericDao.get(EXTSubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", SubtipoTarea.CODIGO_ACEPTACION_ACUERDO));
	        try {
				proxyFactory.proxy(coreextensionApi.class).insertarGestorAdicionalAsunto(subtipotarea.getTipoGestor().getId(),acuerdo.getAsunto().getId(),gestorDespachoValidador.getUsuario().getId(), gestorDespachoValidador.getDespachoExterno().getId());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		

    
    }
    
    /**
     * Pasa un acuerdo a estado Aceptado.
     * @param idAcuerdo el id del acuerdo a aceptar.
     * @throws EXTCrearTareaException 
     */
    @BusinessOperation(BO_ACUERDO_MGR_ACEPTAR_ACUERDO)
    @Transactional(readOnly = false)
    public void aceptarAcuerdo(Long idAcuerdo) throws EXTCrearTareaException {
    	EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
        //NO PUEDE HABER OTROS ACUERDOS VIGENTES.
        if (acuerdoDao.hayAcuerdosVigentes(acuerdo.getAsunto().getId(), idAcuerdo)) { throw new BusinessOperationException(
                "acuerdos.hayOtrosVigentes"); }
        DDEstadoAcuerdo estadoAcuerdoVigente = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_ACEPTADO);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoVigente);
        acuerdo.setFechaEstado(new Date());
        //Cancelo las tareas
        cancelarTareasAcuerdo(acuerdo);
        
		GestorDespacho gestorDespachoValidador = getUsuarioDestinatarioTarea(acuerdo, "validador");
		GestorDespacho gestorDespachoDecisor = getUsuarioDestinatarioTarea(acuerdo, "decisor");
		 
		acuerdoDao.save(acuerdo);
		
		if(usuarioLogadoEsDelTipoDespacho(gestorDespachoDecisor.getDespachoExterno().getTipoDespacho())){
			
			vigenteAcuerdo(acuerdo.getId());
			
		}else if(usuarioLogadoEsDelTipoDespacho(gestorDespachoValidador.getDespachoExterno().getTipoDespacho())){
			
	    	Calendar calendar = new GregorianCalendar();
	    	calendar.add(Calendar.DAY_OF_MONTH, 15);

	    	Long idJBPM = crearTarea(acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, "Revisi�n del acuerdo aceptado "+acuerdo.getId(), gestorDespachoDecisor.getUsuario().getId(), true, SubtipoTarea.CODIGO_REVISION_ACUERDO_ACEPTADO, calendar.getTime());

	        acuerdo.setIdJBPM(idJBPM);
	        acuerdoDao.save(acuerdo);
	        EXTSubtipoTarea subtipotarea = genericDao.get(EXTSubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", SubtipoTarea.CODIGO_REVISION_ACUERDO_ACEPTADO));
	        try {
				proxyFactory.proxy(coreextensionApi.class).insertarGestorAdicionalAsunto(subtipotarea.getTipoGestor().getId(),acuerdo.getAsunto().getId(),gestorDespachoDecisor.getUsuario().getId(), gestorDespachoDecisor.getDespachoExterno().getId());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}  
       
    }
    
    
    /**
     * Pasa un Acuerdo en estado En Conformación a Cancelado.
     * @param idAcuerdo el id del acuerdo
     */
    @BusinessOperation(BO_ACUERDO_MGR_CANCELAR_ACUERDO)
    @Transactional(readOnly = false)
    public void cancelarAcuerdo(Long idAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        DDEstadoAcuerdo estadoAcuerdoCancelado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_CANCELADO);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoCancelado);

        cancelarTareasAcuerdo(acuerdo);

        acuerdoDao.save(acuerdo);
    }
    
	@Override
	@BusinessOperation(BO_ACUERDO_MGR_CONTINUAR_ACUERDO)
	@Transactional(readOnly = false)
	public void continuarAcuerdo(Long id) {
		Acuerdo acuerdo = acuerdoDao.get(id);
		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if (SubtipoTarea.CODIGO_CUMPLIMIENTO_ACUERDO.equals(tarea
					.getSubtipoTarea().getCodigoSubtarea()) && (tarea.getTareaFinalizada()==null || !tarea.getTareaFinalizada())) {

				String codigo = PlazoTareasDefault.CODIGO_CIERRE_ACUERDO;
				
				///Obtenemos el plan de pago
				List<TerminoAcuerdo> plansDePago = terminoAcuerdoDao.buscarTerminosPorTipo(acuerdo.getId(), CODIGO_TIPO_ACUERDO_PLAN_PAGO);
				
				if(!Checks.esNulo(plansDePago.get(0)) && !Checks.esNulo(plansDePago.get(0).getOperaciones().getFrecuenciaPlanpago())){
					codigo = plansDePago.get(0).getOperaciones().getFrecuenciaPlanpago();
				}
//						
//						buscaCodigoPorPeriodo(acuerdo
//						.getPeriodicidadAcuerdo());
				Filter filtroCodigo = genericDao.createFilter(
						FilterType.EQUALS, "codigo", codigo);
				PlazoTareasDefault plazoTarea = genericDao.get(
						PlazoTareasDefault.class, filtroCodigo);
				Long plazo = plazoTarea.getPlazo();
				Date fechaCalculada = new Date(System.currentTimeMillis()
						+ plazo);
				tarea.setFechaVenc(fechaCalculada);

				Long idBPM = acuerdo.getIdJBPM();

				executor.execute(
						ComunBusinessOperation.BO_JBPM_MGR_RECALCULAR_TIMER,
						idBPM, TareaBPMConstants.TIMER_TAREA_SOLICITADA,
						fechaCalculada);
			}
		}
	}
	
	@Override
	@BusinessOperation(BO_ACUERDO_MGR_ACUERDO_CERRAR)
	@Transactional(readOnly = false)
	public void cerrarAcuerdo(Long id) {
		EventFactory.onMethodStart(this.getClass());

		Acuerdo acuerdo = acuerdoDao.get(id);
		
		cancelarTareasAcuerdo(acuerdo);
		

		acuerdo.setFechaCierre(new Date());
		DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDEstadoAcuerdo.class,
						DDEstadoAcuerdo.ACUERDO_FINALIZADO);
		acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);

		acuerdoDao.saveOrUpdate(acuerdo);

		EventFactory.onMethodStop(this.getClass());
	}
	
	
    protected GestorDespacho  getUsuarioDestinatarioTarea(EXTAcuerdo acuerdo, String tipoUser){
    	
    	DDTipoDespachoExterno tipoDespachoDestinatario = getTiposDespachoAcuerdoAsunto(acuerdo.getGestorDespacho().getDespachoExterno().getTipoDespacho().getId()).get(tipoUser);
        
        if(tipoDespachoDestinatario != null){
        	
        	if(tipoUser.equals("proponente")){
        		return acuerdo.getGestorDespacho();
        	}else{
            	GestorDespacho gestorDespacho = null;
            	Order order = new Order(OrderType.ASC, "id");
            	List<GestorDespacho> usuariosDespacho =  genericDao.getListOrdered(GestorDespacho.class,order, genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.id", tipoDespachoDestinatario.getId()));
            	
            	if(usuariosDespacho.size()==1){
        			
        			return usuariosDespacho.get(0);
        			
        		}else if(usuariosDespacho.size()>1){
        			
        			gestorDespacho = usuariosDespacho.get(0);
        			
        			for(GestorDespacho gesDes : usuariosDespacho){
        				if(gesDes.getGestorPorDefecto()){
        					gestorDespacho = gesDes;
        					break;
        				}
        			}
        			
        		}
        		
            	return gestorDespacho;
        	}
        	
        }else{
        	return null;
        }

    }
    
	protected Long crearTarea(Long idUg, String codUg, String asuntoMail,
			Long idUsuarioDestinatarioTarea, boolean enEspera,
			String codigoSubtarea, Date fechaVencimiento)throws EXTCrearTareaException {
		
		EXTDtoGenerarTareaIdividualizadaImpl tareaIndDto = new EXTDtoGenerarTareaIdividualizadaImpl();
		DtoGenerarTarea tareaDto = new DtoGenerarTarea();

		tareaDto.setSubtipoTarea(codigoSubtarea);
		tareaDto.setEnEspera(enEspera);
		tareaDto.setFecha(fechaVencimiento);
		tareaDto.setDescripcion(asuntoMail);
		tareaDto.setIdEntidad(idUg);
		tareaDto.setCodigoTipoEntidad(codUg);
		tareaIndDto.setTarea(tareaDto);
		tareaIndDto.setDestinatario(idUsuarioDestinatarioTarea);
		return proxyFactory.proxy(EXTTareasApi.class).crearTareaNotificacionIndividualizada(tareaIndDto);
	}
	
	protected Long crearNotificacion(Long idUg, String codUg, String asuntoMail,
			Long idUsuarioDestinatarioTarea, boolean enEspera,
			String codigoSubtarea, Date fechaVencimiento, String nombreTarea)throws EXTCrearTareaException {
		
		Long idTarea = crearTarea(idUg, codUg, asuntoMail, idUsuarioDestinatarioTarea, enEspera, codigoSubtarea, fechaVencimiento);
		EXTTareaNotificacion notificacion = genericDao.get(EXTTareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "id", idTarea));
		notificacion.setTarea(nombreTarea);
		tareaNotificacionDao.save(notificacion);
		return idTarea;
	}
	
	protected Usuario obtenerLetradoDelAsunto(Long idAsunto){
		List<EXTGestorAdicionalAsunto> gestoresAsunto =  genericDao.getList(EXTGestorAdicionalAsunto.class, genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", "LETR"), genericDao.createFilter(FilterType.EQUALS, "asunto.id",idAsunto));
		
		Usuario letradoAsunto = null;

		if(gestoresAsunto.size()==1){
			
			letradoAsunto = gestoresAsunto.get(0).getGestor().getUsuario();
			
		}else if(gestoresAsunto.size()>1){
			
			letradoAsunto = gestoresAsunto.get(0).getGestor().getUsuario();
			for(EXTGestorAdicionalAsunto gaa : gestoresAsunto){
				if(gaa.getGestor().getGestorPorDefecto()){
					letradoAsunto = gaa.getGestor().getUsuario();
					break;
				}
			}
		}
		
		return letradoAsunto;
	}

    @BusinessOperation(BO_ACUERDO_MGR_TIPO_GESTOR_PROPONENTE_ACUERDO_ASUNTO)
    @Transactional(readOnly = false)
	@Override
	public boolean esProponenteAcuerdoAsunto(Long idTipoGestorAsunto) {
    	
    	List<AcuerdoConfigAsuntoUsers> configs = null;
    	
    	if(!Checks.esNulo(idTipoGestorAsunto)){
    		configs = genericDao.getList(AcuerdoConfigAsuntoUsers.class, genericDao.createFilter(FilterType.EQUALS, "proponente.id", idTipoGestorAsunto));	
    	} 
    	
    	if(configs != null && configs.size() > 0){
    		return true;
    	}else{
    		return false;	
    	}
		
	}

    @BusinessOperation(BO_ACUERDO_MGR_TIPO_GESTOR_VALIDADOR_ACUERDO_ASUNTO)
    @Transactional(readOnly = false)
	@Override
	public boolean esValidadorAcuerdoAsunto(Long idTipoGestorAsunto) {
    	
    	List<AcuerdoConfigAsuntoUsers> configs = null;
    	
    	if(!Checks.esNulo(idTipoGestorAsunto)){
    		configs = genericDao.getList(AcuerdoConfigAsuntoUsers.class, genericDao.createFilter(FilterType.EQUALS, "validador.id", idTipoGestorAsunto));	
    	} 
    	
    	if(configs != null && configs.size() > 0){
    		return true;
    	}else{
    		return false;	
    	}
    	
	}

    @BusinessOperation(BO_ACUERDO_MGR_TIPO_GESTOR_DECISOR_ACUERDO_ASUNTO)
    @Transactional(readOnly = false)
	@Override
	public boolean esDecisorAcuerdoAsunto(Long idTipoGestorAsunto) {
    	
    	List<AcuerdoConfigAsuntoUsers> configs = null;
    	
    	if(!Checks.esNulo(idTipoGestorAsunto)){
    		configs = genericDao.getList(AcuerdoConfigAsuntoUsers.class, genericDao.createFilter(FilterType.EQUALS, "decisor.id", idTipoGestorAsunto));	
    	} 
    	
    	if(configs != null && configs.size() > 0){
    		return true;
    	}else{
    		return false;	
    	}
    	
	}

	@BusinessOperation(BO_ACUERDO_MGR_GET_VALIDACION_TRAMITE_CORRESPONDIENTE)
    @Transactional(readOnly = false)
	@Override
	public List<ACDAcuerdoDerivaciones> getValidacionTramiteCorrespondiente(EXTAcuerdo acuerdo, boolean soloTramitesSinIniciar){
    	
    	List<ACDAcuerdoDerivaciones> acuerdosDerivaciones = new ArrayList<ACDAcuerdoDerivaciones>();
    	List<TerminoAcuerdo> terminos = terminoAcuerdoDao.buscarTerminosPorTipo(acuerdo.getId(), null);
    	for(TerminoAcuerdo ta : terminos){
    		ACDAcuerdoDerivaciones acudev = genericDao.get(ACDAcuerdoDerivaciones.class, genericDao.createFilter(FilterType.EQUALS, "tipoAcuerdo.id", ta.getTipoAcuerdo().getId()));
    		if(!Checks.esNulo(acudev)){
    			if(soloTramitesSinIniciar){
    				/////Obtenemos los activos
    				if(!tramiteIniciado(acuerdo.getAsunto().getId(),acudev.getTipoProcedimiento().getCodigo())){
    					acuerdosDerivaciones.add(acudev);
    				}
    			}else{
    				acuerdosDerivaciones.add(acudev);	
    			}
    			
    		}
    	}
    	
		return acuerdosDerivaciones;
	}
    
    protected boolean tramiteIniciado(Long idAsunto, String codigoTipoProcedmiento){
    	
    	if(Checks.esNulo(codigoTipoProcedmiento)){throw new IllegalArgumentException("El codigo de procedimiento no puede ser nulo");}
    	if(Checks.esNulo(idAsunto)){throw new IllegalArgumentException("El codigo de procedimiento no puede ser nulo");}
    	
    	EXTAsunto asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto));
    	
    	if(!Checks.esNulo(asunto)){
    		
        	for(Procedimiento pr : asunto.getProcedimientos()){
        		if(codigoTipoProcedmiento.equals(pr.getTipoProcedimiento().getCodigo()) && pr.getEstaAceptado()){
        			return true;
        		}
        	}
        	
    	}else{
    		if(Checks.esNulo(idAsunto)){throw new IllegalArgumentException("El asunto "+idAsunto+" no existe");}
    	}

    	
    	return false;
    }

	@Override
	public List<TerminoAcuerdo> getTerminosAcuerdo(Long idAcuerdo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TerminoContrato> getTerminoAcuerdoContratos(Long idTermino) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TerminoBien> getTerminoAcuerdoBienes(Long idTermino) {
		// TODO Auto-generated method stub
		return null;
	}

	@BusinessOperation(BO_ACUERDO_MGR_GUARDAR_ESTADO_GESTION)
    @Transactional(readOnly = false)
	@Override
	public void guardarEstadoGestion(Long idTermino, Long nuevoEstadoGestion) {
		
		TerminoAcuerdo termino = genericDao.get(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idTermino));
		if (!Checks.esNulo(termino)) {
			DDEstadoGestionTermino nuevoEstado = genericDao.get(DDEstadoGestionTermino.class, genericDao.createFilter(FilterType.EQUALS, "id", nuevoEstadoGestion));
			if (!Checks.esNulo(nuevoEstado)) {
				termino.setEstadoGestion(nuevoEstado);
				genericDao.save(TerminoAcuerdo.class, termino);
			}
		}
	}
	
	private boolean usuarioLogadoEsDelTipoDespacho(DDTipoDespachoExterno tipoDespachoExterno){
		
		Usuario user = usuarioManager.getUsuarioLogado();
		
		Order orderGestDes = new Order(OrderType.ASC, "id");
		List<GestorDespacho> gestdesp = genericDao.getListOrdered(GestorDespacho.class,orderGestDes, genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId()),genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.id", tipoDespachoExterno.getId()));
		
		boolean res = (gestdesp.size()>0)? true:false;
		
		return res;
	}
}
