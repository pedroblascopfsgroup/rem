package es.capgemini.pfs.persona.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.DDTipoPersonaDao;
import es.capgemini.pfs.persona.model.DDTipoPersona;

/**
 * Dao de tipo de personas.
 * @author Mariano Ruiz
 *
 */
@Repository("DDTipoPersonaDao")
public class DDTipoPersonaDaoImpl extends AbstractEntityDao<DDTipoPersona, Long> implements DDTipoPersonaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public DDTipoPersona findByCodigo(String codigo) {
        String hql = "from DDTipoPersona where codigo = ?";

        List<DDTipoPersona> tipos = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (tipos.size() > 0) {
            return tipos.get(0);
        }
        return null;
    }

}
