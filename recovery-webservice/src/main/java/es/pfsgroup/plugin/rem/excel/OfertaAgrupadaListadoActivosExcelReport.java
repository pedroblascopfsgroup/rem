/*package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

public class OfertaAgrupadaListadoActivosExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<VActivosAgrupacion> listaActivosAgrupacion;
	
	private DtoAgrupaciones agrupacionDto;

	public OfertaAgrupadaListadoActivosExcelReport(VListadoOfertasAgrupadasLB listaOfertasAgrupadas) {
		this.listaOfertasAgrupadas = listaOfertasAgrupadas;
		this.agrupacionDto = null;
	}
	
	public OfertaAgrupadaListadoActivosExcelReport(VListadoOfertasAgrupadasLB listaOfertasAgrupadas) {
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
		
		

		for(VListadoOfertasAgrupadasLB ofertasAgrupadas: listaOfertasAgrupadas){
			List<String> fila = new ArrayList<String>();

			fila.add(ofertasAgrupadas.getNumActivo().toString());
			fila.add(this.getDateStringValue(ofertasAgrupadas.getFechaInclusion()));
			fila.add(ofertasAgrupadas.getTipoActivoDescripcion());
			fila.add(ofertasAgrupadas.getSubtipoActivoDescripcion());
			fila.add(ofertasAgrupadas.getDireccion());
			fila.add(ofertasAgrupadas.getPublicado());
			fila.add(ofertasAgrupadas.getSituacionComercial());
			
			
			valores.add(fila);
		}

		return valores;
	}

	public String getReportName() {
		return LISTA_DE_OFERTAS_AGRUPADAS_XLS;
	}
}
*/