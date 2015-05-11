package es.pfsgroup.procedimientos.recoveryapi;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

/**
 * Esta clase proporciona implementaciones vac�as de la API est�ndar de BPM. Extendiendo esta clase podemos implementar s�lamente las nuevas operaciones de negocios.
 * @author bruno
 *
 */
public abstract class AbstractJBPMProcessManager implements JBPMProcessApi{

	@Override
	public Object evaluaScript(Long idProcedimiento, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal, String script) throws Exception {
		return null;
	}

	@Override
	public Procedimiento creaProcedimientoHijo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre) {
		return null;
	}

	@Override
	public Long lanzaBPMAsociadoAProcedimiento(Long idProcedimiento, Long idTokenAviso) {
		return null;
	}

	@Override
	public void destroyProcess(Long idProcess) {
		
	}

	@Override
	public Boolean getFixeBooleanValue(ExecutionContext executionContext, String key) {
		return null;
	}

	@Override
	public Object getVariablesToProcess(Long idProcess, String variableName) {
		return null;
	}

	@Override
	public Boolean hasTransitionToken(Long idToken, String transitionName) {
		return null;
	}

	@Override
	public void signalToken(Long idToken, String transitionName) {
		
	}

}
