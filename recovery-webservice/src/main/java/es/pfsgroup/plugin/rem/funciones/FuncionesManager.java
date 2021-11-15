package es.pfsgroup.plugin.rem.funciones;

import java.util.List;
import java.util.Set;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.FuncionesApi;
import es.pfsgroup.plugin.rem.funciones.dao.FuncionesDao;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;

@Service("funcionesManager")
public class FuncionesManager extends BusinessOperationOverrider<FuncionesApi> implements FuncionesApi {
	
	@Autowired
	private FuncionesDao funcionesDao;
	
	@Override
	public String managerName() {
		return "funcionesManager";
	}

	@Override
	public List<DtoFunciones> getFunciones(DtoFunciones funciones) {
		return funcionesDao.getFunciones(funciones);
	}

	@Override
	public boolean elUsuarioTieneFuncion(String funcionString, Usuario usuario) {		
		List<Perfil> perfiles = usuario.getPerfiles();
		Set<Funcion> funciones = null;
		for (Perfil perfil : perfiles) {
			funciones = perfil.getFunciones();
			
			if(funciones != null && !funciones.isEmpty()) {
				for (Funcion funcion : funciones) {
					if(funcionString.equals(funcion.getDescripcion())) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	@Override
	public boolean userHasFunction(String username, String descripcion) {
		return funcionesDao.userHasFunction(username, descripcion);
	}

}
