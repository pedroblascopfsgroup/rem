package es.pfsgroup.plugin.rem.jbpm.handler.plazo;

import es.pfsgroup.plugin.rem.genericService.api.GenericService;

public interface PlazoAssignationService extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	
	public String[] getCodigoTarea();
	
	public Long getPlazoTarea(Long idTipoTarea, Long idTramite);
}