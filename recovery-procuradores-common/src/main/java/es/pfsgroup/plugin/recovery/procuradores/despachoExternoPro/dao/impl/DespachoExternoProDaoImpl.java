package es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.dao.impl;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;
import es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.dao.DespachoExternoProDao;

import org.springframework.stereotype.Repository;

@Repository("DespachoExternoProDao")
public class DespachoExternoProDaoImpl extends AbstractEntityDao<DespachoExterno, Long> implements DespachoExternoProDao{
	
	@Override
	public Page getPageDespachosExternos(CategorizacionDto dto, String nombre) {
		HQLBuilder hb = new HQLBuilder(" from DespachoExterno des ");	
		hb.appendWhere(" des.auditoria.borrado = 0 ");
		hb.orderBy("despacho", HQLBuilder.ORDER_ASC);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "des.despacho", nombre, false);
		HQLBuilder.addFiltroIgualQue(hb, "des.tipoDespacho.codigo", DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

}
