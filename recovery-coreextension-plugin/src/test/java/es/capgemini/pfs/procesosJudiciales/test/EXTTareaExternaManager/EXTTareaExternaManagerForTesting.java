package es.capgemini.pfs.procesosJudiciales.test.EXTTareaExternaManager;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.EXTTareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

/**
 * Esta es una clase que extiende el {@link EXTTareaExternaManager} original sólo para poder testear los métodos protected con Mockito.
 * @author bruno
 *
 */
public class EXTTareaExternaManagerForTesting extends EXTTareaExternaManager {

    @Override
    @Deprecated
    public List<? extends TareaExterna> getListadoTareasSinOptimizar(Long idProcedimiento) {
        return super.getListadoTareasSinOptimizar(idProcedimiento);
    }

    public List<? extends TareaExterna>  obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(Long idProcedimiento) {
        return super.obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(idProcedimiento);
        
    }

    
}
