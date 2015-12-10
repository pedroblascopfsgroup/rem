package es.capgemini.devon.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;

@Component
public class DynamicElementManager {

    @Autowired(required = false)
    List<DynamicElement> elements;

    @BusinessOperation
    public List<DynamicElement> getAll() {
        return elements;
    }

    @BusinessOperation
    public void changeEntity(String entity, String name, String newEntityName) {
        DynamicElement item = find(elements, entity, name);
        if (item == null) return;

        item.setEntity(newEntityName);
    }

    //si el nombre comienza con "-" no es válido.
    private boolean isEnabled(DynamicElement element) {
        return !element.getName().startsWith("-");
    }

    private List<DynamicElement> getElements(String entity, Object param) {
        List<DynamicElement> valids = new ArrayList<DynamicElement>();
        for (DynamicElement el : elements) {
            if (isEnabled(el) && el.getEntity().equals(entity) && el.valid(param)) {
                valids.add(el);
            }
        }
        return valids;
    }

    private DynamicElement find(List<DynamicElement> els, String entity, String name) {
        for (DynamicElement item : els) {
            if (item.getEntity().equals(entity) && item.getName().equals(name)) { return item; }
        }
        return null;
    }

    private DynamicElement find(List<DynamicElement> els, String name) {
        for (DynamicElement item : els) {
            if (item.getName().equals(name)) { return item; }
        }
        return null;
    }

    /** Combina los tabs opcionales con los de la lista que se pasa
     * @param param 
     * @param tabs
     */
    @BusinessOperation
    public List<DynamicElement> getDynamicElements(String entity, Object param) {
        List<DynamicElement> els = new ArrayList<DynamicElement>();
        if (elements == null) return els;

        for (DynamicElement tab : getElements(entity, param)) {
            DynamicElement found = find(els, tab.getName());
            if (found == null) {
                els.add(new DynamicElementAdapter("", tab.getName(), tab.getFileName(), tab.getOrder(), tab.getPriority()));
            } else {
                if (found.getOrder() <= tab.getOrder()) {
                    els.remove(found);
                    els.add(new DynamicElementAdapter("", tab.getName(), tab.getFileName(), tab.getOrder(), tab.getPriority()));
                }
            }
        }

        sortElements(els);

        return els;
    }

    private void sortElements(List<DynamicElement> tabs) {
        Collections.sort(tabs, new Comparator<DynamicElement>() {
            public int compare(DynamicElement o1, DynamicElement o2) {
                return new Integer(o1.getOrder()).compareTo(o2.getOrder());
            }
        });
    }
}
