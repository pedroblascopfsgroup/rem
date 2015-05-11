package es.pfsgroup.plugin.recovery.iplus.manager;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface GestionIplusApi {

	public static final String PLUGIN_IPLUS_MAPEO_TIPODOC_NUMORDEN_BO = "plugin.iplus.obtenerNumOrdenDeTipoDoc";
	public static final String PLUGIN_IPLUS_MAPEO_NUMORDEN_TIPODOC_BO = "plugin.iplus.obtenerTipoDocDeNumOrden";
	public static final String PLUGIN_IPLUS_BAJAR_ADJUNTO_BO = "plugin.iplus.bajarAdjunto";
	public static final String PLUGIN_IPLUS_BORRAR_ADJUNTO_IPLUS_BO = "plugin.iplus.borrarAdjuntoIplus";
	public static final String PLUGIN_IPLUS_BORRAR_ADJUNTO_BO = "plugin.iplus.borrarAdjunto";
	
	@BusinessOperationDefinition(PLUGIN_IPLUS_MAPEO_TIPODOC_NUMORDEN_BO)
	int obtenerNumOrdenDeTipoDoc(String tipoDoc);
	
	@BusinessOperationDefinition(PLUGIN_IPLUS_MAPEO_NUMORDEN_TIPODOC_BO)
	String obtenerTipoDocDeNumOrden(int numOrden);
	
	@BusinessOperationDefinition(PLUGIN_IPLUS_BAJAR_ADJUNTO_BO)
	FileItem bajarAdjunto(Long idAsunto, String nombre, String descripcion);

	@BusinessOperationDefinition(PLUGIN_IPLUS_BORRAR_ADJUNTO_IPLUS_BO)
	void borrarAdjuntoIplus(Long idAsunto, String nombre, String descripcion);
	
	@BusinessOperationDefinition(PLUGIN_IPLUS_BORRAR_ADJUNTO_BO)
	void borrarAdjunto(Long idAsunto, Long idAdjunto);

}
