package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dao;

import java.util.Collection;
import java.util.HashMap;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao.RecoveryAnotacionDaoApi;

@Repository("RecoveryAnotacionDao")
public class RecoveryAnotacionDao extends AbstractEntityDao implements RecoveryAnotacionDaoApi {

    @SuppressWarnings("unchecked")
    @Override
    public Collection<? extends Usuario> getGestores(String query) {
        StringBuilder hql = new StringBuilder();
		HashMap<String, Object> params = new HashMap<String, Object>();

        hql.append("from Usuario ");
        hql.append("where auditoria.borrado = 0 ");
        hql.append("and upper(concat(username, ' ', nombre, ' ', apellido1, ' ', apellido2)) like '%|| :query ||%' ");
        params.put("query", query.toUpperCase());
//        hql.append("and upper(concat(username, ' ', nombre, ' ', apellido1, ' ', apellido2)) like '%" + query.toUpperCase() + "%' ");

        hql.append("order by nombre, apellido1, apellido2");

        Query q = getSession().createQuery(hql.toString());
        q.setMaxResults(20);

        return q.list();
    }

}
