package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.ListadoPreProyectadoApi;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoExpDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;

@Component
public class ListadoPreProyectadoManager implements ListadoPreProyectadoApi {
	
	@Autowired
	VListadoPreProyectadoCntDao vListadoPreProyectadoCntDao;
	
	@Autowired
	VListadoPreProyectadoExpDao vListadoPreProyectadoExpDao;
	
	@Autowired
	UsuarioManager usuarioManganer;

	@Override
	public Page getListPreproyectadoExp(
			ListadoPreProyectadoDTO dto) {
		
		dto.setUsuarioLogado(usuarioManganer.getUsuarioLogado());
		
		return vListadoPreProyectadoExpDao.getListadoPreProyectadoExp(dto);
	}

	@Override
	public List<VListadoPreProyectadoCnt> getListPreproyectadoCnt(
			ListadoPreProyectadoDTO dto) {

		dto.setUsuarioLogado(usuarioManganer.getUsuarioLogado());
		return vListadoPreProyectadoCntDao.getListadoPreProyectadoCnt(dto);
	}

	@Override
	public List<VListadoPreProyectadoCnt> getListPreproyectadoCntPaginated(ListadoPreProyectadoDTO dto) {
		
		dto.setUsuarioLogado(usuarioManganer.getUsuarioLogado());
		return vListadoPreProyectadoCntDao.getListadoPreProyectadoCntPaginated(dto);
	}

	@Override
	public int getCountListadoPreProyectadoCntPaginated(
			ListadoPreProyectadoDTO dto) {
		
		dto.setUsuarioLogado(usuarioManganer.getUsuarioLogado());
		return vListadoPreProyectadoCntDao.getCountListadoPreProyectadoCntPaginated(dto);
	}

}
