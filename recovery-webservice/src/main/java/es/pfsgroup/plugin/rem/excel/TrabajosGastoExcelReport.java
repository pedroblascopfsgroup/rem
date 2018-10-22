package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;

public class TrabajosGastoExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<VBusquedaGastoTrabajos> listaTrabajos;

	public TrabajosGastoExcelReport(List<VBusquedaGastoTrabajos> listaTrabajos) {
		this.listaTrabajos = listaTrabajos;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Num Trabajo");
		listaCabeceras.add("Subtipo");
		listaCabeceras.add("Fecha ejecutado");
		listaCabeceras.add("Cubierto por seguro");
		listaCabeceras.add("Importe total");
				
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaGastoTrabajos trabajosGasto: listaTrabajos){
			List<String> fila = new ArrayList<String>();
			
			fila.add(trabajosGasto.getNumTrabajo());
			if(!Checks.esNulo(trabajosGasto.getDescripcionSubtipo())) {
				fila.add(trabajosGasto.getDescripcionSubtipo());
			}else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajosGasto.getFechaEjecutado())) {
				fila.add(df.format(trabajosGasto.getFechaEjecutado()));
			}else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajosGasto.getCubreSeguro())) {
				fila.add(trabajosGasto.getCubreSeguro() == 1 ? "Si" : "No");
			}else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajosGasto.getImporteTotal())) {
				fila.add(trabajosGasto.getImporteTotal().toString());
			}else {
				fila.add("");
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_TRABAJOS_DE_GASTOS_XLS;
	}
	
	

}
