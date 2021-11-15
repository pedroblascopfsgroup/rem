package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.VEsCondicionado;
import es.pfsgroup.plugin.rem.model.VSinInformeAprobadoRem;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateManager;

@Component
public class TabActivoCondicionantesDisponibilidad implements TabActivoService {
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Autowired
	private GenericABMDao genericDao;

	
	@Autowired
	private ActivoDao activoDao;


	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private UpdaterStateManager updaterStateManager;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD};
	}
	
	public DtoCondicionantesDisponibilidad getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		
		DtoCondicionantesDisponibilidad activoCondicionantesDisponibilidadDto = new DtoCondicionantesDisponibilidad();		
		
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		VCondicionantesDisponibilidad condicionantesDisponibilidad = (VCondicionantesDisponibilidad) genericDao
				.get(VCondicionantesDisponibilidad.class, idActivoFilter);
		VEsCondicionado vEsCondicionado = genericDao.get(VEsCondicionado.class, idActivoFilter);
		VSinInformeAprobadoRem vSinInforme = genericDao.get(VSinInformeAprobadoRem.class, idActivoFilter);
		
		if(!Checks.esNulo(condicionantesDisponibilidad)) {
			BeanUtils.copyProperties(activoCondicionantesDisponibilidadDto, condicionantesDisponibilidad);
		}
		if(!Checks.esNulo(vEsCondicionado)) {
			BeanUtils.copyProperty(activoCondicionantesDisponibilidadDto, "isCondicionado", vEsCondicionado.getIsCondicionado());
		}
		if(!Checks.esNulo(vSinInforme)) {
			BeanUtils.copyProperty(activoCondicionantesDisponibilidadDto, "sinInformeAprobadoREM", vSinInforme.getSinInformeAprobadoREM());
		}
		if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
			activoCondicionantesDisponibilidadDto.setCamposPropagablesUas(TabActivoService.TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD);
		}else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			activoCondicionantesDisponibilidadDto.setCamposPropagables(TabActivoService.TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD);
		}
		
		ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		
		if (activoCaixa != null) {
			if (activoCaixa.getPublicacionPortalPublicoVenta() != null) {
				activoCondicionantesDisponibilidadDto.setPublicacionPortalPublicoVenta(activoCaixa.getPublicacionPortalPublicoVenta());
			}
			if (activoCaixa.getPublicacionPortalPublicoAlquiler() != null) {
				activoCondicionantesDisponibilidadDto.setPublicacionPortalPublicoAlquiler(activoCaixa.getPublicacionPortalPublicoAlquiler());
			}
			if (activoCaixa.getPublicacionPortalInversorVenta() != null) {
				activoCondicionantesDisponibilidadDto.setPublicacionPortalInversorVenta(activoCaixa.getPublicacionPortalInversorVenta());
			}
			if (activoCaixa.getPublicacionPortalInversorAlquiler() != null) {
				activoCondicionantesDisponibilidadDto.setPublicacionPortalInversorAlquiler(activoCaixa.getPublicacionPortalInversorAlquiler());
			}
			if (activoCaixa.getPublicacionPortalApiVenta() != null) {
				activoCondicionantesDisponibilidadDto.setPublicacionPortalApiVenta(activoCaixa.getPublicacionPortalApiVenta());
			}
			if (activoCaixa.getPublicacionPortalApiAlquiler() != null) {
				activoCondicionantesDisponibilidadDto.setPublicacionPortalApiAlquiler(activoCaixa.getPublicacionPortalApiAlquiler());
			}
			
		}
		
		return activoCondicionantesDisponibilidadDto;
	}

	@Transactional(readOnly=false)
	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		
		String codigo = null;
		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
		
		if(activoApi.isActivoVendido(activo)) {
			codigo = DDSituacionComercial.CODIGO_VENDIDO;
		}
		else if(!Checks.esNulo(perimetro) && !Checks.esNulo(perimetro.getAplicaComercializar()) && perimetro.getAplicaComercializar() == 0) {
			codigo = DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE;
		}
		else if(activoApi.isActivoConReservaByEstado(activo,DDEstadosReserva.CODIGO_FIRMADA)) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_RESERVA;
		}
		else if(activoApi.isActivoConOfertaByEstado(activo,DDEstadoOferta.CODIGO_ACEPTADA)) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA;
		}
		else if(activoApi.getCondicionantesDisponibilidad(activo.getId()).getIsCondicionado()) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_CONDICIONADO;
		}
		else if (!Checks.esNulo(activo.getTipoComercializacion())) {
			switch(Integer.parseInt(activo.getTipoComercializacion().getCodigo())) {
				case 1:
					codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA;
					break;
				case 2:
					codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_ALQUILER;
					break;
				case 3:
					codigo = DDSituacionComercial.CODIGO_DISPONIBLE_ALQUILER;
					break;
				default:
					break;
			}
		} else {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA;
		}
		
		String codigoSituacion = codigo;
		
		if(!Checks.esNulo(codigoSituacion)) {
			activo.setSituacionComercial((DDSituacionComercial)utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class,codigoSituacion));
		}
		
		return activo;
	}
}
