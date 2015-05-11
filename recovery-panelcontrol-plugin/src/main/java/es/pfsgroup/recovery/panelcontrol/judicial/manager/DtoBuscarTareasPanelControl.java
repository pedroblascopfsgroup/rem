package es.pfsgroup.recovery.panelcontrol.judicial.manager;

import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;


public class DtoBuscarTareasPanelControl extends DtoBuscarTareaNotificacion {

	/**
	 * 
	 */
	private static final long serialVersionUID = 727830376197263447L;
	
	private String panelTareas;

	public void setPanelTareas(String panelTareas) {
		this.panelTareas = panelTareas;
	}

	public String getPanelTareas() {
		return panelTareas;
	}
	
	
    
    

}
