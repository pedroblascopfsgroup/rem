package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;

public interface PresupuestoApi {
	/**
	 * Obtiene el sdaldo disponible de un trabajo
	 * 
	 * @param idActivo
	 * @param ejercicioActual
	 * @return
	 * @throws Exception
	 */
	public String obtenerSaldoDisponible(Long idActivo, String ejercicioActual) throws Exception;
	
	/**
	 * Obtiene la lista de trabajos de un activo
	 * @param idActivo
	 * @param ejercicioActual
	 * @return
	 * @throws Exception
	 */
	public List<VBusquedaActivosTrabajoPresupuesto> listarTrabajosActivo(Long idActivo, String ejercicioActual) throws Exception;
	
	
}
