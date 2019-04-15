package es.pfsgroup.plugin.rem.api.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.api.PresupuestoApi;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.presupuesto.dao.PresupuestoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;

@Service("presupuestoManager")
public class PresupuestoManager implements PresupuestoApi{
	
	
	@Autowired
	private PresupuestoDao presupuestoDao;

	@Override
	public String obtenerSaldoDisponible(Long idActivo, String ejercicioActual) throws Exception {
		
		 return presupuestoDao.getSaldoDisponible(idActivo, ejercicioActual);
	}

	@Override
	public List<VBusquedaActivosTrabajoPresupuesto> listarTrabajosActivo(Long idActivo, String ejercicioActual)
			throws Exception {
		DtoActivosTrabajoFilter filtro = new DtoActivosTrabajoFilter();
		filtro.setIdActivo(String.valueOf(idActivo));
		return presupuestoDao.getListActivosTrabajoPresupuesto(filtro);
	}

	@Override
	public List<VBusquedaPresupuestosActivo> getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto) {
		return presupuestoDao.getListHistoricoPresupuestos(dto);
	}
	
	@Override
	public List<VBusquedaActivosTrabajoPresupuesto> getListActivosPresupuesto(DtoActivosTrabajoFilter dto){
		return presupuestoDao.getListActivosTrabajoPresupuesto(dto);
	}

}
