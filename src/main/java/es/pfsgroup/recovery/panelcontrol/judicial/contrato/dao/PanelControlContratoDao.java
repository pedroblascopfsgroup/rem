package es.pfsgroup.recovery.panelcontrol.judicial.contrato.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoDetallePanelControl;

public interface PanelControlContratoDao {

	//public int getTotalContratos(Long nivel, Long idNivel);
	
	public Page getListaContratos(DtoDetallePanelControl dto);
	
	//public int getTotalContratosIrregulares(Long nivel, Long idNivel);
	
	public Page getListaContratosIregulares(DtoDetallePanelControl dto,List<DDZona> listaZonas);
}
