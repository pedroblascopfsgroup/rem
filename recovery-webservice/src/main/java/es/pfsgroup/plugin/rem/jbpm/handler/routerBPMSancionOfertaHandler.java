package es.pfsgroup.plugin.rem.jbpm.handler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

public class routerBPMSancionOfertaHandler extends ActivoBaseActionHandler{
	
	private static final long serialVersionUID = 1L;
	ExecutionContext executionContext;
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception{
		this.setContext(executionContext);
		ActivoTramite tramite = getActivoTramite(executionContext);
		DDCartera cartera = tramite.getActivo().getCartera();
		DDSubcartera subcartera = tramite.getActivo().getSubcartera();
		String target = getTarget(tramite, cartera.getCodigo(), subcartera.getCodigo(), executionContext.getToken().getNode().getFullyQualifiedName());		
		executionContext.getToken().signal(target);
	}
	
	private String getTarget(ActivoTramite tramite, String codigo, String subCodigo, String origin) {
		Map<String, String> target = new HashMap<String, String>();
		target.put(DDCartera.CODIGO_CARTERA_THIRD_PARTY, getTargetThirdParties(subCodigo, origin));
		return target.get(codigo);
	}
	
	private String getTargetThirdParties(String codigoSubcartera, String origin) {
		
		return null;
	}
	
	
	
	private void setDecision(String variable, String action) {
		getContext().setVariable(variable, action);
	}
	
	private void setContext(ExecutionContext ctx) {
		this.executionContext = ctx;
	}
	
	private ExecutionContext getContext() {
		return executionContext;
	}
}

