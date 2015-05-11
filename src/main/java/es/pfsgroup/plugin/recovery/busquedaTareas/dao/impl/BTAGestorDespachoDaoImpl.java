package es.pfsgroup.plugin.recovery.busquedaTareas.dao.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.stereotype.Repository;

import org.hibernate.Query;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTAGestorDespachoDao;

@Repository("BTAGestorDespachoDao")
public class BTAGestorDespachoDaoImpl extends AbstractEntityDao<GestorDespacho, Long> implements BTAGestorDespachoDao {

	@Override
	public GestorDespacho getGestorDespachoPorIdUsuario(Long idUsuario) {
		HQLBuilder hql = new HQLBuilder("from GestorDespacho");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "usuario.id", idUsuario);

		Query q = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(q, hql);
		return (GestorDespacho) q.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GestorDespacho> getGestoresDespacho(Long idDespacho) {
		if (Checks.esNulo(idDespacho)) throw new IllegalArgumentException("idDespacho null");
		HQLBuilder hql = new HQLBuilder("from GestorDespacho");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "borrado", 0);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "despachoExterno.id", idDespacho);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "supervisor", false);
		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		return query.list();
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<GestorDespacho> getGestoresDespachoByUsd(String usdId) {
		if (Checks.esNulo(usdId)) 
			throw new IllegalArgumentException("id null");
		
		List<String> lista = new ArrayList<String>();
		for (String id: usdId.split (","))
			lista.add(id);
		
		Collection col = lista;
		
		HQLBuilder hql = new HQLBuilder("from GestorDespacho");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "borrado", 0);
		HQLBuilder.addFiltroWhereInSiNotNull(hql, "id", col);
		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		
		return query.list();
	}
}
