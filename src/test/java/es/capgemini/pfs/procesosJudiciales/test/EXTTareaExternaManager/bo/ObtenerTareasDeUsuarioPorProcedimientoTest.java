package es.capgemini.pfs.procesosJudiciales.test.EXTTareaExternaManager.bo;

import static org.mockito.Mockito.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.procesosJudiciales.test.EXTTareaExternaManager.AbstractEXTTareaExternaManagerTests;

/**
 * Prueba la BO de obtención de tareas de un usuario por procedimiento.
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class ObtenerTareasDeUsuarioPorProcedimientoTest extends AbstractEXTTareaExternaManagerTests{

    private Long idProcedimiento;

    @Override
    public void childBefore() {
        idProcedimiento = random.nextLong();
    }

    @Override
    public void childAfter() {
        idProcedimiento = null;
    }
    
    @Test
    public void testObtenerTareasConOptimizacion(){
        simular().optimizacionBuzonesActivada();
        
        managerSpy.obtenerTareasDeUsuarioPorProcedimiento(idProcedimiento);
        
        verify(managerSpy, times(1)).obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(idProcedimiento);
    }
    
    @Test
    public void testObtenerTareasSinOptimizacion(){
        simular().optimizacionBuzonesDesactivada();
        
        managerSpy.obtenerTareasDeUsuarioPorProcedimiento(idProcedimiento);
        
        verify(managerSpy, times(1)).getListadoTareasSinOptimizar(idProcedimiento);
    }

}
