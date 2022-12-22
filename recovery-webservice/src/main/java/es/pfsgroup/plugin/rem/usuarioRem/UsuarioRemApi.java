package es.pfsgroup.plugin.rem.usuarioRem;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface UsuarioRemApi{
	
	/**
	 * Este método obtiene el perímetro de un activo por el ID de activo.
	 *
	 * @param usuario: Usuario del que se comprueba si tiene un sustituto vigente 
	 * @return Devuelve un objeto List<String>.
	 */
	public List<String> getGestorSustitutoUsuario(Usuario usuario);
	
	public List<String> getApellidoNombreSustituto(Usuario usuario);
	
	public void rellenaListaCorreos(Activo activo, String codigoTipo, List<String> mailsPara, List<String> mailsCC , boolean addDirector);
	
	public void rellenaListaCorreos(ExpedienteComercial eco, String codigoTipo, List<String> mailsPara, List<String> mailsCC , boolean addDirector);
	
	public void rellenaListaCorreos(Usuario usuarioGestor, String codigoTipo, List<String> mailsPara, List<String> mailsCC , boolean addDirector);
	
	public void rellenaListaCorreosPorDefecto(String codigoTipo, List<String> mailsPara);

	public List<String> getCodigosCarterasUsuario(Boolean tieneSubcartera, Usuario usuario);

	public List<String> getCodigosSubcarterasUsuario(String codCartera, Usuario usuario);
	
}