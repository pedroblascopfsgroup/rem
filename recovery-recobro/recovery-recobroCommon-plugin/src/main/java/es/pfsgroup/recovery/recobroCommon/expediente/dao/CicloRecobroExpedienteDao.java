package es.pfsgroup.recovery.recobroCommon.expediente.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;

public interface CicloRecobroExpedienteDao extends AbstractDao<CicloRecobroExpediente, Long> {

	Page getPage(CicloRecobroExpedienteDto dto);


}
