package es.pfsgroup.recovery.panelcontrol.judicial.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.panelcontrol.judicial.dao.PCTipoPlazaDao;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.PCDtoQuery;

@Repository("PCTipoPlazaDao")
public class PCTipoPlazaDaoImpl extends AbstractEntityDao<TipoPlaza, Long> implements PCTipoPlazaDao{

	@Override
	public Page buscarPorDescripcion(PCDtoQuery dto) {
		HQLBuilder b = new HQLBuilder("from TipoPlaza p");
		b.appendWhere("auditoria.borrado = false");
		HQLBuilder.addFiltroLikeSiNotNull(b, "p.descripcion", dto.getQuery(), true);
		b.orderBy("p.descripcion", HQLBuilder.ORDER_ASC);
		return HibernateQueryUtils.page(this, b, dto);
	}

	@Override
	public List<TipoPlaza> getListOrderedByDescripcion() {
		HQLBuilder b = new HQLBuilder("from TipoPlaza p");
		b.appendWhere("auditoria.borrado = false");
		b.orderBy("p.descripcion", HQLBuilder.ORDER_ASC);
		return HibernateQueryUtils.list(this,b);
	}

}
