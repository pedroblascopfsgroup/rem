package es.pfsgroup.procedimientos.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.procedimientos.PluginProcedimientosConstantsComponents;
import es.pfsgroup.procedimientos.dao.TipoPlazaDao;
import es.pfsgroup.procedimientos.dto.DtoQuery;

@Repository(PluginProcedimientosConstantsComponents.DAO_TIPO_PLAZA)
public class TipoPlazaDaoImpl extends AbstractEntityDao<TipoPlaza, Long> implements TipoPlazaDao{

	@Override
	public Page buscarPorDescripcion(DtoQuery dto) {
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
