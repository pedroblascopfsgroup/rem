package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.model.VBusquedaActivos;


public class ActivoExcelReport extends AbstractExcelReport implements ExcelReport {

	private static final String CAB_NUM_ACTIVO = "Nº activo";
	private static final String CAB_TIPO = "Tipo";
	private static final String CAB_SUBTIPO = "Subtipo";
	private static final String CAB_CARTERA = "Cartera";
	private static final String CAB_ORIGEN = "Origen";
	private static final String CAB_VIA = "Via";
	private static final String CAB_MUNICIPIO = "Municipio";
	private static final String CAB_PROVINCIA = "Provincia";
	private static final String CAB_CP = "Código Postal";
	private static final String CAB_DPTO_COMERCIAL = "Dpto. Comercial";
	private static final String CAB_DPTO_ADMISION = "Dpto. Admisión";
	private static final String CAB_DPTO_GESTION = "Dtpo. Gestion";
	private static final String CAB_DPTO_CALIDAD = "Dpto. Calidad";
	private static final String CAB_RATING = "Rating";
	
	private List<VBusquedaActivos> listaActivos;
	
	private Map<String,String> mapRating;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	public ActivoExcelReport(List<VBusquedaActivos> listaActivos, Map<String,String> mapRating) {
		this.listaActivos = listaActivos;
		this.mapRating = mapRating;
	}
		

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_ACTIVO);
		listaCabeceras.add(CAB_TIPO);
		listaCabeceras.add(CAB_SUBTIPO);
		listaCabeceras.add(CAB_CARTERA);
		listaCabeceras.add(CAB_ORIGEN);
		listaCabeceras.add(CAB_VIA);
		listaCabeceras.add(CAB_MUNICIPIO);
		listaCabeceras.add(CAB_PROVINCIA);
		listaCabeceras.add(CAB_CP);
		listaCabeceras.add(CAB_DPTO_COMERCIAL);
		listaCabeceras.add(CAB_DPTO_ADMISION);
		listaCabeceras.add(CAB_DPTO_GESTION);
		listaCabeceras.add(CAB_DPTO_CALIDAD);
		listaCabeceras.add(CAB_RATING);

		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaActivos activo: listaActivos){
			List<String> fila = new ArrayList<String>();
			fila.add(activo.getNumActivo());
			fila.add(activo.getTipoActivoDescripcion());
			fila.add(activo.getSubtipoActivoDescripcion());
			fila.add(activo.getEntidadPropietariaDescripcion());
			fila.add(activo.getTipoTituloActivoDescripcion());
			fila.add(activo.getNombreVia());
			fila.add(activo.getLocalidadDescripcion());
			fila.add(activo.getProvinciaDescripcion());
			fila.add(activo.getCodPostal());
			fila.add(activo.getSituacionComercial());
			fila.add(mapeoString(activo.getAdmision()));
			fila.add(mapeoString(activo.getGestion()));
			fila.add(mapeoCalidad(activo.getSelloCalidad()));
			fila.add(mapRating.get(activo.getFlagRating()));
			valores.add(fila);
		}
		
		return valores;
	}
	
	private String mapeoString(Boolean dato){
		return (dato == null) ? null : dato ? "OK" : "KO";
	}
	
	private String mapeoCalidad(Boolean dato){
		return (dato == null) ? null : dato ? "OK" : "";
	}


	public String getReportName() {
		return LISTA_DE_ACTIVOS_XLS;
	}
	

}
