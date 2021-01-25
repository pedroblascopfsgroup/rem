package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoParticipa;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;

public class ActivosTrabajoExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<VBusquedaActivosTrabajoParticipa> listaActivos;

	public ActivosTrabajoExcelReport(List<VBusquedaActivosTrabajoParticipa> listaActivos) {
		this.listaActivos = listaActivos;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº activo");
		listaCabeceras.add("Tipo");
		listaCabeceras.add("Último trabajo");
		listaCabeceras.add("Fecha");
		listaCabeceras.add("Estado");
				
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaActivosTrabajoParticipa activosTrabajo: listaActivos){
			List<String> fila = new ArrayList<String>();
			
			fila.add(activosTrabajo.getNumActivo().toString());
			
			if(activosTrabajo.getTipoActivoDescripcion() != null) {
				fila.add(activosTrabajo.getTipoActivoDescripcion());
			}
			
			if(activosTrabajo.getUltimoTrabajo() != null) {
				fila.add(activosTrabajo.getUltimoTrabajo());
			}
			
			if(activosTrabajo.getFecha() != null) {
				fila.add(activosTrabajo.getFecha());
			}
			
			if(activosTrabajo.getDescripcionEstado() != null) {
				fila.add(activosTrabajo.getDescripcionEstado());
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_ACTIVOS_DE_TRABAJOS_XLS;
	}
	
	

}
