package es.pfsgroup.recovery.recobroCommon.expediente.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.expediente.dao.CicloRecobroExpedienteDao;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;

@Repository("CicloRecobroExpediente")
public class CicloRecobroExpedienteDaoImpl extends AbstractEntityDao<CicloRecobroExpediente, Long> implements CicloRecobroExpedienteDao {

	@Override
	public Page getPage(CicloRecobroExpedienteDto dto) {
		
		HQLBuilder hb = new HQLBuilder("select cre from CicloRecobroExpediente cre");
		
		if (!Checks.esNulo(dto.getIdExpediente())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cre.expediente.id", dto.getIdExpediente());			
		}
		
		if (!Checks.esNulo(dto.getListaAgencias())){
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "agencia.id", dto.getListaAgencias());
		}
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	

}
