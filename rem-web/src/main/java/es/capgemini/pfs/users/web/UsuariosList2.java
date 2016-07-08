package es.capgemini.pfs.users.web;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.devon.view.DataBean;

public class UsuariosList2 {
    List<DataBean> usuarios = new ArrayList<DataBean>();

    public List<DataBean> getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(List<DataBean> usuarios) {
        this.usuarios = usuarios;
    }
}
