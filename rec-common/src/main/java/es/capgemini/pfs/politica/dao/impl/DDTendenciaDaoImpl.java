package es.capgemini.pfs.politica.dao.impl;


import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDTendenciaDao;
import es.capgemini.pfs.politica.model.DDTendencia;


/**
 * @author Mariano Ruiz
 */
@Repository("DDTendenciaDao")
public class DDTendenciaDaoImpl extends AbstractEntityDao<DDTendencia, Long> implements DDTendenciaDao {

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public DDTendencia findByCodigo(String codigo) {
        List<DDTendencia> lista = getHibernateTemplate().find("from DDTendencia where codigo = ?", codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
	}
}
