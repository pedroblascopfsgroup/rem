package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VBusquedaProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaPublicacionActivo;


public class ProveedorExcelReport extends AbstractExcelReport implements ExcelReport {
	private static final String CAB_NUM_ACTIVO = "ID Proveedor";
	private static final String CAB_TIPO = "Tipo";
	private static final String CAB_SUBTIPO = "Subtipo";
	private static final String CAB_NIF = "NIF";
	private static final String CAB_NOMBRE = "Nombre";
	private static final String CAB_NOMBRE_COMERCIAL = "Nombre Comercial";
	private static final String CAB_ESTADO = "Estado";
	private static final String CAB_OBSERVACIONES = "Observaciones";
	private List<VBusquedaProveedor> listaProveedores;

	
	public ProveedorExcelReport(List<VBusquedaProveedor> listaProveedores) {
		this.listaProveedores = listaProveedores;
	}
		

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_ACTIVO);
		listaCabeceras.add(CAB_TIPO);
		listaCabeceras.add(CAB_SUBTIPO);
		listaCabeceras.add(CAB_NIF);
		listaCabeceras.add(CAB_NOMBRE);
		listaCabeceras.add(CAB_NOMBRE_COMERCIAL);
		listaCabeceras.add(CAB_ESTADO);
		listaCabeceras.add(CAB_OBSERVACIONES);

		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaProveedor proveedor: listaProveedores){
			List<String> fila = new ArrayList<String>();
			fila.add(String.valueOf(proveedor.getId()));
			fila.add(proveedor.getTipoProveedorDescripcion());
			fila.add(proveedor.getSubtipoProveedorDescripcion());
			fila.add(proveedor.getNifProveedor());
			fila.add(proveedor.getNombreProveedor());
			fila.add(proveedor.getNombreComercialProveedor());
			fila.add(proveedor.getEstadoProveedorDescripcion());
			fila.add(proveedor.getObservaciones());
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return AbstractExcelReport.LISTA_DE_PROVEEDORES_XLS;
	}
}
