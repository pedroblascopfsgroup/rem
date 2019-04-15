package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;

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
	
	
	
	/**
	 * Obtiene la lista de presupestos del trabajo
	 * 
	 * @param dto
	 * @return
	 */
	List<VBusquedaPresupuestosActivo> getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto);
	
	
	/**
	 * 
	 * @param dto
	 * @return
	 */
	public List<VBusquedaActivosTrabajoPresupuesto> getListActivosPresupuesto(DtoActivosTrabajoFilter dto);
	
	
}
