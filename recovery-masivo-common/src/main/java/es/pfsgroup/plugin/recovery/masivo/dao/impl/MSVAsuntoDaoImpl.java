package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.util.Collection;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVAsuntoDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVAsunto;

@Repository("MSVAsuntoDao")
public class MSVAsuntoDaoImpl extends AbstractEntityDao<MSVAsunto,Long> implements MSVAsuntoDao {

	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends MSVAsunto> getAsuntos(String query, Long idUsuarioLogado) {
		StringBuilder hql = new StringBuilder();
		hql.append("from MSVAsunto ");
		hql.append("where usu_id=" + idUsuarioLogado);
		hql.append("and upper(concat(nombre, ' ', plaza, ' ', juzgado, ' ', auto)) like '%"
				+ query.toUpperCase() + "%' ");
		//hql.append("order by plaza, juzgado, auto, nombre");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends MSVAsunto> getAsuntosGrupoUsuarios(String query, List<Long> listaUsuarios) {
		StringBuilder hql = new StringBuilder();
		hql.append("from MSVAsunto ");
		hql.append("where usu_id IN (-1");	
		for(Long idUsuario:listaUsuarios){
			hql.append(",");
			hql.append(idUsuario);
		}
		hql.append(") ");
		hql.append("and upper(concat(nombre, ' ', plaza, ' ', juzgado, ' ', auto)) like '%"
				+ query.toUpperCase() + "%' ");
		//hql.append("order by plaza, juzgado, auto, nombre");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}


	
	
}
