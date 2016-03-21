package es.pfsgroup.recovery.cajamar.serviciosonline;

public interface ServiciosOnlineCajamarApi {
	
	/**
	 * Solicita tasación al servidor financiero de CAJAMAR
	 * 
	 * @param idBien Identificador del bien
	 * 
	 * Método para solicitar la tasación de un bien
	 * @return 
	 * 
	 * */
	String solicitarTasacion(Long idBien, Long cuenta, String persona, Long telefono, String observaciones);

	/**
	 * Consulta de saldos al servidor financiero de CAJAMAR
	 * 
	 * @param numContrato
	 */
	ResultadoConsultaSaldo consultaDeSaldos(Long cntId);

}
