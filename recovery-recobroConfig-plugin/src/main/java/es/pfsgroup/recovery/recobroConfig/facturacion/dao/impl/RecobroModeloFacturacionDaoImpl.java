package es.pfsgroup.recovery.recobroConfig.facturacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoEsquema;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroConfig.facturacion.dao.api.RecobroModeloFacturacionDao;

@Repository("RecobroModeloFacturacionDao")
public class RecobroModeloFacturacionDaoImpl extends
		AbstractEntityDao<RecobroModeloFacturacion, Long> implements
		RecobroModeloFacturacionDao {

	@Override
	public Page buscaModelosFacturacion(RecobroModeloFacturacionDto dto) {
		Assertions.assertNotNull(dto,
				"RecobroModeloFacturacionDto: No puede ser NULL");

		HQLBuilder hb = new HQLBuilder(
				"select distinct modelo from RecobroModeloFacturacion modelo");
		hb.appendWhere("modelo.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "modelo.nombre", dto.getNombre(),
				true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "modelo.tipoCorrector.codigo",
				dto.getTipoDeCorrector(), true);
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "modelo.estado.codigo", dto.getEstado(),true);
		
		if (dto.getEsquemaVigente()) {
			hb.appendWhere(" modelo.id in (select sca.modeloFacturacion.id "
					+ "					   from RecobroEsquema esquema, RecobroCarteraEsquema ce, RecobroSubCartera sca "
					+ "				       where esquema.id = ce.esquema.id AND "
					+ "			 			     esquema.auditoria.borrado = 0 AND "
					+ "					  	     ce.auditoria.borrado = 0 AND "
					+ "							 ce.id = sca.carteraEsquema.id AND  "
					+ "					  	     sca.auditoria.borrado = 0 AND "
					+ "							 esquema.estadoEsquema.codigo = '"
					+ RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO
					+ "' ) ");
		}

		// hb.orderBy("modelo.nombre", HQLBuilder.ORDER_ASC);

		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public List<RecobroModeloFacturacion> getModelosDSPoBLQ() {
		StringBuilder hql = new StringBuilder(
				"select distinct mf from RecobroModeloFacturacion mf  ");
		hql.append(" where mf.auditoria.borrado = 0 and mf.estado.codigo in ('"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO
				+ "','"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE
				+ "')");
		List<RecobroModeloFacturacion> ret = getHibernateTemplate().find(
				hql.toString());
		return ret;
	}
}
