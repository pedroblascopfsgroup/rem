package es.pfsgroup.plugin.recovery.mejoras.expediente;

import java.io.Serializable;
import java.util.List;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.pfsgroup.commons.utils.Checks;

public class MEJExpedienteFacade implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9011566743151521407L;
	private Expediente expediente;

	public MEJExpedienteFacade(Expediente expediente) {
		this.expediente = expediente;
	}

	public ExpedienteContrato getExpedienteContrato(Contrato contrato) {
		List<ExpedienteContrato> cexs = expediente.getContratos();
		if ((contrato == null) || Checks.estaVacio(cexs))
			return null;

		for (ExpedienteContrato cex : cexs) {
			if ((cex.getContrato() != null)
					&& cex.getContrato().getId().equals(contrato.getId())) {
				return cex;
			}
		}
		return null;
	}

	public boolean hasContrato(Contrato contrato) {
		return getExpedienteContrato(contrato) != null;
	}
}
