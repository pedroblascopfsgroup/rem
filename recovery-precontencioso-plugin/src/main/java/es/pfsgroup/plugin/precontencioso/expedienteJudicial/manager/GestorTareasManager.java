package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.GestorTareasDao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.GestorTareasAccionPCODto;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.GestorTareasLineaConfigPCO;
import es.pfsgroup.recovery.api.PlazoTareaExternaPlazaApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;
import es.pfsgroup.recovery.api.TareaProcedimientoApi;

@Service
public class GestorTareasManager implements GestorTareasApi {

	private static final String TXT_CREAMOS_LA_TAREA = "\tCreamos la tarea: ";
	private static final String TXT_CANCELA_TAREA = "\tCancelamos la tarea: ";
	private static final String TXT_SIN_DETERMINAR = "Sin determinar";
	private static final String TXT_ERR_PLAZO_1 = "Error en el script de consulta de plazo [";
	private static final String TXT_ERR_PLAZO_2 = "]. Procedimiento [";
	private static final String TXT_ERR_PLAZO_3 = "], tipoTarea [";
	private static final String TXT_ERR_PLAZO_4 = "].";
    private static final String BPM_ERROR_SCRIPT = "bpm.error.script";
    private static final List<String> CODIGOS_TAREAS_ESPECIALES_PRECONTENCIOSO = Arrays.asList("PCO_SolicitarDoc", "PCO_RegResultadoExped", "PCO_RecepcionExped", 
    		"PCO_RegResultadoDoc", "PCO_RegEnvioDoc", "PCO_RecepcionDoc", "PCO_AdjuntarDoc", "PCO_GenerarLiq", "PCO_ConfirmarLiq", "PCO_EnviarBurofax",
    		"PCO_AcuseReciboBurofax","PCO_RegResultadoDocG");

	protected final Log logger = LogFactory.getLog(getClass());

    @Autowired
	private GenericABMDao genericDao;

    @Autowired
    private GestorTareasDao gestorTareasDao;
    
    @Autowired
    protected ApiProxyFactory proxyFactory;

    @Autowired
    protected JBPMProcessManager processUtils;

    @Autowired
    protected TareaExternaManager tareaExternaManager;

	@Autowired
	private ProcedimientoPCODao procedimientoPcoDao;

    private static List<GestorTareasLineaConfigPCO> lineasConfig = null;
    
    @BusinessOperation(BO_PCO_GESTOR_TAREAS_RECALCULAR)
	@Override
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT)
	public void recalcularTareasPreparacionDocumental(Long idProc) {
		
    	if (lineasConfig==null) {
    		lineasConfig = obtenerLineasConfiguracion();
    	}
    	
    	List<GestorTareasAccionPCODto> listaAcciones = evaluarTareasProcedimiento(idProc, lineasConfig);
    	
    	ejecutarAccionesTareas(idProc, listaAcciones);
    	
	}

    @BusinessOperation(BO_PCO_GESTOR_TAREAS_RECALCULAR_ESTADO)
	@Override
	@Transactional(readOnly = false)
	public void recalcularTareasPreparacionDocumental(Long idProc, String nuevoEstado) {

    	if (lineasConfig==null) {
    		lineasConfig = obtenerLineasConfiguracion();
    	}
    	
    	List<GestorTareasAccionPCODto> listaAcciones = evaluarTareasProcedimiento(idProc, lineasConfig, nuevoEstado);
    	
    	ejecutarAccionesTareas(idProc, listaAcciones);
    	
    }
    
	private List<GestorTareasLineaConfigPCO> obtenerLineasConfiguracion() {
		
		return genericDao.getList(GestorTareasLineaConfigPCO.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
	}


	private List<GestorTareasAccionPCODto> evaluarTareasProcedimiento(
			Long idProc, List<GestorTareasLineaConfigPCO> lineasConfig) {

		List<GestorTareasAccionPCODto> listaAcciones = new ArrayList<GestorTareasAccionPCODto>();
		try{
			for (GestorTareasLineaConfigPCO linea : lineasConfig) {
				if (gestorTareasDao.evaluaCondicion(idProc, linea.getCondicionHQL())) {
					GestorTareasAccionPCODto accion = new GestorTareasAccionPCODto();
					accion.setTipoAccion(linea.getCodigoAccion());
					accion.setTipoTarea(linea.getCodigoTarea());
					listaAcciones.add(accion);
					logger.debug("[evaluarTareasProcedimiento]: " + linea.getCodigoAccion() + "/" + linea.getCodigoTarea() + ": SI");					
				} else {
					logger.debug("[evaluarTareasProcedimiento]: " + linea.getCodigoAccion() + "/" + linea.getCodigoTarea() + ": NO");					
				}
			}
		}
		catch(Exception e){
			logger.error("evaluarTareasProcedimiento: " + e);
		}
		return listaAcciones;
		
	}

	private List<GestorTareasAccionPCODto> evaluarTareasProcedimiento(
			Long idProc, List<GestorTareasLineaConfigPCO> lineasConfig, String nuevoEstado) {

		boolean estadoEsPreparacion = DDEstadoPreparacionPCO.PREPARACION.equals(nuevoEstado);  
		
		List<GestorTareasAccionPCODto> listaAcciones = new ArrayList<GestorTareasAccionPCODto>();
		for (GestorTareasLineaConfigPCO linea : lineasConfig) {
			// Si estado proc es distinto de Preparacion y la acción es Cancelar, hay que ejecutar sin consultar la SQL 
			boolean ejecutarCancelarPorEstado = !estadoEsPreparacion 
					&& GestorTareasLineaConfigPCO.ACCION_CANCELAR.equals(linea.getCodigoAccion());
			if (ejecutarCancelarPorEstado || 
					(estadoEsPreparacion && gestorTareasDao.evaluaCondicion(idProc, linea.getCondicionHQL()))) {
				GestorTareasAccionPCODto accion = new GestorTareasAccionPCODto();
				accion.setTipoAccion(linea.getCodigoAccion());
				accion.setTipoTarea(linea.getCodigoTarea());
				listaAcciones.add(accion);
			}
		}
		return listaAcciones;
		
	}

	private void ejecutarAccionesTareas(Long idProc,
			List<GestorTareasAccionPCODto> listaAcciones) {
		
		for (GestorTareasAccionPCODto accion : listaAcciones) {
			if (GestorTareasLineaConfigPCO.ACCION_CREAR.equals(accion.getTipoAccion())) {
				crearTareaEspecial(idProc, accion.getTipoTarea());
			} else if (GestorTareasLineaConfigPCO.ACCION_CANCELAR.equals(accion.getTipoAccion())) {
				cancelarTareaEspecial(idProc, accion.getTipoTarea());
			} 
		}
		
	}

	@Override
	@BusinessOperation(BO_PCO_GESTOR_TAREAS_CREAR)
	@Transactional(readOnly = false)
	public boolean crearTareaEspecial(Long idProc, String codigoTarea) {

    	Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProc);

        //Buscamos la tarea perteneciente a ese procedimiento con el código tarea y el idTipoProcedimiento y extraemos su ID tarea
        Long idTipoProcedimiento = procedimiento.getTipoProcedimiento().getId();
        TareaProcedimiento tareaProcedimiento = proxyFactory.proxy(TareaProcedimientoApi.class)
        		.getByCodigoTareaIdTipoProcedimiento(idTipoProcedimiento, codigoTarea);

        Long idTareaProcedimiento = tareaProcedimiento.getId();
        String nombreTarea = tareaProcedimiento.getDescripcion();

        //Creamos una nueva tarea extendida con el idProcedimiento y el idTipoTarea y el timer asociado
        //Por defecto la tarea será para un gestor
        //String subtipoTarea = EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR;
        String subtipoTarea = obtenerSubtipoTarea(codigoTarea);

        //Si está marcada como supervisor se cambia el subtipo tarea
        if (tareaProcedimiento.getSupervisor()) {
            subtipoTarea = EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_SUPERVISOR;
        }

        TipoJuzgado juzgado = null;
        TipoPlaza plaza = null;

        juzgado = procedimiento.getJuzgado();
        if (juzgado != null) plaza = juzgado.getPlaza();

        Long idTipoPlaza = null;
        Long idTipoJuzgado = null;

        if (juzgado != null) idTipoJuzgado = juzgado.getId();
        if (plaza != null) idTipoPlaza = plaza.getId();

        if (logger.isDebugEnabled()) {
            logger.debug("Antes de crear la tarea " + codigoTarea + ", de subtipo " + subtipoTarea);
        }

        Long plazoTarea = getPlazoTarea(idTipoPlaza, idTareaProcedimiento, idTipoJuzgado, idProc);
        Long idTarea = tareaExternaManager.crearTareaExterna(subtipoTarea, plazoTarea, nombreTarea, idProc, idTareaProcedimiento,
                getTokenId(procedimiento.getProcessBPM()));

        if (logger.isDebugEnabled()) {
            logger.debug(TXT_CREAMOS_LA_TAREA + codigoTarea + ", " + idTarea + ", de subtipo " + subtipoTarea);
        } else {
        	System.out.println("[crearTareaEspecial]: " + TXT_CREAMOS_LA_TAREA + codigoTarea + ", " + idTarea + ", de subtipo " + subtipoTarea);
        }

        return true;
	}


    private String obtenerSubtipoTarea(String codigoTarea) {
		
    	String subtipo = gestorTareasDao.obtenerSubtipoTarea(codigoTarea); 
    	if (subtipo == null) {
    		subtipo = EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR;
    	}
		return subtipo;
	}

	private Long getTokenId(Long idProcessBPM) {
		return gestorTareasDao.getTokenId(idProcessBPM);
	}

	/**
     * Devuelve el plazo (en milisegundos) de una tarea de un procedimiento.
     * @param idTipoPlaza id de la plaza a la que pertenece
     * @param idTipoTarea id del tipo de tarea
     * @param idTipoJuzgado id del tipo de juzgado al que pertenece
     * @param idProcedimiento id del procedimiento al que pertenece
     * @return plazo de la tarea en milisegundos
     */
    protected Long getPlazoTarea(Long idTipoPlaza, Long idTipoTarea, Long idTipoJuzgado, Long idProcedimiento) {
        
    	PlazoTareaExternaPlaza plazoTareaExternaPlaza = proxyFactory.proxy(PlazoTareaExternaPlazaApi.class).
        		getByTipoTareaTipoPlazaTipoJuzgado(idTipoTarea, idTipoPlaza, idTipoJuzgado);

        String script = TXT_SIN_DETERMINAR;
        Long plazo;
        try {
            script = plazoTareaExternaPlaza.getScriptPlazo();
            String result = processUtils.evaluaScript(idProcedimiento, null, idTipoTarea, null, script).toString();
            plazo = Long.parseLong(result.toString());
        } catch (Exception e) {
            logger.error("getPlazoTarea: " + TXT_ERR_PLAZO_1 + script + TXT_ERR_PLAZO_2 + idProcedimiento + TXT_ERR_PLAZO_3
                    + idTipoTarea + TXT_ERR_PLAZO_4, e);
            throw new UserException(BPM_ERROR_SCRIPT);
        }
        return plazo;
    }

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_PCO_GESTOR_TAREAS_CANCELAR)
	public boolean cancelarTareaEspecial(Long idProc, String tipoTarea) {
		
		List<TareaExterna> listaTareas = tareaExternaManager.getActivasByIdProcedimiento(idProc);
		
		for (TareaExterna tareaExterna : listaTareas) {
			if (tipoTarea.equals(tareaExterna.getTareaProcedimiento().getCodigo())) {
				cancelaTarea(tareaExterna);
			}
		}
		return true;
	}
	
	private void cancelaTarea(TareaExterna tareaExterna) {

		if (tareaExterna != null) {
            tareaExterna.setCancelada(false);
            tareaExterna.setDetenida(false);
            tareaExternaManager.borrar(tareaExterna);
            
            TareaNotificacion tarNotif = proxyFactory.proxy(TareaNotificacionApi.class).get(tareaExterna.getTareaPadre().getId());
            tarNotif.setTareaFinalizada(true);
            proxyFactory.proxy(TareaNotificacionApi.class).saveOrUpdate(tarNotif);
            
            //Buscamos si tiene prorroga activa
            Prorroga prorroga = tareaExterna.getTareaPadre().getProrrogaAsociada();
            //Borramos (finalizamos) la prorroga si es que tiene
            if (prorroga != null) {
            	proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(prorroga.getTarea().getId());
            }
            if (logger.isDebugEnabled()) {
                logger.debug(TXT_CANCELA_TAREA + tareaExterna.getId());
            }
        }

	}
	
	@Override
	public boolean getEsTareaPrecontenciosoEspecial(Long tareaId) {

		TareaExterna tareaExterna = genericDao.get(TareaExterna.class, genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", tareaId));
		
		if (Checks.esNulo(tareaExterna)) {
			return false;
		} else {
			boolean esEspecial = CODIGOS_TAREAS_ESPECIALES_PRECONTENCIOSO.contains(tareaExterna.getTareaProcedimiento().getCodigo()) ? true : false;
	
			return esEspecial;
		}
	}
	
	public boolean existeTarea(Procedimiento proc, String codigoTarea) {
		
		boolean resultado = false;
		List<TareaExterna> listaTareas = tareaExternaManager.getActivasByIdProcedimiento(proc.getId());
		for (TareaExterna tareaExterna : listaTareas) {
			if (codigoTarea.equals(tareaExterna.getTareaProcedimiento().getCodigo())) {
				resultado = true;
			}
			
		}
		return resultado;
	}
}
