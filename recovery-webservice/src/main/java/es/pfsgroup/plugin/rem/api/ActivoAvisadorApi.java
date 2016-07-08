package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.DtoAviso;


public interface ActivoAvisadorApi {
    
	    @BusinessOperationDefinition("activoAvisadorManager.get")
	    public String get(Long id);
	    
	    /**
	     * Recupera la lista completa de avisos de un activo
	     * @return List<DtoActivoAviso>
	     * 
	     */
	    @BusinessOperationDefinition("activoAvisadorManager.getListActivoAvisador")
	    public List<DtoAviso> getListActivoAvisador(Long id, Usuario usuarioLogado);

    
	
    }


