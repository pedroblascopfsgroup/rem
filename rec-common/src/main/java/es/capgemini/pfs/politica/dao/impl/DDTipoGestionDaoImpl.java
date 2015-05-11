package es.capgemini.pfs.politica.dao.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDTipoGestionDao;
import es.capgemini.pfs.politica.model.DDTipoGestion;

/**
 * Implementación del dao de DDTipoGestion.
 * @author pamuller
 *
 */
@Repository("DDTipoGestionDao")
public class DDTipoGestionDaoImpl extends AbstractEntityDao<DDTipoGestion, Long> implements DDTipoGestionDao {

	/**
	 * Devuelve el tipo de análisis por su código.
	 * @param codigo el codigo del DDTipoGestion.
	 * @return el DDTipoGestion.
	 */
	@SuppressWarnings("unchecked")
	public DDTipoGestion findByCodigo(String codigo) {
		String hql = "from DDTipoGestion where codigo = ? and auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDTipoGestion> lista = getHibernateTemplate().find(hql, codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public List<DDTipoGestion> findByCodigos(Set<String> codigos) {
		if(codigos.size()==0 || codigos.toString().equals("[]")) {
			return new ArrayList<DDTipoGestion>();
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
        String hql = "from DDTipoGestion tg "
        	       + "where tg.codigo in (" + lista + ")"
        	       + "      and tg.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql);
	}
}
