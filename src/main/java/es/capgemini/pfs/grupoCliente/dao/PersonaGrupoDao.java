package es.capgemini.pfs.grupoCliente.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.grupoCliente.dto.DtoPersonasDelGrupo;
import es.capgemini.pfs.grupoCliente.model.PersonaGrupo;

/**
 * @author marruiz
 */
public interface PersonaGrupoDao extends AbstractDao<PersonaGrupo, Long> {

    /**
     * Devuelve un listado de todas las personas del mismo grupo.
     * @param dto DtoPersonasDelGrupo
     * @return Page: contiene el List de Persona
     */
    Page getPersonasGrupo(DtoPersonasDelGrupo dto);
}
