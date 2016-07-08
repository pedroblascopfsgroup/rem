package es.pfsgroup.plugin.rem.jbpm.handler.updater;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

public interface UpdaterService extends GenericService{
	
	final public static String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores);

	public String[] getCodigoTarea();
	

}
