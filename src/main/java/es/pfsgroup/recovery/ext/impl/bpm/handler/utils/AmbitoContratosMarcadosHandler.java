package es.pfsgroup.recovery.ext.impl.bpm.handler.utils;

import java.util.List;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.ext.api.expediente.EXTExpedienteApi;

public class AmbitoContratosMarcadosHandler {
	private BPMParametros parametros;
	private ApiProxyFactory proxyFactory;
	private Executor executor;
	
	private Arquetipo arqPersona;
	private DDAmbitoExpediente ambito;
	
	private ContratosPersona contratosPersona;
	
	public AmbitoContratosMarcadosHandler(BPMParametros parametros,
			ApiProxyFactory proxyFactory, Executor executor) {
		this.parametros = parametros;
		this.proxyFactory = proxyFactory;
		this.executor = executor;
		
		
		this.arqPersona = getArquetipo(parametros);
		this.ambito = arqPersona.getItinerario()
				.getAmbitoExpediente();
		this.contratosPersona = new ContratosPersona(parametros, proxyFactory);
	}
	
	
	
	
	public boolean necestaGenerarVariosExpedientes(){
		return isAmbitoContratosMarcados() && diferentesMarcas();
	}
	
	public List<Long> getContratosPase(){
		return this.contratosPersona.getContratosPase();
	}
	
	
	private boolean diferentesMarcas() {
		return contratosPersona.hayDiferentesMarcas();
	}




	private Arquetipo getArquetipo(BPMParametros parametros) {
		Arquetipo arqPersona = (Arquetipo) executor.execute(
				ConfiguracionBusinessOperation.BO_ARQ_MGR_GET,
				parametros.getIdArquetipo());
		return arqPersona;
	}

	private boolean isAmbitoContratosMarcados() {
		return this.ambito.getCodigo().equals(
				EXTExpedienteApi.AMBITO_EXPEDIENTE_CONTRATOS_MARCADOS);
	}
}
