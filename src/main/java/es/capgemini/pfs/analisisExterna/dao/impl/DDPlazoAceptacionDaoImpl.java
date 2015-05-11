package es.capgemini.pfs.analisisExterna.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.analisisExterna.dao.DDPlazoAceptacionDao;
import es.capgemini.pfs.analisisExterna.model.DDPlazoAceptacion;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * 
 * @author pajimene
 *
 */
@Repository("DDPlazoAceptacionDao")
public class DDPlazoAceptacionDaoImpl extends AbstractEntityDao<DDPlazoAceptacion, Long> implements DDPlazoAceptacionDao {
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDPlazoAceptacion findByCodigo(String codigo) {
        String hql = "from DDPlazoAceptacion where codigo = ?";

        List<DDPlazoAceptacion> resultados = getHibernateTemplate().find(hql, codigo);
        if (resultados == null || resultados.size() == 0)
            return null;
        else
            return resultados.get(0);
    }
}
