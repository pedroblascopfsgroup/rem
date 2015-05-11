package es.capgemini.pfs.batch.recobro.facturacion.manager;

import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;

/**
 * Intefaz de m�tdodos para el c�lculo de la facturaci�n de las Agencias de Recobro
 * @author Javier
 * 
 */
public interface CalculoFacturacionManager {
	
	/**
	 * Realiza el c�lculo de la facturaci�n
	 * @throws Throwable
	 */
	public void calcularFacturacion(); 

	/**
	 * Aplica los correctores configurados en el modelo de facturaci�n seg�n subcarteras
	 * @param recobroProcesoFacturacion
	 * @throws Throwable
	 */
	public void aplicarCorrectores(RecobroProcesoFacturacion recobroProcesoFacturacion) throws Throwable;
	
	/**
	 * Transfiere todos los detalles temporales de facturacion a la tabla de producci�n 
	 * @throws Throwable
	 */
	public void transferirDetalleFacturacionTemporalAProduccion() throws Throwable;
	
}
