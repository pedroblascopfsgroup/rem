package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.ListadoPreProyectadoApi;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoExpDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoExp;

@Component
public class ListadoPreProyectadoManager implements ListadoPreProyectadoApi {
	
	@Autowired
	VListadoPreProyectadoCntDao vListadoPreProyectadoCntDao;
	
	@Autowired
	VListadoPreProyectadoExpDao vListadoPreProyectadoExpDao;

	@Override
	public Page getListPreproyectadoExp(
			ListadoPreProyectadoDTO dto) {
		
		return vListadoPreProyectadoExpDao.getListadoPreProyectadoExp(dto);
	}

	@Override
	public List<VListadoPreProyectadoCnt> getListPreproyectadoCnt(
			ListadoPreProyectadoDTO dto) {

		return vListadoPreProyectadoCntDao.getListadoPreProyectadoCnt(dto);
	}

	@Override
	public Page getListPreproyectadoCntPaginated(ListadoPreProyectadoDTO dto) {
		return vListadoPreProyectadoCntDao.getListadoPreProyectadoCntPaginated(dto);
	}

}
