package es.capgemini.pfs.batch.recobro.facturacion.manager;

import java.util.List;

import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionCorrectorTemporal;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionTemporal;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Interfaz de m�todos del manager de detalles temporales de facturas de recobro
 * @author Guillem
 *
 */
public interface RecobroDetalleFacturaTemporalManager {

	/**
	 * Obtiene todas las distintas subcarteras existentes de la tabla de detalles temporales de facturas de recobro
	 * @return
	 * @throws Throwable
	 */
	public List<RecobroSubCartera> obtenerSubcarterasExistentes() throws Throwable;
		
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
	 * Inserta el detalle temporal de facturaci�n
	 * @param recobroDetalleFacturacionTemporal
	 * @throws Throwable
	 */
	public void insertarDetalleTemporalFacturacion(RecobroDetalleFacturacionTemporal recobroDetalleFacturacionTemporal) throws Throwable;

	/**
	 * Vacia la tabla temporal	 
	 * @throws Throwable
	 */
	public void vaciarDetallesFacturaTemporales() throws Throwable;
	
	/**
	 * Vaciar la tabla temporal de corregidos
	 * @throws Throwable
	 */
	public void vaciarDetallesFacturaTemporalesCo() throws Throwable;
	
	/**
	 * Transfiere todos los detalles temporales de facturacion a la tabla de producci�n 
	 * @throws Throwable
	 */
	public void transferirDetallesTemporalesFacturacionAProduccion() throws Throwable;
	
	
	/**
	 * Mueve los detalles temporas de facturación, cuando no hay correctores
	 * @throws Throwable
	 */
	public void moveDetallesTemporalesSinCorrectores(Long subCarteraId) throws Throwable;

	/**
	 * Invoca un procedimiento almacenado que crea los objetos {@link RecobroDetalleFacturacionTemporal}
	 */
	public void procesaProcesoFacturacion();	
}
