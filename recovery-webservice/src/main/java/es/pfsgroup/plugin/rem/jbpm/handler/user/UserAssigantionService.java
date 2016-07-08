package es.pfsgroup.plugin.rem.jbpm.handler.user;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;

public interface UserAssigantionService extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	
	public String[] getCodigoTarea();

	Usuario getUser(TareaExterna tareaExterna);
	
	Usuario getSupervisor(TareaExterna tareaExterna);

}
