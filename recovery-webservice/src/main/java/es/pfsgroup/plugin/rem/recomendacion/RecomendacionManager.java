package es.pfsgroup.plugin.rem.recomendacion;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.RecomendacionApi;
import es.pfsgroup.plugin.rem.model.ConfiguracionRecomendacion;
import es.pfsgroup.plugin.rem.model.DtoConfiguracionRecomendacion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDRecomendacionRCDC;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.recomendacion.dao.RecomendacionDao;

@Service("recomendacionManager")
public class RecomendacionManager extends BusinessOperationOverrider<RecomendacionApi> implements RecomendacionApi {

	protected static final Log logger = LogFactory.getLog(RecomendacionManager.class);
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private RecomendacionDao recomendacionDao;
	
	@Override
	public String managerName() {
		return "recomendacionManager";
	}
	
	@Override
	public List<DtoConfiguracionRecomendacion> getConfiguracionesRecomendacion() {
		
		List<ConfiguracionRecomendacion> lista = genericDao.getList(ConfiguracionRecomendacion.class);
   		List<DtoConfiguracionRecomendacion> listaRecomendaciones = new ArrayList<DtoConfiguracionRecomendacion>();
   		
		for(ConfiguracionRecomendacion recomendacion: lista) {
			listaRecomendaciones.add(configRecomendacionToDto(recomendacion));			
		}		
		return listaRecomendaciones;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveConfigRecomendacion(DtoConfiguracionRecomendacion dtoConfiguracionRecomendacion) {
		
		ConfiguracionRecomendacion configRecomendacion = dtoToConfiguracionRecomendacion(dtoConfiguracionRecomendacion);
		
		if(configRecomendacion != null) {
			genericDao.save(ConfiguracionRecomendacion.class, configRecomendacion);
			return true;
		}
		return false;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteConfigRecomendacion(DtoConfiguracionRecomendacion dtoConfiguracionRecomendacion) {
		
		recomendacionDao.deleteConfigRecomendacionById(Long.parseLong(dtoConfiguracionRecomendacion.getId()));
		return true;
	}
	
	private DtoConfiguracionRecomendacion configRecomendacionToDto(ConfiguracionRecomendacion recomendacion) {
		
		DtoConfiguracionRecomendacion dto = new DtoConfiguracionRecomendacion();
		
		try {
			
			beanUtilNotNull.copyProperty(dto, "id", recomendacion.getId());
			if(recomendacion.getCartera() != null) {
				beanUtilNotNull.copyProperty(dto, "cartera", recomendacion.getCartera().getDescripcion());
			}
			if(recomendacion.getSubcartera() != null) {
				beanUtilNotNull.copyProperty(dto, "subcartera", recomendacion.getSubcartera().getDescripcion());
			}
			if(recomendacion.getTipoComercializacion() != null) {
				beanUtilNotNull.copyProperty(dto, "tipoComercializacion", recomendacion.getTipoComercializacion().getDescripcion());
			}
			if(recomendacion.getEquipoGestion() != null) {
				beanUtilNotNull.copyProperty(dto, "equipoGestion", recomendacion.getEquipoGestion().getDescripcion());
			}
			beanUtilNotNull.copyProperty(dto, "porcentajeDescuento", recomendacion.getPorcentajeDescuento());
			beanUtilNotNull.copyProperty(dto, "importeMinimo", recomendacion.getImporteMinimo());
			if(recomendacion.getRecomendacionRCDC() != null) {
				beanUtilNotNull.copyProperty(dto, "recomendacionRCDC", recomendacion.getRecomendacionRCDC().getDescripcion());
			}
			
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		
		return dto;
		
	}
	
	private ConfiguracionRecomendacion dtoToConfiguracionRecomendacion(DtoConfiguracionRecomendacion dto) {
		
		ConfiguracionRecomendacion configRecomendacion = null;
		
		if(dto != null && dto.getId() != null && !dto.getId().contains("ConfigRecomendacion")) {
			configRecomendacion = genericDao.get(ConfiguracionRecomendacion.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId())));
		}
		
		try {
			if (Checks.esNulo(configRecomendacion)) configRecomendacion = new ConfiguracionRecomendacion();
				
			if(dto.getCartera() != null) {
				DDCartera cartera = genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCartera()));
				if(cartera != null)
					beanUtilNotNull.copyProperty(configRecomendacion, "cartera", cartera);
			}	
			
			if(dto.getSubcartera() != null) {
				DDSubcartera subcartera = genericDao.get(DDSubcartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getSubcartera()));
				if(subcartera != null)
					beanUtilNotNull.copyProperty(configRecomendacion, "subcartera", subcartera);
			}
			
			if(dto.getTipoComercializacion() != null) {
				DDTipoComercializacion tipoComercializacion = genericDao.get(DDTipoComercializacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoComercializacion()));
				if(tipoComercializacion != null)
					beanUtilNotNull.copyProperty(configRecomendacion, "tipoComercializacion", tipoComercializacion);
			}
			
			if(dto.getEquipoGestion() != null) {
				DDEquipoGestion equipoGestion = genericDao.get(DDEquipoGestion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEquipoGestion()));
				if(equipoGestion != null)
					beanUtilNotNull.copyProperty(configRecomendacion, "equipoGestion", equipoGestion);
			}
			
			if(dto.getPorcentajeDescuento() != null) beanUtilNotNull.copyProperty(configRecomendacion, "porcentajeDescuento", dto.getPorcentajeDescuento());
			
			if(dto.getImporteMinimo() != null) beanUtilNotNull.copyProperty(configRecomendacion, "importeMinimo", dto.getImporteMinimo());
			
			if(dto.getRecomendacionRCDC() != null) {
				DDRecomendacionRCDC recomendacion = genericDao.get(DDRecomendacionRCDC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getRecomendacionRCDC()));
				if(recomendacion != null)
					beanUtilNotNull.copyProperty(configRecomendacion, "recomendacionRCDC", recomendacion);
			}
			
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		
		return configRecomendacion;
		
	}

}