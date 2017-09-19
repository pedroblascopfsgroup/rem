package es.pfsgroup.plugin.rem.model;

import java.util.List;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para encapsular la información de cada pestaña del activo *
 */
public class DtoActivo  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    private WebDto tabData;
    private List<?> propagableFields ;
    
    
	public WebDto getTabData() {
		return tabData;
	}
	public void setTabData(WebDto tabData) {
		this.tabData = tabData;
	}
	public List<?> getPropagableFields() {
		return propagableFields;
	}
	public void setPropagableFields(List<?> propagableFields) {
		this.propagableFields = propagableFields;
	}
    

    
    
    
}