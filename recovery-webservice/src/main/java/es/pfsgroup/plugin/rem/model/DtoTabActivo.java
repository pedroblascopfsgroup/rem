package es.pfsgroup.plugin.rem.model;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.config.ConfigManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionUAsFieldTabMap;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoDaoImpl;


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
	
	public void setCamposPropagablesUas(String tab) {
		
		List<String> fields = new ArrayList<String>();
			
		if (ActivoPropagacionUAsFieldTabMap.mapUAs.get(tab) != null) {
			fields.addAll(ActivoPropagacionUAsFieldTabMap.mapUAs.get(tab));
			
		}

		this.setCamposPropagables(fields);
	}
 
}