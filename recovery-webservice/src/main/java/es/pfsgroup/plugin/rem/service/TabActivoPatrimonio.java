package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoHistoricoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;

@Component
public class TabActivoPatrimonio implements TabActivoService {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;
	
	@Autowired
	private ActivoHistoricoPatrimonioDao activoHistoricoPatrimonioDao;
	
	@Autowired
	private ActivoDao activoDao;
    
	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_PATRIMONIO};
	}
	
	public DtoActivoPatrimonio getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		
		DtoActivoPatrimonio activoPatrimonioDto = new DtoActivoPatrimonio();
		
		ActivoPatrimonio activoP = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		if(!Checks.esNulo(activoP)) {
			BeanUtils.copyProperties(activoPatrimonioDto, activoP);
			if(!Checks.esNulo(activoP.getCheckHPM())) {
				activoPatrimonioDto.setChkPerimetroAlquiler(activoP.getCheckHPM());
			}
			if(!Checks.esNulo(activoP.getAdecuacionAlquiler())) {
				activoPatrimonioDto.setCodigoAdecuacion(activoP.getAdecuacionAlquiler().getCodigo());
				activoPatrimonioDto.setDescripcionAdecuacion(activoP.getAdecuacionAlquiler().getDescripcion());
				activoPatrimonioDto.setDescripcionAdecuacionLarga(activoP.getAdecuacionAlquiler().getDescripcionLarga());
			}
			if(!Checks.esNulo(activo.getTipoAlquiler())) {
				activoPatrimonioDto.setTipoAlquilerCodigo(activo.getTipoAlquiler().getCodigo());
			}
		}
		
		return activoPatrimonioDto;
	}

	@Transactional(readOnly=false)
	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoPatrimonio activoPatrimonioDto = (DtoActivoPatrimonio) dto;
		ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		ActivoHistoricoPatrimonio activoHistPatrimonio = new ActivoHistoricoPatrimonio();
		DDAdecuacionAlquiler adecuacionAlquiler = null;
		if(!Checks.esNulo(activoPatrimonioDto.getCodigoAdecuacion())) {
			adecuacionAlquiler = genericDao.get(DDAdecuacionAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo",activoPatrimonioDto.getCodigoAdecuacion()));
		}
		
		if(Checks.esNulo(activoPatrimonio)) {
			activoPatrimonio = new ActivoPatrimonio();
			
			activoHistPatrimonio.setActivo(activo);
			activoHistPatrimonio.setFechaInicioAdecuacionAlquiler(new Date());
			activoHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
			activoHistPatrimonio.setFechaInicioHPM(new Date());
			activoHistPatrimonio.setFechaFinHPM(new Date());

			activoPatrimonio.setActivo(activo);
			if(!Checks.esNulo(adecuacionAlquiler)) {
				activoPatrimonio.setAdecuacionAlquiler(adecuacionAlquiler);
			}
			activoPatrimonio.setCheckHPM(!Checks.esNulo(activoPatrimonioDto.getChkPerimetroAlquiler()) ? activoPatrimonioDto.getChkPerimetroAlquiler() : null);
			
			activoHistoricoPatrimonioDao.save(activoHistPatrimonio);
			
		}else{
		
			if(!Checks.esNulo(activoPatrimonioDto.getCodigoAdecuacion())) {
				
				if(!Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())) {
					activoHistPatrimonio.setAdecuacionAlquiler(activoPatrimonio.getAdecuacionAlquiler());
				}
				
				activoPatrimonio.setAdecuacionAlquiler(adecuacionAlquiler);
			}
			
			activoHistPatrimonio.setFechaInicioAdecuacionAlquiler(activoPatrimonio.getAuditoria().getFechaCrear());
			activoHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
			
			if(!Checks.esNulo(activoPatrimonioDto.getChkPerimetroAlquiler())) {
				activoHistPatrimonio.setCheckHPM(activoPatrimonio.getCheckHPM());
				activoPatrimonio.setCheckHPM(activoPatrimonioDto.getChkPerimetroAlquiler());
			}
			activoHistPatrimonio.setFechaInicioHPM(activoPatrimonio.getAuditoria().getFechaCrear());
			activoHistPatrimonio.setFechaFinHPM(new Date());

			activoHistPatrimonio.setActivo(activo);
			
			activoHistoricoPatrimonioDao.save(activoHistPatrimonio);
		}
		
		if(!Checks.esNulo(activoPatrimonioDto.getTipoAlquilerCodigo())){
			activo.setTipoAlquiler(genericDao.get(DDTipoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", activoPatrimonioDto.getTipoAlquilerCodigo())));
			activoDao.save(activo);
		}
		
		activoPatrimonioDao.save(activoPatrimonio);
		
		return activo;
	}

}
