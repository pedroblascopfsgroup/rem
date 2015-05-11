package es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager;

import java.util.ArrayList;
import java.util.List;

import org.mockito.ArgumentCaptor;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

/**
 * Verificador de las interacciones del manager con sus colaboradores.
 * 
 * @author bruno
 * 
 */
public class VerificadorInteraccionesMEJDecisionProcedimientoManager {

    private GenericABMDao mockGenericDao;

    private Executor mockExecutor;

    private JBPMProcessManager mockJbpmUtil;

    /**
     * Es necesario pararle los mocks de todos los colaboradores.
     * 
     * @param mockGenericDao
     * @param mockExecutor
     * @param mockJbpmUtil
     */
    public VerificadorInteraccionesMEJDecisionProcedimientoManager(GenericABMDao mockGenericDao, Executor mockExecutor, JBPMProcessManager mockJBPMProcessManager) {
        super();
        this.mockGenericDao = mockGenericDao;
        this.mockExecutor = mockExecutor;
        this.mockJbpmUtil = mockJBPMProcessManager;
    }

    /**
     * Verifica que se haya finalizado la tarea de toma de decisión.
     * <p>
     * Cuando finaliza una toma de decisión se cierran todas las tareas.
     * Comprobamos que todas las tareas tengan el flag de finalizado y que se
     * haya hecho un update.
     * <p>
     * 
     * @param tareasProcedimiento
     */
    public void seHaFinalizadoTomaDecision(List<TareaNotificacion> tareasProcedimiento) {
        if (!Checks.estaVacio(tareasProcedimiento)) {
            for (TareaNotificacion tarea : tareasProcedimiento) {
                List<Long> identificadores = getIdentificadores(tareasProcedimiento);

                assertTrue("La tarea no tiene el esado finalizada", tarea.getTareaFinalizada());

                // Verificamos la el update mediante el GenericDao
                ArgumentCaptor<TareaNotificacion> tareaArgumentCaptor = ArgumentCaptor.forClass(TareaNotificacion.class);

                verify(mockGenericDao, times(tareasProcedimiento.size())).update(eq(TareaNotificacion.class), tareaArgumentCaptor.capture());

                assertTrue("No se updatea el flag de finalizado", tareaArgumentCaptor.getValue().getTareaFinalizada());
                assertTrue("Se updatea una tarea con id incorrecto", identificadores.contains(tareaArgumentCaptor.getValue().getId()));
            }
        }

    }

    /**
     * Verifica que se haya cambiado el estado del asunto
     * 
     * @param idAsunto
     */
    public void seHaCambiadoEstadoAsunto(Long idAsunto) {
        verify(mockExecutor, times(1)).execute(ExternaBusinessOperation.BO_ASU_MGR_ACTUALIZA_ESTADO_ASUNTO, idAsunto);
    }

    /**
     * Verifica que se haya guardado el objeto decisión procedimiento
     * 
     * @param idDecisionProcedimiento
     * @param estadoDecision
     * @param causaDecision 
     */
    //public void seHaGuardadoLaDecision(Long idDecisionProcedimiento, String estadoDecision, String causaDecision) {
    public void seHaGuardadoLaDecision(Long idDecisionProcedimiento, String estadoDecision, String causaDecisionFinalizar, String causaDecisionParalizar) {
        ArgumentCaptor<DecisionProcedimiento> decisionArgumentCaptor = ArgumentCaptor.forClass(DecisionProcedimiento.class);

        verify(mockGenericDao, times(1)).save(eq(DecisionProcedimiento.class), decisionArgumentCaptor.capture());

        final DecisionProcedimiento decision = decisionArgumentCaptor.getValue();
        //assertDecisionProcedimiento(idDecisionProcedimiento, estadoDecision, causaDecision, decision);
        assertDecisionProcedimiento(idDecisionProcedimiento, estadoDecision, causaDecisionFinalizar, causaDecisionParalizar, decision);        
    }
    
    /**
     * Comprueba que se ha guardado un determinado objeto {@link DecisionProcedimiento}
     * @param decision
     */
    public void seHaGuardadoLaDecision(DecisionProcedimiento decision) {

        verify(mockGenericDao, times(1)).save(DecisionProcedimiento.class, decision);

    }
    
    /**
     * Verifica que se haya guardado el objeto decisión procedimiento
     * 
     * @param idDecisionProcedimiento
     * @param estadoDecision
     */
    public void seHaActualizadoLaDecision(Long idDecisionProcedimiento, String estadoDecision) {
        ArgumentCaptor<DecisionProcedimiento> decisionArgumentCaptor = ArgumentCaptor.forClass(DecisionProcedimiento.class);
        
        verify(mockGenericDao, times(1)).update(eq(DecisionProcedimiento.class), decisionArgumentCaptor.capture());

        final DecisionProcedimiento decision = decisionArgumentCaptor.getValue();
        //assertDecisionProcedimiento(idDecisionProcedimiento, estadoDecision, null, decision);
        assertDecisionProcedimiento(idDecisionProcedimiento, estadoDecision, null, null, decision);        
    }

    /**
     * Verifica que se invoca la transición correcta del BPM para dar por
     * respondida la tarea.
     * 
     * @param idProcessBPM
     */
    public void seDaPorRespondidaTareaBPM(Long idProcessBPM) {
        verify(mockJbpmUtil, times(1)).signalProcess(idProcessBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
    }

    /**
     * Verifica que se haya borrado la tarea asociada.
     * 
     * @param idTareaAsociada
     */
    public void seBorraLaTareaAsociada(Long idTareaAsociada) {
        verify(mockExecutor, times(1)).execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, idTareaAsociada);
    }

    /**
     * Devuelve los identificadores de las tareas que hay en la lista
     * 
     * @param tareasProcedimiento
     * @return
     */
    private List<Long> getIdentificadores(List<TareaNotificacion> tareasProcedimiento) {
        ArrayList<Long> lista = new ArrayList<Long>();
        for (TareaNotificacion tarea : tareasProcedimiento) {
            lista.add(tarea.getId());
        }
        return lista;
    }
    
    /**
     * Comprueba que la decisión tenga los valores correctos.
     * 
     * @param expectedId
     * @param expectedEstado
     * @param causaDecision 
     * @param decision
     */
    //private void assertDecisionProcedimiento(Long expectedId, String expectedEstado, String causaDecision, final DecisionProcedimiento decision) {
    private void assertDecisionProcedimiento(Long expectedId, String expectedEstado, String causaDecisionFinalizar, String causaDecisionParalizar, final DecisionProcedimiento decision) {
        if (expectedId != null) {
            assertEquals("No se ha guardado la DecisionProcecimiento esperada", expectedId, decision.getId());
        }
        if (!Checks.esNulo(expectedEstado)) {
            assertNotNull("La decisión no tiene estado", decision.getEstadoDecision());
            assertEquals("El código del estado de la decisión no es correcto", expectedEstado, decision.getEstadoDecision().getCodigo());
        }
        /*
        if (!Checks.esNulo(causaDecision)){
            assertNotNull("La decisión no tiene causa", decision.getCausaDecision());
            assertEquals("La causa de la decisión no es la esperada", causaDecision, decision.getCausaDecision().getCodigo());
        }
        */
        if (!Checks.esNulo(causaDecisionFinalizar)){
            assertNotNull("La decisión de finalización no tiene causa", decision.getCausaDecisionFinalizar());
            assertEquals("La causa de la decisión de finalización no es la esperada", causaDecisionFinalizar, decision.getCausaDecisionFinalizar().getCodigo());
        }
        if (!Checks.esNulo(causaDecisionParalizar)){
            assertNotNull("La decisión no tiene causa", decision.getCausaDecisionParalizar());
            assertEquals("La causa de la decisión no es la esperada", causaDecisionParalizar, decision.getCausaDecisionParalizar().getCodigo());
        }        
        
    }

}
