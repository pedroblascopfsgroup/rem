package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VBusquedaAgrupaciones;

public class AgrupacionExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<VBusquedaAgrupaciones> listaAgrupaciones;

	public AgrupacionExcelReport(List<VBusquedaAgrupaciones> listaAgrupaciones) {
		this.listaAgrupaciones = listaAgrupaciones;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº agrupación");
		listaCabeceras.add("Tipo de agrupación");
		listaCabeceras.add("Nombre");
		listaCabeceras.add("Descripción");
		listaCabeceras.add("Provincia");
		listaCabeceras.add("Municipio");
		listaCabeceras.add("Dirección");
		listaCabeceras.add("Fecha de alta");
		listaCabeceras.add("Fecha de baja");
		listaCabeceras.add("Número de activos incluidos");
		listaCabeceras.add("Número de activos publicados");
		
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaAgrupaciones agrupacion: listaAgrupaciones){
			List<String> fila = new ArrayList<String>();
			fila.add(agrupacion.getNumAgrupacionRem());
			fila.add(this.getDictionaryValue(agrupacion.getTipoAgrupacion()));
			fila.add(agrupacion.getNombre());
			fila.add(agrupacion.getDescripcion());
			fila.add(this.getDictionaryValue(agrupacion.getProvincia()));
			
			if (agrupacion.getLocalidad() != null){
				fila.add(agrupacion.getLocalidad().getDescripcion());
			}else{
				fila.add("");
			}
			
			fila.add(agrupacion.getDireccion());
			fila.add(this.getDateStringValue(agrupacion.getFechaAlta()));
			fila.add(this.getDateStringValue(agrupacion.getFechaBaja()));
			fila.add(agrupacion.getActivos());
			fila.add(agrupacion.getPublicados());

			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_AGRUPACIONES_XLS;
	}
	
	

}
