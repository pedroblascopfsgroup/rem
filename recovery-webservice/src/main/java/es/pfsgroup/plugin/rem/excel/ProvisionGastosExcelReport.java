package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastos;

public class ProvisionGastosExcelReport extends AbstractExcelReport implements ExcelReport {
	private static final String CAB_NUM_AGRUPACION = "Nº Agrupación";
	private static final String CAB_ESTADO = "Estado";
	private static final String CAB_NOMBRE_GESTORIA = "Gestoría responsable";
	private static final String CAB_NIF_PROPIETARIO = "Nif propietario";
	private static final String CAB_NOM_PROPIETARIO = "Nombre propietario";
	private static final String CAB_CARTERA = "Cartera";
	private static final String CAB_IMPORTE_TOTAL = "Importe total";
	private static final String CAB_FECHA_ALTA = "Fecha Alta";
	private static final String CAB_FECHA_ENVIO = "Fecha Envío";
	private static final String CAB_FECHA_RESPUESTA = "Fecha Respuesta";
	private List<DtoProvisionGastos> listaProvisionGastos;

	public ProvisionGastosExcelReport(List<DtoProvisionGastos> listaProvisionGastos2) {
		this.listaProvisionGastos = listaProvisionGastos2;
	}

	public List<String> getCabeceras() {

		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_AGRUPACION);
		listaCabeceras.add(CAB_ESTADO);
		listaCabeceras.add(CAB_NOMBRE_GESTORIA);
		listaCabeceras.add(CAB_NIF_PROPIETARIO);
		listaCabeceras.add(CAB_NOM_PROPIETARIO);
		listaCabeceras.add(CAB_CARTERA);
		listaCabeceras.add(CAB_IMPORTE_TOTAL);		
		listaCabeceras.add(CAB_FECHA_ALTA);
		listaCabeceras.add(CAB_FECHA_ENVIO);
		listaCabeceras.add(CAB_FECHA_RESPUESTA);

		return listaCabeceras;
	}

	public List<List<String>> getData() {

		List<List<String>> valores = new ArrayList<List<String>>();

		for (DtoProvisionGastos provision : listaProvisionGastos) {
			List<String> fila = new ArrayList<String>();
			fila.add(String.valueOf(provision.getNumProvision()));
			fila.add(provision.getEstadoProvisionDescripcion());
			fila.add(provision.getNombreProveedor());
			fila.add(provision.getNifPropietario());
			fila.add(provision.getNomPropietario());
			fila.add(provision.getDescCartera());
			fila.add(Checks.esNulo(provision.getImporteTotal()) ? "" : provision.getImporteTotal().toString());
			fila.add(Checks.esNulo(provision.getFechaAlta()) ? "" : provision.getFechaAlta().toString());
			fila.add(Checks.esNulo(provision.getFechaEnvio()) ? "" : provision.getFechaEnvio().toString());
			fila.add(Checks.esNulo(provision.getFechaRespuesta()) ? "" : provision.getFechaRespuesta().toString());

			valores.add(fila);
		}

		return valores;
	}

	public String getReportName() {
		return AbstractExcelReport.LISTA_DE_PROVISION_GASTOS_XLS;
	}
}
