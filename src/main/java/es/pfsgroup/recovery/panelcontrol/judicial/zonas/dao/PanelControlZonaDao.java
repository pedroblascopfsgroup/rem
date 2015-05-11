package es.pfsgroup.recovery.panelcontrol.judicial.zonas.dao;

import java.util.List;

import es.capgemini.pfs.zona.model.DDZona;

public interface PanelControlZonaDao {
	//public List<DDZona> getListaZonas(Long nivel, Long id,Boolean subConsulta);
	//public List<DDZona> getListaZonasNivel(Long nivel, String cod,Boolean subConsulta);
	public List<DDZona> getListaZonasNivelLista(String cod);
	//public DDZona getZona( String cod);
	
	
	public List<DDZona> getListaZonasParaVista(Long nivel, String cod);
}
