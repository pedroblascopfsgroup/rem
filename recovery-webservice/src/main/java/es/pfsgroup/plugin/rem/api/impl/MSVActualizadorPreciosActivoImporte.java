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
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_IMPORTE;
	}
	
	@Override
	@Transactional(readOnly = false)	
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		
		// Si alguno de los precios está vacío, comprobar si existe anterior y pasarlo al histórico sin crear o actualizar ningún otro.
		
		//Si hay Valoracion = Precio Aprobado venta para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, 1))){
			double valor = Double.parseDouble(exc.dameCelda(fila, 1));

			actualizarCrearValoresPrecios(activo,
					DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA, 
					valor,
					exc.dameCelda(fila, 2),
					exc.dameCelda(fila, 3));
			//Actualizar el tipoComercialización del activo
			updaterState.updaterStateTipoComercializacion(activo);
		}
		
		//Si hay Valoracion = Precio Minimo para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, 4))){
			double valor = Double.parseDouble(exc.dameCelda(fila, 4));

			actualizarCrearValoresPrecios(activo,
					DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO, 
					valor,
					exc.dameCelda(fila, 5),
					exc.dameCelda(fila, 6));
		}
		
		//Si hay Valoracion = Precio Aprobado renta para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, 7))){
			double valor = Double.parseDouble(exc.dameCelda(fila, 7));

			
			actualizarCrearValoresPrecios(activo,
					DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA, 
					valor,
					exc.dameCelda(fila, 8),
					exc.dameCelda(fila, 9));
		}
		
		//Si hay Valoracion = Precio de Descuento Aprobado para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, 10))){
			double valor = Double.parseDouble(exc.dameCelda(fila, 10));

			actualizarCrearValoresPrecios(activo,
					DDTipoPrecio.CODIGO_TPC_DESC_APROBADO, 
					valor,
					exc.dameCelda(fila, 11),
					exc.dameCelda(fila, 12));
		}
		
		//Si hay Valoracion = Precio de Descuento Publicado para actualizar o crear
		if(!Checks.esNulo(exc.dameCelda(fila, 13))){
			double valor = Double.parseDouble(exc.dameCelda(fila, 13));
		    
			actualizarCrearValoresPrecios(activo,
					DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO, 
					valor,
					exc.dameCelda(fila, 14),
					exc.dameCelda(fila, 15));
		}
		return new ResultadoProcesarFila();
		
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
		if(!Checks.esNulo(fechaInicioExcel)){
			Date fechaInicio = simpleDate.parse(fechaInicioExcel);
			dtoActivoValoracion.setFechaInicio(fechaInicio);
		} else {
			dtoActivoValoracion.setFechaInicio(new Date());
		}
		
		//El metodo saveActivoValoracion actualizara el importe y las fechas del precio existente (encontrado en activoValoracion
		// o crea uno nuevo si no existia ningun precio del tipo indicado.
		//El metodo se encarga tambien de actualizar el historico de precios
		activoApi.saveActivoValoracion(activo, activoValoracion, dtoActivoValoracion);
	}

	

}
