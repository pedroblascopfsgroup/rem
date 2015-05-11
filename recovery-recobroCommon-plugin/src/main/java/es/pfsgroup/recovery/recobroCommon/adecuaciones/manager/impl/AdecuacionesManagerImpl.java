package es.pfsgroup.recovery.recobroCommon.adecuaciones.manager.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dao.api.AdecuacionesDaoApi;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dto.AdecuacionesDto;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.manager.api.AdecuacionesApi;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.model.Adecuaciones;

/**
 * Implementación del manager de las adecuaciones
 * 
 * @author dgg
 * 
 */
@Component
public class AdecuacionesManagerImpl implements AdecuacionesApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private AdecuacionesDaoApi adecuacionesDao;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	@BusinessOperationDefinition(AdecuacionesApi.BO_EXP_GET_LISTADO_ADECUACIONES)
	public List<Adecuaciones> getListadoAdecuaciones(Long cntId) {
		
		return adecuacionesDao.getListadoAdecuaciones(cntId);
	}

	@Override
	@BusinessOperationDefinition(AdecuacionesApi.BO_EXP_GET_ADECUACION_BY_ID)
	public Adecuaciones getAdecuacionById(Long id) {
		
		return adecuacionesDao.getAdecuacionById(id);
	}

	@Override
	@BusinessOperationDefinition(AdecuacionesApi.BO_EXP_GET_LISTADO_ADECUACIONES_PAGE)
	public Page getListadoAdecuaciones(AdecuacionesDto dto) {

		return adecuacionesDao.getListadoAdecuaciones(dto);
	}
	


	

}
