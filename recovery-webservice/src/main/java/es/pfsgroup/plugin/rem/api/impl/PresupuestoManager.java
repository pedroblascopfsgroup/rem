package es.pfsgroup.plugin.rem.api.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.PresupuestoApi;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.presupuesto.dao.PresupuestoDao;

@Service("presupuestoManager")
public class PresupuestoManager implements PresupuestoApi{
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private PresupuestoDao presupuestoDao;

	@Override
	public String obtenerSaldoDisponible(Long idActivo, String ejercicioActual) throws Exception {
		
		 return presupuestoDao.getSaldoDisponible(idActivo, ejercicioActual);
	}

	@Override
	public List<VBusquedaActivosTrabajoPresupuesto> listarTrabajosActivo(Long idActivo, String ejercicioActual)
			throws Exception {
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo",
				idActivo.toString());
		Filter filtroEjercicioActual = genericDao.createFilter(FilterType.EQUALS, "ejercicio", ejercicioActual);
		List<VBusquedaActivosTrabajoPresupuesto> listaTrabajosActivo = genericDao
				.getList(VBusquedaActivosTrabajoPresupuesto.class, filtroActivo, filtroEjercicioActual);
		
		return listaTrabajosActivo;
	}

}
