package es.pfsgroup.plugin.recovery.mejoras.users;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.users.dto.DtoUsuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class MEJUsuarioManager implements MEJUsuarioApi{
	
	@Autowired
	ApiProxyFactory proxyFactory;

    @Autowired
    private UsuarioDao usuarioDao;

    @Override
	@BusinessOperation(MEJ_MGR_DATOSUSUARIO_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsDatosUsuarioLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.public.buttons.left",
				null);
					if (l == null)
							return new ArrayList<DynamicElement>();
					else
							return l;
	}

	@Override
	@BusinessOperation(MEJ_MGR_DATOSUSUARIO_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsDatosUsuarioRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.mejoras.web.public.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(overrides = ConfiguracionBusinessOperation.BO_USUARIO_MGR_GUARDAR_USUARIO_INTERNO)
    @Transactional(readOnly = false)
	public void guardarUsuarioInterno(DtoUsuario dto) {

        Usuario usr = usuarioDao.get(dto.getId());
        
        //Este metodo se llama antes de estar logeado y por lo tanto no se conoce la entidad de BD 
        //En caso de que no este especificada debemos setearla
        if(DbIdContextHolder.getDbId()<=0){
            DbIdContextHolder.setDbId(usr.getEntidad().getId());  
        }
        
        usr.getPerfiles();
        
        //En Bankia esto no es necesario
        validarPasswords(usr, dto);

        usr.setUsername(dto.getUsername());
        usr.setNombre(dto.getNombre());
        usr.setApellido1(dto.getApellido1());
        usr.setApellido2(dto.getApellido2());
        usr.setEmail(dto.getEmail());
        usr.setTelefono(dto.getTelefono());
        //En Bankia esto no es necesario
        //if (!dto.getPasswordNuevo().trim().isEmpty()) {
        //    usr.setFechaVigenciaPassword(usr.getNuevaFechaVigenciaPassword());
        //    usr.setPassword(dto.getPasswordNuevo().trim());
        //}

        usuarioDao.update(usr);
        
	}

    /**
     * Valida que el password ingresado sea el actual
     * Caso contrario Excepcion.
     * @param usr Usuario actual
     * @param dto parametros
     */
    private void validarPasswords(Usuario usr, DtoUsuario dto) {

    	if (!usr.getPassword().equals(dto.getPassword())) { throw new BusinessOperationException("admin.users.password.invalid"); }

    }

}
