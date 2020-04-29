package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VGridBusquedaActivos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;

public class ActivoGridExcelReport extends AbstractExcelReport implements ExcelReport {

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
	private static final String CAB_ESTADO_OCUPACION = "Estado ocupación";
	private static final String CAB_ESTADO_FISCO_ACTIVO = "Estado físico del activo";
	private static final String CAB_DPTO_ADMISION = "Dpto. Admisión";
	private static final String CAB_DPTO_GESTION = "Dtpo. Gestion";
	private static final String CAB_DPTO_CALIDAD = "Dpto. Calidad";
	private static final String CAB_RATING = "Rating";

	private List<VGridBusquedaActivos> listaActivos;	

	public ActivoGridExcelReport(List<VGridBusquedaActivos> listaActivos) {
		this.listaActivos = listaActivos;	
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
		listaCabeceras.add(CAB_ESTADO_OCUPACION);
		listaCabeceras.add(CAB_ESTADO_FISCO_ACTIVO);
		listaCabeceras.add(CAB_DPTO_ADMISION);
		listaCabeceras.add(CAB_DPTO_GESTION);
		listaCabeceras.add(CAB_DPTO_CALIDAD);
		listaCabeceras.add(CAB_RATING);

		return listaCabeceras;
	}

	public List<List<String>> getData() {	
		List<String> fila;
		List<List<String>> valores = new ArrayList<List<String>>();
		for (VGridBusquedaActivos vGridActivo : listaActivos) {
			fila = new ArrayList<String>();
			fila.add(vGridActivo.getNumActivo().toString());
			fila.add(vGridActivo.getTipoActivoDescripcion());
			fila.add(vGridActivo.getSubtipoActivoDescripcion());
			fila.add(vGridActivo.getCarteraDescripcion());
			fila.add(vGridActivo.getTipoTituloActivoDescripcion());
			fila.add(vGridActivo.getNombreVia());
			fila.add(vGridActivo.getLocalidadDescripcion());
			fila.add(vGridActivo.getProvinciaDescripcion());
			fila.add(vGridActivo.getCodPostal());
			fila.add(vGridActivo.getSituacionComercialDescripcion());			
			fila.add(getEstadoOcupacion(vGridActivo));
			fila.add(vGridActivo.getEstadoActivoDescripcion());		
			fila.add(mapeoBoolean(vGridActivo.getAdmision()));
			fila.add(mapeoBoolean(vGridActivo.getGestion()));
			fila.add(mapeoBoolean(vGridActivo.getSelloCalidad()));
			fila.add(vGridActivo.getFlagRatingDescripcion());
			valores.add(fila);			
		}
		return valores;
	}
	
	private String getEstadoOcupacion(VGridBusquedaActivos vGridActivo) {
	String valor = "";
		if(vGridActivo.getOcupado() != null) {
			if(vGridActivo.getOcupado() == 0) {
				valor = "No ocupado";			
			}else if(vGridActivo.getOcupado() == 1 && DDTipoTituloActivoTPA.tipoTituloSi.equals(vGridActivo.getConTituloCodigo())) {
				valor = vGridActivo.getTituloPosesorioDescripcion() !=null ? "Ocupado con título de " +  vGridActivo.getTituloPosesorioDescripcion() : "Ocupado con título";				
			}else if(vGridActivo.getOcupado() == 1) {
				valor = "Ocupado sin título";
			}			
		}
		return valor;
	}		

	private String mapeoBoolean(Integer dato) {
		return (dato == null || dato == 0) ? "" : "OK";
	}	

	public String getReportName() {
		return LISTA_DE_ACTIVOS_XLS;
	}

}
