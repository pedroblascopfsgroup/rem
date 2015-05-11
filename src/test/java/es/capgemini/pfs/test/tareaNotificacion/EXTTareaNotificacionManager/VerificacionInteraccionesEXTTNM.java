package es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager;

import static org.mockito.Mockito.*;

import java.util.Map;

import org.mockito.ArgumentCaptor;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

/**
 * Utilidad que contiene el código de verificación para todas las interacciones
 * del manager con otros objetos
 * 
 * @author bruno
 * 
 */
public class VerificacionInteraccionesEXTTNM {

    private Executor mockExecutor;
    private GenericABMDao mockGenericDao;

    /**
     * En el constructor se le deben pasar todos los mocks de cada uno de los
     * colaboradores del mánager.
     * 
     * @param executor
     * @param genericDao
     */
    public VerificacionInteraccionesEXTTNM(Executor executor, GenericABMDao genericDao) {
        this.mockExecutor = executor;
        this.mockGenericDao = genericDao;
    }

    /**
     * Comprueba que se haya respondido la prórroga.
     * 
     * @param dto
     */
    public void seHaGeneradoRespuestaProrroga(DtoSolicitarProrroga dto) {
        verify(mockExecutor).execute(InternaBusinessOperation.BO_PRORR_MGR_RESPONDER_PRORROGA, dto);

    }

    /**
     * Comprueba que se haya guardado una tarea
     * 
     * @param tarea
     *            Tarea que queremos que se haya guardado
     */
    public void seHaGuardadoLaTarea(TareaNotificacion tarea) {
        verify(mockGenericDao).update(any(Class.class), eq(tarea));
    }

    public void seHaGuardadoLaProrroga() {
        ArgumentCaptor<Prorroga> argument = ArgumentCaptor.forClass(Prorroga.class);

        verify(mockExecutor, times(1)).execute(eq(InternaBusinessOperation.BO_PRORR_MGR_SAVE_OR_UPDATE), argument.capture());
    }

    /**
     * Verifica que se haya creado un BPM con unos parámetros concretos
     * 
     * @param codBPM
     */
    public void seHaCreadoBPMConParametros(String codBPM) {

        ArgumentCaptor<Map> argument = ArgumentCaptor.forClass(Map.class);
        
        verify(mockExecutor).execute(eq(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS), eq(codBPM), argument.capture());
        Map params = argument.getValue();

    }

}
