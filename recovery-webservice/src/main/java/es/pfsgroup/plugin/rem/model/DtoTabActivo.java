package es.pfsgroup.plugin.rem.model;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap;


/**
 * Dto para encapsular la información por pestaña de campos propagables a otros activos
 */
public class DtoTabActivo extends WebDto  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

    private List<?> camposPropagables ;
    
    
	
	public List<?> getCamposPropagables() {
		return camposPropagables;
	}

	public void setCamposPropagables(List<?> camposPropagables) {
		this.camposPropagables = camposPropagables;
	}


	public void setCamposPropagables(String tab) {
		
		List<String> fields = new ArrayList<String>();

		if (ActivoPropagacionFieldTabMap.map.get(tab) != null) {
			fields.addAll(ActivoPropagacionFieldTabMap.map.get(tab));
		}
		
		this.setCamposPropagables(fields);
	}
    

    
    
    
}