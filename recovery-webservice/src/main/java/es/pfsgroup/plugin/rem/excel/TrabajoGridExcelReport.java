package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VGridBusquedaTrabajos;

public class TrabajoGridExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<VGridBusquedaTrabajos> listaTrabajos;
	
	public TrabajoGridExcelReport(List<VGridBusquedaTrabajos> listaTrabajos) {
			this.listaTrabajos = listaTrabajos;
	}
	
	@Override
	public List<String> getCabeceras() {
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº de trabajo");
		listaCabeceras.add("Nº de activo");
		listaCabeceras.add("Tipo de trabajo");
		listaCabeceras.add("Subtipo de trabajo");
		listaCabeceras.add("Estado");
		listaCabeceras.add("Solicitante");
		listaCabeceras.add("Proveedor");
		listaCabeceras.add("Fecha de petición");
		
		return listaCabeceras;
	}

	@Override
	public List<List<String>> getData() {
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VGridBusquedaTrabajos trabajo: listaTrabajos){
			List<String> fila = new ArrayList<String>();
			fila.add(trabajo.getNumTrabajo().toString());
			fila.add(trabajo.getNumActivoAgrupacion().toString());
			fila.add(trabajo.getTipoTrabajoDescripcion());
			fila.add(trabajo.getSubtipoTrabajoDescripcion());
			fila.add(trabajo.getEstadoTrabajoDescripcion());
			fila.add(trabajo.getSolicitante());
			fila.add(trabajo.getProveedor());
			fila.add(this.getDateStringValue(trabajo.getFechaSolicitud()));
				
			valores.add(fila);
		}
			
		return valores;
	}

	@Override
	public String getReportName() {
		return LISTA_DE_TRABAJOS_XLS;
	}

}
