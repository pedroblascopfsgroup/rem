package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;

@Component
public class TabActivoCargas implements TabActivoService {
    
	@Autowired
	private ActivoCargasApi activoCargasApi;


	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_CARGAS_ACTIVO};
	}
	
	public DtoActivoCargasTab getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		DtoActivoCargasTab activoDto = new DtoActivoCargasTab();
		BeanUtils.copyProperties(activoDto, activo);
		
		// Establecemos el estado de las cargas manualmente.
		if(activoCargasApi.esActivoConCargasNoCanceladas(activo.getId())) {
			activoDto.setConCargas(1);
		} else {
			activoDto.setConCargas(0);
		}
		
		return activoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		return null;
	}

}
