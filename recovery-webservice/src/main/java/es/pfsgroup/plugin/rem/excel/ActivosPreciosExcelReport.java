package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;


public class ActivosPreciosExcelReport extends AbstractExcelReport implements ExcelReport {

	private static final String CAB_NUM_ACTIVO = "Nº activo";
	private static final String CAB_TIPO = "Tipo";
	private static final String CAB_SUBTIPO = "Subtipo";
	private static final String CAB_CARTERA = "Cartera";
	private static final String CAB_ORIGEN = "Origen";
	private static final String CAB_DIRECCION = "Direccion";
	private static final String CAB_MUNICIPIO = "Municipio";
	private static final String CAB_PROVINCIA = "Provincia";
	private static final String CAB_CP = "Código Postal";
	
	private List<VBusquedaActivosPrecios> listaActivos;
	
	public ActivosPreciosExcelReport(List<VBusquedaActivosPrecios> listaActivos) {
		this.listaActivos = listaActivos;
	}
		

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_ACTIVO);
		listaCabeceras.add(CAB_TIPO);
		listaCabeceras.add(CAB_SUBTIPO);
		listaCabeceras.add(CAB_CARTERA);
		listaCabeceras.add(CAB_ORIGEN);
		listaCabeceras.add(CAB_DIRECCION);
		listaCabeceras.add(CAB_MUNICIPIO);
		listaCabeceras.add(CAB_PROVINCIA);
		listaCabeceras.add(CAB_CP);

		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaActivosPrecios activo: listaActivos){
			List<String> fila = new ArrayList<String>();
			fila.add(activo.getNumActivo());
			fila.add(activo.getTipoActivoDescripcion());
			fila.add(activo.getSubtipoActivoDescripcion());
			fila.add(activo.getEntidadPropietariaDescripcion());
			fila.add(activo.getTipoTituloActivoDescripcion());
			fila.add(activo.getDireccion());
			fila.add(activo.getMunicipio());
			fila.add(activo.getProvincia());
			fila.add(activo.getCodigoPostal());
			valores.add(fila);
		}
		
		return valores;
	}


	public String getReportName() {
		return LISTA_DE_ACTIVOS_PRECIOS_XLS;
	}
	

}
