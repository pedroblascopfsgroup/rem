package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;

public class OfertasExcelReport extends AbstractExcelReport implements ExcelReport {
	
	private List<VOfertasActivosAgrupacion> listaOfertas;

	public OfertasExcelReport(List<VOfertasActivosAgrupacion> listaOfertas) {
		this.listaOfertas = listaOfertas;
	}

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº Oferta");
		listaCabeceras.add("Nº Activo/Agrupación");
		listaCabeceras.add("Estado Oferta");
		listaCabeceras.add("Tipo");
		listaCabeceras.add("Fecha Alta");
		listaCabeceras.add("Expediente");
		listaCabeceras.add("Estado expediente");
		//listaCabeceras.add("Subtipo activo");
		listaCabeceras.add("Importe oferta");
		listaCabeceras.add("Ofertante");
		listaCabeceras.add("Prescriptor");
		listaCabeceras.add("Canal prescripcion");
		//NO ESTA DEFINIDO
//		listaCabeceras.add("Comité");
//		listaCabeceras.add("Drch. tanteo");
		
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VOfertasActivosAgrupacion oferta: listaOfertas){
			List<String> fila = new ArrayList<String>();
			
			fila.add(oferta.getNumOferta().toString());
			fila.add(oferta.getNumActivoAgrupacion().toString());
			fila.add(oferta.getEstadoOferta());
			fila.add(oferta.getDescripcionTipoOferta());
			fila.add(this.getDateStringValue(oferta.getFechaCreacion()));
			if(!Checks.esNulo(oferta.getNumExpediente())){
				fila.add(oferta.getNumExpediente().toString());
			}
			else{
				fila.add("");
			}
			fila.add(oferta.getDescripcionEstadoExpediente());
			//fila.add(oferta.getSubtipoActivo());
			fila.add(oferta.getImporteOferta());
			fila.add(oferta.getOfertante());
			
			if(!Checks.esNulo(oferta.getNombreCanal())) {
				fila.add(oferta.getNombreCanal());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(oferta.getCanalDescripcion())) {
				fila.add(oferta.getCanalDescripcion());
			}else {
				fila.add("");
			}
			//NO ESTA DEFINIDO
//			fila.add(oferta.getComite());
//			if(!Checks.esNulo(oferta.getDerechoTanteo())){
//				if(oferta.getDerechoTanteo()){
//					fila.add("SI");
//				}
//				else{
//					fila.add("NO");
//				}
//			}

			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_OFERTAS_XLS;
	}
	
	

}
