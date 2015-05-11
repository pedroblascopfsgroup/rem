package es.capgemini.pfs.batch.recobro.facturacion.manager;

import java.util.Date;
import java.util.List;

import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Interfaz de m�todos del manager de control de preproceso de cobros de recobro
 * @author javier
 *
 */
public interface RecobroControlCobrosManager {
	
	/**
	 * Verifica si existe la fecha indicada en la tabla de control de preproceso de cobros de recobro
	 * @param dia. Fecha a comprobar
	 * @return True si ese d�a esta preprocesado, false en caso contrario
	 */
	public boolean EstaDiaProcesado(Date dia);
	
	/**
	 * Realiza un select count de registros realizando un between entre las fechas desde y hasta
	 * @param desde
	 * @param hasta
	 * @return el n�mero de registros contados para esas fechas
	 */
	public int CountNumeroRegistrosEntreDias(Date desde, Date hasta);

	
	/**
	 * Obtiene las diferentes subcarteras de los cobros pagos entre las fechas determinadas
	 * @param fechaDesde: Fecha de inicio de periodo, inclusive
	 * @param fechaHasta: Fecha de fin de periodo, inclusive
	 * @return lista con las distintas subcarteras de los cobros pagos de recobro durante las fechas indicadas
	 */
	public List<RecobroSubCartera> getSubcarterasCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta);
	
}
