package es.capgemini.pfs.alerta.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.alerta.dao.NivelGravedadDao;
import es.capgemini.pfs.alerta.model.NivelGravedad;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Andrés Esteban
 *
 */
@Repository("NivelGravedad")
public class NivelGravedadDaoImpl extends AbstractEntityDao<NivelGravedad, Long> implements NivelGravedadDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public NivelGravedad findByCodigo(String codigo) {
        String hql = "from NivelGravedad where codigo = ?";

        List<NivelGravedad> niveles = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (niveles.size() > 0) {
            return niveles.get(0);
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public NivelGravedad buscarPorOrden(Integer orden) {
        String hql = "from NivelGravedad where orden = ?";

        List<NivelGravedad> niveles = getHibernateTemplate().find(hql, new Object[] { orden });
        if (niveles.size() > 0) {
            return niveles.get(0);
        }
        return null;
    }
}
