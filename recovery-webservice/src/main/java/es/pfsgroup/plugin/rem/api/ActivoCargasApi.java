package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.ActivoCargas;


public interface ActivoCargasApi {

	    @BusinessOperationDefinition("activoCargasManager.get")
	    public ActivoCargas get(Long id);
	    
	    @BusinessOperationDefinition("activoCargasManager.saveOrUpdate")
	    public boolean saveOrUpdate(ActivoCargas activoCargas);
	    
    }


