package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;


@Component
public class MSVActualizadorPreciosActivoImporte extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UpdaterStateApi updaterState;

	SimpleDateFormat simpleDate = new SimpleDateFormat("dd/MM/yyyy");
	
	//Indicar las posiciones de las columnas en el excel CARGA_DIRECTA_PRECIOS_ACTIVOS.xls
	public static final Integer COLUMNA_ACTIVO 						= 0;
	public static final Integer COLUMNA_P_APROBADO_VENTA 			= 1;
	public static final Integer COLUMNA_F_APROB_P_APROBADO_VENTA 	= 2;
	public static final Integer COLUMNA_F_INI_PRECIO_APROB_VENTA 	= 3;
	public static final Integer COLUMNA_F_FIN_PRECIO_APROB_VENTA 	= 4;
	public static final Integer COLUMNA_P_MIN_AUTORIZADO 			= 5;
	public static final Integer COLUMNA_F_APROB_P_MIN_AUTORIZADO 	= 6;
	public static final Integer COLUMNA_F_INI_P_MIN_AUTORIZADO 		= 7;
	public static final Integer COLUMNA_F_FIN_P_MIN_AUTORIZADO 		= 8;
	public static final Integer COLUMNA_P_APROB_RENTA 				= 9;
	public static final Integer COLUMNA_F_APROB_P_APROBADO_RENTA 	= 10;
	public static final Integer COLUMNA_F_INI_P_APROBADO_RENTA 		= 11;
	public static final Integer COLUMNA_F_FIN_P_APROBADO_RENTA 		= 12;
	public static final Integer COLUMNA_P_DESCUENTO_APROBADO 		= 13;
	public static final Integer COLUMNA_F_APROB_P_DESCUENTO_APROB 	= 14;
	public static final Integer COLUMNA_F_INI_P_DESCUENTO_APROB 	= 15;
	public static final Integer COLUMNA_F_FIN_P_DESCUENTO_APROB 	= 16;
	public static final Integer COLUMNA_P_DESCUENTO_PUBLICADO 		= 17;
	public static final Integer COLUMNA_F_APROB_P_DESCUENTO_PUB 	= 18;
	public static final Integer COLUMNA_F_INI_P_DESCUENTO_PUB 		= 19;
	public static final Integer COLUMNA_F_FIN_P_DESCUENTO_PUB 		= 20;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_IMPORTE;
	}
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COLUMNA_ACTIVO)));
		
		// Si alguno de los precios está vacío, comprobar si existe anterior y pasarlo al histórico sin crear o actualizar ningún otro.
		
		//Si hay Valoracion = Precio Aprobado venta para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, COLUMNA_P_APROBADO_VENTA))){
			double valor = Double.parseDouble(exc.dameCelda(fila, COLUMNA_P_APROBADO_VENTA));

			actualizarCrearValoresPrecios(
					activo,
					DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA, 
					valor,
					exc.dameCelda(fila, COLUMNA_F_APROB_P_APROBADO_VENTA),
					exc.dameCelda(fila, COLUMNA_F_INI_PRECIO_APROB_VENTA),
					exc.dameCelda(fila, COLUMNA_F_FIN_PRECIO_APROB_VENTA)
			);
			//Actualizar el tipoComercialización del activo
			updaterState.updaterStateTipoComercializacion(activo);
		}
		
		//Si hay Valoracion = Precio Minimo para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, COLUMNA_P_MIN_AUTORIZADO))){
			double valor = Double.parseDouble(exc.dameCelda(fila, COLUMNA_P_MIN_AUTORIZADO));

			actualizarCrearValoresPrecios(
					activo,
					DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO, 
					valor,
					exc.dameCelda(fila, COLUMNA_F_APROB_P_MIN_AUTORIZADO),
					exc.dameCelda(fila, COLUMNA_F_INI_P_MIN_AUTORIZADO),
					exc.dameCelda(fila, COLUMNA_F_FIN_P_MIN_AUTORIZADO)
			);
		}
		
		//Si hay Valoracion = Precio Aprobado renta para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, COLUMNA_P_APROB_RENTA))){
			double valor = Double.parseDouble(exc.dameCelda(fila, COLUMNA_P_APROB_RENTA));

			
			actualizarCrearValoresPrecios(
					activo,
					DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA, 
					valor,
					exc.dameCelda(fila, COLUMNA_F_APROB_P_APROBADO_RENTA),
					exc.dameCelda(fila, COLUMNA_F_INI_P_APROBADO_RENTA),
					exc.dameCelda(fila, COLUMNA_F_FIN_P_APROBADO_RENTA)
			);
		}
		
		//Si hay Valoracion = Precio de Descuento Aprobado para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, COLUMNA_P_DESCUENTO_APROBADO))){
			double valor = Double.parseDouble(exc.dameCelda(fila, COLUMNA_P_DESCUENTO_APROBADO));

			actualizarCrearValoresPrecios(
					activo,
					DDTipoPrecio.CODIGO_TPC_DESC_APROBADO, 
					valor,
					exc.dameCelda(fila, COLUMNA_F_APROB_P_DESCUENTO_APROB),
					exc.dameCelda(fila, COLUMNA_F_INI_P_DESCUENTO_APROB),
					exc.dameCelda(fila, COLUMNA_F_FIN_P_DESCUENTO_APROB)
			);
		}
		
		//Si hay Valoracion = Precio de Descuento Publicado para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, COLUMNA_P_DESCUENTO_PUBLICADO))){
			double valor = Double.parseDouble(exc.dameCelda(fila, COLUMNA_P_DESCUENTO_PUBLICADO));
			
			actualizarCrearValoresPrecios(
					activo, 
					DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO, 
					valor,
					exc.dameCelda(fila, COLUMNA_F_APROB_P_DESCUENTO_PUB),
					exc.dameCelda(fila, COLUMNA_F_INI_P_DESCUENTO_PUB),
					exc.dameCelda(fila, COLUMNA_F_FIN_P_DESCUENTO_PUB)
			);
		}
		return new ResultadoProcesarFila();
		
	}
	
	private void actualizarCrearValoresPrecios(Activo activo, String codigoTipoPrecio,
			Double importe, String fechaAprobacionExcel, String fechaInicioExcel, String fechaFinExcel) throws ParseException{
		
		//Intenta ver si el activo tiene ya un precio del tipo indicado para actualizar
		//Se prevee la posibilidad de que exista mas de 1 tipo precio por activo, en ese caso solo se toma el ultimo insertado para evitar error
		//Funcionalmente (Precios v3.0)solo descuento puede tener mas de 1 registro x activo.
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", activo.getNumActivo());
		Filter filtroTipoPrecio = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", codigoTipoPrecio);
		Order orderIdDesc = new Order(OrderType.DESC,"id");
		
		List<ActivoValoraciones> activoValoracionesList = genericDao.getListOrdered(ActivoValoraciones.class, orderIdDesc, filtroActivo, filtroTipoPrecio);
		ActivoValoraciones activoValoracion = null;
		
		if (activoValoracionesList.size() > 0)
			activoValoracion = activoValoracionesList.get(0);
		
		//Preparamos un registro de valoraciones/precios, con los datos indicados en el excel
		DtoPrecioVigente dtoActivoValoracion = new DtoPrecioVigente();
		dtoActivoValoracion.setIdActivo(activo.getId());
		dtoActivoValoracion.setCodigoTipoPrecio(codigoTipoPrecio);
		dtoActivoValoracion.setImporte(importe);
		if(!Checks.esNulo(fechaFinExcel)){
			Date fechaFin = simpleDate.parse(fechaFinExcel);
			dtoActivoValoracion.setFechaFin(fechaFin);
		}
		if(!Checks.esNulo(fechaInicioExcel)){
			Date fechaInicio = simpleDate.parse(fechaInicioExcel);
			dtoActivoValoracion.setFechaInicio(fechaInicio);
		} else {
			dtoActivoValoracion.setFechaInicio(new Date());
		}
		if(!Checks.esNulo(fechaAprobacionExcel)){
			Date fechaAprobacion = simpleDate.parse(fechaAprobacionExcel);
			dtoActivoValoracion.setFechaAprobacion(fechaAprobacion);
		} else {
			if(DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo())) {
				dtoActivoValoracion.setFechaAprobacion(new Date());
			}
		}
		
		//El metodo saveActivoValoracion actualizara el importe y las fechas del precio existente (encontrado en activoValoracion
		// o crea uno nuevo si no existia ningun precio del tipo indicado.
		//El metodo se encarga tambien de actualizar el historico de precios
		activoApi.saveActivoValoracion(activo, activoValoracion, dtoActivoValoracion);
	}

	

}
