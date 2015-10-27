package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.ListadoPreProyectadoApi;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoExp;

@Component
public class ListadoPreProyectadoManager implements ListadoPreProyectadoApi {
	
	@Autowired
	VListadoPreProyectadoCntDao vListadoPreProyectadoCntDao;

	@Override
	public List<VListadoPreProyectadoExp> getListPreproyectadoExp(
			ListadoPreProyectadoDTO dto) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<VListadoPreProyectadoCnt> getListPreproyectadoCnt(
			ListadoPreProyectadoDTO dto) {

		return vListadoPreProyectadoCntDao.getListadoPreProyectadoCnt(dto);
	}

}
