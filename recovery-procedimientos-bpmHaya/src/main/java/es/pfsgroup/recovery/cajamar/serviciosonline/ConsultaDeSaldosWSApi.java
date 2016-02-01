package es.pfsgroup.recovery.cajamar.serviciosonline;

import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;

public interface ConsultaDeSaldosWSApi {

	/**
	 * Invoca al WS de CAJAMAR para consulta de saldos.
	 * 
	 * @param numContrato
	 */
	ResultadoConsultaSaldo consultar(String numCuenta, DDAplicativoOrigen aplicationOrigen);
	
}
