package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;

public class ActivosGastoExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<VBusquedaGastoActivo> listaActivos;

	public ActivosGastoExcelReport(List<VBusquedaGastoActivo> listaActivos) {
		this.listaActivos = listaActivos;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("ID activo");
		listaCabeceras.add("Referencia catastral");
		listaCabeceras.add("Subtipo activo");
		listaCabeceras.add("Dirección");
		listaCabeceras.add("% participación gasto");
		listaCabeceras.add("Importe proporcional total");
				
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaGastoActivo activosGasto: listaActivos){
			List<String> fila = new ArrayList<String>();
			
			fila.add(activosGasto.getNumActivo().toString());
			if(!Checks.esNulo(activosGasto.getReferenciaCatastral())) {
				fila.add(activosGasto.getReferenciaCatastral());
			}else {
				fila.add("");
			}
			if(!Checks.esNulo(activosGasto.getSubtipoDescripcion())) {
				fila.add(activosGasto.getSubtipoDescripcion());
			}else {
				fila.add("");
			}
			if(!Checks.esNulo(activosGasto.getDireccion())) {
				fila.add(activosGasto.getDireccion());
			}else {
				fila.add("");
			}
			if(!Checks.esNulo(activosGasto.getParticipacion())) {
				fila.add(activosGasto.getParticipacion().toString());
			}else {
				fila.add("");
			}
			if(!Checks.esNulo(activosGasto.getImporteProporcinalTotal())) {
				fila.add(activosGasto.getImporteProporcinalTotal().toString());
			}else {
				fila.add("");
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_ACTIVOS_DE_GASTOS_XLS;
	}
	
	

}
