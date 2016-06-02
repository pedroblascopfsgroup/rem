package es.pfsgroup.plugin.recovery.procuradores.busqueda.dao.impl;


import java.util.Collection;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.dao.api.MSVAsuntoAllDao;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.model.MSVAsuntoAll;

@Repository("MSVAsuntoAllDao")
public class MSVAsuntoAllDaoImpl extends AbstractEntityDao<MSVAsuntoAll,Long> implements MSVAsuntoAllDao {

	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends MSVAsuntoAll> getAsuntos(String query, Long idUsuarioLogado) {
		StringBuilder hql = new StringBuilder();
		hql.append("from MSVAsuntoAll ");
		hql.append("where usu_id=" + idUsuarioLogado);
		hql.append(" and upper(concat(nombre, ' ', plaza, ' ', juzgado, ' ', auto)) like '%"
				+ query.toUpperCase() + "%' ");
		//hql.append("order by plaza, juzgado, auto, nombre");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}
}
