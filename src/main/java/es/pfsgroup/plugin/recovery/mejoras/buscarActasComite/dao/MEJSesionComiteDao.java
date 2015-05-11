package es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto.MEJDtoBusquedaActas;

public interface MEJSesionComiteDao extends AbstractDao<SesionComite, Long>{ 

	/**
     * Busca las tareas o notificaciones para un usuario.
     * @param dto dtoparametro
     * @return lista de tareas
     */
    Page buscarActasComites(MEJDtoBusquedaActas dto);
    
}
