package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;

@Component
public class MSVActualizadorIndicadorActivoAlquiler extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final int POSICION_COLUMNA_ID_ACTIVO_HAYA = 0;
	private static final int POSICION_COLUMNA_MOSTRAR_PRECIO = 1;
	private static final int POSICION_COLUMNA_PUBLICAR_SIN_PRECIO = 2;
	
	private static final String COD_SI = "S";
	private static final String COD_NO = "N";
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoAdapter activoAdapter;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_INDICADOR_ACTIVO_ALQUILER;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Activo activo = null;
		ActivoPublicacion activoPublicacion = null;
		
		String idActivoHaya = exc.dameCelda(fila, POSICION_COLUMNA_ID_ACTIVO_HAYA);
		String mostrarPrecio = exc.dameCelda(fila, POSICION_COLUMNA_MOSTRAR_PRECIO);
		String publicarSinPrecio = exc.dameCelda(fila, POSICION_COLUMNA_PUBLICAR_SIN_PRECIO);
		
		if(!Checks.esNulo(idActivoHaya)) {
			activo = activoApi.getByNumActivo(Long.parseLong(idActivoHaya));
		}
		
		if (!Checks.esNulo(activo)) {
			
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			activoPublicacion = genericDao.get(ActivoPublicacion.class, filtroActivo, filtroBorrado);
			
			if (COD_SI.equals(mostrarPrecio)) {
				activoPublicacion.setCheckOcultarPrecioAlquiler(true);
			}
			else if (COD_NO.equals(mostrarPrecio)) {
				activoPublicacion.setCheckOcultarPrecioAlquiler(false);
			}
			
			if (COD_SI.equals(publicarSinPrecio)) { 
				activoPublicacion.setCheckSinPrecioAlquiler(true);
			}
			else if (COD_NO.equals(publicarSinPrecio)) {
				activoPublicacion.setCheckSinPrecioAlquiler(false);
			}
			
			genericDao.save(ActivoPublicacion.class, activoPublicacion);
			
		}
		else{
			return getNotFound(fila);
		}
		
		this.actualizarEstadoPublicacion(activo);
		
		return new ResultadoProcesarFila();
		
	}
	
	private ResultadoProcesarFila getNotFound(int fila) {
		
		String error = "número de activo";
		
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc("No se ha encontrado ningún registro con el " + error + " introducido");
		resultado.setCorrecto(false);
		
		return resultado;
		
	}
	
	//HREOS-5433. Los registros de la fila son correctos. Se lanza el SP_CAMBIO_ESTADO_PUBLICACION.
	private void actualizarEstadoPublicacion(Activo activo) {
		@SuppressWarnings("unused")
		boolean result = activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
	}
	
}
