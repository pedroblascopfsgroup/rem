package es.capgemini.pfs.plazaJuzgado.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.plazaJuzgado.BuscaPlazaPaginadoDtoInfo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.plazaJuzgado.dao.EXTTipoPlazaDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;


@Repository("EXTTipoPlazaDao")
public class EXTTipoPlazaDaoImpl extends AbstractEntityDao<TipoPlaza, Long> implements EXTTipoPlazaDao{

	@Override
	public Page buscarPorDescripcion(BuscaPlazaPaginadoDtoInfo dto) {
		HQLBuilder b = new HQLBuilder("from TipoPlaza p"); 
        b.appendWhere("auditoria.borrado = false"); 
        HQLBuilder.addFiltroLikeSiNotNull(b, "p.descripcion", dto.getQuery(), true); 
        return HibernateQueryUtils.page(this, b, dto); 
	}

	
}
