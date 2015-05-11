package es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTarea.dao;

import java.util.List;

import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoCampanya;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoDetallePanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlFiltros;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlLetrados;

public interface PCExpedienteTareaDao {

	public List<String> getLetrados(String cod);
	public List<String> getTodosLetrados();
	public List<Object[]> getExpedientes(DtoDetallePanelControlLetrados dto);
	public List<Object[]> getTareasPendientes(DtoDetallePanelControlLetrados dto,boolean letrado,String rango);
	public Long totalTareasPendientes(String cod, String rango,DtoPanelControlFiltros dto);
	public Float getImporteExpedientes(String cod, DtoPanelControlFiltros dto);
	public Long getNumeroExpedientes(String cod, DtoPanelControlFiltros dto);
	public List<String> getCampanyas();
	public List<String> getLetradoGestor();
	public Long getNumeroExpedientesPorLetrado(String idLetrado,DtoPanelControlFiltros dtoFiltros);
	public Float getImporteExpedientesPorLetrado(String idLetrado,DtoPanelControlFiltros dtoFiltros);
	public Long totalTareasPendientesPorLetrado(String rango, String idLetrado,DtoPanelControlFiltros dtoFiltros);
	public List<String> getCarteras();
	public List<String> getLotes(String cartera);
	public Float getImportePorTareas(String cod, String rango,
			DtoPanelControlFiltros dto);
	
	public List<String> getCodigosTipoProcedimiento();
	public List<String> getListaLotes();

}
