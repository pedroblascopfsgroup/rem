package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonio;

@Component
public class TabActivoPatrimonio implements TabActivoService {
	
	@Autowired
	private GenericABMDao genericDao;
    
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
		
		BeanUtils.copyProperties(activoPatrimonioDto, activo);

		return activoPatrimonioDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoPatrimonio activoPatrimonioDto = (DtoActivoPatrimonio) dto;
		ActivoPatrimonio activoPatrimonio = new ActivoPatrimonio();
		try {
			BeanUtils.copyProperties(activoPatrimonioDto,activoPatrimonio);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
		
		return null;
	}

}
