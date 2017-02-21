package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class MSVActualizadorPropuestaPreciosActivoEntidad03 implements MSVLiberator {

	public static final int EXCEL_FILA_INICIAL = 8;
	public static final int EXCEL_COL_NUMACTIVO = 3;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UpdaterStateApi updaterState;

	SimpleDateFormat simpleDate = new SimpleDateFormat("dd/MM/yyyy");
	
//	private int numUltimaFila; // En esta excel, el último registro es un resumen, no se tiene en cuenta para validar
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD03.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException {
			
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
		
//		this.numUltimaFila = this.getNumFilasRealesHojaExcel(exc);

		try {
			//Cambiar estado de la propuesta, y asignarle fecha de carga
			activoApi.actualizarFechaYEstadoCargaPropuesta(Long.parseLong(exc.dameCeldaByHoja(1, 2, 1)));
			
//			for (int fila = EXCEL_FILA_INICIAL; fila <= this.numUltimaFila; fila++) {
			for (int fila = EXCEL_FILA_INICIAL; fila < exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL); fila++) {
				Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCeldaByHoja(fila, EXCEL_COL_NUMACTIVO, 1)));
				Boolean actualizatTipoComercializacionActivo = false;
				
				//Si hay Valoracion = Valor Neto Contable (VNC) actualizar o crear -- Columna Q
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 16, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 16, 1)),
							null,
							null);
					actualizatTipoComercializacionActivo = true;
				}
				
				//Si hay Valoracion = Precio Aprobado venta (Precio Propuesto) para actualizar o crear -- Columna S
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 18, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 18, 1)),
							exc.dameCeldaByHoja(fila, 19, 1),
							exc.dameCeldaByHoja(fila, 20, 1));
					actualizatTipoComercializacionActivo = true;
				}
				
				//Si hay Valoracion = Precio Aprobado renta para actualizar o crear -- Columna Y
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 24, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 24, 1)),
							exc.dameCeldaByHoja(fila, 25, 1),
							exc.dameCeldaByHoja(fila, 26, 1));
				}
				
				//Si hay Valoracion = Precio Minimo para actualizar o crear -- Columna V
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 21, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 21, 1)),
							exc.dameCeldaByHoja(fila, 22, 1),
							exc.dameCeldaByHoja(fila, 23, 1));
				}
				/*
				//Si hay Valoracion = Precio de Descuento Aprobado para actualizar o crear
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 56))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_DESC_APROBADO, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 56)),
							exc.dameCeldaByHoja(fila, 57),
							exc.dameCeldaByHoja(fila, 58));
				}
				
				//Si hay Valoracion = Precio de Descuento Publicado para actualizar o crear
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 59))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 59)),
							exc.dameCeldaByHoja(fila, 60),
							exc.dameCeldaByHoja(fila, 61));
				}
				*/
				//Si hay Valoracion = Valor estimado de venta (Valor Colaborador) para actualizar o crear -- Columna L
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 11, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 11, 1)),
							exc.dameCeldaByHoja(fila, 10, 1),
							null);
				}

				//Si hay Valoracion = Valor de referencia (Valor Asesoramiento JLL) para actualizar o crear -- Columna P
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 15, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_VALOR_REFERENCIA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 15, 1)),
							exc.dameCeldaByHoja(fila, 14, 1),
							null);
				}

				//Si hay Valoracion = Precio de transferencia (VNC) para actualizar o crear -- Columna S
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 16, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_PT, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 16, 1)),
							null,
							null);
				}

				//Si hay Valoracion = Valor FSV Venta actualizar o crear -- Columna N
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 13, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_FSV_VENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 13, 1)),
							exc.dameCeldaByHoja(fila, 12, 1),
							null);
				}
				
				//Actualizar el tipoComercialización del activo
				if(actualizatTipoComercializacionActivo)
					updaterState.updaterStateTipoComercializacion(activo);
				
			}

		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return true;
	}
	
	private void actualizarCrearValoresPrecios(Activo activo, String codigoTipoPrecio,
			Double importe, String fechaInicioExcel, String fechaFinExcel) throws ParseException{
		
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
		if(Checks.esNulo(fechaInicioExcel)){
			dtoActivoValoracion.setFechaInicio(new Date());
		} else {
			Date fechaInicio = simpleDate.parse(fechaInicioExcel);
			dtoActivoValoracion.setFechaInicio(fechaInicio);
		}
		
		//El metodo saveActivoValoracion actualizara el importe y las fechas del precio existente (encontrado en activoValoracion
		// o crea uno nuevo si no existia ningun precio del tipo indicado.
		//El metodo se encarga tambien de actualizar el historico de precios
		activoApi.saveActivoValoracion(activo, activoValoracion, dtoActivoValoracion);
	}
	
//	/**
//	 * Esta excel puede contener una fila RESUMEN en la última posición, y no se debe tener en cuenta 
//	 * para las validadciones.
//	 * @param exc
//	 * @return
//	 */
//	private Integer getNumFilasRealesHojaExcel(MSVHojaExcel exc) {
//		Integer ultimaFila = null;
//		
//		try {
//			ultimaFila = exc.getNumeroFilasByHoja(1) - 1;
//			if(exc.dameCeldaByHoja(ultimaFila, EXCEL_COL_NUMACTIVO, 1).isEmpty() && 
//					exc.dameCeldaByHoja(ultimaFila, 6, 1).contains("Activos:"))
//				ultimaFila--;
//		
//		} catch (IllegalArgumentException e) {
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		} catch (IOException e) {
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		
//		return ultimaFila;
//	}

}
