package es.pfsgroup.plugin.rem.excel;

import java.math.BigDecimal;
import java.math.MathContext;
import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.VElementosLineaDetalle;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

public class ElementosLineasExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<VElementosLineaDetalle> listaElementos;
	private String codigoCartera = null;
	
	public ElementosLineasExcelReport(List<VElementosLineaDetalle> listaElementos) {
		this.listaElementos = listaElementos;

	}

	public ElementosLineasExcelReport(List<VElementosLineaDetalle> listaElementos, String cartera) {
		this.listaElementos = listaElementos;
		this.codigoCartera = cartera;
	}

	public List<String> getCabeceras() {
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Id línea");
		listaCabeceras.add("Línea");
		listaCabeceras.add("Tipo elemento");
		listaCabeceras.add("ID elemento");
		listaCabeceras.add("Subtipo activo");
		if ( DDCartera.CODIGO_CARTERA_BBVA.equals(this.codigoCartera)) {
			listaCabeceras.add("Línea factura");
		}
		listaCabeceras.add("Dirección");
		listaCabeceras.add("Referencia catastral");
		listaCabeceras.add("% participación gasto");
		listaCabeceras.add("Importe proporcional total");
				
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VElementosLineaDetalle elemento: listaElementos){
			List<String> fila = new ArrayList<String>();
			
			if(elemento.getIdLinea() != null) {
				fila.add(elemento.getIdLinea().toString());
			}
			fila.add(elemento.getDescripcionLinea());
			fila.add(elemento.getTipoElemento());
			fila.add(elemento.getIdElemento().toString());
			fila.add(elemento.getTipoActivo());
			if ( DDCartera.CODIGO_CARTERA_BBVA.equals(this.codigoCartera)) {
				fila.add(elemento.getLineaFactura());
			}
			fila.add(elemento.getDireccion());
			fila.add(elemento.getReferenciaCatastral());
			if(elemento.getParticipacion() != null) {
				fila.add(elemento.getParticipacion().toString() + "%");
			}
			if(elemento.getImporteProporcinalTotal() != null) {
				BigDecimal elementoBigDecimal  = BigDecimal.valueOf(elemento.getImporteProporcinalTotal());
				elementoBigDecimal = elementoBigDecimal.round(new MathContext(4));
				fila.add(elementoBigDecimal.toString());
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_ELEMENTOS_DE_LINEA_XLS;
	}
}
