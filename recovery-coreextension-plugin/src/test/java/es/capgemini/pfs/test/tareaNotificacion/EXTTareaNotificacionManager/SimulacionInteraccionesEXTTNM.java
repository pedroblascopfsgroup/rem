package es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager;

import static org.mockito.Mockito.*;

import java.util.Map;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;

/**
 * Esta clase sirve para simular interacciones con los colaboradores del
 * EXTTareaNotificacionManager
 * 
 * @author bruno
 * 
 */
public class SimulacionInteraccionesEXTTNM {

    final private EXTTareaNotificacionManager mockManager;

    final private Executor mockExecutor;
    final private GenericABMDao mockGenericDao;

    final private VTARBusquedaOptimizadaTareasDao mockBusquedaOptimizadaTareasDao;

    /**
     * Se deben pasar los mocks de todos los colaboradores del manager
     * 
     * @param mockManager
     * @param executor
     * @param busquedaTareasDao
     * @param mockGenericDao
     */
    public SimulacionInteraccionesEXTTNM(EXTTareaNotificacionManager mockManager, Executor executor, VTARBusquedaOptimizadaTareasDao busquedaTareasDao, GenericABMDao mockGenericDao) {
        this.mockManager = mockManager;
        this.mockExecutor = executor;
        this.mockBusquedaOptimizadaTareasDao = busquedaTareasDao;
        this.mockGenericDao = mockGenericDao;
    }

    /**
     * Simula que se produce la interacción de respuesta de la prórroga
     * 
     * @param prorroga
     */
    public void simulaRespuestaProrroga(Prorroga prorroga) {
        when(mockExecutor.execute(eq(InternaBusinessOperation.BO_PRORR_MGR_RESPONDER_PRORROGA), any(DtoSolicitarProrroga.class))).thenReturn(prorroga);
    }

    /**
     * Simula que se obtiene un tipo de entidad mediante código
     * 
     * @param codigo
     *            Código del tipo de entidad
     * @param tipoEntidad
     *            Tipo de entidad que se devuelve
     */
    public void simulaGetTipoEntidad(Object codigo, DDTipoEntidad tipoEntidad) {
        when(mockExecutor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, codigo)).thenReturn(tipoEntidad);
    }

    /**
     * Simula que se obtiene un tipo de entidad mediante código
     * 
     * @param codigo
     *            Código del tipo de entidad
     */
    public DDTipoEntidad simulaGetTipoEntidad(Object codigo) {
        DDTipoEntidad mockTipoEntidad = mock(DDTipoEntidad.class);
        when(mockTipoEntidad.getCodigo()).thenReturn(codigo.toString());
        simulaGetTipoEntidad(codigo, mockTipoEntidad);
        return mockTipoEntidad;
    }

    /**
     * Simula que se obtiene un expediente
     * 
     * @param idExpediente
     *            Id del expediente
     * @param mockExpediente
     *            Expediente que se simula devolver
     */
    public void simulaGetExpediente(Long idExpediente, Expediente mockExpediente) {
        when(mockExecutor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente)).thenReturn(mockExpediente);

    }

    /**
     * Simula qu se devuelve un determinado conjunto de tareas pendientes
     * 
     * @param tareas
     *            Conjunto de tareas que queremos simular que devolvemo
     */
    public void simulaDevolverTareasPendientes(Page tareas) {
        when(mockBusquedaOptimizadaTareasDao.buscarTareasPendiente(any(DtoBuscarTareaNotificacion.class), any(Boolean.class), any(Usuario.class), any(Class.class))).thenReturn(tareas);

    }

    /**
     * Simula que se obtiene un procedimiento.
     * 
     * @param idProcedimiento
     */
    public void simulaGetProcedimiento(Long idProcedimiento) {
        Procedimiento mockProcedimiento = mock(Procedimiento.class);
        when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
        when(mockExecutor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento)).thenReturn(mockProcedimiento);

    }

    /**
     * Simula que se devuelve un plazo por defecto
     * 
     * @param codTipoPlazo
     * @param plazo
     */
    public void simulaGetPlazoTareasDefault(String codTipoPlazo, Long plazo) {
        Filter mockFiltro = mock(Filter.class);
        when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo", codTipoPlazo)).thenReturn(mockFiltro);

        PlazoTareasDefault mockPlazo = mock(PlazoTareasDefault.class);
        when(mockPlazo.getCodigo()).thenReturn(codTipoPlazo);
        when(mockPlazo.getPlazo()).thenReturn(plazo);
        when(mockGenericDao.get(PlazoTareasDefault.class, mockFiltro)).thenReturn(mockPlazo);
    }

    /**
     * Simula que se cra un proceso BPM
     * 
     * @param idBpmProcess
     *            ID que queremos que tenga el proceso
     */
    public void simulaCreateBPMProcess(Long idBpmProcess) {
        when(mockExecutor.execute(eq(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS), eq(TareaBPMConstants.TAREA_PROCESO), any(Map.class))).thenReturn(idBpmProcess);
    }

    /**
     * Simula que se crea un objeto prórroga
     * 
     * @param idProrroga
     */
    public void simulaCreateProrroga(Long idProrroga) {
        Prorroga mockProrroga = mock(Prorroga.class);
        TareaNotificacion mockTareaAsociada = mock(TareaNotificacion.class);
        TareaExterna mockTareaExterna = mock(TareaExterna.class);
        TareaProcedimiento mockTareaProcedimiento = mock(TareaProcedimiento.class);
        
        when(mockProrroga.getId()).thenReturn(idProrroga);
		when(mockProrroga.getTareaAsociada()).thenReturn(mockTareaAsociada);
		when(mockTareaAsociada.getTareaExterna()).thenReturn(mockTareaExterna);
		when(mockTareaExterna.getTareaProcedimiento()).thenReturn(mockTareaProcedimiento);
		when(mockTareaProcedimiento.getId()).thenReturn(1L);
        when(mockExecutor.execute(eq(InternaBusinessOperation.BO_PRORR_MGR_CREAR_NUEVA_PRORROGA), any(DtoSolicitarProrroga.class))).thenReturn(mockProrroga);
    }

    /**
     * Simula que se obtiene una determinada variable del contexto de un BPM
     * 
     * @param idBpmProcess
     *            ID del proceso BPM
     * @param variable
     *            Nombre de la variable
     * @param valor
     *            Valor que se quiere devolver.
     */
    public void simulaGetVariableBPM(Long idBpmProcess, String variable, Long valor) {
        when(mockExecutor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, idBpmProcess, variable)).thenReturn(valor);

    }

    /**
     * Simula qe se obtiene una tarea.
     * 
     * @param idTareaAsociada
     * @return Mock de la tarea que se devuelve
     */
    public TareaNotificacion simulaGetTarea(Long idTareaAsociada) {
        TareaNotificacion mockTarea = mock(TareaNotificacion.class);
        when(mockTarea.getId()).thenReturn(idTareaAsociada);
        when(mockManager.get(idTareaAsociada)).thenReturn(mockTarea);
        return mockTarea;
    }
}
