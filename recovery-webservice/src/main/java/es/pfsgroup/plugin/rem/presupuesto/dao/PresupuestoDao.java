package es.pfsgroup.plugin.rem.presupuesto.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;

public interface PresupuestoDao  extends AbstractDao<VBusquedaActivosTrabajoPresupuesto, Long>{
	
	/**
	 * Obtener el saldo disponible
	 * 
	 * @param idActivo
	 * @param ejercicioActual
	 * @return
	 */
	public String getSaldoDisponible(Long idActivo, String ejercicioActual);
	
	
	/**
	 * Obtiene la lista de presupestos del trabajo
	 * 
	 * @param dto
	 * @return
	 */
	public List<VBusquedaPresupuestosActivo> getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto);
	
	
	
	/**
	 * 
	 * @param dto
	 * @return
	 */
	public List<VBusquedaActivosTrabajoPresupuesto> getListActivosTrabajoPresupuesto(DtoActivosTrabajoFilter dto);
	
	

}
