package es.pfsgroup.plugin.rem.gestor.dao;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadHistoricoDao;
import es.pfsgroup.plugin.rem.model.Activo;

public interface GestorActivoHistoricoDao extends GestorEntidadHistoricoDao{
	
	public List<Usuario> getListUsuariosGestoresActivoByTipoYActivo(Long idTipoGestor, Activo activo);

}
