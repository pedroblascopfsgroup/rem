package es.pfsgroup.recovery.recobroCommon.esquema.manager.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.recobroCommon.cartera.api.RecobroCarteraApi;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroCarteraEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroCarteraEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroCarteraEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDAmbitoExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoGestionCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;

@Component
public class RecobroCarteraEsquemaManager implements RecobroCarteraEsquemaApi{
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private RecobroCarteraEsquemaDao carteraEsquemaDao;

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_GET_BO)
	public RecobroCarteraEsquema getRecobroCarteraEsquema(Long idCarteraEsquema) {
		return carteraEsquemaDao.get(idCarteraEsquema);
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_DELETE_BO)
	@Transactional(readOnly=false)
	public void borrarRecobroCarteraEsquema(Long idCarteraEsquema) {
		RecobroCarteraEsquema carteraEsquema = carteraEsquemaDao.get(idCarteraEsquema);	
		RecobroCartera cartera= carteraEsquema.getCartera();
		int prioridadAnt = carteraEsquema.getPrioridad();
		carteraEsquema.setPrioridad(-1);
		carteraEsquemaDao.saveOrUpdate(carteraEsquema);
		carteraEsquemaDao.delete(carteraEsquema);
		
		int prioridad = carteraEsquemaDao.getMaxPrioridad(carteraEsquema.getEsquema().getId())+1;		
		carteraEsquemaDao.reorganizaPrioridades(carteraEsquema.getEsquema().getId(), carteraEsquema.getId(), prioridad , prioridadAnt);
		
		if (Checks.esNulo(cartera.getCarteraEsquemas()) || Checks.estaVacio(cartera.getCarteraEsquemas())){
			proxyFactory.proxy(RecobroCarteraApi.class).cambiarEstadoCartera(cartera.getId(), RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		}
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_SAVE_BO)
	@Transactional(readOnly=false)
	public void guardarRecobroCarteraEsquema(RecobroCarteraEsquemaDto dto) {
		RecobroCarteraEsquema carteraEsquema;
		int prioridadAnt = -1;
		if (Checks.esNulo(dto.getId())) {
			carteraEsquema = new RecobroCarteraEsquema();
		} else {
			carteraEsquema = carteraEsquemaDao.get(dto.getId());
			prioridadAnt = carteraEsquema.getPrioridad();
		}
		
		if (!Checks.esNulo(dto.getIdCartera())) {
			RecobroCartera cartera = proxyFactory.proxy(RecobroCarteraApi.class).getCartera(dto.getIdCartera());
			if (!Checks.esNulo(cartera)) carteraEsquema.setCartera(cartera);
		}
		
		if (!Checks.esNulo(dto.getIdEsquema())) {
			RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(dto.getIdEsquema());
			if (!Checks.esNulo(esquema)) carteraEsquema.setEsquema(esquema);
		}
		
		// si la cartera es de tipo filtro o de tipo gestión sin gestión se borran todas las subcarteras asociadas
		if (!Checks.esNulo(dto.getCodigoTipoCarteraEsquema())) {
			RecobroDDTipoCarteraEsquema tipoCartera = (RecobroDDTipoCarteraEsquema) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDTipoCarteraEsquema.class, dto.getCodigoTipoCarteraEsquema());
			if (!Checks.esNulo(tipoCartera)) {
				carteraEsquema.setTipoCarteraEsquema(tipoCartera);
				if (tipoCartera.getCodigo().equals(RecobroDDTipoCarteraEsquema.TIPO_CARTERA_FILTRO)){
					carteraEsquema.setTipoGestionCarteraEsquema(null);
					carteraEsquema.setAmbitoExpedienteRecobro(null);
					if (!Checks.esNulo(carteraEsquema.getSubcarteras())){
						for (RecobroSubCartera subcartera : carteraEsquema.getSubcarteras()){
							genericDao.deleteById(RecobroSubCartera.class, subcartera.getId());
						}
					}
				} else {
					if (!Checks.esNulo(dto.getIdTipoGestionCarteraEsquema())) {
						RecobroDDTipoGestionCartera tipoGestion = (RecobroDDTipoGestionCartera) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionario(RecobroDDTipoGestionCartera.class, dto.getIdTipoGestionCarteraEsquema());
						if (!Checks.esNulo(tipoGestion)) {
							carteraEsquema.setTipoGestionCarteraEsquema(tipoGestion);
							if (tipoGestion.getCodigo().equals(RecobroDDTipoGestionCartera.CODIGO_TIPO_SIN_GESTION)){
								if (!Checks.esNulo(carteraEsquema.getSubcarteras())){
									for (RecobroSubCartera subcartera : carteraEsquema.getSubcarteras()){
										genericDao.deleteById(RecobroSubCartera.class, subcartera.getId());
									}
								}
							}
						}
					}

					if (!Checks.esNulo(dto.getIdAmbitoExpedienteRecobro())) {
						RecobroDDAmbitoExpedienteRecobro ambito = (RecobroDDAmbitoExpedienteRecobro) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionario(RecobroDDAmbitoExpedienteRecobro.class, dto.getIdAmbitoExpedienteRecobro());
						if (!Checks.esNulo(ambito)) carteraEsquema.setAmbitoExpedienteRecobro(ambito);
					}
				}
			}
			
		}
		
		if (!Checks.esNulo(dto.getPrioridad())) {
			carteraEsquema.setPrioridad(dto.getPrioridad());
		}
		
		carteraEsquemaDao.saveOrUpdate(carteraEsquema);
		
		carteraEsquemaDao.reorganizaPrioridades(dto.getIdEsquema(), carteraEsquema.getId(), dto.getPrioridad(), prioridadAnt);
		
		proxyFactory.proxy(RecobroCarteraApi.class).cambiarEstadoCartera(carteraEsquema.getCartera().getId(), RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO); 

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_GET2_BO)
	public RecobroCarteraEsquema getRecobroCarteraEsquema(Long idEsquema, Long idCartera) {
		return carteraEsquemaDao.getCarteraEsquema(idEsquema, idCartera);
	}

}
