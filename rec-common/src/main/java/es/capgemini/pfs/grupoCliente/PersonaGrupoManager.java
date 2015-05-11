package es.capgemini.pfs.grupoCliente;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.grupoCliente.dao.PersonaGrupoDao;
import es.capgemini.pfs.grupoCliente.dto.DtoPersonasDelGrupo;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * Maneja las operaciones de grupo de clientes.
 * @author marruiz
 */
@Service
public class PersonaGrupoManager {

    @Autowired
    private PersonaGrupoDao personaGrupoDao;

    /**
     * Devuelve un listado de todas las personas del mismo grupo.
     * @param dto DtoPersonasDelGrupo: contiene el id de la persona del cliente.
     * @return Page: contiene el List de Persona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PERSONA_GRUPO_MGR_GET_PERSONA_GRUPO)
    public Page getPersonasGrupo(DtoPersonasDelGrupo dto) {
        return personaGrupoDao.getPersonasGrupo(dto);
    }

}
