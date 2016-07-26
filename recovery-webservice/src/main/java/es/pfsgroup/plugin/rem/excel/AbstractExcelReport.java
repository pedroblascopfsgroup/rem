package es.pfsgroup.plugin.rem.excel;

import java.text.SimpleDateFormat;
import java.util.Date;

import es.capgemini.pfs.diccionarios.Dictionary;

public abstract class AbstractExcelReport {
	
	public static final String LISTA_DE_AGRUPACIONES_XLS = "Lista_de_agrupaciones.xls";
	public static final String LISTA_DE_TRABAJOS_XLS = "Lista_de_trabajos.xls";
	public static final String LISTA_DE_ACTIVOS_XLS = "Lista_de_activos.xls";
	public static final String LISTA_DE_PUBLICACION_XLS = "Lista_de_publicación.xls";
	public static final String LISTA_DE_TAREAS_XLS = "Lista_de_tareas.xls";
	public static final String LISTA_DE_ACTIVOS_PRECIOS_XLS = "Lista_de_activos.xls";
	public static final String PROPUESTA_PRECIOS_XLS = "Propuesta_de_precios.xls";
	
	private SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	
	public String getDictionaryValue(Dictionary dictionaryValue){
		if (dictionaryValue == null){
			return "";
		}else{
			return dictionaryValue.getDescripcion();
		}
	}

	public String getDateStringValue(Date fecha) {
		if (fecha != null)
		{
			return this.df.format(fecha);
		}else{
			return "";
		}
	}

}
