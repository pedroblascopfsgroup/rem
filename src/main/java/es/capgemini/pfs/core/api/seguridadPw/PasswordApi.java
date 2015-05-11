package es.capgemini.pfs.core.api.seguridadPw;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface PasswordApi {
	
	public static final String BO_EXT_PASSWORD_MGR_CONTRASENA_CORRECTA = "es.capgemini.pfs.core.api.seguridadPw.isPwCorrect";
	
	/**
     * Comprueba si la contraseña pasada para el usuario pasado es correcta.
     * @return boolean
     */
    @BusinessOperationDefinition(BO_EXT_PASSWORD_MGR_CONTRASENA_CORRECTA)
    public boolean isPwCorrect(Usuario usuario, String password);
    

}
