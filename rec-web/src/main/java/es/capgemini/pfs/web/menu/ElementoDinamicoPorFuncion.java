package es.capgemini.pfs.web.menu;

import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.web.DynamicElementAdapter;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;

public class ElementoDinamicoPorFuncion extends DynamicElementAdapter {

    @Autowired
    UsuarioManager usuarioManager;

    @Autowired
    FuncionManager funcionManager;

    private String permission = "";
    
    private Set<String> tabsNoPermitidas;
    
    private Set<String> inicializarTabs(){
    	Set<String> tabs = new HashSet<String>();
    	tabs.add("adjuntosCliente");
    	tabs.add("adjuntosAsunto");
    	tabs.add("historicoEventosAsuntos");
    	tabs.add("decisionProcedimiento");
    	tabs.add("tareasProcedimiento");
    	tabs.add("docRequeridaProcedimiento");
    	tabs.add("historicoProcedimiento");
    	tabs.add("expedientesAsuntos");
    	tabs.add("adjuntosContratos");
    	tabs.add("tabProcedimientos");
    	tabs.add("adjuntosProcedimiento");
    	tabs.add("historicoAsunto");
    	tabs.add("tabTramiteSubastas");
    	tabs.add("tabAnalisis");
    	return tabs;
    }

    @Override
    public boolean valid(Object param) {
    	for(Perfil perfil : usuarioManager.getUsuarioLogado().getPerfiles()){
    		if("HAYASAREB".equals(perfil.getCodigo())){
    			tabsNoPermitidas = inicializarTabs();
    			if(tabsNoPermitidas.contains(getName())){
    				return false;
    			}else{
    				if (StringUtils.isBlank(getPermission())) return true;
    		        return tienePerfil(getPermission());
    			}
    		}
    	}
        if (StringUtils.isBlank(getPermission())) return true;
        return tienePerfil(getPermission());
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

}
