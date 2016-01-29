package es.capgemini.pfs.asunto;

import java.util.List;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.lang.ObjectUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Controller
public class EXTAsuntoController {
	
	private static final String GESTORES_ADICIONALES_ASUNTO_JSON = "plugin/coreextension/multigestor/multiGestorAdicionalAsuntoDataJSON";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private EXTAsuntoApi extAsuntoApi;

	@Autowired
    private Executor executor;	
	
	@Resource
	private Properties appProperties;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String exportacionAsuntosCount(EXTDtoBusquedaAsunto dto, String params, ModelMap model) {		
    	
		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_ASUNTOS);
		
		model.put("count", proxyFactory.proxy(EXTAsuntoApi.class).findAsuntosPaginatedDinamicoCount(dto, params));
		model.put("limit", Integer.parseInt(param.getValor()));
		
        return "plugin/coreextension/exportacionGenericoCountJSON";
    }

	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getMsgErrorEnvioCDDCabecera(Long idAsunto, ModelMap model) {		
    	
		String mensaje = proxyFactory.proxy(EXTAsuntoApi.class).getMsgErrorEnvioCDDCabecera(idAsunto);
		
		model.put("okko", mensaje);
		
        return "plugin/coreextension/OkRespuestaJSON";
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getGestoresAdicionalesAsunto(Long idAsunto, ModelMap model) {
		List<EXTGestorAdicionalAsunto> listadoGestoresAdicionalesAsunto = proxyFactory.proxy(EXTAsuntoApi.class).getGestoresAdicionalesAsunto(idAsunto);
		model.put("listaGestoresAdicionales", listadoGestoresAdicionalesAsunto);
		
		return GESTORES_ADICIONALES_ASUNTO_JSON;
	}

	@RequestMapping
	public String exportarExcelAsuntos(EXTDtoBusquedaAsunto filter, String params, ModelMap model) {
		Page resultadoPaginado = extAsuntoApi.findAsuntosPaginatedDinamicoCount(filter, params);
		List<EXTAsunto> asuntos = (List<EXTAsunto>) resultadoPaginado.getResults();

		FileItem excel = generarExcelAsuntos(asuntos);

		model.put("fileItem", excel);
		return "plugin/coreextension/asunto/download";
	}

	private FileItem generarExcelAsuntos(List<EXTAsunto> asuntos) {
		List<List<String>> datos = getDataToExport(asuntos);

		String nombreFichero = (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "-listaAsuntos.xls";
		String rutaCompletaFichero = !Checks.esNulo(appProperties.getProperty("files.temporaryPath")) ? appProperties.getProperty("files.temporaryPath") : "";

		rutaCompletaFichero += File.separator.equals(rutaCompletaFichero.substring(rutaCompletaFichero.length()-1)) || rutaCompletaFichero.length() == 0 ? nombreFichero : File.separator+nombreFichero; 

		//Creo el fichero excel
		HojaExcel hojaExcel = new HojaExcel();
		hojaExcel.crearNuevoExcel(rutaCompletaFichero, getHeader(), datos);

		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
		excelFileItem.setFileName(rutaCompletaFichero);
		excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
		excelFileItem.setLength(hojaExcel.getFile().length());

		return excelFileItem;
	}

	private List<List<String>> getDataToExport(List<EXTAsunto> asuntos) {
		List<List<String>> datos = new ArrayList<List<String>>();

		SimpleDateFormat dateFormat = new SimpleDateFormat(FormatUtils.DDMMYYYY);

		for (EXTAsunto asunto : asuntos) {
			List<String> filaExportar = new ArrayList<String>();

			filaExportar.add(ObjectUtils.toString(asunto.getId())); // codigo
			filaExportar.add(asunto.getNombre()); // nombre

			Date fechaCrear =  null;
			if (asunto.getAuditoria() != null) {
				fechaCrear = asunto.getAuditoria().getFechaCrear();
			}

			String fechaCrearFormateada = fechaCrear != null ? dateFormat.format(asunto.getAuditoria().getFechaCrear()) : "";

			filaExportar.add(fechaCrearFormateada); // fechaCrear
			filaExportar.add(asunto.getCodigoDecodificado()); // estado
			filaExportar.add(asunto.getGestorNombreApellidosSQL()); // gestor
			filaExportar.add(asunto.getDespachoSQL()); // despacho
			filaExportar.add(asunto.getSupervisorNombreApellidosSQL() != null ? asunto.getSupervisorNombreApellidosSQL() : ""); // supervisor

			// Formateo con , separador de decimales
			String saldoTotalPorContratos = asunto.getSaldoTotalPorContratosSQL() != null ? String.format(Locale.GERMANY, "%.2f", asunto.getSaldoTotalPorContratosSQL()) : "";
			filaExportar.add(saldoTotalPorContratos); // saldoTotal

			// Formateo con , separador de decimales
			String importeEstimado = asunto.getImporteEstimado() != null ? String.format(Locale.GERMANY, "%.2f", asunto.getImporteEstimado()) : "";
			filaExportar.add(importeEstimado); // importeEstimado

			datos.add(filaExportar);
		}
		return datos;
	}

	private ArrayList<String> getHeader(){
		ArrayList<String> cabeceras = new ArrayList<String>();

		//Cabecera de las columnas
		cabeceras.add("C\u00f3digo");
		cabeceras.add("Nombre");
		cabeceras.add("Fecha creaci\u00f3n");
		cabeceras.add("Estado");
		cabeceras.add("Gestor");
		cabeceras.add("Despacho");
		cabeceras.add("Supervisor");
		cabeceras.add("Saldo total");
		cabeceras.add("importe estimado");

		return cabeceras;
	}
}
