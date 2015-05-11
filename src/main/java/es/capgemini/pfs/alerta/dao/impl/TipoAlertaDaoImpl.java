package es.capgemini.pfs.alerta.dao.impl;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.alerta.dao.TipoAlertaDao;
import es.capgemini.pfs.alerta.model.TipoAlerta;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Andrés Esteban
 *
 */
@Repository("TipoAlertaDao")
public class TipoAlertaDaoImpl extends AbstractEntityDao<TipoAlerta, Long> implements TipoAlertaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public TipoAlerta findByCodigo(String codigo) {
        String hql = "from TipoAlerta where codigo = ?";

        List<TipoAlerta> tipos = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (tipos.size() > 0) { return tipos.get(0); }
        return null;
    }

}
