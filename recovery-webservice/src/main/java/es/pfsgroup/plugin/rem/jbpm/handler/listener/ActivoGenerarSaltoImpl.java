package es.pfsgroup.plugin.rem.jbpm.handler.listener;


import java.util.Iterator;
import java.util.Map;

import org.jbpm.graph.def.Node;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.genericlistener.GenerarTransicionSaltoListener;
import es.pfsgroup.plugin.rem.jbpm.handler.ActivoBaseActionHandler;

/**
 * 
 * @author Daniel Gutiérrez
 * Listener que genera la transición 'saltoX' en los nodos.
 * 
 */
@Component
public class ActivoGenerarSaltoImpl extends ActivoBaseActionHandler implements GenerarTransicionSaltoListener {

	private static final long serialVersionUID = -6204184256333027776L;
	public static final String CODIGO_SALTO_CIERRE = "CierreEconomico";
	public static final String CODIGO_FIN = "Fin";


	@Override
	public void fireEvent(Map<String, Object> map) {
		
//		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
//		this.generaTransicionsSaltoCierreEconomico(executionContext);

	}
	
	@Override
	public void fireEventGeneric(Map<String, Object> map, String tipoSalto){
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.creaSalto(executionContext, tipoSalto);
	}
	
	/**
	 * Crea una transición para un salto 
	 * @param tipoSalto
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void creaSalto(ExecutionContext executionContext, String tipoSalto) {
		Node node = null;
		
		Map<String,Node> mapaNodos = executionContext.getProcessDefinition().getNodesMap();
		Iterator it = mapaNodos.keySet().iterator();
		while(it.hasNext()){
		  String key = (String) it.next();
		  if(key.contains(tipoSalto))
			  node = mapaNodos.get(key);
		}
		if (!existeTransicion("salto"+tipoSalto, executionContext)) {
			nuevaTransicionConDestino("salto"+tipoSalto, executionContext, node);
		}
	}

}