package es.pfsgroup.plugin.rem.usuarioRem;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;

public interface UsuarioRemApi{
	
	/**
	 * Este método obtiene el perímetro de un activo por el ID de activo.
	 *
	 * @param usuario: Usuario del que se comprueba si tiene un sustituto vigente 
	 * @return Devuelve un objeto List<String>.
	 */
	public List<String> getGestorSustitutoUsuario(Usuario usuario);
	
}

