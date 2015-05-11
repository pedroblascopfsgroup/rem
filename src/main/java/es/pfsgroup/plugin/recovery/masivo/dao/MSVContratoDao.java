package es.pfsgroup.plugin.recovery.masivo.dao;

import java.math.BigDecimal;

import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.dao.AbstractDao;

public interface MSVContratoDao extends AbstractDao<EXTContrato, Long> {
	public BigDecimal getRestanteDemanda(Long idContrato);
}
