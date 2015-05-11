package es.pfsgroup.plugin.recovery.agendaMultifuncion.api;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.dto.DtoCalendarioEventoImpl;

public interface CalendarioAgendaApi {

    public static final String PLUGIN_AGENDA_MULTIFUNCION_BO_NUEVO_EVENTO = "plugin.agendaMultifucion.calendarioAgenda.nuevoEvento";
    public static final String PLUGIN_AGENDA_MULTIFUNCION_BO_BORRAR_EVENTO = "plugin.agendaMultifucion.calendarioAgenda.borraarEvento";

    //@BusinessOperationDefinition(PLUGIN_AGENDA_MULTIFUNCION_BO_NUEVO_EVENTO)
    Long nuevoEvento(DtoCalendarioEvento dto);

    //@BusinessOperationDefinition(PLUGIN_AGENDA_MULTIFUNCION_BO_BORRAR_EVENTO)
    void borrarEvento(DtoCalendarioEventoImpl dto);

}
