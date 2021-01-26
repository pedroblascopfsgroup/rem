package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VBusquedaPublicacionActivo;


public class PublicacionExcelReport extends AbstractExcelReport implements ExcelReport {
	private static final String CAB_NUM_ACTIVO = "Nº activo";
	private static final String CAB_TIPO = "Tipo";
	private static final String CAB_SUBTIPO = "Subtipo";
	private static final String CAB_CARTERA = "Cartera";
	private static final String CAB_DIRECCION = "Dirección";
	private static final String CAB_ESTADO_PUBLICACION = "Estado publicacion";
	private static final String CAB_DPTO_ADMISION = "Dpto. Admisión";
	private static final String CAB_DPTO_GESTION = "Dtpo. Gestion";
	private static final String CAB_DPTO_PUBLICACION = "Dpto. Publicación";
	private static final String CAB_PRECIO = "Precio";
	private List<VBusquedaPublicacionActivo> listaPublicacionActivos;

	
	public PublicacionExcelReport(List<VBusquedaPublicacionActivo> listaActivos) {
		this.listaPublicacionActivos = listaActivos;
	}
		

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_ACTIVO);
		listaCabeceras.add(CAB_TIPO);
		listaCabeceras.add(CAB_SUBTIPO);
		listaCabeceras.add(CAB_CARTERA);
		listaCabeceras.add(CAB_DIRECCION);
		listaCabeceras.add(CAB_ESTADO_PUBLICACION);
		listaCabeceras.add(CAB_DPTO_ADMISION);
		listaCabeceras.add(CAB_DPTO_GESTION);
		listaCabeceras.add(CAB_DPTO_PUBLICACION);
		listaCabeceras.add(CAB_PRECIO);

		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaPublicacionActivo publicacion: listaPublicacionActivos){
			List<String> fila = new ArrayList<String>();
			fila.add(publicacion.getNumActivo());
			fila.add(publicacion.getTipoActivoDescripcion());
			fila.add(publicacion.getSubtipoActivoDescripcion());
			fila.add(publicacion.getCartera());
			fila.add(publicacion.getDireccion());
			fila.add(publicacion.getEstadoPublicacionDescripcion());
			fila.add(mapeoBoolean(publicacion.getAdmision()));
			fila.add(mapeoBoolean(publicacion.getGestion()));
			fila.add(mapeoBoolean(publicacion.getPublicacion()));
			fila.add(mapeoBoolean(publicacion.getPrecio()));
			valores.add(fila);
		}
		
		return valores;
	}
	
	private String mapeoYesNo(Boolean dato){
		return (dato == null) ? null : dato ? "Si" : "No";
	}
	
	private String mapeoBoolean(Boolean dato){
		return (dato == null) ? null : dato ? "OK" : "KO";
	}

	public String getReportName() {
		return AbstractExcelReport.LISTA_DE_PUBLICACION_XLS;
	}
}
