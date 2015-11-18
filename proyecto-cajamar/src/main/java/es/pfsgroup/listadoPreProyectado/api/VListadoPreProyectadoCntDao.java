package es.pfsgroup.listadoPreProyectado.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoCnt;

public interface VListadoPreProyectadoCntDao {

	List<VListadoPreProyectadoCnt> getListadoPreProyectadoCnt(ListadoPreProyectadoDTO dto);
	
	List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntExp(Long expId, Usuario usuarioLogado);

	List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto);

	int getCountListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto);
}