package es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager.bo;

import static org.mockito.Mockito.*;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;

//import sun.awt.motif.MComponentPeer;



import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager.AbstractMEJDecisionProcedimientoManagerTests;
import es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager.MEJDtoDecisionProcedimientoTestFactory;

/**
 * Suite de pruebas de la operaci�n de negocio de aceptaci�n de propuesta
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class AceptarPropuestaTests extends AbstractMEJDecisionProcedimientoManagerTests {

    private Long idProcedimiento;
    private Long idAsunto;
    private Long idUsuario;
    private Long idDecisionProcedimiento;
    private Long idProcessBPMDecision;
    private Long idTareaAsociada;
    private int numPrcDerivar;
    private Long[] idsPrcDerivar;
    private List<TareaNotificacion> listaTareas;

    /*
     * Objetos que se devuelven durante las interacciones
     */
    private MEJProcedimiento mockProcedimiento;
    private DecisionProcedimiento mockDecisionProcedimiento;

    @Override
    public void setUpChildTest() {
        idProcedimiento = random.nextLong();
        idAsunto = random.nextLong();
        idUsuario = random.nextLong();
        idDecisionProcedimiento = random.nextLong();
        idProcessBPMDecision = random.nextLong();
        idTareaAsociada = random.nextLong();
        numPrcDerivar = random.nextInt(100);
        idsPrcDerivar = initArray(numPrcDerivar);
        // Simulaci�n de interacciones
        Usuario mockUsuario = simularInteracciones().obtenerUsuarioLogado(idUsuario);
        simularInteracciones().obtenerSiEsSupervisor(idProcedimiento, false);
        simularInteracciones().obtenerTieneFuncionFinalizarAsunto(false, mockUsuario);
        simularInteracciones().seDevuelvenProcedimientosADerivar(idsPrcDerivar);
        //simularInteracciones().seObtieneConfiguracionDerivacion();
        
        mockProcedimiento = simularInteracciones().obtenerProcedimiento(idProcedimiento, idAsunto);
        mockDecisionProcedimiento = simularInteracciones().obtenerDecisionProcedimiento(idDecisionProcedimiento, mockProcedimiento, idTareaAsociada, idProcessBPMDecision);
        listaTareas = simularInteracciones().simulaSeObtienenTareas(idProcedimiento, SubtipoTarea.CODIGO_TOMA_DECISION_BPM, random.nextInt(200));

    }

    @Override
    public void tearDownChildTest() {
        idProcedimiento = null;
        idUsuario = null;
        idDecisionProcedimiento = null;
        idAsunto = null;
        listaTareas = null;
        idProcessBPMDecision = null;
        idTareaAsociada = null;
        numPrcDerivar = 0;
        idsPrcDerivar = null;

        mockProcedimiento = null;
        mockDecisionProcedimiento = null;
    }

    /**
     * Prueba del caso general de aceptaci�n de la pr�rroga
     */
    @Test
    public void aceptarProrrogaTest() {
        MEJDtoDecisionProcedimiento dto = MEJDtoDecisionProcedimientoTestFactory.decisionExistente(idDecisionProcedimiento, idProcedimiento);
        manager.aceptarPropuesta(dto);

        verificacionesGenerales();
    }

    /**
     * Comprueba el caso en el que la propuesta incluya la derivaci�n en otros
     * procedimientos.
     */
    @Test
    public void testPropuesta_derivarProcedimientos() {
        MEJDtoDecisionProcedimiento dto = MEJDtoDecisionProcedimientoTestFactory.decisionExistenteDerivacion(idDecisionProcedimiento, idProcedimiento,idsPrcDerivar);
        manager.aceptarPropuesta(dto);

        verificacionesGenerales();
    }

    /**
     * Este test comprueba el caso en el que se quiere aceptar una pr�rroga de
     * un procedimiento cancelado
     * <p>
     * No se permite aceptar una pr�rroga de un procedimiento cancelado
     * </p>
     */
    @Test(expected = UserException.class)
    public void aceptarProrrogaTest_procedimientoCancelado() {
        MEJDtoDecisionProcedimiento dto = MEJDtoDecisionProcedimientoTestFactory.decisionExistente(idDecisionProcedimiento, idProcedimiento);
        DDEstadoProcedimiento mockEstado = mockProcedimiento.getEstadoProcedimiento();
        when(mockEstado.getCodigo()).thenReturn(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO);
        manager.aceptarPropuesta(dto);
    }

    /**
     * Este test comprueba el caso en el que se quiere aceptar una pr�rroga de
     * un procedimiento cancelado
     * <p>
     * No se permite aceptar una pr�rroga de un procedimiento cancelado
     * </p>
     */
    @Test(expected = UserException.class)
    public void aceptarProrrogaTest_procedimientoCerrado() {
        MEJDtoDecisionProcedimiento dto = MEJDtoDecisionProcedimientoTestFactory.decisionExistente(idDecisionProcedimiento, idProcedimiento);
        DDEstadoProcedimiento mockEstado = mockProcedimiento.getEstadoProcedimiento();
        when(mockEstado.getCodigo()).thenReturn(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
        manager.aceptarPropuesta(dto);
    }

    /**
     * Testea el caso en el que el gestor quiere finalizar el origen.
     * <p>
     * No se le permite, ya que s�lo el supervisor lo puede hacer
     * </p>
     */
    @Test(expected = BusinessOperationException.class)
    public void testGestorIntentaFinalizarOrigen() {
        MEJDtoDecisionProcedimiento dto = MEJDtoDecisionProcedimientoTestFactory.decisionExistente(idDecisionProcedimiento, idProcedimiento);
        dto.setFinalizar(true);
        manager.aceptarPropuesta(dto);
    }

    /**
     * Testea el caso en el que el gestor quiere finalizar el origen.
     * <p>
     * No se le permite, ya que s�lo el supervisor lo puede hacer
     * </p>
     */
    @Test(expected = BusinessOperationException.class)
    public void testGestorIntentaParalizarOrigen() {
        MEJDtoDecisionProcedimiento dto = MEJDtoDecisionProcedimientoTestFactory.decisionExistente(idDecisionProcedimiento, idProcedimiento);
        dto.setParalizar(true);
        manager.aceptarPropuesta(dto);

    }

    /**
     * Comprueba el caso en el que el estado de la propuesta es PROPUESTA. En
     * este caso se debe enviar una notificaci�n al gestor.
     */
    public void testPropuesta_propuesta() {
        // TODO Implementar este test
    }

    /**
     * Comprueba el caso en el que la propuesta sea de finalizaci�n del
     * procedimiento. En este caso se deben finalizar las tareas pendientes del
     * procedimiento.
     */
    public void testPropuesta_finalizarProcedimiento() {
        // TODO Implementar este test
    }

    /**
     * Comprueba el caso en el que la propuesta sea de finalizaci�n del
     * procedimiento. En este caso se deben aplazar todas las tareas.
     */
    public void testPropuesta_paralizarProcedimiento() {
        // TODO Implementar este test
    }

    /**
     * Verificaciones que se repiten en todos los casos.
     */
    private void verificacionesGenerales() {
        verifica().seHaFinalizadoTomaDecision(listaTareas);
        verifica().seHaCambiadoEstadoAsunto(idAsunto);
        
        //FIXME Primero se guarda la decisi�n y despu�s se actualiza, no tiene sentido
        //verifica().seHaGuardadoLaDecision(idDecisionProcedimiento, null, null);
        verifica().seHaGuardadoLaDecision(idDecisionProcedimiento, null, null, null);
        verifica().seHaActualizadoLaDecision(idDecisionProcedimiento, null);
        
        verifica().seDaPorRespondidaTareaBPM(idProcessBPMDecision);
        verifica().seBorraLaTareaAsociada(idTareaAsociada);
    }
}
