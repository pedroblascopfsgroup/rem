package es.capgemini.pfs.users.web;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.users.dto.DtoBuscarUsuarios;

public class FormListadoUsuarios extends DtoBuscarUsuarios {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    //    private Object[] usuarios;
    //
    //    public Object[] getUsuarios() {
    //        return usuarios;
    //    }
    //
    //    public void setUsuarios(Object[] usuarios) {
    //        this.usuarios = usuarios;
    //    }

    private List<Usuario> usuarios;

    public List<Usuario> getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(List<Usuario> usuarios) {
        this.usuarios = usuarios;
    }

}
