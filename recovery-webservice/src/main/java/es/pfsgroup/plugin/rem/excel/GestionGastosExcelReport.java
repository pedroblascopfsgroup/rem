package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;

public class GestionGastosExcelReport extends AbstractExcelReport implements ExcelReport {
	private static final String CAB_NUM_GASTO = "Nº Gasto";
	private static final String CAB_NUM_FACTURA_LUQUIDACION = "Nº Factura/Liquidación";
	private static final String CAB_TIPO = "Tipo";
	private static final String CAB_SUBTIPO = "Subtipo";
	private static final String CAB_CONCEPTO = "Concepto";
	private static final String CAB_NUM_PROVEEDOR = "Nº Proveedor";
	private static final String CAB_PROVEEDOR = "Proveedor";
	private static final String CAB_FECHA_EMISION_DEVENGO = "Fecha Emisión/Devengo";
	private static final String CAB_IMPORTE_TOTAL = "Importe Total";
	private static final String CAB_FECHA_TOPE_PAGO = "Fecha Tope Pago";
	private static final String CAB_FECHA_PAGO = "Fecha Pago";
	private static final String CAB_PERIODICIDAD = "Periodicidad";
	private static final String CAB_DESTINATARIO = "Destinatario";
	private static final String CAB_ESTADO = "Estado";
	private static final String CAB_SUJETO_IMPUESTO_INDIRECTO = "Sujeto Impuesto Indirecto";
	private static final String CAB_NOMBRE_GESTORIA = "Nombre Gestoría";
	private static final String CAB_CARTERA = "Cartera";
	private List<VGastosProveedor> listaGastosProveedor;

	public GestionGastosExcelReport(List<VGastosProveedor> listaGastosProveedor2) {
		this.listaGastosProveedor = listaGastosProveedor2;
	}

	public List<String> getCabeceras() {

		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_GASTO);
		listaCabeceras.add(CAB_NUM_FACTURA_LUQUIDACION);
		listaCabeceras.add(CAB_TIPO);
		listaCabeceras.add(CAB_SUBTIPO);
		listaCabeceras.add(CAB_CONCEPTO);
		listaCabeceras.add(CAB_NUM_PROVEEDOR);
		listaCabeceras.add(CAB_PROVEEDOR);
		listaCabeceras.add(CAB_FECHA_EMISION_DEVENGO);
		listaCabeceras.add(CAB_IMPORTE_TOTAL);
		listaCabeceras.add(CAB_FECHA_TOPE_PAGO);
		listaCabeceras.add(CAB_FECHA_PAGO);
		listaCabeceras.add(CAB_PERIODICIDAD);
		listaCabeceras.add(CAB_DESTINATARIO);
		listaCabeceras.add(CAB_ESTADO);
		listaCabeceras.add(CAB_SUJETO_IMPUESTO_INDIRECTO);
		listaCabeceras.add(CAB_NOMBRE_GESTORIA);
		listaCabeceras.add(CAB_CARTERA);

		return listaCabeceras;
	}

	public List<List<String>> getData() {

		List<List<String>> valores = new ArrayList<List<String>>();

		for (VGastosProveedor gastoProveedor : listaGastosProveedor) {
			List<String> fila = new ArrayList<String>();
			fila.add(String.valueOf(gastoProveedor.getNumGastoHaya()));
			fila.add(gastoProveedor.getNumFactura());
			fila.add(gastoProveedor.getTipoDescripcion());
			fila.add(gastoProveedor.getSubtipoDescripcion());
			fila.add(gastoProveedor.getConcepto());
			fila.add(gastoProveedor.getCodigoProveedorRem());
			fila.add(gastoProveedor.getNombreProveedor());
			fila.add(Checks.esNulo(gastoProveedor.getFechaEmision()) ? "" : gastoProveedor.getFechaEmision().toString());
			fila.add(String.valueOf(gastoProveedor.getImporteTotal()));
			fila.add(Checks.esNulo(gastoProveedor.getFechaTopePago()) ? "" : gastoProveedor.getFechaTopePago().toString());
			fila.add(Checks.esNulo(gastoProveedor.getFechaPago()) ? "" : gastoProveedor.getFechaPago().toString());
			fila.add(gastoProveedor.getPeriodicidadDescripcion());
			fila.add(gastoProveedor.getDestinatarioDescripcion());
			fila.add(gastoProveedor.getEstadoGastoDescripcion());
			fila.add(gastoProveedor.getSujetoImpuestoIndirecto() ? "Si" : "No");
			fila.add(gastoProveedor.getNombreGestoria());
			fila.add(gastoProveedor.getEntidadPropietariaDescripcion());

			valores.add(fila);
		}

		return valores;
	}

	public String getReportName() {
		return AbstractExcelReport.LISTA_DE_GESTION_GASTOS_XLS;
	}
}
