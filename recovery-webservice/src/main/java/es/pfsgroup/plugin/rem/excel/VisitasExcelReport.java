package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;

public class VisitasExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<DtoVisitasFilter> listaVisitas;

	public VisitasExcelReport(List<DtoVisitasFilter> listaVisitas) {
		this.listaVisitas = listaVisitas;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº Visita");
		listaCabeceras.add("Nº Activo");
		listaCabeceras.add("Fecha Solicitud");
		listaCabeceras.add("Nombre");
		listaCabeceras.add("Nº Documento");
		listaCabeceras.add("Fecha Visita");
		
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(DtoVisitasFilter visita: listaVisitas){
			List<String> fila = new ArrayList<String>();
			fila.add(visita.getNumVisitaRem().toString());
			fila.add(visita.getNumActivo().toString());
			fila.add(this.getDateStringValue(visita.getFechaSolicitud()));
			fila.add(visita.getNombre());
			fila.add(visita.getNumDocumento());
			fila.add(this.getDateStringValue(visita.getFechaVisita()));

			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_VISITAS_XLS;
	}
	
	

}
