package es.pfsgroup.plugin.recovery.plazosExterna.tipoJuzgado.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoQuery;
import es.pfsgroup.plugin.recovery.plazosExterna.tipoJuzgado.dao.PTETipoJuzgadoDao;

@Repository("PTETipoJuzgadoDao")
public class PTETipoJuzgadoDaoImpl extends AbstractEntityDao<TipoJuzgado, Long> implements PTETipoJuzgadoDao{

	@Override
	public List<TipoJuzgado> findJuzPlazaYDescrip(PTEDtoQuery dto) {
		HQLBuilder hb = new HQLBuilder("from TipoJuzgado juz");
		hb.appendWhere("juz.auditoria.borrado=false");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "juz.plaza.codigo", dto.getCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "juz.descripcion", dto.getQuery());
		
		return HibernateQueryUtils.list(this, hb);
	}

}
