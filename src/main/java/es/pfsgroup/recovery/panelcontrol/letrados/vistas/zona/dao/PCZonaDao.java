package es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.dao;

import java.util.List;

import es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.model.PCZona;

public interface PCZonaDao {

	public List<PCZona> getListaZonas(Long nivel);
	public List<PCZona> getListaZonas(Long nivel, String cod);
	public List<PCZona> getLetrados(Long nivel, String cod);
	
}
