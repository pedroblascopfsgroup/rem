package es.pfsgroup.recovery.recobroCommon.ranking.manager.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroModeloDeRankingDao;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloDeRankingDto;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloRankingVariableDto;
import es.pfsgroup.recovery.recobroCommon.ranking.manager.api.RecobroModeloDeRankingApi;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroDDVariableRanking;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloRankingVariable;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonModeloDeRankingConstants;

@Component
public class RecobroModeloDeRankingManager implements RecobroModeloDeRankingApi{
	
	@Autowired
	private RecobroModeloDeRankingDao recobroModeloDeRankingDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private AbstractMessageSource ms = MessageUtils.getMessageSource();

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_GETLIST_BO)
	public List<RecobroModeloDeRanking> getListaModelosDeRanking() {
		return recobroModeloDeRankingDao.getModelosDSPoBLQ();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_GET_BO)
	public RecobroModeloDeRanking getModeloDeRanking(Long idModeloRanking) {
		return recobroModeloDeRankingDao.get(idModeloRanking);
	}

	/**
	 * {@inheritDoc}
	 * @return 
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_SAVEMODELORANKING_BO)
	@Transactional(readOnly=false)
	public Long saveModeloRanking(RecobroModeloDeRankingDto dto) {
		RecobroModeloDeRanking ranking;
		if (!Checks.esNulo(dto.getId())){
			ranking = this.getModeloDeRanking(dto.getId());
		} else {
			ranking = new RecobroModeloDeRanking();
		}
		ranking.setNombre(dto.getNombre());
		ranking.setEstado((RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION));
		Usuario propietario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		ranking.setPropietario(propietario);
		
		return recobroModeloDeRankingDao.save(ranking);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_BUSCARMODELORANKING_BO)
	public Page buscarModelosRanking(RecobroModeloDeRankingDto dto) {
		return recobroModeloDeRankingDao.buscarModelosRanking(dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_ASOCIAVARIABLE_BO)
	@Transactional(readOnly=false)
	public void asociarVariableRankingModelo(RecobroModeloRankingVariableDto dto) {
		if (!Checks.esNulo(dto.getIdModelo())){
			RecobroModeloRankingVariable variable;
			if (!Checks.esNulo(dto.getIdVariable())){
				variable = this.getModeloRankingVariable(dto.getIdVariable());
			} else {
				variable = new RecobroModeloRankingVariable();
				RecobroModeloDeRanking modelo = this.getModeloDeRanking(dto.getIdModelo());
				if (!Checks.esNulo(modelo.getModeloRankingVariables())){
					for(RecobroModeloRankingVariable v : modelo.getModeloRankingVariables()){
						if (v.getVariableRanking().getCodigo().equals(dto.getTipoVariable())){
							throw new BusinessOperationException("Esa variable ya está asociada a este modelo");
						}
					}
				}	
				variable.setModeloDeRanking(modelo);
				
			}
			variable.setCoeficiente(dto.getCoeficiente());
			if (!Checks.esNulo(dto.getTipoVariable())){
				RecobroDDVariableRanking tipoVariable = (RecobroDDVariableRanking) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDVariableRanking.class, dto.getTipoVariable());
				variable.setVariableRanking(tipoVariable);
			} else {
				throw new BusinessOperationException("El tipo de variable no puede ser null");
			}
			genericDao.save(RecobroModeloRankingVariable.class, variable);
		} else {
			throw new BusinessOperationException("El id del modelo no puede ser null");
		}
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_GET_VARIABLE_BO)
	public RecobroModeloRankingVariable getModeloRankingVariable(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		return genericDao.get(RecobroModeloRankingVariable.class, filtro);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_DELETE_VARIABLERANKING_BO)
	@Transactional(readOnly=false)
	public void borrarVariableModeloRanking(Long idVariable) {
		genericDao.deleteById(RecobroModeloRankingVariable.class, idVariable);
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_DELETE_MODELORANKING_BO)
	@Transactional(readOnly=false)
	public void borrarModeloDeRanking(Long id) {
		RecobroModeloDeRanking modelo = this.getModeloDeRanking(id);
		if (Checks.estaVacio(modelo.getSubCarteras())){
			for (RecobroModeloRankingVariable variable : modelo.getModeloRankingVariables()){
				this.borrarVariableModeloRanking(variable.getId());
			}
		}else {
			throw new BusinessOperationException("No se puede borrar un modelo de ranking que esté asociado a un esquema");
		}
		
		recobroModeloDeRankingDao.deleteById(id);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_COPIAR_MODELORANKING_BO)
	@Transactional(readOnly=false)
	public void copiarModeloRanking(Long idModelo) {
		RecobroModeloDeRanking modelo = this.getModeloDeRanking(idModelo);
		RecobroModeloDeRankingDto dto = creaDtoCopiaModeloRanking(modelo);
		Long idCopia = this.saveModeloRanking(dto);
		RecobroModeloDeRanking copia = this.getModeloDeRanking(idCopia);
		copiaVariablesRanking(modelo, copia);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_CAMBIAESTADO_MODELORANKING_BO)
	@Transactional(readOnly=false)
	public void cambiaEstadoModelo(Long idModelo,
			String codigoEstado) {
		RecobroModeloDeRanking modelo = this.getModeloDeRanking(idModelo);
		String error = validaCoherencia (modelo, codigoEstado);
		if (Checks.esNulo(error)){
			RecobroDDEstadoComponente estado = (RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, codigoEstado);
			if (!Checks.esNulo(modelo) && !Checks.esNulo(estado)){
				modelo.setEstado(estado);
				recobroModeloDeRankingDao.save(modelo);
			}
		} else{
			throw new BusinessOperationException(error);
		}	
			
	}

	

	private void copiaVariablesRanking(RecobroModeloDeRanking modelo,
			RecobroModeloDeRanking copia) {
		for (RecobroModeloRankingVariable variable: modelo.getModeloRankingVariables() ){
			 asociarVariableRankingModelo(creaDtoVariable(variable, copia));
		}
	}

	private RecobroModeloRankingVariableDto creaDtoVariable(
			RecobroModeloRankingVariable variable, RecobroModeloDeRanking copia) {
		RecobroModeloRankingVariableDto dto = new RecobroModeloRankingVariableDto();
		dto.setIdModelo(copia.getId());
		dto.setTipoVariable(variable.getVariableRanking().getCodigo());
		dto.setCoeficiente(variable.getCoeficiente());
		return dto;
	}

	private RecobroModeloDeRankingDto creaDtoCopiaModeloRanking(
			RecobroModeloDeRanking modelo) {
		RecobroModeloDeRankingDto dto = new RecobroModeloDeRankingDto();
		dto.setNombre(modelo.getNombre()+"COPIA_"+(new SimpleDateFormat("_ddMMyyyy_HHmmss").format(new Date())));
		return dto;
	}

	private String validaCoherencia(RecobroModeloDeRanking modelo,
			String codigoEstado) {
		String error= null;
		if(RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE.equals(codigoEstado)){
			if (Checks.esNulo(modelo.getModeloRankingVariables()) || Checks.estaVacio(modelo.getModeloRankingVariables()) ){
				error= ms.getMessage("plugin.recobroCommon.modeloRanking.validaVariables.sinVariablesDefinidas", new Object[] {}, "**Debe de definir al menos una variable de ranking antes de liberar", MessageUtils.DEFAULT_LOCALE);
			}
		}
		return error;
	}
	
}
