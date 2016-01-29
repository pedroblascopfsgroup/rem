package es.pfsgroup.recovery.api;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comite.dto.DtoSesionComite;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ComiteApi {
	
	/**
     * Inicia la sesion del comite.
     * @param dtoSesionComite dto
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_COMITE_MGR_CREAR_SESION)
    @Transactional(readOnly = false)
    public void crearSesion(DtoSesionComite dtoSesionComite);

    
    /**
     * Crea un DtoSesionComite.
     * @param comiteId comite
     * @return DtoSesionComite
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_COMITE_MGR_GET_DTO)
    public DtoSesionComite getDto(Long comiteId) ;
}
