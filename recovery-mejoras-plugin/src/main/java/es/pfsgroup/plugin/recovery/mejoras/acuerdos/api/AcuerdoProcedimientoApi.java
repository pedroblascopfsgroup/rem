package es.pfsgroup.plugin.recovery.mejoras.acuerdos.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AcuerdoProcedimientoApi {
	
	public static final String BO_ACU_PRC_ACUERDO = "plugin.mejoras.acuerdoProcedimientoManager.esProcedimientoAcuerdo";
	public static final String BO_ACU_PRC_VER_TAB_INF_REQUERIDA = "plugin.mejoras.acuerdoProcedimientoManager.verTabInfRequerida";
	public static final String BO_ACU_PRC_CODIGO_TIPO_ACTUACION = "plugin.mejoras.acuerdoProcedimientoManager.codigoTipoActuacion";
	
	@BusinessOperationDefinition(BO_ACU_PRC_CODIGO_TIPO_ACTUACION)
    public String codigoTipoActuacion(Long prcId);
	
	@BusinessOperationDefinition(BO_ACU_PRC_ACUERDO)
    public boolean esProcedimientoAcuerdo(Long prcId);
    
	@BusinessOperationDefinition(BO_ACU_PRC_VER_TAB_INF_REQUERIDA)
    public boolean verTabInfRequerida(Long prcId);

}
