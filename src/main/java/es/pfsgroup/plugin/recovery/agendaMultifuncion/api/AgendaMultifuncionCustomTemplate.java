package es.pfsgroup.plugin.recovery.agendaMultifuncion.api;

import java.util.Map;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionInfo;

public interface AgendaMultifuncionCustomTemplate {
	
	final static String AGENDA_MULTIFUNCION_GET_CUSTOMIZE = "es.pfsgroup.plugin.recovery.agendaMultifuncion.api.agendaMultifuncionCustomTemplate.getCustomize";
	final static String LOCATION_TEMPLATE_KEY = "templateLocation";

	/**
     * Metodo que devuelve un map, con el codigo de litigio y el template que se
     * va a utilizar en el envio del email
     * 
     * FIXME Cambiar descripción del JAVADOC a algo más claro.
     * 
     * @param dto
     * @return mapa con los datos del codigo de litigio y el template
     */
	@BusinessOperationDefinition(AGENDA_MULTIFUNCION_GET_CUSTOMIZE)
	Map<String, String> getCustomize(DtoCrearAnotacionInfo dto);
}
