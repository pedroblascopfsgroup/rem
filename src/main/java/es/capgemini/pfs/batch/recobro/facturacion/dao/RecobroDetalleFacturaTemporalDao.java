package es.capgemini.pfs.batch.recobro.facturacion.dao;

import java.util.List;

import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionCorrectorTemporal;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionTemporal;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Interfaz de m�todos para el patr�n DAO o acceso a objetos de la bbdd
 * @author Javier Ruiz
 *
 */
public interface RecobroDetalleFacturaTemporalDao {

	/**
	 * Borra toda la tabla temporal utilizando un delete all
	 * en lugar de un truncate para mantener la transaccionalidad
	 */
	public void deleteAll();
		
	/**
	 * Borra toda la tabla temporal de detalles correcgidos
	 * en lugar de un truncate para mantener la transaccionalidad
	 */
	public void deleteAllCo();
	
	/**
	 * Obtiene todas las distintas subcarteras existentes de la tabla de detalles temporales de facturas de recobro
	 * @return
	 * @throws Throwable
	 */
	public List<RecobroSubCartera> obtenerSubcarterasExistentesEnDetallesFacturaTemporalesSinCorregir() throws Throwable;
		
	/**
	 * Obtiene todos los detalles temporales de facturas de recobro a partir de una Subcartera de Recobro 
	 * @param recobroSubCartera
	 * @return
	 * @throws Throwable
	 */
	public List<RecobroDetalleFacturacionTemporal> obtenerDetallesTemporalesFacturacionPorSubcartera(RecobroSubCartera recobroSubCartera) throws Throwable;
	
	/**
	 * Insertar el detalle temporal de facturaci�n una vez calculado el corrector
	 * @param recobroDetalleFacturacionCorrectorTemporal
	 * @throws Throwable
	 */
	public void insertarDetalleTemporalCorregidoFacturacion(RecobroDetalleFacturacionCorrectorTemporal recobroDetalleFacturacionCorrectorTemporal) throws Throwable;
	
	/**
	 * Transfiere todos los detalles temporales de facturacion a la tabla de producci�n 
	 * @throws Throwable
	 */
	public void transferirDetallesTemporalesCorregidosFacturacionAProduccion() throws Throwable;

	/**
	 * Insertar el detalle temporal de facturaci�n
	 * @param recobroDetalleFacturacionTemporal
	 * @throws Throwable
	 */
	public void insertarDetalleTemporalFactura(RecobroDetalleFacturacionTemporal recobroDetalleFacturacionTemporal) throws Throwable;
	
	/**
	 * Mueve los detalles temporas de facturación, cuando no hay correctores
	 * @throws Throwable
	 */
	public void moveDetallesTemporalesSinCorrectores(Long subCarteraId) throws Throwable;

	/**
	 * Invoca un procedimiento almacenado que vacía y rellena la tabla TMP_RECOBRO_DETALLE_FACTURA 
	 */
	public void procesaProcesoFacturacion();
}
