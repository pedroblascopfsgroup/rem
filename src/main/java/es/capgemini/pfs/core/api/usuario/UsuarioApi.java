package es.capgemini.pfs.core.api.usuario;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.usuario.dto.EXTDtoUsuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface UsuarioApi {
	
	
	public static final String BO_EXT_USUARIO_MGR_TIENE_PERFIL_CARTERIZADO = "plugin.coreextension.usuario.tienePerfilCarterizado";

	/**
     * Recupera el usuario logeado. Y si no hay el usuario por defecto.
     * @return usuario
     */
    @BusinessOperationDefinition(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)
    @Transactional
    public Usuario getUsuarioLogado();
    
    /**
     * @param id Long
     * @return Usuario
     */
    @BusinessOperationDefinition(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET)
    public Usuario get(Long id);
    
    @BusinessOperationDefinition("es.capgemini.usuario.getList")
    public List<EXTDtoUsuario> getListaUsuarios();
    
    @BusinessOperationDefinition(BO_EXT_USUARIO_MGR_TIENE_PERFIL_CARTERIZADO)
    public Boolean tienePerfilCarterizado();

}
