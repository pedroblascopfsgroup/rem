package es.pfsgroup.recovery.panelcontrol.judicial.cliente.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoDetallePanelControl;

public interface PanelControlClienteDao {

	
	
	public Page getListaClientes(DtoDetallePanelControl dto,List<DDZona> listaZonas);
}
