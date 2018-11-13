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
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
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
		
		if(!Checks.esNulo(condicionantesDisponibilidad)) {
			BeanUtils.copyProperties(activoCondicionantesDisponibilidadDto, condicionantesDisponibilidad);
		}
		
		activoCondicionantesDisponibilidadDto.setCamposPropagables(TabActivoService.TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD);
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
