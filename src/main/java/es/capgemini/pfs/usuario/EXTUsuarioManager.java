package es.capgemini.pfs.usuario;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.usuario.dto.EXTDtoUsuario;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

@Component
public class EXTUsuarioManager extends BusinessOperationOverrider<UsuarioApi> implements UsuarioApi{

	@Autowired
	private UsuarioDao usuarioDao;
	
	@Override
	@BusinessOperation(overrides=ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)
	@Transactional
	public Usuario getUsuarioLogado() {
		EventFactory.onMethodStart(this.getClass());
		return parent().getUsuarioLogado();
	}

	@Override
	public String managerName() {
		return "usuarioManager";
	}

	@Override
	@BusinessOperation(overrides=ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET)
	public Usuario get(Long id) {
		EventFactory.onMethodStart(this.getClass());
		return parent().get(id);
	}

	@Override
	@BusinessOperation("es.capgemini.usuario.getList")
	public List<EXTDtoUsuario> getListaUsuarios() {
		
		List<EXTDtoUsuario> listaDto = new ArrayList<EXTDtoUsuario>();
		List<Usuario> lista = usuarioDao.getList();
		for(Usuario u:lista){
			EXTDtoUsuario dto = new EXTDtoUsuario();
			dto.setCodigo(u.getId());
			if(u.getApellidoNombre()!=null)
				dto.setDescripcion(u.getApellidoNombre());
			else
				dto.setDescripcion(u.getUsername());
			listaDto.add(dto);
		}
		return listaDto;
	}
	
	@Override
	@BusinessOperation(BO_EXT_USUARIO_MGR_TIENE_PERFIL_CARTERIZADO)
	public Boolean tienePerfilCarterizado() {
		Usuario usuario = this.getUsuarioLogado();
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			EXTPerfil extPerfil = (EXTPerfil)per;
			if (extPerfil.getEsCarterizado())
				return true;
		}		
		return false;
	}	

}
