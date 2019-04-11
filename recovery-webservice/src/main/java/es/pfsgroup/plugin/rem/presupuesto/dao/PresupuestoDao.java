package es.pfsgroup.plugin.rem.presupuesto.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;

public interface PresupuestoDao  extends AbstractDao<VBusquedaActivosTrabajoPresupuesto, Long>{
	
	/**
	 * Obtener el saldo disponible
	 * 
	 * @param idActivo
	 * @param ejercicioActual
	 * @return
	 */
	public String getSaldoDisponible(Long idActivo, String ejercicioActual);

}
