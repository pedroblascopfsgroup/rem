package es.pfsgroup.plugin.rem.jbpm.activo;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.PlazoTareaExternaPlazaManager;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoScriptExecutorApi;


/**
 * Refactorización de las clases de la api de ejecución de BPMs.
 * @author manuel
 */
@org.springframework.stereotype.Service("jbpmActivoTareasUtil")
@Scope(BeanDefinition.SCOPE_SINGLETON)
public class JBPMActivoTareasManager implements BPMContants, JBPMActivoTareasManagerApi{

    protected final Log logger = LogFactory.getLog(getClass());

    @Autowired
    protected JBPMActivoScriptExecutorApi jbpmActivoScriptExecutorApi;
    
    @Autowired
    private PlazoTareaExternaPlazaManager plazoTareaExternaPlazaManager;

	/**
	 * Devuelve el plazo (en milisegundos) de una tarea de un activo.
	 * @param idTipoTarea id del tipo de tarea
	 * @param idTramite id del procedimiento al que pertenece
	 * @return plazo de la tarea en milisegundos
	 */	
	public Long getPlazoTarea(Long idTipoTarea, Long idTramite) {
		
	    PlazoTareaExternaPlaza plazoTareaExternaPlaza = plazoTareaExternaPlazaManager.getByTipoTareaTipoPlazaTipoJuzgado(idTipoTarea, null, null);
	
	    String script = "Sin determinar";
	    Long plazo;
	    try {
	        script = plazoTareaExternaPlaza.getScriptPlazo();
	        String result = jbpmActivoScriptExecutorApi.evaluaScript(idTramite, null, idTipoTarea, null, script).toString();
	        plazo = Long.parseLong(result.toString());
	    } catch (Exception e) {
	        logger.error("Error en el script de consulta de plazo [" + script + "]. Trámite [" + idTramite + "], tipoTarea ["
	                + idTipoTarea + "].", e);
	        throw new UserException("bpm.error.script");
	    }
	    return plazo;
	}
	
    /**
     * Método que inicializa las fechas de una tarea.
     * @param tarea Tarea del BPM para inicializar las fechas
     */
    public void iniciaFechasTarea(TareaNotificacion tarea, ExecutionContext executionContext) {
        Date fechaInicio = (Date) getVariable(BPMContants.FECHA_ACTIVACION_TAREAS, executionContext);
        if (fechaInicio == null) {
            fechaInicio = new Date();
        }
        
        Long idTramite;

        if (tarea instanceof TareaActivo){
        	TareaActivo tareaActivo = (TareaActivo) tarea;
        	idTramite = tareaActivo.getTramite().getId();
        }else{
        	idTramite = tarea.getProcedimiento().getId();
        }

        Long idTipoTarea = tarea.getTareaExterna().getTareaProcedimiento().getId();

        Long plazo = this.getPlazoTarea(idTipoTarea, idTramite);
        Date fechaVenc = new Date(fechaInicio.getTime() + plazo);

        tarea.setFechaInicio(fechaInicio);
        tarea.setFechaVenc(fechaVenc);
        tarea.setAlerta(false);
    }

    private Object getVariable(String key, ExecutionContext executionContext) {
        return executionContext.getVariable(key);
    }

}
