package es.pfsgroup.recovery.ext.impl.bpm.handler.utils;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ClienteApi;

public class BPMParametros implements ClienteBPMConstants, ExpedienteBPMConstants{
	private Map<String, Object> params = new HashMap<String, Object>();
	private ExecutionContext executionContext;
	private ApiProxyFactory proxyFactory;
	private Cliente cliente;
	
	
	public BPMParametros(ExecutionContext executionContext, ApiProxyFactory proxyFactory) {
		if (executionContext == null){
			this.executionContext = executionContext;
			throw new IllegalArgumentException("executionContext no puede ser NULL");
		}
		if (proxyFactory == null){
			this.proxyFactory = proxyFactory;
			throw new IllegalArgumentException("proxyFactory no puede ser NULL");
		}
		putParameter(CLIENTE_ID);
		putParameter(FECHA_EXTRACCION);
		
		this.cliente = proxyFactory.proxy(ClienteApi.class).getWithContratos(this.getIdCliente());
		Long idContrato = this.cliente.getContratoPrincipal().getId();
		Long idPersona = this.cliente.getPersona().getId();

		// BUG: No se setea cuando se cambia de arquetipo y por tanto se
		// ha tenido que añadir esto
		Long idArquetipo = this.cliente.getArquetipo().getId();
		executionContext.setVariable(ARQUETIPO_ID, idArquetipo);
		
		params.put(PERSONA_ID, idPersona);
		params.put(CONTRATO_ID, idContrato);
		params.put(ARQUETIPO_ID, idArquetipo);
		params.put(IDBPMCLIENTE, executionContext.getProcessInstance()
				.getId());
	}
	
	
	public Long getIdCliente(){
		return (Long) params.get(CLIENTE_ID);
	}
	
	public Cliente getCliente(){
		return cliente;
	}


	public Long getIdArquetipo() {
		return this.cliente.getArquetipo().getId();
	}


	public void put(String key, Object value) {
		this.params.put(key, value);
	}


	public Map<String, Object> getParamsMap() {
		return params;
	}


	private void putParameter(String key) {
		Object o =  executionContext.getVariable(key);
		if (Checks.esNulo(o)){
			throw new IllegalStateException("No se ha encontrado el parametro (key=" + key + ") en el contexto del BPM");
		}
		params.put(key, o);
	}	

}
