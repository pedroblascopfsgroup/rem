package es.pfsgroup.recovery.cajamar.ws;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;
import es.pfsgroup.recovery.cajamar.serviciosonline.ConsultaDeSaldosWSApi;
import es.pfsgroup.recovery.cajamar.serviciosonline.ResultadoConsultaSaldo;

public class ConsultaDeSaldosWS extends BaseWS implements ConsultaDeSaldosWSApi {

	private static final String WEB_SERVICE_NAME = "S_A_RECOVERY_TASACION";

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}

	private Map<String, WSConsultaSaldos> configuracionServicios;
	
	public Map<String, WSConsultaSaldos> getConfiguracionServicios() {
		return configuracionServicios;
	}

	public void setConfiguracionServicios(Map<String, WSConsultaSaldos> configuracionServicios) {
		this.configuracionServicios = configuracionServicios;
	}

	@Override
	public ResultadoConsultaSaldo consultar(String numCuenta, DDAplicativoOrigen aplicativoOrigenContrato) {
		ResultadoConsultaSaldo resultado = new ResultadoConsultaSaldo();
		if (configuracionServicios==null) {
			String logMsg = "No se ha configurado una tabla de correspondencia para el WS de Consulta de Saldos";
			logger.warn(logMsg);
			resultado.setError(true);
			resultado.setMensajeError(logMsg);
			return resultado;
		}
		
		// Sacar spring el objeto correspondiente a este aplicativo origen
		WSConsultaSaldos wsInstance = configuracionServicios.get(aplicativoOrigenContrato.getCodigo());
		if (wsInstance!=null) {
			resultado = wsInstance.consultar(numCuenta);
		} else {
			String logMsg = String.format("No hay configurado un gestor de WS para el tipo aplicación %s",aplicativoOrigenContrato.getCodigo());
			logger.warn(logMsg);
			resultado.setError(true);
			resultado.setMensajeError(logMsg);
		}
		
		return resultado;
	}

}