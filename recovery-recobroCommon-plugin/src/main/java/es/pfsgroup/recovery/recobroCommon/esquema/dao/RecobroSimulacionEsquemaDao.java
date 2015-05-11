package es.pfsgroup.recovery.recobroCommon.esquema.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;

public interface RecobroSimulacionEsquemaDao extends AbstractDao<RecobroSimulacionEsquema, Long> {

	/**
	 * Devuelve los procesos de simulacion por estado
	 * @param Estado, Id del estado
	 * @return
	 */
	public Long countProcesosPorEstado(Long Estado);
	
	/**
	 * Devuelve los procesos de simulación por el estado
	 * @param estado, Id del estado
	 * @return
	 */
	public List<RecobroSimulacionEsquema> getProcesosPorEstado(Long estado);

	/**
	 * Devuelve la simulacion de un esquema
	 * @param idEsquema
	 * @return
	 */
	public List<RecobroSimulacionEsquema> getSimulacionesDelEsquema(Long idEsquema);

	/**
	 * Devuelve los procesos de simulacion por el código del estado
	 * @param codigoEstado
	 * @return
	 */
	public List<RecobroSimulacionEsquema> getProcesosPorCodigoEstado(String codigoEstado);
	
}
