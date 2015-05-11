package es.pfsgroup.plugin.recovery.coreextension.subasta.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface SubastasServicioTasacionDelegateApi {
	
	public static final String BO_UVEM_SOLICITUD_NUMERO_ACTIVO = "es.pfsgroup.plugin.recovery.coreextension.subasta.api.solicitarNumeroActivo";
	public static final String BO_UVEM_SOLICITUD_TASACION = "es.pfsgroup.plugin.recovery.coreextension.subasta.api.solicitarTasacion";
	//public static final String BO_UVEM_CANCELAR_SOLICITUD_TASACION = "es.pfsgroup.plugin.recovery.coreextension.subasta.api.cancelarTasacion";
	public static final String BO_UVEM_SOLICITUD_NUMERO_ACTIVO_BY_PRCID = "es.pfsgroup.plugin.recovery.coreextension.subasta.api.solicitarNumeroActivoByPrcId";
	public static final String BO_UVEM_SOLICITUD_TASACION_BY_PRCID = "es.pfsgroup.plugin.recovery.coreextension.subasta.api.solicitarTasacionByPrcId";
	
		
	/**
	 * Método que cancela una peticion de tasacion de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	/*
	@BusinessOperationDefinition(BO_UVEM_CANCELAR_SOLICITUD_TASACION)
	public void cancelarTasacion(Long bienId);
	*/
	
	/**
	 * Método que solicita el numero de activo de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_UVEM_SOLICITUD_NUMERO_ACTIVO)
	public void solicitarNumeroActivo(Long bienId);
	
	/**
	 * Método que solicita la tasacion de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_UVEM_SOLICITUD_TASACION)
	public void solicitarTasacion(Long bienId);
	
	/**
	 * Método que solicita el numero de activo de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_UVEM_SOLICITUD_NUMERO_ACTIVO_BY_PRCID)
	public void solicitarNumeroActivoByPrcId(Long bienId, Long prcId);
	
	/**
	 * Método que solicita la tasacion de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_UVEM_SOLICITUD_TASACION_BY_PRCID)
	public void solicitarTasacionByPrcId(Long bienId, Long prcId);

}