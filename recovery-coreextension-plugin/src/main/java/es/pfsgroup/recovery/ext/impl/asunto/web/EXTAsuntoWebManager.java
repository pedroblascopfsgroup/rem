package es.pfsgroup.recovery.ext.impl.asunto.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Controller
public class EXTAsuntoWebManager {

    public static final String EXT_WEB_BO_ASUNTO_BUTTONS_LEFT = "es.pfsgroup.recovery.ext.impl.asunto.web.getButtonsAsuntoLeft";
    public static final String EXT_WEB_BO_ASUNTO_BUTTONS_RIGHT = "es.pfsgroup.recovery.ext.impl.asunto.web.getButtonsAsuntoRight";
    public static final String EXT_WEB_BO_ASUNTO_TABS = "es.pfsgroup.recovery.ext.impl.asunto.web.getTabs";

    @Autowired
    private ApiProxyFactory proxyFactory;

    @BusinessOperation(EXT_WEB_BO_ASUNTO_BUTTONS_LEFT)
    public List<DynamicElement> getButtonsAsuntoLeft() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.web.asuntos.buttons.left", null);
        if (l == null) {
            return new ArrayList<DynamicElement>();
        } else {
            return l;
        }
    }

    @BusinessOperation(EXT_WEB_BO_ASUNTO_BUTTONS_RIGHT)
    public List<DynamicElement> getButtonsAsuntoRight() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.web.asuntos.buttons.right", null);
        if (l == null) {
            return new ArrayList<DynamicElement>();
        } else {
            return l;
        }
    }

    @BusinessOperation(EXT_WEB_BO_ASUNTO_TABS)
    public List<DynamicElement> getTabs() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.web.asuntos.tabs", null);
        if (l == null) {
            return new ArrayList<DynamicElement>();
        } else {
            return l;
        }
    }
}
