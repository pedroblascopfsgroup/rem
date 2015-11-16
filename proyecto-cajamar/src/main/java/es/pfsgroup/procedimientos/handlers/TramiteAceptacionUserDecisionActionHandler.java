package es.pfsgroup.procedimientos.handlers;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TareaProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.procedimientos.PROGenericUserDecisionActionHandler;
import es.pfsgroup.procedimientos.recoveryapi.TareaProcedimientoApi;

@Component
public class TramiteAceptacionUserDecisionActionHandler extends PROGenericUserDecisionActionHandler {
    private static final long serialVersionUID = 1L;
    
    @Autowired
    private TareaProcedimientoManager tareaProcedimientoManager;

    @Override
    public Procedimiento getProcedimiento(ExecutionContext executionContext) 
    {
    	return super.getProcedimiento(executionContext).getProcedimientoPadre();
    }
    
    @Override
    protected TareaProcedimiento getTareaProcedimientoBBDD(String codigoTarea,
    		ExecutionContext executionContext) 
    {
    	Long idTipoProcedimiento = super.getProcedimiento(executionContext).getTipoProcedimiento().getId();
        TareaProcedimiento tareaProcedimiento = tareaProcedimientoManager.getByCodigoTareaIdTipoProcedimiento(idTipoProcedimiento, getNombreNodo(executionContext));    
        
        return tareaProcedimiento; 
    }
}
