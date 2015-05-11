package es.capgemini.pfs.persona.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.DDTipoPersona;

/**
 * Dao de tipo de personas.
 * @author Mariano Ruiz
 *
 */
public interface DDTipoPersonaDao extends AbstractDao<DDTipoPersona, Long> {

    /**
     * Busca el tipo de persona por codigo.
     * @param codigo string;
     * @return DDTipoPersona
     */
    DDTipoPersona findByCodigo(String codigo);
}
