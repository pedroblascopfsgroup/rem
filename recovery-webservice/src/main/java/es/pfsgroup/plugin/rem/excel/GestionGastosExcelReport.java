package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VGastosProveedor;
import es.pfsgroup.plugin.rem.model.VGastosProveedorExcel;

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
	private static final String CAB_SUBCARTERA = "Subcartera";
	private static final String CAB_ELEMENTO = "Número del activo/genérico/promoción";
	private static final String CAB_MOTIVO_RECHAZO_PROP = "Motivo Rechazo Prop.";
	private static final String CAB_PTDA_PRESUPUESTARIA = "Partida Presupuestaria";
	private static final String CAB_CONCEPTO_CONTABLE = "Concepto Contable";
	private static final String CAB_PROVISION_FONDOS = "Provisión fondos";
	private static final String CAB_ID_LINEA = "Línea detalle";
	private static final String CAB_CC_TASAS = "Cuenta Contable Tasas";
	private static final String CAB_PP_TASAS = "Partida Presupuestaria Tasas";
	private static final String CAB_CC_RECARGO = "Cuenta Contable Recargo";
	private static final String CAB_PP_RECARGO = "Partida Presupuestaria Recargo";
	private static final String CAB_CC_INTERESES = "Cuenta Contable Intereses";
	private static final String CAB_PP_INTERESES = "Partida Presupuestaria Intereses";
	private static final String CAB_SC_BASE = "Subcuenta Contable Base";
	private static final String CAB_APDO_BASE = "Apartado Base";
	private static final String CAB_CAP_BASE = "Capítulo Base";
	private static final String CAB_SC_RECARGO = "Subcuenta Contable Recargo";
	private static final String CAB_APDO_RECARGO = "Apartado Recargo";
	private static final String CAB_CAP_RECARGO = "Capítulo Recargo";
	private static final String CAB_SC_TASA = "Subcuenta Contable Tasa";
	private static final String CAB_APDO_TASA = "Apartado Recargo Tasa";
	private static final String CAB_CAP_TASA = "Capítulo Recargo Tasa";
	private static final String CAB_SC_INTERESES = "Subcuenta Contable Intereses";
	private static final String CAB_APDO_INTERESES = "Apartado Recargo Intereses";
	private static final String CAB_CAP_INTERESES = "Capítulo Recargo Intereses";
	
	
	private List<VGastosProveedorExcel> listaGastosProveedor;

	public GestionGastosExcelReport(List<VGastosProveedorExcel> listaGastosProveedor2) {
		this.listaGastosProveedor = listaGastosProveedor2;
	}

	public List<String> getCabeceras() {

		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_GASTO);
		listaCabeceras.add(CAB_ELEMENTO);
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
		listaCabeceras.add(CAB_SUBCARTERA);
		listaCabeceras.add(CAB_MOTIVO_RECHAZO_PROP);
		listaCabeceras.add(CAB_PTDA_PRESUPUESTARIA);
		listaCabeceras.add(CAB_CONCEPTO_CONTABLE);
		listaCabeceras.add(CAB_PROVISION_FONDOS);
		listaCabeceras.add(CAB_ID_LINEA);
		listaCabeceras.add(CAB_CC_TASAS);
		listaCabeceras.add(CAB_PP_TASAS);
		listaCabeceras.add(CAB_CC_RECARGO);
		listaCabeceras.add(CAB_PP_RECARGO);
		listaCabeceras.add(CAB_CC_INTERESES);
		listaCabeceras.add(CAB_PP_INTERESES);
		listaCabeceras.add(CAB_SC_BASE);
		listaCabeceras.add(CAB_APDO_BASE);
		listaCabeceras.add(CAB_CAP_BASE);
		listaCabeceras.add(CAB_SC_RECARGO);
		listaCabeceras.add(CAB_APDO_RECARGO);
		listaCabeceras.add(CAB_CAP_RECARGO);
		listaCabeceras.add(CAB_SC_TASA);
		listaCabeceras.add(CAB_APDO_TASA);
		listaCabeceras.add(CAB_CAP_TASA);
		listaCabeceras.add(CAB_SC_INTERESES);
		listaCabeceras.add(CAB_APDO_INTERESES);
		listaCabeceras.add(CAB_CAP_INTERESES);
		
		return listaCabeceras;
	}

	public List<List<String>> getData() {

		List<List<String>> valores = new ArrayList<List<String>>();

		for (VGastosProveedorExcel gastoProveedor : listaGastosProveedor) {
			List<String> fila = new ArrayList<String>();
			fila.add(String.valueOf(gastoProveedor.getNumGastoHaya()));
			fila.add(gastoProveedor.getElemento());
			fila.add(gastoProveedor.getNumFactura());
			fila.add(gastoProveedor.getTipoDescripcion());
			fila.add(gastoProveedor.getSubtipoDescripcion());
			fila.add(gastoProveedor.getConcepto());
			fila.add(gastoProveedor.getCodigoProveedorRem());
			fila.add(gastoProveedor.getNombreProveedor());
			fila.add(this.getDateStringValue(gastoProveedor.getFechaEmision()));
			fila.add(String.valueOf(gastoProveedor.getImporteTotal()));
			fila.add(this.getDateStringValue(gastoProveedor.getFechaTopePago()));
			fila.add(this.getDateStringValue(gastoProveedor.getFechaPago()));
			fila.add(gastoProveedor.getPeriodicidadDescripcion());
			fila.add(gastoProveedor.getDocIdentifPropietario() + " - " + gastoProveedor.getNombrePropietario());
			fila.add(gastoProveedor.getEstadoGastoDescripcion());
			fila.add(this.getBooleanStringValue(gastoProveedor.getSujetoImpuestoIndirecto()));
			fila.add(gastoProveedor.getNombreGestoria());
			fila.add(gastoProveedor.getEntidadPropietariaDescripcion());
			fila.add(gastoProveedor.getSubentidadPropietariaDescripcion());
			fila.add(gastoProveedor.getMotivoRechazoProp());
			fila.add(gastoProveedor.getPtdaPresupuestaria());
			fila.add(gastoProveedor.getConceptoContable());
			fila.add(gastoProveedor.getProvisionFondos());
			fila.add(String.valueOf(gastoProveedor.getIdLinea()));
			fila.add(gastoProveedor.getCuentaContableTasas());
			fila.add(gastoProveedor.getPtdaPresupuestariaTasas());
			fila.add(gastoProveedor.getCuentaContableRecargo());
			fila.add(gastoProveedor.getPtdaPresupuestariaRecargo());
			fila.add(gastoProveedor.getCuentaContableIntereses());
			fila.add(gastoProveedor.getPtdaPresupuestariaIntereses());
			fila.add(gastoProveedor.getSubcuentaContableBase());
			fila.add(gastoProveedor.getApartadoBase());
			fila.add(gastoProveedor.getCapituloBase());
			fila.add(gastoProveedor.getSubcuentaContableRecargo());
			fila.add(gastoProveedor.getApartadoRecargo());
			fila.add(gastoProveedor.getCapituloRecargo());
			fila.add(gastoProveedor.getSubcuentaContableTasa());
			fila.add(gastoProveedor.getApartadoTasa());
			fila.add(gastoProveedor.getCapituloTasa());
			fila.add(gastoProveedor.getSubcuentaContableIntereses());
			fila.add(gastoProveedor.getApartadoIntereses());
			fila.add(gastoProveedor.getCapituloIntereses());

			valores.add(fila);
		}

		return valores;
	}

	public String getReportName() {
		return AbstractExcelReport.LISTA_DE_GESTION_GASTOS_XLS;
	}
}
