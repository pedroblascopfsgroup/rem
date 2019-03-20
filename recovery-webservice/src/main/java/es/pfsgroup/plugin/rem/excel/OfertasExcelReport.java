package es.pfsgroup.plugin.rem.excel;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCisComiteInternoSancionador;

public class OfertasExcelReport extends AbstractExcelReport implements ExcelReport {
	
	/** Logger available to subclasses */
	protected final Log logger = LogFactory.getLog(getClass());
	
	private List<VOfertasActivosAgrupacion> listaOfertas;
	
	private String dtoCarteraCodigo;
	
	private UsuarioCartera usuarioCartera;
	
	private HashMap<Long,String> fechasReunionComite;
	
	private HashMap<Long,String> sancionadores;
	
	public OfertasExcelReport(List<VOfertasActivosAgrupacion> listaOfertas, String dtoCarteraCodigo, 
			UsuarioCartera usuarioCartera, HashMap<Long,String> fechasReunionComite, HashMap<Long,String> sancionadores) {
		this.listaOfertas = listaOfertas;
		this.dtoCarteraCodigo = dtoCarteraCodigo;
		this.usuarioCartera = usuarioCartera;
		this.fechasReunionComite = fechasReunionComite;
		this.sancionadores = sancionadores;
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
		if(!Checks.esNulo(usuarioCartera) && (DDCartera.CODIGO_CARTERA_LIBERBANK).equals(usuarioCartera.getCartera().getCodigo())
				|| (!Checks.esNulo(dtoCarteraCodigo) && (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(dtoCarteraCodigo)))){
			listaCabeceras.add("Comité interno sancionador");
			listaCabeceras.add("Fecha reunión comité");
		}
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
			
			if(!Checks.esNulo(usuarioCartera) && (DDCartera.CODIGO_CARTERA_LIBERBANK).equals(usuarioCartera.getCartera().getCodigo())
					|| (!Checks.esNulo(dtoCarteraCodigo) && (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(dtoCarteraCodigo)))){
				
				if(!Checks.esNulo(sancionadores.get(oferta.getId()))){
					String sancionador = "";
					
					if((DDCisComiteInternoSancionador.CODIGO_PLANIFICACION_Y_CONTROL_INMOBILIARIO).equals(sancionadores.get(oferta.getId()))){
						sancionador = "Planificación y Control Inmobiliario";
					}else if((DDCisComiteInternoSancionador.CODIGO_DIRECTOR_DE_PLANIFICACION_Y_CONTROL_INMOBILIARIO).equals(sancionadores.get(oferta.getId()))){
						sancionador = "Director de Planificación y Control Inmobiliario";
					}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_INVERSIONES_INMOBILIARIAS).equals(sancionadores.get(oferta.getId()))){
						sancionador = "Comité de Inversiones Inmobiliarias";
					}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_DIRECCION).equals(sancionadores.get(oferta.getId()))){
						sancionador = "Comité de Dirección";
					}else if((DDCisComiteInternoSancionador.CODIGO_DIRECTOR_DE_RECUPERACIONES_Y_CENTROS_SUPERIORES).equals(sancionadores.get(oferta.getId()))){
						sancionador = "Director de Recuperaciones y Centros Superiores";
					}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_SEGUIMIENTO_E_IMPAGOS).equals(sancionadores.get(oferta.getId()))){
						sancionador = "Comité de Seguimiento e Impagos";
					}else if((DDCisComiteInternoSancionador.CODIGO_COMITE_DE_RIESGOS).equals(sancionadores.get(oferta.getId()))){
						sancionador = "Comité de Riesgos";
					}
					fila.add(sancionador);
				}else{
					fila.add("");
				}
				
				if(!Checks.esNulo(fechasReunionComite.get(oferta.getId()))){
					try {
						SimpleDateFormat stringToDate = new SimpleDateFormat("yyyy-MM-dd");
						Date fecha = stringToDate.parse(fechasReunionComite.get(oferta.getId()));
						SimpleDateFormat dateToString = new SimpleDateFormat("dd/MM/yyyy");
						String strFecha = dateToString.format(fecha);
						fila.add(strFecha);
					} catch (ParseException e) {
						logger.error("Excepcion al parsear la fecha en la clase OfertaExcelReport", e);
						e.printStackTrace();
					}
				}else{
					fila.add("");
				}
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_OFERTAS_XLS;
	}
	
	

}
