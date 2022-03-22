package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoValoraciones;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class TabActivoValoracionesPrecios implements TabActivoService {
    
	@Autowired
	private GenericAdapter adapter;	
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_VALORACIONES_PRECIOS};
	}
	
	
	public DtoActivoValoraciones getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		
		Calendar fecha = Calendar.getInstance();
		fecha.set(Calendar.HOUR_OF_DAY, 0);
		fecha.set(Calendar.MINUTE, 0);
		fecha.set(Calendar.SECOND, 0);
		fecha.add(Calendar.SECOND, -1);
        
        Date yesterday = fecha.getTime();

		
		DtoActivoValoraciones valoracionesDto = new DtoActivoValoraciones();
		
		BeanUtils.copyProperties(valoracionesDto, activo);
		
		if (activo.getAdjJudicial() != null && activo.getAdjJudicial().getAdjudicacionBien() != null) {
			BeanUtils.copyProperty(valoracionesDto, "importeAdjudicacion", activo.getAdjJudicial().getAdjudicacionBien().getImporteAdjudicacion());
		}
		
		if (activo.getAdjNoJudicial() != null) {
			BeanUtils.copyProperty(valoracionesDto, "valorAdquisicion", activo.getAdjNoJudicial().getValorAdquisicion());
		}
		
		if (activo.getGestorBloqueoPrecio() != null)
		{
			BeanUtils.copyProperty(valoracionesDto, "gestorBloqueoPrecio", activo.getGestorBloqueoPrecio().getApellidoNombre());
		}
		
		if (activo.getValoracion() != null)
		{
			
			for (int i = 0; i < activo.getValoracion().size(); i++)
			{
					ActivoValoraciones val = activo.getValoracion().get(i);
					
					if(!Checks.esNulo(val.getFechaFin()) && val.getFechaFin().before(yesterday)) {
						activoApi.deleteValoracionPrecioConGuardadoEnHistorico(val.getId(),true,false);
					} else {		
						
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("01") 
								&& !DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())) {
							BeanUtils.copyProperty(valoracionesDto, "vnc", val.getImporte());
							
						}else if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("25")){
							BeanUtils.copyProperty(valoracionesDto, "vnc", val.getImporte());
						}		
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("14"))
							beanUtilNotNull.copyProperty(valoracionesDto, "valorReferencia", val.getImporte());
										
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("16"))
							beanUtilNotNull.copyProperty(valoracionesDto, "valorAsesoramientoLiquidativo", val.getImporte());
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("17"))
							beanUtilNotNull.copyProperty(valoracionesDto, "vacbe", val.getImporte());
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("18"))
							beanUtilNotNull.copyProperty(valoracionesDto, "costeAdquisicion", val.getImporte());
							
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("19"))
							beanUtilNotNull.copyProperty(valoracionesDto, "fsvVenta", val.getImporte());
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("20"))
							beanUtilNotNull.copyProperty(valoracionesDto, "fsvRenta", val.getImporte());
	
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("11"))
							beanUtilNotNull.copyProperty(valoracionesDto, "valorEstimadoVenta", val.getImporte());
	
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("12"))
							beanUtilNotNull.copyProperty(valoracionesDto, "valorEstimadoRenta", val.getImporte());
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("24"))
							beanUtilNotNull.copyProperty(valoracionesDto, "deudaBruta", val.getImporte());
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("23")) 
							beanUtilNotNull.copyProperty(valoracionesDto, "valorRazonable", val.getImporte());
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("26"))
							beanUtilNotNull.copyProperty(valoracionesDto, "fsvVentaOrigen", val.getImporte());
						
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("27"))
							beanUtilNotNull.copyProperty(valoracionesDto, "fsvRentaOrigen", val.getImporte());
						
						if(!Checks.esNulo(val.getFechaVentaHaya())) {
							beanUtilNotNull.copyProperty(valoracionesDto, "fechaVentaHaya", val.getFechaVentaHaya());
						}
						
//						if(!Checks.esNulo(val.getLiquidez())) {
//							beanUtilNotNull.copyProperty(valoracionesDto, "liquidez", val.getLiquidez());
//						}
						
						/*
						 * valorLegalVpo se informa desde la Info administrativa
						if(val.getTipoPrecio() != null && val.getTipoPrecio().getCodigo().equalsIgnoreCase("09"))
							beanUtilNotNull.copyProperty(valoracionesDto, "valorLegalVpo", val.getImporte());*/
					}

				}
		}
		
		beanUtilNotNull.copyProperty(valoracionesDto, "vpo", !Checks.esNulo(activo.getVpo()) && activo.getVpo() == 1 ? true : false);
		if(valoracionesDto.getVpo()) {
			beanUtilNotNull.copyProperty(valoracionesDto, "valorLegalVpo", activo.getInfoAdministrativa().getMaxPrecioVenta());
		}
		
		if (activo.getTotalValorCatastralConst() != null)
		{
			beanUtilNotNull.copyProperty(valoracionesDto, "valorCatastralConstruccion", activo.getTotalValorCatastralConst());
		}
		
		if (activo.getTotalValorCatastralSuelo() != null)
		{
			beanUtilNotNull.copyProperty(valoracionesDto, "valorCatastralSuelo", activo.getTotalValorCatastralSuelo());					
		}
		
			
		if (!Checks.estaVacio(activo.getTasacion()))
		{
			ActivoTasacion tasacionMasReciente = activo.getTasacion().get(0);
			Date fechaValorTasacionMasReciente = new Date();
			if (tasacionMasReciente.getValoracionBien().getFechaValorTasacion() != null)
			{
				fechaValorTasacionMasReciente = tasacionMasReciente.getValoracionBien().getFechaValorTasacion();
			}
			for (int i = 0; i < activo.getTasacion().size(); i++)
			{
					ActivoTasacion tas = activo.getTasacion().get(i);
					if (tas.getValoracionBien().getFechaValorTasacion() != null)
					{
						if (tas.getValoracionBien().getFechaValorTasacion().after(fechaValorTasacionMasReciente))
						{
							fechaValorTasacionMasReciente = tas.getValoracionBien().getFechaValorTasacion();
							tasacionMasReciente = tas;
						}
					}
			}
			beanUtilNotNull.copyProperty(valoracionesDto, "importeValorTasacion", tasacionMasReciente.getImporteTasacionFin());
			beanUtilNotNull.copyProperty(valoracionesDto, "fechaValorTasacion", tasacionMasReciente.getValoracionBien().getFechaValorTasacion());
			if (tasacionMasReciente.getTipoTasacion() != null){
				beanUtilNotNull.copyProperty(valoracionesDto, "tipoTasacionDescripcion", tasacionMasReciente.getTipoTasacion().getDescripcion());
			}
			
		}
		
		List<VBusquedaActivosPrecios> listaActivos = activoDao.getListActivosPreciosFromListId(activo.getId().toString());
		
		if(!Checks.estaVacio(listaActivos)) {
			VBusquedaActivosPrecios activoPrecio = listaActivos.get(0);
			valoracionesDto.setIncluidoBolsaPreciar(Checks.esNulo(activoPrecio.getFechaRepreciar()));
			valoracionesDto.setIncluidoBolsaRepreciar(!Checks.esNulo(activoPrecio.getFechaRepreciar()));
		}
		
		if(!Checks.esNulo(activo.getValorLiquidez())) {
			beanUtilNotNull.copyProperty(valoracionesDto, "liquidez", activo.getValorLiquidez());
		}
		
		ActivoCaixa actCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		
		if (actCaixa != null) {
			if (actCaixa.getPrecioVentaNegociable() != null) {
				valoracionesDto.setPrecioVentaNegociable(actCaixa.getPrecioVentaNegociable());
			}
			if (actCaixa.getPrecioAlquilerNegociable() != null) {
				valoracionesDto.setPrecioAlquilerNegociable(actCaixa.getPrecioAlquilerNegociable());
			}
			if (actCaixa.getCampanyaPrecioAlquilerNegociable() != null) {
				valoracionesDto.setCampanyaPrecioAlquilerNegociable(actCaixa.getCampanyaPrecioAlquilerNegociable());
			}
			if (actCaixa.getCampanyaPrecioVentaNegociable() != null) {
				valoracionesDto.setCampanyaPrecioVentaNegociable(actCaixa.getCampanyaPrecioVentaNegociable());
			}
		}

		return valoracionesDto;	
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {

		DtoActivoValoraciones dto = (DtoActivoValoraciones) webDto;
				
		if (dto.getBloqueoPrecio() != null)
		{
			if (dto.getBloqueoPrecio() > 0)
			{
				activo.setBloqueoPrecioFechaIni(new Date());
				Usuario usuarioLogado = adapter.getUsuarioLogado();
				activo.setGestorBloqueoPrecio(usuarioLogado);
			}
			else
			{
				activo.setBloqueoPrecioFechaIni(null);
				activo.setGestorBloqueoPrecio(null);
			}
		}
		
		return activo;
		
	}

}
