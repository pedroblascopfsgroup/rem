package es.capgemini.pfs.prorroga.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.prorroga.dao.DDTipoProrrogaDao;
import es.capgemini.pfs.prorroga.model.DDTipoProrroga;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * tipos de prorroga.
 *
 */
@Repository("DDTipoProrrogaDao")
public class DDTipoProrrogaDaoImpl extends AbstractEntityDao<DDTipoProrroga, Long> implements DDTipoProrrogaDao {

    /**
     * Devuelve un tipo de estado expediente por su cÃ³digo.
     * @param codigo el codigo
     * @return el estado expediente.
     */
    @SuppressWarnings("unchecked")
    public DDTipoProrroga getByCodigo(String codigo) {
        String hql = "from DDTipoProrroga where codigo = ?";
        List<DDTipoProrroga> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (lista.size() > 0) { return lista.get(0); }
        return null;
    }
}
