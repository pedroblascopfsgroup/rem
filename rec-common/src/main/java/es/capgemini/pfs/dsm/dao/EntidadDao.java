package es.capgemini.pfs.dsm.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Dao para el objeto Entidad.
 *
 */
public interface EntidadDao extends AbstractDao<Entidad, Long> {

    /**
     * Busca la entidad por codigo.
     * @param workingCode String
     * @return Entidad
     */
    Entidad findByWorkingCode(String workingCode);
    
    Entidad findByDescripcion(String descripcion);
    
    Usuario getUsuario(Long idUsu);

}
