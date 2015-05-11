package es.capgemini.pfs.asunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

/**
 * Clase de acceso a datos para procedimientos.
 * @author pamuller
 *
 */
@Repository("TipoProcedimientoDao")
public class TipoProcedimientoDaoImpl extends AbstractEntityDao<TipoProcedimiento, Long> implements TipoProcedimientoDao {

    /**
     * Devuelve un TipoProcedimiento por su código.
     * @param codigo el codigo del TipoProcedimiento
     * @return el TipoProcedimiento.
     */
    @SuppressWarnings("unchecked")
    public TipoProcedimiento getByCodigo(String codigo) {
        String hql = "from TipoProcedimiento where codigo like ?";
        List<TipoProcedimiento> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (lista.size() > 0) { return lista.get(0); }
        return null;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<TipoProcedimiento> getTipoProcedimientosPorTipoActuacion(String codigoActuacion) {
        String hql = "from TipoProcedimiento where tipoActuacion.codigo = ?";
        List<TipoProcedimiento> lista = (List<TipoProcedimiento>) getHibernateTemplate().find(hql, new Object[] { codigoActuacion });
        return lista;
    }

}
