package es.capgemini.pfs.subfase.dao.impl;


import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.subfase.dao.SubfaseDao;
import es.capgemini.pfs.subfase.model.Subfase;

/**
 * Clase que implementa los métodos de la interfaz SubfaseDao.
 *
 */
@Repository("SubfaseDao")
public class SubfaseDaoImpl extends AbstractEntityDao<Subfase, Long> implements SubfaseDao {

    private static final String BUSCAR_POR_CODIGO_FASE_HQL = "from Subfase where fase.codigo = ?";

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Subfase> findByCodigoDeLaFase(String codigoFase) {
        return getHibernateTemplate().find(BUSCAR_POR_CODIGO_FASE_HQL, codigoFase);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
	public List<Subfase> getByCodigos(Set<String> codigos) {
		if(codigos.size()==0 || codigos.toString().equals("[]")) {
			return new ArrayList<Subfase>();
		}
		Iterator<String> it = codigos.iterator();
		String lista = "";
		while(it.hasNext()) {
			if(lista.equals("")) {
				lista += "'" + it.next() + "'";
			} else {
				lista += ", '" + it.next() + "'";
			}
		}
        String hql = "from Subfase smg "
        	       + "where smg.codigo in (" + lista + ")"
        	       + "      and smg.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql);
    }
}
