package es.pfsgroup.recovery.ext.api.multigestor;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EXTGrupoUsuariosApi {
	
	public static final String EXT_BO_GRUPOS_USUARIO_DAME_IDGRUPOS_BY_USU = "es.pfsgroup.recovery.ext.api.multigestor.buscarIdGruposUsuario";


	@BusinessOperationDefinition(EXT_BO_GRUPOS_USUARIO_DAME_IDGRUPOS_BY_USU)
	List<Long> buscaIdsGrupos(Usuario usuario) ;

	Boolean usuarioPerteneceAGrupo(Usuario usuario, Usuario grupo);

}
