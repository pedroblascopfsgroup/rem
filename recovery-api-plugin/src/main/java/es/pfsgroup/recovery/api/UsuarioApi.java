package es.pfsgroup.recovery.api;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Interfaz con las BO de recovery relativas al Usuario que usam el plugin
 * @author bruno
 *
 */
public interface UsuarioApi {

	/**
     * Recupera el usuario logeado. Y si no hay el usuario por defecto.
     * @return usuario
     */
    @BusinessOperationDefinition(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)
	Usuario getUsuarioLogado();
    
    /**
     * @param id Long
     * @return Usuario
     */
    @BusinessOperationDefinition(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET)
    Usuario get(Long id);
}
