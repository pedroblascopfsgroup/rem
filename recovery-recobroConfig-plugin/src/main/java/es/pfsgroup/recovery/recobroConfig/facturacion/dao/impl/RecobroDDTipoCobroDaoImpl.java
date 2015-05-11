package es.pfsgroup.recovery.recobroConfig.facturacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroDDTipoCobroDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroDDTipoCobro;
import es.pfsgroup.recovery.recobroConfig.facturacion.dao.api.RecobroDDTipoCobroDao;

@Repository("RecobroDDTipoCobroDao")
public class RecobroDDTipoCobroDaoImpl extends AbstractEntityDao<DDSubtipoCobroPago, Long> implements RecobroDDTipoCobroDao{

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Page getCobrosFacturacion(RecobroDDTipoCobroDto dto) {
		Assertions.assertNotNull(dto.getIdModFact(), "Id facturación: No puede ser NULL");
		
		HQLBuilder hb = new HQLBuilder("from DDSubtipoCobroPago tpoCobro");
		//hb.appendWhere("tpoCobro.facturable = " + dto.getFacturables());
		hb.appendWhere("tpoCobro.auditoria.borrado = false");
		hb.appendWhere("tpoCobro " + (dto.getHabilitados() ? "in" : "not in") +
				"(select cobroFact.tipoCobro from RecobroCobroFacturacion cobroFact " +
				"where cobroFact.modeloFacturacion.id = " + dto.getIdModFact() + 
				" and cobroFact.auditoria.borrado = false)");
		//sacamos solo los facturables	
		hb.appendWhere("tpoCobro.facturable = true");
				
		hb.orderBy("tpoCobro.codigo", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
		
		
	}

}
