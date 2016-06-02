package es.pfsgroup.recovery.ext.impl.multigestor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

/**
 * Operaciones de negocio para relaciones de usuarios y grupos
 * @author Diana
 *
 */
@Component
public class EXTGrupoUsuariosManager implements EXTGrupoUsuariosApi{
	
	@Autowired
	private EXTGrupoUsuariosDao grupoUsuarioDao;

    @Autowired
    private GenericABMDao genericDao;

	@Override
	@BusinessOperation(EXT_BO_GRUPOS_USUARIO_DAME_IDGRUPOS_BY_USU)
	public List<Long> buscaIdsGrupos(Usuario usuario) {
		return grupoUsuarioDao.buscaGruposUsuario(usuario);
	}

	public Boolean usuarioPerteneceAGrupo(Usuario usuario, Usuario grupo) {
		List<EXTGrupoUsuarios> usuariosDelGrupo =  genericDao.getList(EXTGrupoUsuarios.class, 
				genericDao.createFilter(FilterType.EQUALS, "grupo.id", grupo.getId()),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		boolean usuEsDelGrupo = false;
		for(EXTGrupoUsuarios ug : usuariosDelGrupo){
			if(usuario.equals(ug.getUsuario())){
				usuEsDelGrupo = true;
			}
		}
		return usuEsDelGrupo;

	}
}

