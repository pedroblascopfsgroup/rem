package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

public class OfertaAgrupadaListadoActivosExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<VListadoOfertasAgrupadasLbk> listaOfertasAgrupadas;
	

	public OfertaAgrupadaListadoActivosExcelReport(List<VListadoOfertasAgrupadasLbk> listaOfertasAgrupadas) {
		this.listaOfertasAgrupadas = listaOfertasAgrupadas;
	}

	public List<String> getCabeceras() {

		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº Oferta principal");
		listaCabeceras.add("Nº Oferta dependiente");
		listaCabeceras.add("Nº Activo");
		listaCabeceras.add("Importe");
		listaCabeceras.add("VTA");
		listaCabeceras.add("VNC");
		listaCabeceras.add("VR comercial");
		
		
		return listaCabeceras;
	}

	public List<List<String>> getData() {

		List<List<String>> valores = new ArrayList<List<String>>();
		
		

		for(VListadoOfertasAgrupadasLbk ofertasAgrupadas: listaOfertasAgrupadas){
			
			List<String> fila = new ArrayList<String>();
			fila.add(ofertasAgrupadas.getNumActivo().toString());
			fila.add(ofertasAgrupadas.getNumOfertaPrincipal().toString());
			fila.add(ofertasAgrupadas.getImporteOfertaDependiente().toString());
			fila.add(ofertasAgrupadas.getValorTasacionActivo().toString());
			fila.add(ofertasAgrupadas.getValorNetoContable().toString());
			fila.add(ofertasAgrupadas.getValorRazonable().toString());
			
			valores.add(fila);
			
		}

		return valores;
	}
	
	public String getReportName() {
		return LISTA_DE_OFERTAS_AGRUPADAS_XLS;
	}
}
