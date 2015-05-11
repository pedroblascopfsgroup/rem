package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDEstadoPoliticaDao;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;

/**
 * Implementación de DDEstadoPoliticaDao.
 * @author aesteban
 *
 */
@Repository("DDEstadoPoliticaDao")
public class DDEstadoPoliticaDaoImpl extends AbstractEntityDao<DDEstadoPolitica, Long> implements DDEstadoPoliticaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDEstadoPolitica buscarPorCodigo(String codigo) {
        List<DDEstadoPolitica> lista = getHibernateTemplate().find("from DDEstadoPolitica where codigo = ?",codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }

}
