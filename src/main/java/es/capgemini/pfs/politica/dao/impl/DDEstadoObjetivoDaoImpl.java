package es.capgemini.pfs.politica.dao.impl;


import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDEstadoObjetivoDao;
import es.capgemini.pfs.politica.model.DDEstadoObjetivo;


/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDEstadoObjetivoDao")
public class DDEstadoObjetivoDaoImpl extends AbstractEntityDao<DDEstadoObjetivo, Long> implements DDEstadoObjetivoDao {

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public DDEstadoObjetivo findByCodigo(String codigo) {
        List<DDEstadoObjetivo> lista = getHibernateTemplate().find("from DDEstadoObjetivo where codigo = ?", codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
	}
}
