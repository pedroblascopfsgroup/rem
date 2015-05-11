package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dao.api.RecobroPoliticaDeAcuerdosDao;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;

@Repository("RecobroPoliticaDeAcuerdosDao")
public class RecobroPoliticaDeAcuerdosDaoImpl extends AbstractEntityDao<RecobroPoliticaDeAcuerdos, Long> implements RecobroPoliticaDeAcuerdosDao{

	@Override
	public Page buscaPoliticas(RecobroPoliticaDeAcuerdosDto dto) {
		Assertions.assertNotNull(dto, "RecobroPoliticaDeAcuerdosDto: No puede ser NULL");
		
		HQLBuilder hb = new HQLBuilder("select distinct politica from RecobroPoliticaDeAcuerdos politica");
		hb.appendWhere("politica.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "politica.nombre", dto.getNombre() ,true);
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "politica.estado.codigo", dto.getEstado(),true);
		
		//hb.orderBy("politica.nombre", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}


	@Override
	public List<RecobroPoliticaDeAcuerdos> getModelosDSPoBLQ() {
		StringBuilder hql = new StringBuilder(
				"select distinct pa from RecobroPoliticaDeAcuerdos pa  ");
		hql.append(" where pa.auditoria.borrado = 0 and pa.estado.codigo in ('"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO
				+ "','"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE
				+ "')");
		List<RecobroPoliticaDeAcuerdos> ret = getHibernateTemplate().find(
				hql.toString());
		return ret;
	}
}
