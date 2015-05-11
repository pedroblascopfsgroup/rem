package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.RecoveryAgendaMultifuncionDtoBusquedaAsunto;

public interface RecoveryAgendaMultifuncionAsuntoEXTAsuntoApi {

    final static String AMF_ASUNTO_FIND_ASUNTOS_PAGINATED = "es.pfsgroup.plugin.recovery.agendaMultifuncion.asunto.findAsuntosPaginated";

    @BusinessOperationDefinition(AMF_ASUNTO_FIND_ASUNTOS_PAGINATED)
    public Page findAsuntosPaginated(RecoveryAgendaMultifuncionDtoBusquedaAsunto dto);
}
