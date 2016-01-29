package es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dao.JUZJuzgadoDao;
import es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto.JUZDtoBusquedaPlaza;

@Repository("JUZJuzgadoDao")
public class JUZJuzgadoDaoImpl extends AbstractEntityDao<TipoJuzgado, Long> implements JUZJuzgadoDao {

	@Override
	public Page findJuzgados(JUZDtoBusquedaPlaza dto) {
		HQLBuilder hb = new HQLBuilder("from TipoJuzgado juz");
		hb.appendWhere("juz.auditoria.borrado=false");
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "juz.plaza.descripcion", dto.getFiltroPlaza(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "juz.descripcion", dto.getFiltroJuzgado(), true);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public TipoJuzgado createNewJuzgado() {
		TipoJuzgado juzgado= new TipoJuzgado();
		juzgado.setId(getLastId()+1);
		return juzgado;
	}

	public Long getLastId() {
		HQLBuilder b = new HQLBuilder("select max(id) from TipoJuzgado");
		return (Long) getSession().createQuery(b.toString()).uniqueResult();
	}

	@Override
	public List<TipoJuzgado> findByPlaza(Long idPlaza) {
		HQLBuilder hb = new HQLBuilder("from TipoJuzgado juz");
		hb.appendWhere("juz.auditoria.borrado=false");
		
		HQLBuilder.addFiltroIgualQue(hb, "juz.plaza.id", idPlaza);
		
		return HibernateQueryUtils.list(this, hb);
	}

	
	
	
	
	

}
