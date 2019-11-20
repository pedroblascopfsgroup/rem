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
			
			if(!Checks.esNulo(ofertasAgrupadas.getNumOfertaPrincipal())) {
				fila.add(ofertasAgrupadas.getNumOfertaPrincipal().toString());
			}else {
				fila.add("No existe la oferta principal");
			}
			if(!Checks.esNulo(ofertasAgrupadas.getNumOfertaDependiente())) {
				fila.add(ofertasAgrupadas.getNumOfertaDependiente().toString());
			}else {
				fila.add("No existe la oferta dependiente");
			}
			if(!Checks.esNulo(ofertasAgrupadas.getNumActivo())) {
				fila.add(ofertasAgrupadas.getNumActivo().toString());
			}else {
				fila.add("No existe el activo");
			}
			if(!Checks.esNulo(ofertasAgrupadas.getImporteOfertaDependiente())) {
				fila.add(ofertasAgrupadas.getImporteOfertaDependiente().toString());
			}else {
				fila.add("-");
			}
			
			if(!Checks.esNulo(ofertasAgrupadas.getValorTasacionActivo())) {
				fila.add(ofertasAgrupadas.getValorTasacionActivo().toString());
			}else {
				fila.add("-");
			}
			if(!Checks.esNulo(ofertasAgrupadas.getValorNetoContable())) {
				fila.add(ofertasAgrupadas.getValorNetoContable().toString());
			}else {
				fila.add("-");
			}
			if(!Checks.esNulo(ofertasAgrupadas.getValorRazonable())) {
				fila.add(ofertasAgrupadas.getValorRazonable().toString());
			}else {
				fila.add("-");
			}
			
			valores.add(fila);
			
		}

		return valores;
	}
	
	public String getReportName() {
		return LISTA_DE_OFERTAS_AGRUPADAS_XLS;
	}
}
