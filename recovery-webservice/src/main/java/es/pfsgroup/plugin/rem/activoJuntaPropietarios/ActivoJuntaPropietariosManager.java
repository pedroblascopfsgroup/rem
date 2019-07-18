package es.pfsgroup.plugin.rem.activoJuntaPropietarios;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.activoJuntaPropietarios.dao.ActivoJuntaPropietariosDao;
import es.pfsgroup.plugin.rem.api.ActivoJuntaPropietariosApi;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;


@Service("activoJuntaPropietariosManager")
public class ActivoJuntaPropietariosManager implements ActivoJuntaPropietariosApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoJuntaPropietariosDao activoJuntaPropietariosDao;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Override
	public ActivoJuntaPropietarios findOne(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);		
		return genericDao.get(ActivoJuntaPropietarios.class, filtro );
	}

	@Override
	public DtoPage getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios) {
	
		return activoJuntaPropietariosDao.getListJuntas(dtoActivoJuntaPropietarios);
	}
	
	@Override
	public Object getJuntaDto(Long id) {

		ActivoJuntaPropietarios junta = findOne(id);
		DtoActivoJuntaPropietarios dto = new DtoActivoJuntaPropietarios();

		try {
				
				if (!Checks.esNulo(junta)) {
					beanUtilNotNull.copyProperties(junta, dto);
					
					/*
					dto.setActivo(junta.getActivo());
					dto.setComunidad(junta.getComunidad());
					dto.setCuota(junta.getCuota());
					dto.setDerrama(junta.getDerrama());
					dto.setEstatutos(junta.getEstatutos());
					dto.setExtra(junta.getExtra());
					dto.setFechaAltaJunta(junta.getFechaAltaJunta());					
					dto.setImporte(junta.getImporte());
					dto.setIndicaciones(junta.getIndicaciones());
					dto.setIte(junta.getIte());
					dto.setJudicial(junta.getJudicial());
					dto.setJunta(junta.getJunta());
					dto.setMorosos(junta.getMorosos());
					dto.setOrdinaria(junta.getOrdinaria());
					dto.setOtros(junta.getOtros());
					dto.setPorcentaje(junta.getPorcentaje());
					dto.setPromo20a50(junta.getPromo20a50());
					dto.setPromoMayor50(junta.getPromoMayor50());
					dto.setPropuesta(junta.getPropuesta());
					dto.setSuministros(junta.getSuministros());
					dto.setVoto(junta.getVoto());				
				*/
			}
			

		} catch (Exception e) {
			logger.error(e.getMessage(),e);			
		}

		return dto;
	}
}
