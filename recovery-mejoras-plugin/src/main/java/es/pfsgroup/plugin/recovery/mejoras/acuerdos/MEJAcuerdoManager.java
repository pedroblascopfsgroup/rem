package es.pfsgroup.plugin.recovery.mejoras.acuerdos;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AcuerdoConfigAsuntoUsers;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDPeriodicidadAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo;
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
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.termino.dao.TerminoAcuerdoDao;
import es.capgemini.pfs.termino.dao.TerminoOperacionesDao;
import es.capgemini.pfs.termino.dto.ListadoTerminosAcuerdoDto;
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
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Component
public class MEJAcuerdoManager implements MEJAcuerdoApi {

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

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_EXT_ACUERDO_MGR_GUARDAR_ACUERDO)
	public Long guardarAcuerdo(DtoAcuerdo dto) {

		// NO PUEDE HABER OTROS ACUERDOS VIGENTES.
		if (DDEstadoAcuerdo.ACUERDO_ACEPTADO.equals(dto.getEstado()) && acuerdoDao.hayAcuerdosVigentes(dto.getIdAsunto(), dto.getIdAcuerdo())) {
			throw new BusinessOperationException("acuerdos.hayOtrosVigentes");
		}

		EXTAcuerdo acuerdo;
		if (dto.getIdAcuerdo() == null) {
			acuerdo = new EXTAcuerdo();
			acuerdo.setFechaPropuesta(new Date());
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getIdAsunto());
			acuerdo.setAsunto(asunto);
			
			Usuario user = usuarioManager.getUsuarioLogado();
			acuerdo.setProponente(user);
			List<EXTGestorAdicionalAsunto> gestoresAsunto =  genericDao.getList(EXTGestorAdicionalAsunto.class, genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id", user.getId()), genericDao.createFilter(FilterType.EQUALS, "asunto.id",asunto.getId()));
			
			if(gestoresAsunto.size()==1){
				
				acuerdo.setTipoGestorProponente(gestoresAsunto.get(0).getTipoGestor());
				
			}else if(gestoresAsunto.size()>1){
				
				EXTGestorAdicionalAsunto gestorAsunto = gestoresAsunto.get(0);
				for(EXTGestorAdicionalAsunto gaa : gestoresAsunto){
					if(gaa.getGestor().getGestorPorDefecto()){
						gestorAsunto = gaa;
						break;
					}
				}
				acuerdo.setTipoGestorProponente(gestorAsunto.getTipoGestor());
			}
			
			
		} else {
			acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdAcuerdo()));
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

		// Boolean matarTareas = false;

		// Si se ha cancelado el acuerdo O se ha cerrado se deben matar las
		// tareas
		if (DDEstadoAcuerdo.ACUERDO_CANCELADO.equals(dto.getEstado()) || DDEstadoAcuerdo.ACUERDO_FINALIZADO.equals(dto.getEstado()) || DDEstadoAcuerdo.ACUERDO_RECHAZADO.equals(dto.getEstado())
				|| (dto.getFechaCierre() != null)) {

			for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
				if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
					Long idBPM = acuerdo.getIdJBPM();
					executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
				}
			}
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_ACUERDO_CERRADO, null);

		}

		// VEO SI ESTAN CERRANDO EL ACUERDO
		if (!Checks.esNulo(dto.getFechaCierre())) {
			// Esta fecha solo viene cuando el estado es vigente y el gestor la
			// carga
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				acuerdo.setFechaCierre(sdf1.parse(dto.getFechaCierre()));
			} catch (ParseException e) {
				logger.error("Error parseando la fecha", e);
			}
			DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_FINALIZADO);

			acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);
		} else if (DDEstadoAcuerdo.ACUERDO_ACEPTADO.equals(dto.getEstado())) {
			
			//Si tiene el permiso CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA entonces NO DEBE generar la tarea
			Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			if (!funcionManager.tieneFuncion(usuarioLogado, "CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA")){
				Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
					SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO, PlazoTareasDefault.CODIGO_CIERRE_ACUERDO);
				acuerdo.setIdJBPM(idJBPM);
			}

		}
		
		
		// Fecha limite
		SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy");
		try {
			acuerdo.setFechaLimite(sdf2.parse(dto.getFechaLimite()));
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
    	//return genericDao.save(TerminoAcuerdo.class, ta);
    	terminoAcuerdoDao.saveOrUpdate(ta);
    	
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
     */
    @BusinessOperation(BO_ACUERDO_MGR_VIGENTE_ACUERDO)
    @Transactional(readOnly = false)
    public void vigenteAcuerdo(Long idAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        //NO PUEDE HABER OTROS ACUERDOS VIGENTES.
        if (acuerdoDao.hayAcuerdosVigentes(acuerdo.getAsunto().getId(), idAcuerdo)) { throw new BusinessOperationException(
                "acuerdos.hayOtrosVigentes"); }
        DDEstadoAcuerdo estadoAcuerdoVigente = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_VIGENTE);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoVigente);
        acuerdo.setFechaEstado(new Date());
        //Cancelo las tareas del supervisor
        cancelarTareasAcuerdoPropuesto(acuerdo);
        //Genero tareas al gestor para el cierre del acuerdo.
        Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, acuerdo.getAsunto().getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO, PlazoTareasDefault.CODIGO_CIERRE_ACUERDO);
        acuerdo.setIdJBPM(idJBPM);
        acuerdoDao.save(acuerdo);
    }
    
    
    @BusinessOperation(BO_ACUERDO_MGR_GET_TIPOS_GESTORES_ACUERDO_ASUNTO)
    @Transactional(readOnly = false)
	public  Map<String, EXTDDTipoGestor> getTiposGestoresAcuerdoAsunto(Long idTipoGestorProponente) {
    	
    	AcuerdoConfigAsuntoUsers config = null; 
    			
    	if(!Checks.esNulo(idTipoGestorProponente)){
    		config = genericDao.get(AcuerdoConfigAsuntoUsers.class, genericDao.createFilter(FilterType.EQUALS, "proponente.id", idTipoGestorProponente));	
    	}   	
    	
    	Map<String, EXTDDTipoGestor> tiposGestor = new HashMap<String, EXTDDTipoGestor>();
    	
    	if(!Checks.esNulo(config)){
    		tiposGestor.put("proponente", config.getProponente());
        	tiposGestor.put("validador", config.getValidador());
        	tiposGestor.put("decisor", config.getDecisor());	
    	}
    	
    	
    	return tiposGestor;
    	
	}

    @BusinessOperation(BO_ACUERDO_MGR_GET_PUEDE_EDITAR_ACUERDO_ASUNTO)
    @Transactional(readOnly = false)
	public boolean puedeEditar(Long idAcuerdo) {
    	
    	EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
    	Usuario user = usuarioManager.getUsuarioLogado();
    	
    	if(acuerdo.getEstadoAcuerdo().getId().equals(Long.parseLong(DDEstadoAcuerdo.ACUERDO_EN_CONFORMACION)) && user.getId().equals(acuerdo.getProponente().getId())){
    		return true;
    	}
    	
    	
    	Map<String, EXTDDTipoGestor> config = null;
    	
    	if(acuerdo.getTipoGestorProponente()!=null){
    		config =  getTiposGestoresAcuerdoAsunto(acuerdo.getTipoGestorProponente().getId());
    	}
	
		List<EXTGestorAdicionalAsunto> gestoresAsunto =  genericDao.getList(EXTGestorAdicionalAsunto.class, genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id", user.getId()), genericDao.createFilter(FilterType.EQUALS, "asunto.id",acuerdo.getAsunto().getId()));
		
		EXTDDTipoGestor extTipoGestorAsunto = null;

		if(gestoresAsunto.size()==1){
			
			extTipoGestorAsunto = gestoresAsunto.get(0).getTipoGestor();
			
		}else if(gestoresAsunto.size()>1){
			
			extTipoGestorAsunto = gestoresAsunto.get(0).getTipoGestor();
			for(EXTGestorAdicionalAsunto gaa : gestoresAsunto){
				if(gaa.getGestor().getGestorPorDefecto()){
					extTipoGestorAsunto = gaa.getTipoGestor();
					break;
				}
			}
		}
    	
    	if(extTipoGestorAsunto!=null && config!=null && acuerdo.getEstadoAcuerdo().getId().equals(Long.parseLong(DDEstadoAcuerdo.ACUERDO_PROPUESTO)) && (extTipoGestorAsunto.getId().equals(config.get("validador").getId())  || extTipoGestorAsunto.getId().equals(config.get("decisor").getId()))){
    		return true;
    	}
    	
    	if(extTipoGestorAsunto!=null && config!=null && acuerdo.getEstadoAcuerdo().getId().equals(Long.parseLong(DDEstadoAcuerdo.ACUERDO_ACEPTADO)) && extTipoGestorAsunto.getId().equals(config.get("decisor").getId())){
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
    public void finalizarAcuerdo(Long id, Date fechaPago, Boolean cumplido) {
        Acuerdo acuerdo = acuerdoDao.get(id);
        if (acuerdo.getEstadoAcuerdo().getCodigo() == DDEstadoAcuerdo.ACUERDO_CANCELADO) { throw new BusinessOperationException("acuerdos.cancelado"); }
        
        String estado = null;
        if(cumplido){
        	estado = DDEstadoAcuerdo.ACUERDO_CUMPLIDO;
        }else{
        	estado = DDEstadoAcuerdo.ACUERDO_INCUMPLIDO;
        }
        
        Date fechaEstado = null;
        if(!Checks.esNulo(fechaPago)){
        	fechaEstado = fechaPago;
        }else{
        	fechaEstado = new Date();
        }
        
        DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, estado);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);
        acuerdo.setFechaEstado(fechaEstado);
        acuerdoDao.save(acuerdo);
        //Cancelo las tareas del supervisor
//        cancelarTareasAcuerdoPropuesto(acuerdo);
//        cancelarTareasCerrarAcuerdo(acuerdo);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
                SubtipoTarea.CODIGO_ACUERDO_CERRADO, acuerdo.getObservaciones());

    }

}
