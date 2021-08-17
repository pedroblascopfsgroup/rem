package es.pfsgroup.plugin.rem.security.jupiter;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;

public interface IntegracionJupiterDao {

	public void actualizarPerfiles(Usuario usuario, List<String> altasPerfiles, List<String> bajasPerfiles);

	public void actualizarGrupos(Usuario usuario, List<String> altasGrupos, List<String> bajasGrupos);
	
	public void actualizarCarteras(Usuario usuario, List<String> altasCarteras, List<String> bajasCarteras);
	
	public void actualizarSubcarteras(Usuario usuario, List<String> altasSubcarteras, List<String> bajasSubcarteras);

	public void actualizarUsuario(Usuario usuario, String nombre, String apellidos, String email);
	
	public List<String> getCodigosCarterasREM(Usuario usuario);
	
	public List<String> getCodigosSubcarterasREM(Usuario usuario);
	
	public List<String> getCodigodGruposREM(Usuario usuario);
	
	public List<String> getPerfilesREM(String username);

	public void eliminarSubcarteras(Usuario usuario);

	public Usuario crearUsuario(String username, String nombre, String apellidos, String email);

	public List<String> getCodigodGruposPerfilesREM(List<String> codigosPerfilesJupiter);
	
}
