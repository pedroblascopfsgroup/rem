package es.capgemini.pfs.prorroga.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.prorroga.dao.RespuestaProrrogaDao;
import es.capgemini.pfs.prorroga.model.RespuestaProrroga;

/**
 * Interfaz dao para las prorrogas.
 * @author pamuller
 *
 */
@Repository("RespuestaProrrogaDao")
public class RespuestaProrrogaDaoImpl extends AbstractEntityDao<RespuestaProrroga, Long> implements RespuestaProrrogaDao {

    private static final String BUSCAR_POR_CODIGO_HQL = "from RespuestaProrroga where codigo = ?";

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public RespuestaProrroga buscarPorCodigo(String codigo) {
        List<RespuestaProrroga> respues = getHibernateTemplate().find(BUSCAR_POR_CODIGO_HQL, codigo);
        if (respues.size() > 0) { return respues.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<RespuestaProrroga> getList(String codigoTipoProrroga) {
        List<RespuestaProrroga> respues = getHibernateTemplate().find("from RespuestaProrroga where tipoProrroga.codigo = ? ", codigoTipoProrroga);
        return respues;
    }

}
