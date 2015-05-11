package es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dao.impl;

import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dao.CobrosPagosDao;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dto.DtoCobrosPagos;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.model.RecobroPagoContrato;

@Repository("CobrosPagosDao")
public class CobrosPagosDaoImpl extends AbstractEntityDao<RecobroPagoContrato, Long> implements CobrosPagosDao {

	@Override
	public Page getListadoCobrosPagos(DtoCobrosPagos dto) {
		HQLBuilder hb = new HQLBuilder("from RecobroPagoContrato cpa");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cpa.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cpa.contrato.id", dto.getContrato().getId());
		
		//hb.orderBy(dto.getSort(), HQLBuilder.ORDER_ASC);
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	@Deprecated
	public RecobroPagoContrato getDetalleCobroPago(DtoCobrosPagos dto) {

		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Long getCntIdPaseByExpId(Long idExpediente) {

		String queryString = "select TO_CHAR(cnt.cnt_id) from cnt_contratos cnt join cex_contratos_expediente cex on cnt.cnt_id = cex.cnt_id and cex.cex_pase = 1 and cex.borrado = 0";
		queryString += " and cex.exp_id = '" + idExpediente + "'";

		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(queryString);

		List<String> lista = sqlQuery.list();
		for (String obj : lista) {
			if(obj != null) return Long.parseLong(obj.toString());
		}
		
		return null;

	}

}
