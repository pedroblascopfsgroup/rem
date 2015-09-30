package es.pfsgroup.recovery.cajamar.ws;

public interface WSConsultaSaldos {

	/**
	 * Invoca el WS de consulta de saldo con el número de cuenta indicado.
	 * 
	 * @param numCuenta
	 */
	void ejecutar(String numCuenta);

}
