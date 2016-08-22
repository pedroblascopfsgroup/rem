package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import es.pfsgroup.commons.utils.Checks;

public class PropuestaPreciosExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<Map<String,String>> datos ;
	
	private String reportName;	
	private final String DEFAULT_REPORT_NAME = PROPUESTA_PRECIOS_XLS;	
	
	public static final String CAB_NUM_ACTIVO = "Nº activo";
	public static final String CAB_TIPO = "Tipo";
	public static final String CAB_SUBTIPO = "Subtipo";
	public static final String CAB_CARTERA = "Cartera";
	public static final String CAB_ORIGEN = "Origen";
	public static final String CAB_DIRECCION = "Direccion";
	public static final String CAB_MUNICIPIO = "Municipio";
	public static final String CAB_PROVINCIA = "Provincia";
	public static final String CAB_CP = "Código Postal";
	
	// Establece el orden en el que se pintaran las columnas
	private static List<String> listaCabeceras = Arrays.asList(CAB_NUM_ACTIVO,CAB_TIPO,CAB_SUBTIPO,CAB_CARTERA,CAB_ORIGEN,CAB_DIRECCION,CAB_MUNICIPIO,CAB_PROVINCIA,CAB_CP);
	
	public PropuestaPreciosExcelReport(List<Map<String,String>> datos, String reportName) {
		this.datos = datos;
		if(Checks.esNulo(reportName)) {
			this.reportName = DEFAULT_REPORT_NAME;
		} else {
			this.reportName = reportName + ".xls";
		}
	}
	
	public List<String> getCabeceras() {
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(Map<String,String> dato: datos){
			List<String> fila = new ArrayList<String>();
			
			for (String cabecera: listaCabeceras) {				
				fila.add(dato.get(cabecera));				
			}

			valores.add(fila);
		}
		
		return valores;
	}
	
	

	public String getReportName() {
		return this.reportName;
	}
	
	

}
