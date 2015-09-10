package es.pfsgroup.web.menu;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.web.DynamicElementAdapter;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.UsuarioManager;

public class ElementoDinamicoPorFuncionYOperador extends DynamicElementAdapter {

	private static final long serialVersionUID = -2864875663163501198L;

	@Autowired
    UsuarioManager usuarioManager;

    @Autowired
    FuncionManager funcionManager;

    private String permission = "";
    private String operador = "OR";
    
    private static final String OPERADOR_OR = "OR";
    private static final String OPERADOR_AND = "AND";

    /**
     * Dependiendo del parámetro "operador"
     * OR: Si el perfil tiene algún permiso de la lista devuelve true
     * AND: Si el perfil tiene todos los permisos de la lista devuelve true
     */
    @Override
    public boolean valid(Object param) {
        if (StringUtils.isBlank(getPermission())) return true;
        String[] permissions = getPermission().split(",");        
        for (String permission : permissions) {        	
			if (tienePerfil(permission)) {	
				if (operador.compareTo(OPERADOR_OR)==0) {				
					return true;
				}
			} else {
				if (operador.compareTo(OPERADOR_AND)==0) {
					return false;
				}
			}
		}
        return (operador.compareTo(OPERADOR_OR)==0) ? false : true;
    }

    private boolean tienePerfil(String perfil) {
        return funcionManager.tieneFuncion(usuarioManager.getUsuarioLogado(), perfil);
    }

    public void setPermission(String permission) {
        this.permission = permission;
    }

    public String getPermission() {
        return permission;
    }

	public String getOperador() {
		return operador;
	}

	public void setOperador(String operador) {
		this.operador = operador;
	}
    
}
