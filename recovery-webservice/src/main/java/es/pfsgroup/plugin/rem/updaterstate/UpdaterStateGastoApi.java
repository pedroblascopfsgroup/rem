package es.pfsgroup.plugin.rem.updaterstate;

import es.pfsgroup.plugin.rem.model.GastoProveedor;

public interface UpdaterStateGastoApi {

	/**
	 * Actualiza el estado de un gasto
	 * @param gasto
	 * @param codigo
	 * @return boolean Si se ha cambiado el estado
	 */
	boolean updaterStates(GastoProveedor gasto, String codigo);

	/**
	 * Comprueba sin un gasto tiene todos los gastos obligatorios para poder ser autorizado, devolviendo el error en caso
	 * de fallar la validación
	 * @param gasto
	 * @return
	 */
	String validarCamposMinimos(GastoProveedor gasto , Boolean origen);

	String validarAutorizacionSuplido(GastoProveedor gasto);

	Boolean isGastoSuplido(GastoProveedor gasto);

	String validarDatosPagoGastoPrincipal(GastoProveedor gasto);

	Boolean isGastoSuplidoPadre(GastoProveedor gasto);
	
}
