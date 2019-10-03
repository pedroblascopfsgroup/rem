package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;

public class PlantillaDistribucionPrecios extends AbstractExcelReport implements ExcelReport {
	
	private List<DtoActivosExpediente> listaActivos;
	private Long numExpediente;

	public PlantillaDistribucionPrecios(List<DtoActivosExpediente> listaActivos,  Long numExpediente) {
		this.listaActivos = listaActivos;
		this.numExpediente = numExpediente;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Numero Expediente Comercial");
		listaCabeceras.add("Numero Activo");
		listaCabeceras.add("Importe Participacion");
						
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(DtoActivosExpediente activosGasto: listaActivos){
			List<String> fila = new ArrayList<String>();
			
			fila.add(this.numExpediente.toString());
			fila.add(activosGasto.getNumActivo().toString());
			if(!Checks.esNulo(activosGasto.getImporteParticipacion())) {
				fila.add(activosGasto.getImporteParticipacion().toString());
			}else {
				fila.add("");
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return CARGA_DISTRIBUCION_PRECIOS_XLS;
	}
	
}
