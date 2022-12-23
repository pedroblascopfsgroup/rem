package es.pfsgroup.plugin.rem.excel;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.model.VGridBusquedaOfertas;
import es.pfsgroup.plugin.rem.model.dd.DDCisComiteInternoSancionador;

public class OfertaGridExcelReport extends AbstractExcelReport implements ExcelReport {
	
	protected final Log logger = LogFactory.getLog(getClass());	
	private List<VGridBusquedaOfertas> listaOfertas;	
	private boolean esCarteraLBK;	
	private HashMap<Long,String> fechasReunionComite;	
	private HashMap<Long,String> sancionadores;
	private boolean isSuper;
	
	public OfertaGridExcelReport(List<VGridBusquedaOfertas> listaOfertas, boolean esCarteraLBK, HashMap<Long,String> fechasReunionComite, HashMap<Long,String> sancionadores, boolean isSuper) {
		this.listaOfertas = listaOfertas;		
		this.esCarteraLBK = esCarteraLBK;
		this.fechasReunionComite = fechasReunionComite;
		this.sancionadores = sancionadores;
		this.isSuper = isSuper;
	}

	public List<String> getCabeceras() {
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("NºOferta");
		listaCabeceras.add("NºActivo/Agrupación");
		listaCabeceras.add("Estado Oferta");
		listaCabeceras.add("Tipo");
		listaCabeceras.add("Fecha Alta");
		listaCabeceras.add("Expediente");
		listaCabeceras.add("Estado expediente");
		listaCabeceras.add("Importe oferta");
		listaCabeceras.add("Ofertante");
		listaCabeceras.add("Prescriptor");
		listaCabeceras.add("Canal prescripcion");
		if(esCarteraLBK){
			listaCabeceras.add("Comité interno sancionador");
			listaCabeceras.add("Fecha reunión comité");
		}		
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VGridBusquedaOfertas oferta: listaOfertas){
			List<String> fila = new ArrayList<String>();
			
			String importeOferta = oferta.getImporteOferta() != null ? oferta.getImporteOferta().toString() : "";
			if (oferta.getConcurrenciaActiva() == 1 && !isSuper) {
				importeOferta = "*****";
			}
			
			fila.add(oferta.getNumOferta() != null ? oferta.getNumOferta().toString() : "");
			fila.add(oferta.getNumActivoAgrupacion() != null ? oferta.getNumActivoAgrupacion().toString() : "");
			fila.add(oferta.getDescripcionEstadoOferta());
			fila.add(oferta.getDescripcionTipoOferta());
			fila.add(this.getDateStringValue(oferta.getFechaCreacion()));
			fila.add(oferta.getNumExpediente() != null ? oferta.getNumExpediente().toString() : "");
			fila.add(oferta.getDescripcionEstadoExpediente());
			fila.add(importeOferta);
			fila.add(oferta.getOfertante());
			fila.add(oferta.getNombreCanal());
			fila.add(oferta.getCanalDescripcion());	
			if(esCarteraLBK){				
				fila.add(this.getComiteInternoSancionador(sancionadores.get(oferta.getId())));				
				fila.add(this.getFechaReunionComite(fechasReunionComite.get(oferta.getId())));
			}			
			valores.add(fila);
		}		
		return valores;
	}
	
	private String getComiteInternoSancionador(String codigoCIS){
		String sancionador = "";					
		if(codigoCIS != null){
			if((DDCisComiteInternoSancionador.CODIGO_PLANIFICACION_Y_CONTROL_INMOBILIARIO).equals(codigoCIS)){
				sancionador = "Planificación y Control Inmobiliario";
			}else if((DDCisComiteInternoSancionador.CODIGO_DIRECTOR_DE_PLANIFICACION_Y_CONTROL_INMOBILIARIO).equals(codigoCIS)){
				sancionador = "Director de Planificación y Control Inmobiliario";
			}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_INVERSIONES_INMOBILIARIAS).equals(codigoCIS)){
				sancionador = "Comité de Inversiones Inmobiliarias";
			}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_DIRECCION).equals(codigoCIS)){
				sancionador = "Comité de Dirección";
			}else if((DDCisComiteInternoSancionador.CODIGO_DIRECTOR_DE_RECUPERACIONES_Y_CENTROS_SUPERIORES).equals(codigoCIS)){
				sancionador = "Director de Recuperaciones y Centros Superiores";
			}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_SEGUIMIENTO_E_IMPAGOS).equals(codigoCIS)){
				sancionador = "Comité de Seguimiento e Impagos";
			}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_RIESGOS).equals(codigoCIS)){
				sancionador = "Comité de Riesgos";
			}
		}
		return sancionador;
	}
	
	private String getFechaReunionComite(String fecha) {
		String strFecha = "";
		if(fecha != null ){
			try {
				SimpleDateFormat stringToDate = new SimpleDateFormat("yyyy-MM-dd");
				Date date = stringToDate.parse(fecha);
				SimpleDateFormat dateToString = new SimpleDateFormat("dd/MM/yyyy");
				strFecha = dateToString.format(date);			
			} catch (ParseException e) {
				logger.error("Excepcion al parsear la fecha en la clase OfertaGridExcelReport", e);						
			}
		}
		return strFecha;
	}

	public String getReportName() {
		return LISTA_DE_OFERTAS_XLS;
	}

}
