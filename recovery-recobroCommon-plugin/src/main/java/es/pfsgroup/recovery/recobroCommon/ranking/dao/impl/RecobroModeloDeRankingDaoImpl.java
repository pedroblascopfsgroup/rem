package es.pfsgroup.recovery.recobroCommon.ranking.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroModeloDeRankingDao;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloDeRankingDto;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;

@Repository("RecobroModeloDeRankingDao")
public class RecobroModeloDeRankingDaoImpl extends AbstractEntityDao<RecobroModeloDeRanking, Long> implements RecobroModeloDeRankingDao{

	@Override
	public Page buscarModelosRanking(RecobroModeloDeRankingDto dto) {
		Assertions.assertNotNull(dto, "RecobroModeloDeRankingDto: No puede ser NULL");
		
		HQLBuilder hb = new HQLBuilder("select distinct ranking from RecobroModeloDeRanking ranking");
		hb.appendWhere("ranking.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "ranking.nombre", dto.getNombre() ,true);
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "ranking.estado.codigo", dto.getEstado(),true);
		
		//hb.orderBy("ranking.nombre", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public List<RecobroModeloDeRanking> getModelosDSPoBLQ() {
		StringBuilder hql = new StringBuilder(
				"select distinct mr from RecobroModeloDeRanking mr  ");
		hql.append(" where mr.auditoria.borrado = 0 and mr.estado.codigo in ('"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO
				+ "','"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE
				+ "')");
		List<RecobroModeloDeRanking> ret = getHibernateTemplate().find(
				hql.toString());
		return ret;
	}

}
