package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoActivo;
import es.pfsgroup.plugin.rem.model.DtoActivoAdministracion;
import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;

@Component
public class TabActivoCargas implements TabActivoService {
    
	@Autowired
	private ActivoCargasApi activoCargasApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

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

		// Establecemos el estado de las cargas manualmente.
		// if(activoCargasApi.esActivoConCargasNoCanceladasRegistral(activo.getId()) || activoCargasApi.esActivoConCargasNoCanceladasEconomica(activo.getId())) {
			
		if(activoDao.isUnidadAlquilable(activo.getId())) {
			ActivoAgrupacion actgagru = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			Activo activoM = activoApi.get(activoDao.getIdActivoMatriz(actgagru.getId()));
			if(activoCargasApi.esActivoConCargasNoCanceladas(activoM.getId())) {
				activoDto.setConCargas(1);
			} else {
				activoDto.setConCargas(0);
			}
		}
		else {
			if(activoCargasApi.esActivoConCargasNoCanceladas(activo.getId())) {
				activoDto.setConCargas(1);
			} else {
				activoDto.setConCargas(0);
			}
			
		}
			if(activoDao.isUnidadAlquilable(activo.getId())) {
				activoDto.setUnidadAlquilable(true);
			}else {
				activoDto.setUnidadAlquilable(false);
			}
		
		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
			if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
				activoDto.setCamposPropagablesUas(TabActivoService.TAB_CARGAS_ACTIVO);
			}else {
				// Buscamos los campos que pueden ser propagados para esta pestaña
				activoDto.setCamposPropagables(TabActivoService.TAB_CARGAS_ACTIVO);
			}
	
		return activoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {		
		return null;
	}

}
