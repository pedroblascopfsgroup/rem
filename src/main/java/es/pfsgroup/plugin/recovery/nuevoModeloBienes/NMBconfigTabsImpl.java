package es.pfsgroup.plugin.recovery.nuevoModeloBienes;

import java.io.Serializable;
import java.util.Map;

import es.capgemini.devon.bo.annotations.BusinessOperation;
/**
 * Contiene los tabs seg�n el tipo de bien.
 * La configuraci�n se carga mediante fichero xml.
 * 
 * @author carlos
 *
 */
public class NMBconfigTabsImpl implements NMBconfigTabs, Serializable {
	
	private static final long serialVersionUID = 6181409949938789726L;

	private Map<String, NMBconfigTabsTipoBien> mapaTabsTipoBien;

	@Override
	public Map<String, NMBconfigTabsTipoBien> getMapaTabsTipoBien() {
		return mapaTabsTipoBien;
	}

	public void setMapaTabsTipoBien(Map<String, NMBconfigTabsTipoBien> mapaTabsTipoBien) {
		this.mapaTabsTipoBien = mapaTabsTipoBien;
	}


}
