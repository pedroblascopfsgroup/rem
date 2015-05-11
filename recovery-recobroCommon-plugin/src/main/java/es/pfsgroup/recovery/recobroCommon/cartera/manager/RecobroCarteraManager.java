package es.pfsgroup.recovery.recobroCommon.cartera.manager;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.recobroCommon.cartera.api.RecobroCarteraApi;
import es.pfsgroup.recovery.recobroCommon.cartera.dao.RecobroCarteraDao;
import es.pfsgroup.recovery.recobroCommon.cartera.dto.RecobroDtoCartera;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.CarteraCommonConstants;

@Component
public class RecobroCarteraManager implements RecobroCarteraApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private RecobroCarteraDao carteraDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	@Override
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_GET_ESQUEMAS_BO)
	public List<RecobroEsquema> listaEsquemas() {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"nombre");
		List<RecobroEsquema> listaEsquemas = genericDao.getListOrdered(RecobroEsquema.class, order, filtro);
		return listaEsquemas;
	}
	
	@Override
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_BUSCAR_CARTERAS_BO)
	public Page buscaCarteras(RecobroDtoCartera dto) {
		Page listaCarteras = carteraDao.buscaCarteras(dto);
		return listaCarteras;
	}


	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_ALTA_CARTERAS_BO)
	public void altaCartera(RecobroDtoCartera dto) {
		
		if (!Checks.esNulo(dto)){
			RecobroCartera cartera= null;
			if (!Checks.esNulo(dto.getId())){
				cartera = this.getCartera(Long.valueOf(dto.getId()));
			} else {
				cartera = new RecobroCartera();
			}
			cartera.setNombre(dto.getNombre());
			cartera.setDescripcion(dto.getDescripcion());
			cartera.setFechaAlta(new Date());
						
			Long id = Long.parseLong(dto.getIdRegla()); 
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", id);
			RuleDefinition regla = genericDao.get(RuleDefinition.class, f1);
			cartera.setRegla(regla);
			
			RecobroDDEstadoComponente estado = (RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
			cartera.setEstado(estado);
			cartera.setPropietario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());

			carteraDao.saveOrUpdate(cartera);
			
		} else {
			throw new BusinessOperationException("No se ha pasado el dto de alta de cartera que se quiere dar de alta");
		}
		
	}


	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_ELIMINAR_CARTERAS_BO)
	public void eliminarCartera(Long idCartera) {
		if (!Checks.esNulo(idCartera)){
			 carteraDao.deleteById(idCartera);
		} else {
			throw new BusinessOperationException("El id de la cartera a eliminar no puede ser null");
		}
	}


	@Override
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_GET_CARTERAS_BO)
	public RecobroCartera getCartera(Long idCartera) {
		if (!Checks.esNulo(idCartera)){
			RecobroCartera cartera = carteraDao.get(idCartera);
			return cartera;
		} else {
			throw new BusinessOperationException("El id de la cartera a mostrar no puede ser null");
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_COPIAR_CARTERAS_BO)
	@Transactional(readOnly=false)
	public void copiarRecobroCartera(Long id) {
		RecobroCartera cartera = this.getCartera(id);
		this.altaCartera(creaDtoCopiaCartera(cartera));
	}

	private RecobroDtoCartera creaDtoCopiaCartera(RecobroCartera cartera) {
		RecobroDtoCartera dto = new RecobroDtoCartera();
		String[] nombreCopia = cartera.getNombre().split("_");
		dto.setNombre(nombreCopia[0]+"_COPIA_"+(new SimpleDateFormat("_ddMMyyyy_HHmmss").format(new Date())));
		dto.setDescripcion(cartera.getDescripcion());
		dto.setIdRegla(cartera.getRegla().getId().toString());
		return dto;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_CAMBIARESTADO_CARTERAS_BO)
	@Transactional(readOnly=false)
	public void cambiarEstadoCartera(Long id, String codigoEstado) {
		RecobroCartera cartera = this.getCartera(id);
		RecobroDDEstadoComponente estado = (RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, codigoEstado);
		if (!Checks.esNulo(cartera) && !Checks.esNulo(estado)){
			cartera.setEstado(estado);
			carteraDao.save(cartera);
		}
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_BUSCAR_CARTERASDISPONIBLES_BO)
	public Page buscaCarterasDisponibles(RecobroDtoCartera dto) {
		Page listaCarteras = carteraDao.buscaCarterasDisponibles(dto);
		return listaCarteras;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_GETLIST_BO)
	public List<RecobroCartera> getList() {		
		return carteraDao.getList();
	}	

}
