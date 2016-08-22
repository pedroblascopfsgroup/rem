package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;

public class TareaExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<DtoResultadoBusquedaTareasBuzones> listaTareas;

	public TareaExcelReport(List<DtoResultadoBusquedaTareasBuzones> listaTareas) {
		this.listaTareas = listaTareas;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº activo");
		listaCabeceras.add("Tarea");
		listaCabeceras.add("Nº trámite");
		listaCabeceras.add("Tipo de trámite");
		listaCabeceras.add("Responsable");
		listaCabeceras.add("Fecha inicio");
		listaCabeceras.add("Fecha vencimiento");
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(DtoResultadoBusquedaTareasBuzones tarea: listaTareas){
			List<String> fila = new ArrayList<String>();
			fila.add(tarea.getCodEntidad()); //Nº activo
			fila.add(tarea.getNombreTarea()); //Tarea
			fila.add(tarea.getContrato()); //Nº trámite
			fila.add(tarea.getDescripcionEntidad()); //Tipo de trámite
			fila.add(tarea.getGestor());//Reponsable
			fila.add(tarea.getFechaInicio().toString());
			fila.add(tarea.getFechaVenc().toString());
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_TAREAS_XLS;
	}
	
	

}
