package es.pfsgroup.plugin.proyectoBankiaOnline.adjudicacion.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AdjudicacionApi {
	
	public static final String BO_ADJUDICACION_VALIDACIONES_ADJUDICACION_ENTREGA_TITULO = "es.pfsgroup.recovery.adjudicacion.validacionesAdjudicacionEntregaTituloPRE";

	@BusinessOperationDefinition(BO_ADJUDICACION_VALIDACIONES_ADJUDICACION_ENTREGA_TITULO)
	public String validacionesAdjudicacionEntregaTituloPRE(Long idProcedimiento);
}
