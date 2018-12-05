package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.diccionarios.DictionaryDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;

@Component
public class MSVActualizadorCargaMasivaSancion extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private DictionaryDao dictionaryDao;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES;
	}
	
	private static final int POSICION_COLUMNA_NUMERO_ACTIVO = 0;
	private static final int POSICION_COLUMNA_FECHA_SANCION = 1;
	private static final int POSICION_COLUMNA_RESULTADO_SANCION = 2;
	private static final int POSICION_COLUMNA_NIF = 3;
	private static final int POSICION_COLUMNA_NOMBRE = 4;
	
	private static final String COD_EJERCE ="Ejerce";
	private static final String COD_NO_EJERCE ="No ejerce";

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		List<ComunicacionGencat> list = new ArrayList<ComunicacionGencat>();
		
		if (COD_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {
			
			list = comunicacionGencatApi.getByNumActivoHayaAndNif(Long.valueOf(exc.dameCelda(fila, POSICION_COLUMNA_NUMERO_ACTIVO))
					,exc.dameCelda(fila, POSICION_COLUMNA_NIF));
			
			if (Checks.esNulo(list) || list.isEmpty()) {
				return getNotFound(fila, true);
			}
			
		} else if (COD_NO_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {
			
			list = comunicacionGencatApi.getByNumActivoHaya(Long.valueOf(exc.dameCelda(fila, POSICION_COLUMNA_NUMERO_ACTIVO)));
			
			if (Checks.esNulo(list) || list.isEmpty()) {
				return getNotFound(fila, false);
			}
			
		}

		for (int i = 0; i < list.size(); i++) {
			
			ComunicacionGencat tmp = list.get(i);
			
			tmp.setFechaSancion(new SimpleDateFormat(DateFormat.DATE_FORMAT).parse(exc.dameCelda(fila, POSICION_COLUMNA_FECHA_SANCION)));
			
			if (COD_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {
				tmp.setSancion((DDSancionGencat) dictionaryDao.getByCode(DDSancionGencat.class, DDSancionGencat.COD_EJERCE));
			} else if (COD_NO_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {
				tmp.setSancion((DDSancionGencat) dictionaryDao.getByCode(DDSancionGencat.class, DDSancionGencat.COD_NO_EJERCE));
			}
			
			comunicacionGencatApi.saveOrUpdate(tmp);

		}

		return new ResultadoProcesarFila();
	}
	
	private ResultadoProcesarFila getNotFound(int fila, boolean nif) {
		
		String error = "numero de activo";
		
		if (nif) { error = "NIF"; }
		
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc("No se ha encontrado ningún registro con el " + error + " introducido");
		resultado.setCorrecto(false);
		
		return resultado;
		
	}

}
