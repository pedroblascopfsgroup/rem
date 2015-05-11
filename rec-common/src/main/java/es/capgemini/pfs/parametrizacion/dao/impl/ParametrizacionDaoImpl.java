package es.capgemini.pfs.parametrizacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.exceptions.ParametrizationException;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

/**
 * Clase que implementa ParametrizacionDao.
 * @author aesteban
 *
 */
@Repository("ParametrizacionDao")
public class ParametrizacionDaoImpl extends AbstractEntityDao<Parametrizacion, Long> implements ParametrizacionDao {

    private static final String BUSCAR_POR_NOMBRE_HQL = "from Parametrizacion where nombre = ? and auditoria." + Auditoria.UNDELETED_RESTICTION;

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Parametrizacion buscarParametroPorNombre(String nombre) {
        List<Parametrizacion> params = getHibernateTemplate().find(BUSCAR_POR_NOMBRE_HQL, nombre);

        if (params.size() > 1) { throw new ParametrizationException("parametrizacion.error.duplicado", nombre); }
        if (params.size() == 1) { return params.get(0); }
        throw new ParametrizationException("parametrizacion.error.noExiste", nombre);
    }
}
