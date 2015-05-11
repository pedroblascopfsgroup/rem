package es.capgemini.pfs.asunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.EstadoProcedimientoDao;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementación  del Dao de Estados de Asunto.
 * @author pamuller
 *
 */
@Repository("EstadoProcedimientoDao")
public class EstadoProcedimientoDaoImpl extends AbstractEntityDao<DDEstadoProcedimiento, Long> implements EstadoProcedimientoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public DDEstadoProcedimiento buscarPorCodigo(String codigo) {
        String hql = "from DDEstadoProcedimiento where codigo = ?";
        List<DDEstadoProcedimiento> estados = getHibernateTemplate().find(hql, codigo);
        if (estados == null || estados.size() == 0) { return null; }
        return estados.get(0);
    }

}
