package es.pfsgroup.recovery.cajamar.serviciosonline;

public interface ConsultaDeSaldosWSApi {

	/**
	 * Invoca al WS de CAJAMAR para consulta de saldos.
	 * 
	 * @param numContrato
	 */
	void consultaDeSaldo(String numContrato);
	
}
