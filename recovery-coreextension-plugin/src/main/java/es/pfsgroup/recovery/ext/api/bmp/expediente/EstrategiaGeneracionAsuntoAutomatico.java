package es.pfsgroup.recovery.ext.api.bmp.expediente;

import java.util.List;

import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;

public interface EstrategiaGeneracionAsuntoAutomatico {

	List<Long> generaAsuntos(Long idExpediente, DecisionComiteAutomatico dca);

}
