package es.pfsgroup.plugin.recovery.mejoras.test.procedimiento.MEJProcedimientoManager.bo;

import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InOrder;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.test.procedimiento.MEJProcedimientoManager.AbstractMEJProcedimientoManagerTests;

/**
 * Pruebas del método saveOrUpdate de {@link MEJProcedimientoManager}
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class SaveOrUpdateProcedimientoTest extends AbstractMEJProcedimientoManagerTests {

    private Procedimiento mockProcedimiento;
    private List<ProcedimientoContratoExpediente> prcCntExpList;
    private Long idProcedimiento;
    private TipoProcedimiento mockTipoProcedimiento;

    @Override
    public void childBefore() {
        Random random = new Random();

        mockProcedimiento = mock(Procedimiento.class);
        mockTipoProcedimiento = mock(TipoProcedimiento.class);
        prcCntExpList = new ArrayList<ProcedimientoContratoExpediente>();
        idProcedimiento = random.nextLong();

        when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
        when(mockProcedimiento.getProcedimientosContratosExpedientes()).thenReturn(prcCntExpList);

        when(mockProcedimiento.getTipoProcedimiento()).thenReturn(mockTipoProcedimiento);
        when(mockTipoProcedimiento.getCodigo()).thenReturn("P11");
    }

    @Override
    public void childAfter() {
        mockProcedimiento = null;
        idProcedimiento = null;
        prcCntExpList = null;
        mockTipoProcedimiento = null;
    }

    @Test
    public void testSaveOrUpdate() {

        doNothing().when(managerSpy).cambiarGestorSupervisorTramiteSubasta(mockProcedimiento);

        managerSpy.saveOrUpdateProcedimiento(mockProcedimiento);

        verificacionesBasicas();
    }

    // FIXME Tenemos que activar este test para que se compruebe la gestión de
    // errores
    // @Test(expected = BusinessOperationException.class)
    public void testSaveOrUpdate_falloAlCambiarElGestor() {

        doThrow(Exception.class).when(managerSpy).cambiarGestorSupervisorTramiteSubasta(mockProcedimiento);

        managerSpy.saveOrUpdateProcedimiento(mockProcedimiento);

        verificacionesBasicas();
    }

    private void verificacionesBasicas() {
        InOrder orden = inOrder(mockProcedimientoDao, mockProcedimientoContratoExpedienteDao, managerSpy);

        // Verificamos que se ha guardado elprocedimiento
        orden.verify(mockProcedimientoDao, times(1)).saveOrUpdate(mockProcedimiento);

        // No estamos seguros de que esto haga falta, TODO Comprobar si esto
        // hace falta.
        orden.verify(mockProcedimientoContratoExpedienteDao, times(1)).actualizaCEXProcedimiento(prcCntExpList, idProcedimiento);

        orden.verify(managerSpy, times(1)).cambiarGestorSupervisorTramiteSubasta(mockProcedimiento);

        orden.verifyNoMoreInteractions();
    }
}
