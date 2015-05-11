package es.pfsgroup.recovery.panelcontrol.letrados.api.model;

import java.io.Serializable;

public interface DDRangoImportePanelControlInfo extends Serializable{
	
    String getCodigo();

    String getDescripcion();

    Long getValorInicial();

    Long getValorFinal();


}
