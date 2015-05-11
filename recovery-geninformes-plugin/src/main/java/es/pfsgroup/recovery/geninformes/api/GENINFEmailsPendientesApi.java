package es.pfsgroup.recovery.geninformes.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface GENINFEmailsPendientesApi {

    String PLUGIN_GENINFORMES_BO_PROCESAR_EMAILS_PENDIENTES = "es.pfsgroup.recovery.geninformes.api.GENINFEmailsPendientesApi.procesarEmailsPendientes";

    /**
     * Revisar las solicitudes de envío de email pendientes y si la fecha actual coincide con la fecha programada
     * ejecutar el envío del email y marcar la petición como realizada
     */
    @BusinessOperationDefinition(PLUGIN_GENINFORMES_BO_PROCESAR_EMAILS_PENDIENTES)
    void procesarEmailsPendientes();

}
