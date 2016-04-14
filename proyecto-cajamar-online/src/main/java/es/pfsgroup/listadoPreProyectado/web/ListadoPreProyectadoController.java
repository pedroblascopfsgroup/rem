package es.pfsgroup.listadoPreProyectado.web;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.lang.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.termino.model.DDEstadoGestionTermino;
import es.capgemini.pfs.vencidos.model.DDTramosDiasVencidos;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.listadoPreProyectado.api.ListadoPreProyectadoApi;
import es.pfsgroup.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;

@Controller
public class ListadoPreProyectadoController {

	static final String LISTADO_PREPROYECTADO = "plugin/cajamar/listadoPreProyectado/listadoPreProyectado";
	static final String LISTADO_PREPROYECTADO_EXP_JSON = "plugin/cajamar/listadoPreProyectado/listadoPreProyectadoExpJSON";
	static final String LISTADO_PREPROYECTADO_CNT_JSON = "plugin/cajamar/listadoPreProyectado/listadoPreProyectadoCntJSON";
	static final String LISTADO_PREPROYECTADO_JSP_DOWNLOAD_FILE="plugin/cajamar/listadoPreProyectado/download";
	
	@Autowired
	ListadoPreProyectadoApi listadoPreProyectado;
	
	@Autowired
	UtilDiccionarioApi utilDiccionario;
	
	@Resource
	private Properties appProperties;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirListado(ModelMap model) {

		//Diccionarios pestanya Datos Generales
		ArrayList<DDEstadoGestionTermino> ddEstadoGestionTermino =  (ArrayList<DDEstadoGestionTermino>) utilDiccionario.dameValoresDiccionario(DDEstadoGestionTermino.class); 
		model.put("estadosGestion", ddEstadoGestionTermino);
		
		ArrayList<DDTipoPersona> ddTipoPersona = (ArrayList<DDTipoPersona>) utilDiccionario.dameValoresDiccionario(DDTipoPersona.class);
		model.put("tipoPersonas", ddTipoPersona);
		
		ArrayList<DDTramosDiasVencidos> ddTramosDiasVencidos = (ArrayList<DDTramosDiasVencidos>) utilDiccionario.dameValoresDiccionario(DDTramosDiasVencidos.class);
		model.put("tramo", ddTramosDiasVencidos);
		
		ArrayList<DDTipoAcuerdo> ddTipoAcuerdo = (ArrayList<DDTipoAcuerdo>) utilDiccionario.dameValoresDiccionario(DDTipoAcuerdo.class);
		
		//Al no existir el valor sin propuesta se añade manualmente
		DDTipoAcuerdo tipoAcuertoSinPropuesta = new DDTipoAcuerdo();
		tipoAcuertoSinPropuesta.setCodigo(DDTipoAcuerdo.SIN_PROPUESTA);
		tipoAcuertoSinPropuesta.setDescripcion("Sin Propuesta");
		ddTipoAcuerdo.add(0, tipoAcuertoSinPropuesta);

		model.put("propuesta", ddTipoAcuerdo);
		
		//Diccionarios pestanya Expediente y contrato
		ArrayList<Nivel> nivel = (ArrayList<Nivel>) utilDiccionario.dameValoresDiccionario(Nivel.class);
		model.put("niveles", nivel);
		
		ArrayList<Nivel> jerarquias = (ArrayList<Nivel>) utilDiccionario.dameValoresDiccionario(Nivel.class);
		model.put("nivelesExp", jerarquias);
		
		ArrayList<DDEstadoItinerario> ddEstadoItinerario = (ArrayList<DDEstadoItinerario>) utilDiccionario.dameValoresDiccionario(DDEstadoItinerario.class);
		model.put("fase", ddEstadoItinerario);
		
		return LISTADO_PREPROYECTADO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListPreproyectadoExp(ListadoPreProyectadoDTO dto, ModelMap map) {
		//List<VListadoPreProyectadoExp> listadoExp = listadoPreProyectado.getListPreproyectadoExp(dto);
		Page listadoExp = listadoPreProyectado.getListPreproyectadoExp(dto);
		map.put("listadoPreProyectadoExp", listadoExp);
		return LISTADO_PREPROYECTADO_EXP_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListPreproyectadoCnt(ListadoPreProyectadoDTO dto, ModelMap map) {
		List<VListadoPreProyectadoCnt> listadoCnt = listadoPreProyectado.getListPreproyectadoCntPaginated(dto);
		map.put("listadoPreProyectadoCnt", listadoCnt);
		
		int registrosTotales = listadoPreProyectado.getCountListadoPreProyectadoCntPaginated(dto);
		map.put("totalCount", registrosTotales);
		return LISTADO_PREPROYECTADO_CNT_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	private String generarInformeListadoPreProyectado(ListadoPreProyectadoDTO dto, ModelMap map){
		//obtenemos los valores del grid
		List <VListadoPreProyectadoCnt> listadoCnt = listadoPreProyectado.getListPreproyectadoCnt(dto);
		
		List<List<String>> valores = new ArrayList<List<String>>();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
				
		for(VListadoPreProyectadoCnt row:listadoCnt){
			List<String> filaExportar = new ArrayList<String>();
			
			filaExportar.add(ObjectUtils.toString(row.getContrato())); 	//N.Contrato
			filaExportar.add(ObjectUtils.toString(row.getExpId())); 	//Id expediente
			filaExportar.add(ObjectUtils.toString(row.getNomTitular())); // Nombre primer titular
			filaExportar.add(ObjectUtils.toString(row.getNifTitular())); // Nif primer titular
			filaExportar.add(ObjectUtils.toString(row.getRiesgoTotal())); 	//Riesgo total
			filaExportar.add(ObjectUtils.toString(row.getDeudaIrregular())); 	//Deuda irregular
			filaExportar.add(ObjectUtils.toString(row.getTramo())); 	//Tramo
			filaExportar.add(ObjectUtils.toString(row.getDiasVencidos())); 	//Dias vencidos
			if(!Checks.esNulo(row.getFechaPaseAMoraCnt())){
					filaExportar.add(ObjectUtils.toString(sdf.format(row.getFechaPaseAMoraCnt())));//Fecha pase a mora
			}
			filaExportar.add(ObjectUtils.toString(row.getPropuesta())); 	//Propuesta
			filaExportar.add(ObjectUtils.toString(row.getEstadoGestion())); 	//Estado Gestion
			filaExportar.add(ObjectUtils.toString(row.getOfiCodigo())); 	//Estado Gestion
			/*if(!Checks.esNulo(row.getFechaPrevReguCnt())){
				filaExportar.add(ObjectUtils.toString(sdf.format(row.getFechaPrevReguCnt()))); //Fecha prevista regularizacion	
			}*/
			
			valores.add(filaExportar);
		}
		
		//nombre del fichero
		String nombreFichero = (new SimpleDateFormat("yyyMMddHHmmss")).format(new Date()) + "-listadoPreProyectado.xls";
		String rutaCompletaFichero = !Checks.esNulo(appProperties.getProperty("files.temporaryPath")) ? appProperties.getProperty("files.temporaryPath") : "";
		
		rutaCompletaFichero += File.separator.equals(rutaCompletaFichero.substring(rutaCompletaFichero.length()-1)) || rutaCompletaFichero.length() == 0 ? nombreFichero : File.separator+nombreFichero;
		
		//creacion fichero excel
		HojaExcel hojaExcel = new HojaExcel();
		hojaExcel.crearNuevoExcel(rutaCompletaFichero, getListaCabecera(), valores);
		
		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
		excelFileItem.setFileName(rutaCompletaFichero);
		excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
		excelFileItem.setLength(hojaExcel.getFile().length());
		
		map.put("fileItem", excelFileItem);
		
		return LISTADO_PREPROYECTADO_JSP_DOWNLOAD_FILE;
	}
	
	private ArrayList<String> getListaCabecera(){
		ArrayList<String> cabeceras = new ArrayList<String>();
		
		//Cabecera de las columnas
		cabeceras.add(formatearString("Nro. contrato"));
		cabeceras.add(formatearString("ID Expediente"));
		cabeceras.add(formatearString("Nombre 1er titular"));
		cabeceras.add(formatearString("Nif 1er titular"));
		cabeceras.add(formatearString("Riesgo total"));
		cabeceras.add(formatearString("Deuda irregular"));
		cabeceras.add(formatearString("Tramo"));
		cabeceras.add(formatearString("Días vencidos"));
		cabeceras.add(formatearString("Fecha pase a mora"));
		cabeceras.add(formatearString("Última Propuesta"));
		cabeceras.add(formatearString("Estado gestión"));
		cabeceras.add(formatearString("Código oficina"));
		//cabeceras.add(formatearString("Fecha prevista regularización"));
		
		return cabeceras;
	}
	
	//Formatea las String introducidas que desean verse correctamente en la hoja excel
		private String formatearString(String texto){
			
			texto = texto.replace("ñ", "\u00f1");
			texto = texto.replace("Ñ", "\u00d1");
			
			texto = texto.replace("á", "\u00e1");
			texto = texto.replace("é", "\u00e9");
			texto = texto.replace("í", "\u00ed");
			texto = texto.replace("ó", "\u00f3");
			texto = texto.replace("ú", "\u00fa");
			
			texto = texto.replace("Á", "\u00c1");
			texto = texto.replace("É", "\u00c9");
			texto = texto.replace("Í", "\u00cd");
			texto = texto.replace("Ó", "\u00d3");
			texto = texto.replace("Ú", "\u00da");
			
			return texto;
		}
}
