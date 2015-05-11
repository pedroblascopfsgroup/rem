package es.pfsgroup.recovery.recobroCommon.esquema.manager.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroSimulacionEsquemaConstants;

public interface RecobroSimulacionEsquemaManager {
	
	/**
	 * Devuelve el número de procesos de simulación en estado pendiente
	 * @return
	 */
	public Long obtenerNumeroProcesosEstadoPendiente();
	
	/**
	 * Devuelve el esquema de simulacion en estado pendiente
	 * @return
	 */
	public RecobroSimulacionEsquema getProcesoEstadoPendiente();
	
	/**
	 * Graba el esquema de simulacion
	 * @param esquema
	 */
	public void grabarProceso(RecobroSimulacionEsquema esquema);
	
	/**
	 * Devuelve la simulacion de un esquema
	 * @param idEsquema
	 * @return
	 */
	@BusinessOperationDefinition(RecobroSimulacionEsquemaConstants.RECOBRO_SIMULACION_GET_SIMULACIONES_ESQUEMA)
	public List<RecobroSimulacionEsquema> getSimulacionesDelEsquema(Long idEsquema);
	
	/**
	 * Devuelve los procesos de simulacion por el id del estado
	 * @param idEstado
	 * @return
	 */
	@BusinessOperationDefinition(RecobroSimulacionEsquemaConstants.RECOBRO_SIMULACION_GET_SIMULACIONES_POR_ESTADO)
	public List<RecobroSimulacionEsquema> getSimulacionesPorEstado(Long idEstado);
	
}
