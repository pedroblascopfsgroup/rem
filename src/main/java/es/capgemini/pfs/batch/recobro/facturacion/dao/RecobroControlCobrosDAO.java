package es.capgemini.pfs.batch.recobro.facturacion.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Intefaz de m�tdodos para el acceso a BBDD de la facturaci�n de las Agencias de Recobro 
 * @author javier
 *
 */
public interface RecobroControlCobrosDAO {
	
	/**
	 * Devuelve si existen registros de control para la fecha indicada
	 * @param dia, fecha por la cual se buscan los registros de control
	 * @return int con el n�mero de registros encontrados
	 */
	public int cuentaControlCobrosDia(Date dia);
	
	/**
	 * Devuelve el n�mero de registros de control entre las fechas desde y hasta
	 * @param desde
	 * @param hasta
	 * @return int con el n�mero de registros
	 */
	public int cuentaControlCobrosEntreDias(Date desde, Date hasta);

	/**
	 * Obtiene los diferentes ids de las subcarteras de los cobros pagos entre las fechas determinadas
	 * @param fechaDesde: Fecha de inicio de periodo, inclusive
	 * @param fechaHasta: Fecha de fin de periodo, inclusive
	 * @return lista con los ids de las subcarteras de los cobros pagos de recobro durante las fechas indicadas
	 */
	public List<Map> getSubcarterasCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta);
	
	
}
