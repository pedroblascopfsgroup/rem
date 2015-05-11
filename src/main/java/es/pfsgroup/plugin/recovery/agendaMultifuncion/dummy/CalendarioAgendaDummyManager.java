package es.pfsgroup.plugin.recovery.agendaMultifuncion.dummy;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.CalendarioAgendaApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.dto.DtoCalendarioEventoImpl;

@Component
public class CalendarioAgendaDummyManager implements CalendarioAgendaApi {

    private final Log logger = LogFactory.getLog(getClass());

    @Override
    //@BusinessOperation(PLUGIN_AGENDA_MULTIFUNCION_BO_NUEVO_EVENTO)
    public Long nuevoEvento(DtoCalendarioEvento dto) {
        logger.warn("DUMMY IMPL of nuevoEvento");
        return 0L;
    }

    @Override
    //@BusinessOperation(PLUGIN_AGENDA_MULTIFUNCION_BO_NUEVO_EVENTO)
    public void borrarEvento(DtoCalendarioEventoImpl dto) {
        logger.warn("DUMMY IMPL of borrarEvento");
    }

}
