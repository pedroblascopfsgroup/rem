package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;

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
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPlusvalia;
import es.pfsgroup.plugin.rem.model.DtoActivoPlusvalia;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


@Component
public class TabActivoPlusvalia implements TabActivoService {

	protected static final Log logger = LogFactory.getLog(TabActivoPlusvalia.class);
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoDao gastoDao; 
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_PLUSVALIA};
	}

	public DtoActivoPlusvalia getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		
		DtoActivoPlusvalia activoPlusvaliaDto = new DtoActivoPlusvalia();
		
		ActivoPlusvalia activoPlusvalia = activoDao.getPlusvaliaByIdActivo(activo.getId());
		
		if(!Checks.esNulo(activoPlusvalia)) {
			if(!Checks.esNulo(activoPlusvalia)) {
				BeanUtils.copyProperties(activoPlusvaliaDto, activoPlusvalia);
			}
			
			if(!Checks.esNulo(activoPlusvalia.getId())) {
				activoPlusvaliaDto.setIdPlusvalia(activoPlusvalia.getId());
			}
			
			if(!Checks.esNulo(activoPlusvalia.getActivo())) {
				activoPlusvaliaDto.setIdActivo(activoPlusvalia.getActivo().getId());
			}
			
			if(!Checks.esNulo(activoPlusvalia.getGastoProveedor())) {
				activoPlusvaliaDto.setIdGasto(activoPlusvalia.getGastoProveedor().getId());
				activoPlusvaliaDto.setNumGastoHaya(activoPlusvalia.getGastoProveedor().getNumGastoHaya());
			}
			
			if(!Checks.esNulo(activoPlusvalia.getAperturaSeguimientoExp())) {
				activoPlusvaliaDto.setAperturaSeguimientoExp(activoPlusvalia.getAperturaSeguimientoExp().getCodigo());
			}
			
			if(!Checks.esNulo(activoPlusvalia.getMinusvalia())) {
				activoPlusvaliaDto.setMinusvalia(activoPlusvalia.getMinusvalia().getCodigo());
			}
			
			if(!Checks.esNulo(activoPlusvalia.getExento())) {
				activoPlusvaliaDto.setExento(activoPlusvalia.getExento().getCodigo());
			}
			
			if(!Checks.esNulo(activoPlusvalia.getAutoliquidacion())) {
				activoPlusvaliaDto.setAutoliquidacion(activoPlusvalia.getAutoliquidacion().getCodigo());
			}
		}
		
		return activoPlusvaliaDto;
	}
	
	@Transactional()
	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoPlusvalia activoPlusvaliaDto = (DtoActivoPlusvalia) dto;
		DDSinSiNo codSiNo = new DDSinSiNo();
		ActivoPlusvalia activoPlusvalia = genericDao.get(ActivoPlusvalia.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		
		if(Checks.esNulo(activoPlusvalia)) {
			activoPlusvalia = new ActivoPlusvalia();			
		}
		
		activoPlusvalia.setActivo(activo);
		
		if(!Checks.esNulo(activoPlusvaliaDto.getIdPlusvalia())) {
			activoPlusvalia.setId(activoPlusvaliaDto.getIdPlusvalia());
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getDateRecepcionPlus())) {
			activoPlusvalia.setDateRecepcionPlus(activoPlusvaliaDto.getDateRecepcionPlus());
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getDatePresentacionPlus())) {
			activoPlusvalia.setDatePresentacionPlus(activoPlusvaliaDto.getDatePresentacionPlus());
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getDatePresentacionRecu())) {
			activoPlusvalia.setDatePresentacionRecu(activoPlusvaliaDto.getDatePresentacionRecu());
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getDateRespuestaRecu())) {
			activoPlusvalia.setDateRespuestaRecu(activoPlusvaliaDto.getDateRespuestaRecu());
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getAperturaSeguimientoExp())) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoPlusvaliaDto.getAperturaSeguimientoExp());
			codSiNo = (DDSinSiNo) genericDao.get(DDSinSiNo.class, filtro);
			activoPlusvalia.setAperturaSeguimientoExp(codSiNo);

		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getImportePagado())) {
			activoPlusvalia.setImportePagado(new BigDecimal(activoPlusvaliaDto.getImportePagado()));
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getNumGastoHaya())) {
			GastoProveedor gasto = gastoDao.getGastoPorNumeroGastoHaya(activoPlusvaliaDto.getNumGastoHaya());
			activoPlusvalia.setGastoProveedor(gasto);
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getMinusvalia())) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoPlusvaliaDto.getMinusvalia());
				codSiNo = (DDSinSiNo) genericDao.get(DDSinSiNo.class, filtro);
				activoPlusvalia.setMinusvalia(codSiNo);
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getExento())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoPlusvaliaDto.getExento());
				codSiNo = (DDSinSiNo) genericDao.get(DDSinSiNo.class, filtro);
				activoPlusvalia.setExento(codSiNo);
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getAutoliquidacion())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoPlusvaliaDto.getAutoliquidacion());
				codSiNo = (DDSinSiNo) genericDao.get(DDSinSiNo.class, filtro);
				activoPlusvalia.setAutoliquidacion(codSiNo);
		}
		
		if(!Checks.esNulo(activoPlusvaliaDto.getObservaciones())) {
			activoPlusvalia.setObservaciones(activoPlusvaliaDto.getObservaciones());

		}
	
		
		genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
		
		return activo;
	}
}
