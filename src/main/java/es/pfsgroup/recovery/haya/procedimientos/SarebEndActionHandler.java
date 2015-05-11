package es.pfsgroup.recovery.haya.procedimientos;

import static es.capgemini.pfs.BPMContants.TOKEN_JBPM_PADRE;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.procedimientos.PROEndProcessActionHandler;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class SarebEndActionHandler extends PROEndProcessActionHandler {

	private static final long serialVersionUID = 8848571604183292383L;
	
	private static final String NODO_SALIENTE = "NOMBRE_NODO_SALIENTE";
	private static final String MASK_ULTIMA_TAREA = "id%s.%d";
	private static final String COMBO_RESULTADO = "comboResultado";
	
	@Autowired
	private ProcessManager processManager;

	@Autowired
	private Executor executor;
	
	private ExecutionContext executionContext;

	/**
	 * Procesa tras la salida del estado JBPM
	 */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
    	this.executionContext = executionContext;
		estableceContexto();
		super.run(executionContext);
	}

	/**
	 * Establece la variable de contexto de salida para el procedimiento padre.
	 */
	private void estableceContexto() {

        //si este proceso ha sido iniciado por otro, lanzará una señal con su nombre
		if (executionContext.getVariable(TOKEN_JBPM_PADRE) != null) {

        	final Long idTokenPadre = (Long) executionContext.getVariable(TOKEN_JBPM_PADRE);

        	// Recupera los valores de la tarea para coger el seleccionado.
        	String nombreProceso = getNombreProceso(executionContext);
        	Long tokenId = executionContext.getToken().getId();
        	String nodoSaliente = (String)executionContext.getVariable(NODO_SALIENTE);
        	Long idTareaExterna = (Long)executionContext.getVariable(String.format(MASK_ULTIMA_TAREA,nodoSaliente, tokenId));
        	
        	@SuppressWarnings("unchecked")
			List<EXTTareaExternaValor> listado = (List<EXTTareaExternaValor>)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA, idTareaExterna);
        	
        	TareaExternaValor valor = new TareaExternaValor();
			for (TareaExternaValor tev : listado) {
				try {
					if (COMBO_RESULTADO.equals(tev.getNombre())) {
						valor = tev;
						break;
					}
				} catch (Exception e) {
					logger.error("Error al recuperar valor comboResultado", e);
				}
			}

			// Redirige por la salida correspondiente.
			String resultado = valor.getValor();
			if (StringUtils.isNotBlank(resultado) && proxyFactory.proxy(JBPMProcessApi.class).hasTransitionToken(idTokenPadre, resultado)) {
				proxyFactory.proxy(JBPMProcessApi.class).signalToken(idTokenPadre, resultado);
			} else if (proxyFactory.proxy(JBPMProcessApi.class).hasTransitionToken(idTokenPadre, nombreProceso)) {
				proxyFactory.proxy(JBPMProcessApi.class).signalToken(idTokenPadre, nombreProceso);
			}
            
        }

    }

}
