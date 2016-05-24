package es.pfsgroup.plugin.recovery.mejoras.procuradores;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface MEJProcuradoresApi {

	public static final String MEJ_PROCURADORES_IS_INSTALL = "plugin.mejoras.web.procuradores.pluginProcuradoresIsInstall";
	
	/**
	 * 
	 * @param 
	 * @return devuelve true si el plugin de procuradores está instalado
	 */
	@BusinessOperationDefinition(MEJ_PROCURADORES_IS_INSTALL)
	public boolean pluginProcuradoresIsInstall();
   
}
