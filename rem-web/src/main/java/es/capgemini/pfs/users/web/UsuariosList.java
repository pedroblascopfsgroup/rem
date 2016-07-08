package es.capgemini.pfs.users.web;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections.FactoryUtils;
import org.apache.commons.collections.list.LazyList;

import es.capgemini.devon.view.DataBean;

@SuppressWarnings("unchecked")
public class UsuariosList {

    List usuarios = LazyList.decorate(new ArrayList(), FactoryUtils.instantiateFactory(DataBean.class));

    public List getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(List usuarios) {
        this.usuarios = usuarios;
    }
}
