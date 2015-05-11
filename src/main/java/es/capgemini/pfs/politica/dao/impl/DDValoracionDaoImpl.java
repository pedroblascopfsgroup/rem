package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDValoracionDao;
import es.capgemini.pfs.politica.model.DDValoracion;

/**
 * Implementación del dao de DDTipoAnalisis.
 * @author pamuller
 *
 */
@Repository("DDValoracionDao")
public class DDValoracionDaoImpl extends AbstractEntityDao<DDValoracion, Long> implements DDValoracionDao {

    /**
     * Devuelve el DDValoracion por su código.
     * @param codigo el codigo del DDValoracion.
     * @return el DDValoracion.
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDValoracion findByCodigo(String codigo) {
        String hql = "from DDValoracion where codigo = ?";
        List<DDValoracion> valoraciones = getHibernateTemplate().find(hql, codigo);
        if (valoraciones.size() > 0) { return valoraciones.get(0); }
        return null;
    }

}
