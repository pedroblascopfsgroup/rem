package es.pfsgroup.plugin.recovery.masivo.utils;

import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoValidacion;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVExcelFileItemDto;

public interface MSVExcelValidator {
	
	static final String CODIFICACION_NUMERICA = "n";
	static final String CODIFICACION_IMPORTE = "i";
	static final String CODIFICACION_STRING = "s";
	static final String CODIFICACION_FECHA ="f";
	static final String CODIGO_BOOLEAN="b";
	
	static final String NOMBRE_COL_CARTERA="Cartera ";
	static final String NOMBRE_COL_LOTE="Lote";
	static final String NOMBRE_COL_NUM_CONTRATO_NOVA="Nº referencia ";
	static final String NOMBRE_COL_LETRADO="Letrado";
	static final String NOMBRE_COL_TIPO_PROC="Tipo de procedimiento";
	
	public static final String KEY_NUMERO_MAXIMO_FILAS = "masivo.cargaExcel.maxFilas";
	
	MSVDtoValidacion validarFormatoFichero(MSVExcelFileItemDto dtoFile);
	
	MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile);
	
	

}
