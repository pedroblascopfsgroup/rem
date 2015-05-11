package es.pfsgroup.recovery.ext.impl.multigestor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;

/**
 * Operaciones de negocio para relaciones de usuarios y grupos
 * @author Diana
 *
 */
@Component
public class EXTGrupoUsuariosManager implements EXTGrupoUsuariosApi{
	
	@Autowired
	
	private EXTGrupoUsuariosDao grupoUsuarioDao;

	@Override
	@BusinessOperation(EXT_BO_GRUPOS_USUARIO_DAME_IDGRUPOS_BY_USU)
	public List<Long> buscaIdsGrupos(Usuario usuario) {
		return grupoUsuarioDao.buscaGruposUsuario(usuario);
	}

}
