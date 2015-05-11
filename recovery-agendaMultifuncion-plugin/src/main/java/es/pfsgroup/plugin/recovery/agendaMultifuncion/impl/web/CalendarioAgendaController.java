package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.CalendarioAgendaApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.dto.DtoCalendarioEventoImpl;

@Controller
public class CalendarioAgendaController {

    public static final String PLUGIN_AGENDA_MULTIFUNCION_JSON_NUEVO_CALENDARIO_EVENTO = "plugin/agendaMultifuncion/calendario/json/nuevoCalendarioEventoJSON";

    @Autowired
    private ApiProxyFactory proxyFactory;

    @RequestMapping
    public String nuevoCalendarioEvento(DtoCalendarioEventoImpl dto, ModelMap model) {
        Long id = proxyFactory.proxy(CalendarioAgendaApi.class).nuevoEvento(dto);
        model.put("result", id);
        return PLUGIN_AGENDA_MULTIFUNCION_JSON_NUEVO_CALENDARIO_EVENTO;
    }

    public String borrarCalendarioEvento(DtoCalendarioEventoImpl dto, ModelMap mode) {
        proxyFactory.proxy(CalendarioAgendaApi.class).borrarEvento(dto);
        return PLUGIN_AGENDA_MULTIFUNCION_JSON_NUEVO_CALENDARIO_EVENTO;
    }
}
