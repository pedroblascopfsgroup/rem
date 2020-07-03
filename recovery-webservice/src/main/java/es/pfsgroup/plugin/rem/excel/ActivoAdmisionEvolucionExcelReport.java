package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoActivoAdmisionEvolucion;

public class ActivoAdmisionEvolucionExcelReport extends AbstractExcelReport implements ExcelReport {

	private static final String CAB_ESTADO = "ESTADO";
	private static final String CAB_SUBESTADO = "SUBESTADO";
	private static final String CAB_FECHA = "FECHA";
	private static final String CAB_OBSERVACIONES = "OBSERVACIONES";
	private static final String CAB_GESTOR = "GESTOR";

	private List<DtoActivoAdmisionEvolucion> listaActivoAdmisionEvolucion;
	private String numActivo;

	public ActivoAdmisionEvolucionExcelReport(String numActivo, List<DtoActivoAdmisionEvolucion> listaActivoAdmisionEvolucion) {
		this.numActivo = numActivo;
		this.listaActivoAdmisionEvolucion = listaActivoAdmisionEvolucion;	
	}

	public List<String> getCabeceras() {
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_ESTADO);
		listaCabeceras.add(CAB_SUBESTADO);
		listaCabeceras.add(CAB_FECHA);
		listaCabeceras.add(CAB_OBSERVACIONES);
		listaCabeceras.add(CAB_GESTOR);

		return listaCabeceras;
	}

	public List<List<String>> getData() {	
		List<String> fila;
		List<List<String>> valores = new ArrayList<List<String>>();
		for (DtoActivoAdmisionEvolucion actAdmEvo : listaActivoAdmisionEvolucion) {
			fila = new ArrayList<String>();
			fila.add(actAdmEvo.getEstadoEvolucion());
			fila.add(actAdmEvo.getSubestadoEvolucion());
			fila.add(actAdmEvo.getFechaEvolucion().substring(8, 10)+"/"+actAdmEvo.getFechaEvolucion().substring(5, 7)+"/"+actAdmEvo.getFechaEvolucion().substring(0, 4));
			fila.add(actAdmEvo.getObservacionesEvolucion());
			fila.add(actAdmEvo.getGestorEvolucion());
			valores.add(fila);
		}
		return valores;
	}

	public String getReportName() {
		String listaEvolucionAdmision = LISTA_EVOLUCION_ADMISION_ACTIVO;
		String nombre = listaEvolucionAdmision.substring(0, listaEvolucionAdmision.length()-4)+"_";
		String extension = listaEvolucionAdmision.substring(listaEvolucionAdmision.length()-4, listaEvolucionAdmision.length());
		return nombre+numActivo+extension;
	}

}

