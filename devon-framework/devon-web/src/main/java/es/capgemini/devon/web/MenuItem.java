package es.capgemini.devon.web;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Elemento básico para crear una estructura jerárquica de elementos de menús que luego se dibujarán con el tag de menu
 */
public class MenuItem implements Serializable {

    String id;
    String file;
    List<MenuItem> menu = new ArrayList<MenuItem>();
    boolean curlyBraces = true;

    public boolean isCurlyBraces() {
        return curlyBraces;
    }

    public void setCurlyBraces(boolean curlyBraces) {
        this.curlyBraces = curlyBraces;
    }

    public static MenuItem createMenuItem(String id, String fileName, boolean curlyBraces) {
        MenuItem m = new MenuItem(id, fileName, new ArrayList<MenuItem>(), curlyBraces);
        return m;
    }

    public static MenuItem createMenuItem(String id, String fileName, List<MenuItem> menus) {
        MenuItem m = new MenuItem(id, fileName, menus);
        return m;
    }

    public static MenuItem createMenuItem(String id, String fileName, List<MenuItem> menus, boolean curlyBraces) {
        MenuItem m = new MenuItem(id, fileName, menus, curlyBraces);
        return m;
    }

    public static MenuItem createMenuItem(String id, String fileName) {
        MenuItem m = new MenuItem(id, fileName);
        return m;
    }

    public MenuItem(String id, String fileName) {
        this(id, fileName, new ArrayList<MenuItem>());
    }

    public MenuItem(String id, String fileName, List<MenuItem> menus) {
        this(id, fileName, menus, true);
    }

    public MenuItem(String id, String fileName, List<MenuItem> menus, boolean curlyBraces) {
        this.id = id;
        this.file = fileName;
        this.menu = menus;
        this.curlyBraces = curlyBraces;
    }

    public boolean getSubmenu() {
        return menu.size() > 0;
    }

    public List<MenuItem> getMenu() {
        return menu;
    }

    public void setMenu(List<MenuItem> menu) {
        this.menu = menu;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFile() {
        return file;
    }

    public void setFile(String file) {
        this.file = file;
    }

}
