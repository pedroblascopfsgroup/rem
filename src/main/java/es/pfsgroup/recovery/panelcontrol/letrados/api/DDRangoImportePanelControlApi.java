package es.pfsgroup.recovery.panelcontrol.letrados.api;

import java.util.Collection;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.panelcontrol.letrados.api.model.DDRangoImportePanelControlInfo;

public interface DDRangoImportePanelControlApi {
	

    final static String REC_RANGO_IMPORTE_PANEL_CONTROL_GET_BY_ID = "es.pfsgroup.recovery.previsiones..panelcontrol.letrados.rangoimporte.getById";
    final static String REC_RANGO_IMPORTE_PANEL_CONTROL_GET_LIST = "es.pfsgroup.recovery.previsiones.panelcontrol.letrados.rangoimporte.getListado";

    /**
     * Recupera el DDRangoImportePanelControl a través de su ID
     * @param idContrato Identificador de la entidad
     * @return
     */
    @BusinessOperationDefinition(REC_RANGO_IMPORTE_PANEL_CONTROL_GET_BY_ID)
    public	DDRangoImportePanelControlInfo getById(Long id);

    /**
     * Recupera un listado de DDRangoImportePanelControl 
     * @return
     */
    @BusinessOperationDefinition(REC_RANGO_IMPORTE_PANEL_CONTROL_GET_LIST)
    public	Collection<? extends DDRangoImportePanelControlInfo> getListado();	

}
