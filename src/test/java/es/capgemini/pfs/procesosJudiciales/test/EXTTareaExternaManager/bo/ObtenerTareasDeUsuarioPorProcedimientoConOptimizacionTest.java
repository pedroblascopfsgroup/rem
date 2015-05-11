package es.capgemini.pfs.procesosJudiciales.test.EXTTareaExternaManager.bo;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.test.EXTTareaExternaManager.AbstractEXTTareaExternaManagerTests;

@RunWith(MockitoJUnitRunner.class)
public class ObtenerTareasDeUsuarioPorProcedimientoConOptimizacionTest extends AbstractEXTTareaExternaManagerTests {

    private Long idProcedimiento;
    
    private List<? extends TareaExterna> tareas;

    private Long idUsuario;


    @Override
    public void childBefore() {
        idProcedimiento = random.nextLong();
        idUsuario = random.nextLong();
        tareas = new ArrayList<TareaExterna>();
    }

    @Override
    public void childAfter() {
        idProcedimiento = null;
        idUsuario = null;
        tareas = null;
    }

    
    @Test
    public void test(){
        simular().seObtieneUsuarioLogado(idUsuario);
        simular().seObtienenTareasExternasMedianteOptimizacion(idProcedimiento, idUsuario, tareas);
        
        List<? extends TareaExterna> obtenidas = manager.obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(idProcedimiento);
        
        assertEquals("La lista de tareas obtenida no es la esperada", tareas, obtenidas);
    }
}
