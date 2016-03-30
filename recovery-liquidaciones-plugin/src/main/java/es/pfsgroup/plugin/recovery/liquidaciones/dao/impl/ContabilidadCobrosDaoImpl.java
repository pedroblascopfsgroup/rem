package es.pfsgroup.plugin.recovery.liquidaciones.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.ContabilidadCobrosDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;

@Repository("ContabilidadCobrosDaoImpl")
public class ContabilidadCobrosDaoImpl extends AbstractEntityDao<ContabilidadCobros, Long> implements ContabilidadCobrosDao{

	@Override
	public List<ContabilidadCobros> getListadoContabilidadCobros(DtoContabilidadCobros dto) {
		HQLBuilder hb = new HQLBuilder("from ContabilidadCobros cco");
		hb.appendWhere("cco.asunto.id = "+dto.getId() + " and cco.auditoria.borrado = 0 "); // ID de asunto y borrado.
		hb.orderBy("fechaValor", HQLBuilder.ORDER_DESC);

		return HibernateQueryUtils.list(this, hb);
	}
	
	@Override
	public ContabilidadCobros getContabilidadCobroByID(DtoContabilidadCobros dto){
		HQLBuilder hb = new HQLBuilder("from ContabilidadCobros cco");
		hb.appendWhere("cco.id = "+dto.getId()); // ID de Contabilidad Cobro.

		return HibernateQueryUtils.uniqueResult(this, hb);
	}
	
}
