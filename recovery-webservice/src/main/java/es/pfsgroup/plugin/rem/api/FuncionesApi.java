package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;

public interface FuncionesApi {

	List<DtoFunciones> getFunciones(DtoFunciones funciones);

	/**
	 * Este método devuelve un boolean si el usuario tiene una función
	 * 
	 * @param Se le pasa la descripción(que es el código) de la función que se quiere comprobar y el usuario.
	 * @return Devuelve un booleano si el usuario tiene la función.
	 */
	boolean elUsuarioTieneFuncion(String funcionString, Usuario usuario);

	boolean userHasFunction(String username, String descripcion);
	
}
