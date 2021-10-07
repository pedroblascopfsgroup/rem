package es.pfsgroup.plugin.rem.security.jupiter;

public interface IntegracionJupiterApi {

	public enum TIPO_PERFIL {
		PERFIL_ROL, GRUPO, CARTERA, SUBCARTERA
	}
	
	/**
	 * Si detecta modificaciones, actualiza los datos personales del usuario con la información que se pasa como parámetro 
	 * 
	 * @param username
	 * @param nombre
	 * @param apellidos
	 * @param email
	 * @throws Exception
	 */
	public void actualizarInfoPersonal(String username, String nombre, String apellidos, String email) throws Exception;
	
	/**
	 * Comprueba la lista de roles Jupiter (separadas por comas) y, si detecta diferencias con REM, actualiza en REM.
	 * Tenemos en cuenta que roles en Jupiter significan en REM todas estas cosas: perfiles, grupos, carteras, subcarteras)
	 * 
	 * @param username
	 * @param listaRoles
	 * @throws Exception
	 */
	public void actualizarRolesDesdeJupiter(String username, String listaRoles) throws Exception;

	/**
	 * Establece el contexto de BD para que las tablas del esquema de entidad sean accesibles 
	 * 
	 */
	public void setDBContext();
	
}
