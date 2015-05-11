package es.pfsgroup.recovery.panelcontrol.judicial.dao;

import java.util.List;

import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoPanelControl;

public interface PanelControlDao {

	public List<DtoPanelControl> getListaCompleta(Long nivel, Long id,List<DDZona> zonas);
	//public Float getSaldoNoVencidoDanyado(String cod);
	
}
