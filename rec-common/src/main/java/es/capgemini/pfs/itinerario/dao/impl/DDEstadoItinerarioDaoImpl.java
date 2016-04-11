package es.capgemini.pfs.itinerario.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.dao.DDEstadoItinerarioDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;

/**
 * Dao impl DDEstadoItinerarioDaoImpl.
 * @author jbosnjak
 *
 */
@Repository("DDEstadoItinerarioDao")
public class DDEstadoItinerarioDaoImpl extends AbstractEntityDao<DDEstadoItinerario, Long> implements DDEstadoItinerarioDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDEstadoItinerario> findByCodigo(String codigo) {
        String hsql = "from DDEstadoItinerario where codigo = ?";
        return getHibernateTemplate().find(hsql, new Object[] {codigo});
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDEstadoItinerario> findByEntidad(String tipoEntidad) {
        String hsql = "from DDEstadoItinerario where tipoEntidad.codigo = ? and auditoria.borrado = false";
        return getHibernateTemplate().find(hsql, new Object[] {tipoEntidad});
    }

}
