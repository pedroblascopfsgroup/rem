package es.capgemini.devon.web;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;

@Component
public class MenuManager {

    @Autowired
    DynamicElementManager dynamicElementManager;

    @BusinessOperation
    public List<MenuItem> getMenuDefinitionWithParam(String entity, Object param) {
        return getMenu(entity, param);
    }

    @BusinessOperation
    public List<MenuItem> getMenuDefinition(String entity) {
        return getMenu(entity, null);
    }

    public List<DynamicElement> getNivel(List<DynamicElement> lista, int level) {
        List<DynamicElement> filtrados = new ArrayList<DynamicElement>();
        for (DynamicElement item : lista) {
            if (StringUtils.countMatches(item.getName(), "/") == level) {
                filtrados.add(item);
            }
        }
        return filtrados;
    }

    private MenuItem getItem(List<MenuItem> list, String id) {
        for (MenuItem item : list) {
            if (item.getId().equals(id)) { return item; }

        }
        return null;
    }

    public MenuItem buscaPadre(List<MenuItem> list, String id) {
        String key = id;
        MenuItem item = null;
        List<MenuItem> padre = list;
        for (int i = 0; i < StringUtils.countMatches(id, "/"); i++) {
            String k = StringUtils.substringBefore(key, "/");
            item = getItem(padre, k);
            if (item != null) {
                padre = item.getMenu();
                if (padre == null) padre = new ArrayList<MenuItem>();
            }
            key = StringUtils.substringAfter(key, "/");
        }
        return item;
    }

    public List<MenuItem> getMenu(String entity, Object param) {
        List<DynamicElement> list = dynamicElementManager.getDynamicElements(entity, param);

        List<MenuItem> menu = new ArrayList<MenuItem>();
        int level = 0;

        while (getNivel(list, level).size() > 0) {
            for (DynamicElement item : getNivel(list, level)) {
                MenuItem m = new MenuItem(item.getName(), item.getFileName(), new ArrayList<MenuItem>());
                if (item.getName().contains("*")) m.setCurlyBraces(false);
                MenuItem padre = buscaPadre(menu, m.getId());
                if (padre == null) {
                    menu.add(m);
                } else {
                    List<MenuItem> submenu = padre.getMenu();
                    if (submenu == null) submenu = new ArrayList<MenuItem>();
                    submenu.add(m);
                    padre.setMenu(submenu);
                }
            }
            level++;
        }

        return menu;
    }

}
