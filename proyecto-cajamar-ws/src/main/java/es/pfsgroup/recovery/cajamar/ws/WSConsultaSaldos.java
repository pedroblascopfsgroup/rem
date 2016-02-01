package es.pfsgroup.recovery.cajamar.ws;

import es.pfsgroup.recovery.cajamar.serviciosonline.ResultadoConsultaSaldo;

public interface WSConsultaSaldos {

	/**
	 * Invoca el WS de consulta de saldo con el número de cuenta indicado.
	 * 
	 * @param numCuenta
	 */
	ResultadoConsultaSaldo consultar(String numCuenta);

}
