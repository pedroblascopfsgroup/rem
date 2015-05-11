package es.pfsgroup.procedimientos.contratos;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;

public class IteradorAActionHandler extends IteradorActionHandler {
    
	private static final long serialVersionUID = 1L;

	@Autowired
	private Executor executor;
	
    /**
     * Devuelve los Ids de los contratos para iterar. 
     * @return
     */
    @Override
    protected List<Long> getIds(ExecutionContext executionContext) {
    	Procedimiento proc = getProcedimiento(executionContext);
    	@SuppressWarnings("unchecked")
		List<Long> lista = (List<Long>)executor.execute("es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.bpmDameContratosConIniciarEjecucionA", proc.getId());
    	return lista;
    }
    
}