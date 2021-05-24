package es.pfsgroup.plugin.rem.excel;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VExportTrabajosAlbaranes;

public class TrabajosPrefacturaExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<VExportTrabajosAlbaranes> listaTrabajos;

	public TrabajosPrefacturaExcelReport(List<VExportTrabajosAlbaranes> listaTrabajos) {
		this.listaTrabajos = listaTrabajos;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Número de Albarán");
		listaCabeceras.add("Fecha Albarán");
		listaCabeceras.add("Estado Albarán");
		listaCabeceras.add("Número de Prefacturas");
		listaCabeceras.add("Número de Trabajos");
		listaCabeceras.add("Importe Total Albarán");
		listaCabeceras.add("Importe Total Cliente Albarán");
		listaCabeceras.add("Número Prefactura");
		listaCabeceras.add("Proveedor");
		listaCabeceras.add("Propietario");
		listaCabeceras.add("Estado Prefactura");
		listaCabeceras.add("Número Gasto");
		listaCabeceras.add("Estado Gasto");
		listaCabeceras.add("Número de Trabajos Prefactura");
		listaCabeceras.add("Importe Total Prefactura");
		listaCabeceras.add("Importe Total Cliente Prefactura");
		listaCabeceras.add("Número Trabajo");
		listaCabeceras.add("Tipo Trabajo");
		listaCabeceras.add("Subtipo Trabajo");
		listaCabeceras.add("Descripción Trabajo");
		listaCabeceras.add("Año Trabajo");
		listaCabeceras.add("Estado Trabajo");
		listaCabeceras.add("Importe Total Trabajo");
		listaCabeceras.add("Importe Total Cliente Trabajo");
		listaCabeceras.add("Área peticionaria");
		listaCabeceras.add("Cartera de Propietario");
				
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		
		for(VExportTrabajosAlbaranes trabajoAlbaranPrefactura: listaTrabajos){
			List<String> fila = new ArrayList<String>();

			if(!Checks.esNulo(trabajoAlbaranPrefactura.getNumAlbaran())) {
				fila.add(trabajoAlbaranPrefactura.getNumAlbaran().toString());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getFechaAlbaran())) {
				fila.add(formato.format(trabajoAlbaranPrefactura.getFechaAlbaran()));
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getEstadoAlbaranDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getEstadoAlbaranDescripcion());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getNumPrefacturasAlbaran())) {
				fila.add(trabajoAlbaranPrefactura.getNumPrefacturasAlbaran().toString());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getNumTrabajosAlbaran())) {
				fila.add(trabajoAlbaranPrefactura.getNumTrabajosAlbaran().toString());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getImporteTotalAlbaran())) {
				fila.add(formatearImportes(trabajoAlbaranPrefactura.getImporteTotalAlbaran()));
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getImporteTotalClienteAlbaran())) {
				fila.add(formatearImportes(trabajoAlbaranPrefactura.getImporteTotalClienteAlbaran()));
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getNumPrefactura())) {
				fila.add(trabajoAlbaranPrefactura.getNumPrefactura().toString());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getProveedor())) {
				fila.add(trabajoAlbaranPrefactura.getProveedor());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getPropietario())) {
				fila.add(trabajoAlbaranPrefactura.getPropietario());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getEstadoPrefacturaDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getEstadoPrefacturaDescripcion());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getNumGastoHaya())) {
				fila.add(trabajoAlbaranPrefactura.getNumGastoHaya());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getEstadoGastoDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getEstadoGastoDescripcion());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getNumTrabajosPrefactura())) {
				fila.add(trabajoAlbaranPrefactura.getNumTrabajosPrefactura().toString());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getImporteTotalPrefactura())) {
				fila.add(formatearImportes(trabajoAlbaranPrefactura.getImporteTotalPrefactura()));
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getImporteTotalClientePrefactura())) {
				fila.add(formatearImportes(trabajoAlbaranPrefactura.getImporteTotalClientePrefactura()));
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getNumTrabajo())) {
				fila.add(trabajoAlbaranPrefactura.getNumTrabajo().toString());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getTipoTrabajoDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getTipoTrabajoDescripcion());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getSubtipoTrabajoDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getSubtipoTrabajoDescripcion());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getDescripcionTrabajo())) {
				fila.add(trabajoAlbaranPrefactura.getDescripcionTrabajo());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getAnyoTrabajo())) {
				fila.add(trabajoAlbaranPrefactura.getAnyoTrabajo());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getEstadoTrabajoDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getEstadoTrabajoDescripcion());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getImporteTotalTrabajo())) {
				fila.add(formatearImportes(trabajoAlbaranPrefactura.getImporteTotalTrabajo()));
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getImporteTotalClienteTrabajo())) {
				fila.add(formatearImportes(trabajoAlbaranPrefactura.getImporteTotalClienteTrabajo()));
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getAreaPeticionariaDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getAreaPeticionariaDescripcion());
			} else {
				fila.add("");
			}
			if(!Checks.esNulo(trabajoAlbaranPrefactura.getCarteraPropietarioDescripcion())) {
				fila.add(trabajoAlbaranPrefactura.getCarteraPropietarioDescripcion());
			} else {
				fila.add("");
			}

			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_TRABAJOS_DE_PREFACTURA_XLS;
	}
	
	private String formatearImportes(Double importe) {
		Locale currentLocale = new Locale ("es","ES");
		NumberFormat numberFormatter = NumberFormat.getNumberInstance(currentLocale);
		String importeFormateado =  numberFormatter.format(importe);
		return importeFormateado.concat("€");
		
	}

}
