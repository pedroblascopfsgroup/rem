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


@Component
public class MSVActualizadorPreciosFSVActivoImporte implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;

	SimpleDateFormat simpleDate = new SimpleDateFormat("dd/MM/yyyy");
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_FSV_ACTIVO_IMPORTE.equals(tipoOperacion.getCodigo())){
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
			Integer numFilas = exc.getNumeroFilasByHoja(0,file.getProcesoMasivo().getTipoOperacion());
			for (int fila = getFilaInicial(); fila < numFilas; fila++) {
				Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
				
				//Si hay Valoracion = Precio FSV Venta
				if(!Checks.esNulo(exc.dameCelda(fila, 1))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_FSV_VENTA, 
							Double.parseDouble(exc.dameCelda(fila, 1)),
							null,
							null);
				}
				
				//Si hay Valoracion = Precio FSV Renta
				if(!Checks.esNulo(exc.dameCelda(fila, 2))){
					actualizarCrearValoresPrecios(activo,
							DDTipoPrecio.CODIGO_TPC_FSV_RENTA, 
							Double.parseDouble(exc.dameCelda(fila, 2)),
							null,
							null);
				}
				
			}

		} catch (ParseException e) {
			// TODO Auto-generated catch block
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

	@Override
	public int getFilaInicial() {
		return 1;
	}

}
