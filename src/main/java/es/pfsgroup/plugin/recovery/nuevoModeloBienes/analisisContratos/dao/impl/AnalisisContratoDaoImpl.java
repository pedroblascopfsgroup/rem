package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dao.AnalisisContratoDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosWebDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.AnalisisContratos;

@Repository("AnalisisContratoDao")
public class AnalisisContratoDaoImpl extends AbstractEntityDao<AnalisisContratos, Long> implements AnalisisContratoDao {

	@Override
	public Page getListadoAnalisisContratos(AnalisisContratosWebDto dto) {
		HQLBuilder b = new HQLBuilder("from AnalisisContratos");
		HQLBuilder.addFiltroIgualQue(b, "asunto.id", dto.getAsuId());

		return HibernateQueryUtils.page(this, b, dto);
	}

}
