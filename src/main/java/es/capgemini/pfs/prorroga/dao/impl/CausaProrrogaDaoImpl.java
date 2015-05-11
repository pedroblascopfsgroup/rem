package es.capgemini.pfs.prorroga.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.prorroga.dao.CausaProrrogaDao;
import es.capgemini.pfs.prorroga.model.CausaProrroga;

/**
 * Interfaz dao para las causa prorrogas.
 * @author jbosnjak
 *
 */
@Repository("CausaProrrogaDao")
public class CausaProrrogaDaoImpl extends AbstractEntityDao<CausaProrroga, Long> implements CausaProrrogaDao {

    private static final String BUSCAR_POR_CODIGO_HQL = "from CausaProrroga where codigo = ?";

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public CausaProrroga buscarPorCodigo(String codigo) {
        List<CausaProrroga> causas = getHibernateTemplate().find(BUSCAR_POR_CODIGO_HQL, codigo);
        if (causas.size() > 0) { return causas.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<CausaProrroga> getList(String codigoTipoProrroga) {
        List<CausaProrroga> causas = getHibernateTemplate().find("from CausaProrroga where tipoProrroga.codigo = ? ", codigoTipoProrroga);
        return causas;
    }

}
