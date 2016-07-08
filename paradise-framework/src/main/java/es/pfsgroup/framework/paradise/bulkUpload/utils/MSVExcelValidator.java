package es.pfsgroup.framework.paradise.bulkUpload.utils;

import java.util.HashSet;

import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;

public interface MSVExcelValidator {
	
	static final String CODIFICACION_NUMERICA = "n";
	static final String CODIFICACION_IMPORTE = "i";
	static final String CODIFICACION_STRING = "s";
	static final String CODIFICACION_FECHA ="f";
	static final String CODIGO_BOOLEAN="b";
	
	static final String VALIDAR_COLUMNA_TODOS_IGUALES="T";
	static final String VALIDAR_COLUMNA_NINGUN_REPETIDO="D";
	static final String VALIDAR_COLUMNA_SOLO_UN_UNO="U";
	
	static final String NOMBRE_COL_CARTERA="Cartera ";
	static final String NOMBRE_COL_LOTE="Lote";
	static final String NOMBRE_COL_NUM_CONTRATO_NOVA="N� referencia ";
	static final String NOMBRE_COL_LETRADO="Letrado";
	static final String NOMBRE_COL_TIPO_PROC="Tipo de procedimiento";
	
	public static final String KEY_NUMERO_MAXIMO_FILAS = "masivo.cargaExcel.maxFilas";
	
	MSVDtoValidacion validarFormatoFichero(MSVExcelFileItemDto dtoFile);
	
	MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile);
	
	

}
