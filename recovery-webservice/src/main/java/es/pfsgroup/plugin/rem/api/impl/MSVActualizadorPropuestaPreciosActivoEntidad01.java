package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
public class MSVActualizadorPropuestaPreciosActivoEntidad01 implements MSVLiberator {

	public static final int EXCEL_FILA_INICIAL = 6;
	public static final int EXCEL_COL_NUMACTIVO = 7;
	
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
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD01.equals(tipoOperacion.getCodigo())){
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

		try {
			//Cambiar estado de la propuesta, y asignarle fecha de carga
			activoApi.actualizarFechaYEstadoCargaPropuesta(Long.parseLong(exc.dameCeldaByHoja(1, 2, 1)));
			
			for (int fila = EXCEL_FILA_INICIAL; fila < exc.getNumeroFilasByHoja(1,EXCEL_FILA_INICIAL); fila++) {
				Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCeldaByHoja(fila, EXCEL_COL_NUMACTIVO, 1)));
				Boolean actualizatTipoComercializacionActivo = false;
				
				//Si hay Valoracion = Valor Neto Contable (VNC) actualizar o crear -- Columna AH
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 33, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 33, 1).replace(",", ".")),
							null,
							null);
					actualizatTipoComercializacionActivo = true;
				}
				
				//Si hay Valoracion = Precio Aprobado venta(Actual web) para actualizar o crear -- Columna BJ
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 61, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 61, 1).replace(",", ".")),
							exc.dameCeldaByHoja(fila, 62, 1),
							exc.dameCeldaByHoja(fila, 63, 1));
					actualizatTipoComercializacionActivo = true;
				}
				
				//Si hay Valoracion = Precio Aprobado renta para actualizar o crear -- Columna BM
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 64, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 64, 1).replace(",", ".")),
							exc.dameCeldaByHoja(fila, 65, 1),
							exc.dameCeldaByHoja(fila, 66, 1));
				}
				
				//Si hay Valoracion = Precio Minimo(Autorizado Cajamar) para actualizar o crear -- Columna BF
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 57, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 57, 1).replace(",", ".")),
							null,
							null);
				}
				/*
				 * Estos valores solo aparecen en la Propuesta UNIFICADA por ahora.
				 * 
				//Si hay Valoracion = Precio de Descuento Aprobado para actualizar o crear
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 56, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_DESC_APROBADO, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 56, 1).replace(",", ".")),
							exc.dameCeldaByHoja(fila, 57, 1),
							exc.dameCeldaByHoja(fila, 58, 1));
				}
				
				//Si hay Valoracion = Precio de Descuento Publicado para actualizar o crear
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 59, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 59, 1).replace(",", ".")),
							exc.dameCeldaByHoja(fila, 60, 1),
							exc.dameCeldaByHoja(fila, 61, 1));
				}
				*/
				
				//Si hay Valoracion = Valor estimado de venta(Valor Colaborador) para actualizar o crear -- Columna AF
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 31, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 31, 1).replace(",", ".")),
							exc.dameCeldaByHoja(fila, 32, 1),
							null);
				}

				//Si hay Valoracion = Precio de transferencia (PT) para actualizar o crear -- Columna AH
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 33, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_PT, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 33, 1).replace(",", ".")),
							null,
							null);
				}

				//Si hay Valoracion = Coste de adquisicion para actualizar o crear -- Columna AI
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 34, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_COSTE_ADQUISICION, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 34, 1).replace(",", ".")),
							null,
							null);
				}

				//Si hay Valoracion = Valor FSV Venta (Valor Haya) actualizar o crear -- Columna AD
				if(!Checks.esNulo(exc.dameCeldaByHoja(fila, 29, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_FSV_VENTA, 
							Double.parseDouble(exc.dameCeldaByHoja(fila, 29, 1).replace(",", ".")),
							exc.dameCeldaByHoja(fila, 30, 1),
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

}
