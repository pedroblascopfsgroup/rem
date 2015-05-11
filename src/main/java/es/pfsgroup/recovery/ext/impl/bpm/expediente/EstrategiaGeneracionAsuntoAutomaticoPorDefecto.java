package es.pfsgroup.recovery.ext.impl.bpm.expediente;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.ext.api.bmp.expediente.EstrategiaGeneracionAsuntoAutomatico;

public class EstrategiaGeneracionAsuntoAutomaticoPorDefecto implements
		EstrategiaGeneracionAsuntoAutomatico {
	
	
	public EstrategiaGeneracionAsuntoAutomaticoPorDefecto(
			ApiProxyFactory proxyFactory) {
		super();
		this.proxyFactory = proxyFactory;
	}

	private ApiProxyFactory proxyFactory;

	@Override
	public List<Long> generaAsuntos(Long idExpediente,
			DecisionComiteAutomatico dca) {
		Long asunto = proxyFactory.proxy(ExpedienteApi.class).crearDatosParaDecisionComiteAutomatica(idExpediente, dca);
		return Arrays.asList(asunto);
	}

}
