package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VBusquedaTrabajos;

public class TrabajoExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<VBusquedaTrabajos> listaTrabajos;

	public TrabajoExcelReport(List<VBusquedaTrabajos> listaTrabajos2) {
		this.listaTrabajos = listaTrabajos2;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReport#getCabeceras()
	 */
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

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReport#getData()
	 */
	@Override
	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaTrabajos trabajo: listaTrabajos){
			List<String> fila = new ArrayList<String>();
			fila.add(trabajo.getNumTrabajo());
			fila.add(trabajo.getNumActivo().toString());
			fila.add(trabajo.getDescripcionTipo());
			fila.add(trabajo.getDescripcionSubtipo());
			fila.add(trabajo.getDescripcionEstado());
			fila.add(trabajo.getSolicitante());
			fila.add(trabajo.getProveedor());
			fila.add(this.getDateStringValue(trabajo.getFechaSolicitud()));
			
			valores.add(fila);
		}
		
		return valores;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReport#getReportName()
	 */
	@Override
	public String getReportName() {
		return LISTA_DE_TRABAJOS_XLS;
	}
	
	

}
