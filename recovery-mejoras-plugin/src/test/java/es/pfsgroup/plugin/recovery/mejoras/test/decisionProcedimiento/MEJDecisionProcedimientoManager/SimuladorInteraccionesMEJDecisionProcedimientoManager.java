package es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager;

import static org.mockito.Mockito.*;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.RandomStringUtils;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionFinalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionParalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJConfiguracionDerivacionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;

/**
 * Simulador de interacciones para MEJDecisionProcedimientoManager.
 * <p>
 * Esta clase contiene un m�todo por cada interacci�n del manager con otros
 * objetos
 * </p>
 * 
 * @author bruno
 * 
 */
public class SimuladorInteraccionesMEJDecisionProcedimientoManager {

    private Executor mockExecutor;

    private ApiProxyFactory mockProxyFactory;

    private FuncionManager mockFuncionManager;

    private TareaNotificacionApi mockTareaNotificacionManager;

    private GenericABMDao mockGenericDao;
    
    private MEJConfiguracionDerivacionProcedimiento mockConfiguracionDerivacionProcedimiento;

    /**
     * Crea un simulador. Es necesario pasar al constructor los mocks de todos
     * los objetos con los que va a interactuar el manager
     * 
     * @param mockExecutor
     * @param mockProxyFactory
     * @param mockFuncionManager
     * @param mockGenericDao
     * @param mockTareaNotificacionManager
     */
    public SimuladorInteraccionesMEJDecisionProcedimientoManager(Executor mockExecutor, ApiProxyFactory mockProxyFactory, FuncionManager mockFuncionManager, GenericABMDao mockGenericDao,
            TareaNotificacionApi mockTareaNotificacionManager, MEJConfiguracionDerivacionProcedimiento mockConfiguracionDerivacionProcedimiento) {
        super();
        this.mockExecutor = mockExecutor;
        this.mockProxyFactory = mockProxyFactory;
        this.mockFuncionManager = mockFuncionManager;
        this.mockGenericDao = mockGenericDao;
        this.mockTareaNotificacionManager = mockTareaNotificacionManager;
        this.mockConfiguracionDerivacionProcedimiento=mockConfiguracionDerivacionProcedimiento;
    }

    /**
     * Simula la interacci�n para devolver el usuario logado
     * 
     * @param idUsuario
     * @return Devuelve el mock del usuario que se simula devolver
     */
    public Usuario obtenerUsuarioLogado(Long idUsuario) {
        Usuario mockUsuario = mock(Usuario.class);
        when(mockUsuario.getId()).thenReturn(idUsuario);

        when(mockExecutor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)).thenReturn(mockUsuario);
        return mockUsuario;
    }

    /**
     * Simula la interacci�n para saber si el usuario logado es supervisor del
     * procedimiento
     * 
     * @param idProcedimiento
     *            Id del procedimiento del que queremos saber si el usuario es
     *            supervisor
     * @param b
     *            Resultado, true es supervisor false no lo es
     */
    public void obtenerSiEsSupervisor(Long idProcedimiento, boolean b) {
        ProcedimientoApi mockProcedimientoApi = mock(ProcedimientoApi.class);
        when(mockProcedimientoApi.esSupervisor(idProcedimiento)).thenReturn(b);

        when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);

    }

    /**
     * Simula la interaccion para obtener si tien la funci�n finalizar asunto
     * 
     * @param b
     *            Resultado de la consulta
     * @param MEJDecisionProcedimientoManager
     */
    public void obtenerTieneFuncionFinalizarAsunto(boolean b, Usuario usuario) {
        when(mockFuncionManager.tieneFuncion(usuario, MEJDecisionProcedimientoManager.FUNCION_FINALIZAR_ASUNTOS)).thenReturn(b);
    }

    /**
     * Simula la interacci�n para obtener un Procedimiento y un Procedimiento
     * 
     * @param idProcedimiento
     * @param idAsunto
     * @return
     */
    public MEJProcedimiento obtenerProcedimiento(Long idProcedimiento, Long idAsunto) {
        // Creamos lo necesario para devolver el Procedimiento
        DDEstadoProcedimiento mockEstadoProcedimiento = mock(DDEstadoProcedimiento.class);
        Asunto mockAsunto = mock(Asunto.class);
        TipoProcedimiento mockTipoProcedimiento=mock(TipoProcedimiento.class);
        when(mockAsunto.getId()).thenReturn(idAsunto);

        Filter mockFiltro = mock(Filter.class);
        MEJProcedimiento mockProcedimiento = mock(MEJProcedimiento.class);
        when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
        when(mockProcedimiento.getEstadoProcedimiento()).thenReturn(mockEstadoProcedimiento);
        when(mockProcedimiento.getAsunto()).thenReturn(mockAsunto);
        when(mockProcedimiento.getTipoProcedimiento()).thenReturn(mockTipoProcedimiento);

        when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento)).thenReturn(mockFiltro);

        // GenericDao puede devolver tanto un Procedimiento como un
        // MEJProcedimiento
        when(mockGenericDao.get(MEJProcedimiento.class, mockFiltro)).thenReturn(mockProcedimiento);
        when(mockGenericDao.get(Procedimiento.class, mockFiltro)).thenReturn(mockProcedimiento);

        return mockProcedimiento;
    }

    /**
     * Simula que se devuelven peticiones de derivaci�n de procedimientos
     * asociadas a la decisi�n.
     * 
     * @param idsPrcDerivar
     */
    public void seDevuelvenProcedimientosADerivar(Long[] idsPrcDerivar) {
        if (idsPrcDerivar != null) {
            for (int i = 0; i < idsPrcDerivar.length; i++) {
                Long id = idsPrcDerivar[i];

                DecisionProcedimiento mockDecisionProcedimiento = mock(DecisionProcedimiento.class);
                when(mockDecisionProcedimiento.getId()).thenReturn(id);

                Filter mockFiltro = mock(Filter.class);
                when(mockGenericDao.createFilter(FilterType.EQUALS, "id", id)).thenReturn(mockFiltro);
                when(mockGenericDao.get(DecisionProcedimiento.class, mockFiltro)).thenReturn(mockDecisionProcedimiento);
            }
        }

    }

    /**
     * Simula la interacci�n para obtener el objeto DecisionProcedimiento
     * 
     * @param idDecision
     *            ID de la decisi�n que queremos crear
     * @param procedimiento
     *            La decisi�n debe contener un objeto MEJProcedimiento, pasarlo
     *            aqu�.
     * @param idTareaAsociada
     * @param idProcessBPM
     * @return
     */
    public DecisionProcedimiento obtenerDecisionProcedimiento(Long idDecision, MEJProcedimiento procedimiento, Long idTareaAsociada, Long idProcessBPM) {

        // Creamos lo necesario para devolver el DecisionProcedimiento

        Filter mockFiltro = mock(Filter.class);
        DecisionProcedimiento mockDecisionProcedimiento = mock(DecisionProcedimiento.class);
        when(mockDecisionProcedimiento.getId()).thenReturn(idDecision);

        TareaNotificacion mockTareaAsociada = mock(TareaNotificacion.class);
        when(mockTareaAsociada.getId()).thenReturn(idTareaAsociada);

        //DDCausaDecision mockCausaDecision = mock(DDCausaDecision.class);
        //when(mockCausaDecision.getCodigo()).thenReturn(RandomStringUtils.randomAlphanumeric(50));
        //when(mockCausaDecision.getDescripcion()).thenReturn(RandomStringUtils.randomAlphanumeric(100));
        //when(mockCausaDecision.getDescripcionLarga()).thenReturn(RandomStringUtils.randomAlphanumeric(500));
        DDCausaDecisionFinalizar mockCausaDecisionFinalizar = mock(DDCausaDecisionFinalizar.class);
        when(mockCausaDecisionFinalizar.getCodigo()).thenReturn(RandomStringUtils.randomAlphanumeric(50));
        when(mockCausaDecisionFinalizar.getDescripcion()).thenReturn(RandomStringUtils.randomAlphanumeric(100));
        when(mockCausaDecisionFinalizar.getDescripcionLarga()).thenReturn(RandomStringUtils.randomAlphanumeric(500));
        DDCausaDecisionParalizar mockCausaDecisionParalizar = mock(DDCausaDecisionParalizar.class);
        when(mockCausaDecisionParalizar.getCodigo()).thenReturn(RandomStringUtils.randomAlphanumeric(50));
        when(mockCausaDecisionParalizar.getDescripcion()).thenReturn(RandomStringUtils.randomAlphanumeric(100));
        when(mockCausaDecisionParalizar.getDescripcionLarga()).thenReturn(RandomStringUtils.randomAlphanumeric(500));
                        
        when(mockDecisionProcedimiento.getProcedimiento()).thenReturn(procedimiento);
        when(mockDecisionProcedimiento.getTareaAsociada()).thenReturn(mockTareaAsociada);
        
        //when(mockDecisionProcedimiento.getCausaDecision()).thenReturn(mockCausaDecision);
        when(mockDecisionProcedimiento.getCausaDecisionFinalizar()).thenReturn(mockCausaDecisionFinalizar);
        when(mockDecisionProcedimiento.getCausaDecisionParalizar()).thenReturn(mockCausaDecisionParalizar);        
        
        when(mockDecisionProcedimiento.getProcessBPM()).thenReturn(idProcessBPM);

        when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idDecision)).thenReturn(mockFiltro);
        when(mockGenericDao.get(DecisionProcedimiento.class, mockFiltro)).thenReturn(mockDecisionProcedimiento);

        return mockDecisionProcedimiento;

    }

    /**
     * Simula que se obtienen determinadas tareas del procedimiento.
     * 
     * @param idProcedimiento
     *            Id del procedimiento
     * 
     * @param subtipo
     *            C�digo del subtipo de la tarea.
     * @param cantidad
     *            Cantidad de tareas a genenrar
     * @return Devuelve la lista que simula devolver.
     */
    public List<TareaNotificacion> simulaSeObtienenTareas(Long idProcedimiento, final String subtipo, final int cantidad) {
        // Creamos la lista de tareas a devolver
        final ArrayList<TareaNotificacion> lista = new ArrayList<TareaNotificacion>();
        final Random generadorIds = new Random();
        TareaNotificacion tarea;
        Auditoria auditoria;
        for (int i = 0; i < Math.abs(cantidad); i++) {
            auditoria = new Auditoria();
            auditoria.setBorrado(false);

            tarea = new TareaNotificacion();
            tarea.setId(generadorIds.nextLong());
            tarea.setAuditoria(auditoria);

            tarea.setDescGestor(RandomStringUtils.randomAlphanumeric(100));
            tarea.setDescSupervisor(RandomStringUtils.randomAlphanumeric(100));

            lista.add(tarea);
        }

        // Programamos el mock
        when(mockTareaNotificacionManager.getListByProcedimientoSubtipo(idProcedimiento, subtipo)).thenReturn(lista);

        return lista;
    }

    /**
     * Simula que se obtiene un estado de decisi�n.
     * 
     * @param estadoDecision
     */
    public void seObtieneEstadoDecision(String estadoDecision) {
        DDEstadoDecision mockEstadoDecision = mock(DDEstadoDecision.class);
        when(mockEstadoDecision.getCodigo()).thenReturn(estadoDecision);
        
        when(mockExecutor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoDecision.class,estadoDecision)).thenReturn(mockEstadoDecision);

    }

    /**
     * Simula que se obtiene una causa de decisi�n.
     * @param causaDecision
     */
    /*
    public void seObtieneCausaDecision(String causaDecision) {
       DDCausaDecision mockCausa = mock(DDCausaDecision.class);
       when(mockCausa.getCodigo()).thenReturn(causaDecision);
       
       when(mockExecutor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCausaDecision.class,causaDecision)).thenReturn(mockCausa);
        
    }
    */
    public void seObtieneCausaDecisionFinalizar(String causaDecisionFinalizar) {
        DDCausaDecisionFinalizar mockCausa = mock(DDCausaDecisionFinalizar.class);
        when(mockCausa.getCodigo()).thenReturn(causaDecisionFinalizar);
        
        when(mockExecutor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCausaDecisionFinalizar.class,causaDecisionFinalizar)).thenReturn(mockCausa);
         
     }
    public void seObtieneCausaDecisionParalizar(String causaDecision) {
        DDCausaDecisionParalizar mockCausa = mock(DDCausaDecisionParalizar.class);
        when(mockCausa.getCodigo()).thenReturn(causaDecision);
        
        when(mockExecutor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCausaDecisionParalizar.class,causaDecision)).thenReturn(mockCausa);
         
     }    
    
    /**
     * Devuelve la configuraci�n para un procedimiento en concreto
     */
    
//    public void seObtieneConfiguracionDerivacion(){
//    	Filter mockFiltroOrigen = mock(Filter.class);
//    	Filter mockFiltroDestino = mock(Filter.class);
//    	
//    	when(mockGenericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoOrigen", any(String.class))).thenReturn(mockFiltroOrigen);
//    	when(mockGenericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoDestino",any(String.class))).thenReturn(mockFiltroDestino)  ;
//    	when(mockGenericDao.get(MEJConfiguracionDerivacionProcedimiento.class, mockFiltroOrigen,mockFiltroDestino)).thenReturn(mockConfiguracionDerivacionProcedimiento) ;
//    }

}
