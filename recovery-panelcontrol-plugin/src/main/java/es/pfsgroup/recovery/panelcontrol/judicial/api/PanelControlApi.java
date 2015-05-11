package es.pfsgroup.recovery.panelcontrol.judicial.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoDetallePanelControl;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoPanelControl;

public interface PanelControlApi {
	public static final String PANEL_CONTROL_GET_NIVELES = "plugin.panelcontrol.getNiveles";
	public static final String PANEL_CONTROL_GET_DATOS_POR_JERARQUIA = "plugin.panelcontrol.getDatosPorJerarquia";
	public static final String GET_CONTRATOS_PANEL_CONTROL = "plugin.panelcontrol.getContratosPanelControl";
	public static final String GET_CLIENTES_PANEL_CONTROL = "plugin.panelcontrol.getClientesPanelControl";
	public static final String GET_TAREAS_PANEL_CONTROL = "plugin.panelcontrol.getTareasPanelControl";
	
	@BusinessOperationDefinition(PANEL_CONTROL_GET_NIVELES)
	public List<Nivel> getDDNiveles();
	
	@BusinessOperationDefinition(PANEL_CONTROL_GET_DATOS_POR_JERARQUIA)
	public List<DtoPanelControl> getDatosPorJerarquia(Long nivel,Long id,String cod,Boolean subConsulta);
	
	@BusinessOperationDefinition(GET_CONTRATOS_PANEL_CONTROL)
	public Page getContratosPanelControl(DtoDetallePanelControl dto);
	
	@BusinessOperationDefinition(GET_CLIENTES_PANEL_CONTROL)
	public Page getClientesPanelControl(DtoDetallePanelControl dto);
	
	@BusinessOperationDefinition(GET_TAREAS_PANEL_CONTROL)
	public Page getTareasPendientesPanelControl(DtoDetallePanelControl dto);
	
	

}
