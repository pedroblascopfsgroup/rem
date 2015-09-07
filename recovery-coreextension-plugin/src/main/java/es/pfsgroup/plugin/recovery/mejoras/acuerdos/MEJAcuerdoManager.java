package es.pfsgroup.plugin.recovery.mejoras.acuerdos;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
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
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDPeriodicidadAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoPagoAcuerdo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.termino.dto.ListadoTerminosAcuerdoDto;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.integration.Guid;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Component
public class MEJAcuerdoManager extends BusinessOperationOverrider<AcuerdoApi> implements MEJAcuerdoApi {

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
	
		
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;

	@Autowired
	private AcuerdoDao acuerdoDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private FuncionManager funcionManager;

	@Autowired
	private IntegracionBpmService bpmIntegracionService;

	@Override
	public String managerName() {
		return "acuerdoManager";
	}
    
	/**
	 * Pasa un acuerdo a estado Rechazado.
	 * 
	 * @param idAcuerdo
	 *            el id del acuerdo a rechazar
	 */
	@Override
	@BusinessOperation(BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO)
	@Transactional(readOnly = false)
	public void rechazarAcuerdoMotivo(Long idAcuerdo, String motivo) {

		EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
		DDEstadoAcuerdo estadoAcuerdoRechazado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_RECHAZADO);

		acuerdo.setEstadoAcuerdo(estadoAcuerdoRechazado);
		acuerdo.setFechaEstado(new Date());
		acuerdo.setMotivo(motivo);
		acuerdoDao.save(acuerdo);
		
		bpmIntegracionService.notificaCambioEstado(acuerdo);
		
		// Cancelo las tareas del supervisor
		cancelarTareasAcuerdoPropuesto(acuerdo);
		cancelarTareasCerrarAcuerdo(acuerdo);
		StringBuffer observaciones = new StringBuffer();
		observaciones.append(acuerdo.getObservaciones());
		if(!Checks.esNulo(motivo))
			observaciones.append(" Motivo rechazo: " + motivo);
		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_ACUERDO_RECHAZADO,
				observaciones.toString());

	}

	private void cancelarTareasCerrarAcuerdo(Acuerdo acuerdo) {
		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
				Long idBPM = acuerdo.getIdJBPM();
				executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
			}
		}
	}

	private void cancelarTareasAcuerdoPropuesto(Acuerdo acuerdo) {
		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if (SubtipoTarea.CODIGO_ACUERDO_PROPUESTO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
				Long idBPM = acuerdo.getIdJBPM();
				executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
			}
		}
	}

	public Long guardar(DtoAcuerdo dto) {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		EXTAcuerdo acuerdo;
		if (dto.getIdAcuerdo() == null) {
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getIdAsunto());
			acuerdo = new EXTAcuerdo();
			acuerdo.setFechaPropuesta(new Date());
			acuerdo.setAsunto(asunto);
			acuerdo.setIdJBPM(dto.getIdJBPM());
			acuerdo.setGuid(dto.getGuid());
		} else {
			acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdAcuerdo()));
		}
		
		DDEstadoAcuerdo estadoAcuerdo = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAcuerdo.class, dto.getEstado());
		acuerdo.setEstadoAcuerdo(estadoAcuerdo);
		acuerdo.setFechaEstado(dto.getFechaEstado());
		
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
		acuerdo.setIdJBPM(dto.getIdJBPM());

		// Fecha limite
		try {
			Date fecha = (!Checks.esNulo(dto.getFechaLimite())) ? sdf.parse(dto.getFechaLimite()) : null;
			acuerdo.setFechaLimite(fecha);
		} catch (ParseException e) {
			logger.error("Error parseando la fecha", e);
		}		
		
		try {
			Date fecha = (!Checks.esNulo(dto.getFechaCierre())) ? sdf.parse(dto.getFechaCierre()) : null;
			acuerdo.setFechaCierre(fecha);
		} catch (ParseException e) {
			logger.error("Error parseando la fecha", e);
		}		
		
		acuerdoDao.saveOrUpdate(acuerdo);
		return acuerdo.getId();
		
	}
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_EXT_ACUERDO_MGR_GUARDAR_ACUERDO)
	public Long guardarAcuerdo(DtoAcuerdo dto) {
		
		// NO PUEDE HABER OTROS ACUERDOS VIGENTES.
		if (DDEstadoAcuerdo.ACUERDO_VIGENTE.equals(dto.getEstado()) && acuerdoDao.hayAcuerdosVigentes(dto.getIdAsunto(), dto.getIdAcuerdo())) {
			throw new BusinessOperationException("acuerdos.hayOtrosVigentes");
		}

		if (Checks.esNulo(dto.getFechaEstado())) {
			dto.setFechaEstado(new Date());
		}
		
		// Si se ha cancelado el acuerdo O se ha cerrado se deben matar las
		// tareas
		if (DDEstadoAcuerdo.ACUERDO_CANCELADO.equals(dto.getEstado()) 
				|| DDEstadoAcuerdo.ACUERDO_FINALIZADO.equals(dto.getEstado()) 
				|| DDEstadoAcuerdo.ACUERDO_RECHAZADO.equals(dto.getEstado())
				|| (dto.getFechaCierre() != null)) {
			EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdAcuerdo()));
			for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
				if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
					Long idBPM = acuerdo.getIdJBPM();
					if (idBPM != null) {
						executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
					}
				}
			}
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_ACUERDO_CERRADO, null);
		}

		// VEO SI ESTAN CERRANDO EL ACUERDO
		if (!Checks.esNulo(dto.getFechaCierre())) {
			DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_FINALIZADO);
			dto.setEstado(estadoAcuerdoFinalizado.getCodigo());

		} else if (DDEstadoAcuerdo.ACUERDO_VIGENTE.equals(dto.getEstado())) {
			
			//Si tiene el permiso CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA entonces NO DEBE generar la tarea
			Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			if (!funcionManager.tieneFuncion(usuarioLogado, "CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA")){
				Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, dto.getIdAsunto(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
					SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO, PlazoTareasDefault.CODIGO_CIERRE_ACUERDO);
				dto.setIdJBPM(idJBPM);
			}
		}
			
		Long id = guardar(dto);

		Acuerdo acuerdo = acuerdoDao.get(id);
		bpmIntegracionService.enviarDatos(acuerdo);
		
		return id;
	}
	
	/**
     * @param id Long
     * @return Acuerdo
     */
    @BusinessOperation(BO_ACUERDO_MGR_GET_LISTADO_ACUERDOS_BY_ASU_ID)
    public List<EXTAcuerdo> getAcuerdosDelAsunto(Long id) {
        logger.debug("Obteniendo acuerdos del asunto" + id);
        return (List<EXTAcuerdo>) genericDao.getList(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "asunto.id", id));
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
    
    @Override
    public List<TerminoAcuerdo> getTerminosAcuerdo(Long idAcuerdo) {
    	return genericDao.getList(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "acuerdo.id", idAcuerdo));
    }
    
    @Override
    public List<TerminoContrato> getTerminoAcuerdoContratos(Long idTermino) {
    	return genericDao.getList(TerminoContrato.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTermino));
    }

    @Override
    public List<TerminoBien> getTerminoAcuerdoBienes(Long idTermino) {
    	return genericDao.getList(TerminoBien.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTermino));
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
        List<TerminoAcuerdo> listaTerminosAcuerdo =  getTerminosAcuerdo(idAcuerdo);
        List<ListadoTerminosAcuerdoDto> terminosAcuerdos = new ArrayList<ListadoTerminosAcuerdoDto>(); 
        for (TerminoAcuerdo termino : listaTerminosAcuerdo) {
        	ListadoTerminosAcuerdoDto dtoTerAcu = new ListadoTerminosAcuerdoDto();
        	dtoTerAcu.setId(termino.getId());
        	dtoTerAcu.setComisiones(termino.getComisiones());
        	dtoTerAcu.setImporte(termino.getImporte());
        	dtoTerAcu.setTipoAcuerdo(termino.getTipoAcuerdo());
        	
        	List<TerminoContrato> listaContratosTermino = getTerminoAcuerdoContratos(termino.getId()); 
        	ArrayList<EXTContrato> listaContratos = new ArrayList<EXTContrato>();
        	for (TerminoContrato terminoCnt : listaContratosTermino) {
        		listaContratos.add((EXTContrato)terminoCnt.getContrato());
        	}
        	
        	dtoTerAcu.setContratosTermino(listaContratos);
        	
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
	public List<DDTipoAcuerdo> getListTipoAcuerdo() {

		Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDTipoAcuerdo> listado = (ArrayList<DDTipoAcuerdo>) genericDao.getList(DDTipoAcuerdo.class, fBorrado);

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
    	return genericDao.save(TerminoAcuerdo.class, ta);

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
        
    	List<TerminoBien> listaBienesTermino = getTerminoAcuerdoBienes(idTermino);
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

    public EXTAcuerdo getAcuerdoById(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, filtro);
		return acuerdo;
    }
    
	public EXTAcuerdo getAcuerdoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, filtro);
		return acuerdo;
	}

	public TerminoAcuerdo getTerminoAcuerdoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		TerminoAcuerdo termAcuerdo = genericDao.get(TerminoAcuerdo.class, filtro);
		return termAcuerdo;
	}

	public TerminoContrato getTerminoAcuerdoContratoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		TerminoContrato termAcuerdoCnt = genericDao.get(TerminoContrato.class, filtro);
		return termAcuerdoCnt;
	}

	public TerminoBien getTerminoAcuerdoBienByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		TerminoBien termAcuerdoBien = genericDao.get(TerminoBien.class, filtro);
		return termAcuerdoBien;
	}

	public ActuacionesRealizadasAcuerdo getActuacionesRealizadasAcuerdoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		ActuacionesRealizadasAcuerdo actRealizadas = genericDao.get(ActuacionesRealizadasAcuerdo.class, filtro);
		return actRealizadas;
	}

	public ActuacionesAExplorarAcuerdo getActuacionesAExplorarAcuerdoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		ActuacionesAExplorarAcuerdo actAExp = genericDao.get(ActuacionesAExplorarAcuerdo.class, filtro);
		return actAExp;
	}

	@Transactional(readOnly = false)
	public void prepareGuid(TerminoAcuerdo terminoacuerdo) {
		if (Checks.esNulo(terminoacuerdo.getGuid())) {
			terminoacuerdo.setGuid(Guid.getNewInstance().toString());
			saveTerminoAcuerdo(terminoacuerdo);
		}
	}
	
	@Transactional(readOnly = false)
	public EXTAcuerdo prepareGuid(Acuerdo acuerdo) {
		EXTAcuerdo extAcuerdo = getAcuerdoById(acuerdo.getId());
		//boolean modificado = false;
		if (Checks.esNulo(extAcuerdo.getGuid())) {
			//logger.debug(String.format("[INTEGRACION] Asignando nuevo GUID para procedimiento %d", procedimiento.getId()));
			extAcuerdo.setGuid(Guid.getNewInstance().toString());
			//modificado = true;
		}
		/*
		// Prepara GUID de tablas relacionadas.
		List<ActuacionesAExplorarAcuerdo> actuacionesExplorar = extAcuerdo.getActuacionesAExplorar();
		List<ActuacionesRealizadasAcuerdo> actuacionesRealizadas = extAcuerdo.getActuacionesRealizadas();
		for (ActuacionesAExplorarAcuerdo actuacion : actuacionesExplorar) {
			if (Checks.esNulo(actuacion.getGuid())) {
				actuacion.setGuid(Guid.getNewInstance().toString());
				modificado = true;
			}
		}
		for (ActuacionesRealizadasAcuerdo actuacion: actuacionesRealizadas) {
			if (Checks.esNulo(actuacion.getGuid())) {
				actuacion.setGuid(Guid.getNewInstance().toString());
				modificado = true;
			}
		}
		if (modificado) {
			acuerdoDao.saveOrUpdate(extAcuerdo);
		}*/
		return extAcuerdo;
	}

}
