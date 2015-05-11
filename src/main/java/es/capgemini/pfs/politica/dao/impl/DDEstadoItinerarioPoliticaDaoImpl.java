package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDEstadoItinerarioPoliticaDao;
import es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica;

/**
 * Implementación de DDEstadoItinerarioPoliticaDao.
 * @author aesteban
 *
 */
@Repository("DDEstadoItinerarioPoliticaDao")
public class DDEstadoItinerarioPoliticaDaoImpl extends AbstractEntityDao<DDEstadoItinerarioPolitica, Long> implements DDEstadoItinerarioPoliticaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDEstadoItinerarioPolitica buscarPorCodigo(String codigo) {
        List<DDEstadoItinerarioPolitica> lista = getHibernateTemplate().find("from DDEstadoItinerarioPolitica where codigo = ?",codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }

}
