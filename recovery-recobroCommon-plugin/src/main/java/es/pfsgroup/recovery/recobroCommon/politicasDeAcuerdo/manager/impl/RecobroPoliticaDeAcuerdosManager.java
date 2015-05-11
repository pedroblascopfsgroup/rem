package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.impl;

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
import es.capgemini.pfs.acuerdo.model.RecobroDDSubtipoPalanca;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dao.api.RecobroPoliticaDeAcuerdosDao;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaAcuerdosPalancaDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.api.RecobroPoliticaDeAcuerdosApi;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaAcuerdosPalanca;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonPoliticaDeAcuerdosConstants;

@Component
public class RecobroPoliticaDeAcuerdosManager implements RecobroPoliticaDeAcuerdosApi{
	
	@Autowired
	private RecobroPoliticaDeAcuerdosDao recobroPoliticaDeAcuerdosDao;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private AbstractMessageSource ms = MessageUtils.getMessageSource();
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_BUSCARPOLITICAS_BO)
	public Page buscaPoliticas(RecobroPoliticaDeAcuerdosDto dto) {
		return recobroPoliticaDeAcuerdosDao.buscaPoliticas(dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETPOLITICASDEACUERDO_BO)
	public List<RecobroPoliticaDeAcuerdos> getListaPoliticasDeAcuerdo() {
		return recobroPoliticaDeAcuerdosDao.getModelosDSPoBLQ();
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETPOLITICADEACUERDO_BO)
	public RecobroPoliticaDeAcuerdos getPoliticaDeAcuerdo(
			Long idPoliticaDeAcuerdo) {
		return recobroPoliticaDeAcuerdosDao.get(idPoliticaDeAcuerdo);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_SAVEPOLITICADEACUERDO_BO)
	@Transactional(readOnly=false)
	public Long savePolitica(
			RecobroPoliticaDeAcuerdosDto dto) {
		RecobroPoliticaDeAcuerdos politica=null;
		if (!Checks.esNulo(dto.getId())){
			politica = this.getPoliticaDeAcuerdo(dto.getId());
		} else{
			politica=new RecobroPoliticaDeAcuerdos();
		}
		if (!Checks.esNulo(politica)){
			politica.setNombre(dto.getNombre());
			politica.setCodigo(dto.getCodigo());
			politica.setEstado((RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class,RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION ));
			politica.setPropietario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());
			Long idPolitica = recobroPoliticaDeAcuerdosDao.save(politica);
			return idPolitica;
		}
		return null;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_DELETE_POLITICADEACUERDO_BO)
	@Transactional(readOnly=false)
	public void borrarPolitica(Long id) {
		
		RecobroPoliticaDeAcuerdos politica = this.getPoliticaDeAcuerdo(id);
		if (!Checks.estaVacio(politica.getSubCarteras()) ){
			throw new BusinessOperationException("No se puede borrar una política asociada a un esquema");
			
		} else {
			for (RecobroPoliticaAcuerdosPalanca palanca : politica.getPoliticaAcuerdosPalancas()){
				this.borrarPalancaPoliticaDeAcuerdos(palanca.getId());
			}
			recobroPoliticaDeAcuerdosDao.deleteById(id);
		}	
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GUARDA_PALANCA_POLITICA_BO)
	@Transactional(readOnly=false)
	public void guardaPalancaPolitica(RecobroPoliticaAcuerdosPalancaDto dto) {
		if (!Checks.esNulo(dto.getIdPolitica())){
			RecobroPoliticaAcuerdosPalanca palanca ;
			RecobroPoliticaDeAcuerdos politica = this.getPoliticaDeAcuerdo(dto.getIdPolitica());
			if (!Checks.esNulo(dto.getIdPalanca())){
				palanca = this.getPoliticaDeAcuerdosPalanca(dto.getIdPalanca());
				if (palanca.getPrioridad()!=dto.getPrioridad()){
					// si voy a subir la prioridad tengo que restarle uno a todos que tengan la prioridad menor o 
					//igual que la que voy a cambiar
					if (palanca.getPrioridad() < dto.getPrioridad()){
						recalcuraPrioridadRestoPalancasEdicionSubir(palanca.getPoliticaAcuerdos(), palanca.getPrioridad(),dto.getPrioridad(),-1);
					} else {
						// si voy a bajar la prioridad tengo que sumar uno a todos aquellos que tengan la prioridad superior
						// que la que voy a poner
						recalcuraPrioridadRestoPalancasEdicionBajar(palanca.getPoliticaAcuerdos(), palanca.getPrioridad(),dto.getPrioridad(),1);
					}
				}	
			} else {
				palanca = new RecobroPoliticaAcuerdosPalanca();
				palanca.setPoliticaAcuerdos(politica);
				recalcuraPrioridadRestoPalancas(palanca.getPoliticaAcuerdos(), dto.getPrioridad(),1);
			}
			if (!Checks.esNulo(dto.getCodigoSubtipoPalanca())){
				RecobroDDSubtipoPalanca subTipoPalanca = (RecobroDDSubtipoPalanca) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDSubtipoPalanca.class, dto.getCodigoSubtipoPalanca());
				if (!Checks.esNulo(politica.getPoliticaAcuerdosPalancas())){
					for (RecobroPoliticaAcuerdosPalanca p : palanca.getPoliticaAcuerdos().getPoliticaAcuerdosPalancas()){
						if (p.getSubtipoPalanca().getCodigo().equals(subTipoPalanca.getCodigo()) && p.getId()!= palanca.getId()){
							throw new BusinessOperationException("Ese tipo de palanca ya está asociado a esta política");
						}
					}
				}	
				palanca.setSubtipoPalanca(subTipoPalanca);
			}
			palanca.setPrioridad(dto.getPrioridad());
			if (!Checks.esNulo(dto.getCodigoSiNo())){
				DDSiNo delegada = (DDSiNo) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(DDSiNo.class, dto.getCodigoSiNo());
				palanca.setDelegada(delegada);
			} 
			palanca.setPrioridad(dto.getPrioridad());
			if (!Checks.esNulo(dto.getTiempoInmunidad1())){
				palanca.setTiempoInmunidad1(Integer.valueOf(dto.getTiempoInmunidad1()));
			} else {
				palanca.setTiempoInmunidad1(null);
			}
			if (!Checks.esNulo(dto.getTiempoInmunidad2())){
				palanca.setTiempoInmunidad2(Integer.valueOf(dto.getTiempoInmunidad2()));
			} else {
				palanca.setTiempoInmunidad2(null);
			}
			genericDao.save(RecobroPoliticaAcuerdosPalanca.class, palanca);	
		} else {
			throw new BusinessOperationException("No se puede crear una relación de palanca-politica si no se pasa el id de politica asocicada");
		}
		
	}

	

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETPALANCAPOLITICA_BO)
	public RecobroPoliticaAcuerdosPalanca getPoliticaDeAcuerdosPalanca(
			Long idPoliticaPalanca) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idPoliticaPalanca);
		return genericDao.get(RecobroPoliticaAcuerdosPalanca.class, filtro);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_BORRAR_PALANCAPOLITICA_BO)
	@Transactional(readOnly=false)
	public void borrarPalancaPoliticaDeAcuerdos(Long id) {
		genericDao.deleteById(RecobroPoliticaAcuerdosPalanca.class, id);
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_BORRAR_PALANCA_RECALC_PRIOR_BO)
	@Transactional(readOnly=false)
	public void borrarPalancaRecualculoPrioridades(Long id) {
		RecobroPoliticaAcuerdosPalanca palanca = this.getPoliticaDeAcuerdosPalanca(id);
		recalcuraPrioridadRestoPalancas(palanca.getPoliticaAcuerdos(), palanca.getPrioridad(),-1);
		this.borrarPalancaPoliticaDeAcuerdos(id);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETSUBPALANCAS_BO)
	public List<RecobroDDSubtipoPalanca> getSubTiposPalanca(
			String codigoTipoPalanca) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoPalanca.codigo", codigoTipoPalanca);
		List<RecobroDDSubtipoPalanca> subpalancas= genericDao.getList(RecobroDDSubtipoPalanca.class,filtro );
		return subpalancas;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_COPIA_POLITICA_BO)
	@Transactional(readOnly=false)
	public void copiarPoliticaAcuerdos(Long id) {
		RecobroPoliticaDeAcuerdos politica = this.getPoliticaDeAcuerdo(id);
		RecobroPoliticaDeAcuerdosDto dto = mapeaDtoAltaPolitica(politica);
		Long idCopia = this.savePolitica(dto);
		RecobroPoliticaDeAcuerdos copia = this.getPoliticaDeAcuerdo(idCopia);
		copiarPalancasPolitica(copia, politica);
		
	}


	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_CAMBIARESTADO_POLITICA_BO)
	@Transactional(readOnly=false)
	public void cambiarEstadoPoliticaAcuerdos(Long id, String codigoEstado) {
		RecobroPoliticaDeAcuerdos politica = this.getPoliticaDeAcuerdo(id);
		String error = validaCoherencia (politica, codigoEstado);
		if (Checks.esNulo(error)){
			RecobroDDEstadoComponente estado = (RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, codigoEstado);
			if (!Checks.esNulo(politica) && !Checks.esNulo(estado)){
				politica.setEstado(estado);
				recobroPoliticaDeAcuerdosDao.save(politica);
			}
		}	
		else{
			throw new BusinessOperationException(error);
		}
	}

	
	private void recalcuraPrioridadRestoPalancas(
			RecobroPoliticaDeAcuerdos politicaAcuerdos, Integer prioridad, Integer recalculo) {
		if (!Checks.esNulo(politicaAcuerdos.getPoliticaAcuerdosPalancas())){
			for (RecobroPoliticaAcuerdosPalanca p : politicaAcuerdos.getPoliticaAcuerdosPalancas()){
				if ( p.getPrioridad().compareTo(prioridad)>-1){
					p.setPrioridad(p.getPrioridad()+recalculo);
					genericDao.save(RecobroPoliticaAcuerdosPalanca.class, p);
				}
			}
		}
		
	}
	
	private void recalcuraPrioridadRestoPalancasEdicionSubir(
			RecobroPoliticaDeAcuerdos politicaAcuerdos, Integer prioridadAnterior, Integer prioridadActual, int j) {
		for (RecobroPoliticaAcuerdosPalanca p : politicaAcuerdos.getPoliticaAcuerdosPalancas()){
			// a los que la prioridad es menor o igual que la que quiero cambiar les tengo que restar uno
			if ( (p.getPrioridad()< prioridadActual || p.getPrioridad().equals(prioridadActual)) 
					&& (p.getPrioridad()>prioridadAnterior || p.getPrioridad().equals(prioridadActual)) ){
				p.setPrioridad(p.getPrioridad()+j);
				genericDao.save(RecobroPoliticaAcuerdosPalanca.class, p);
			}
		}
		
	}
	
	private void recalcuraPrioridadRestoPalancasEdicionBajar(
			RecobroPoliticaDeAcuerdos politicaAcuerdos, Integer prioridadAnterior, Integer prioridadActual, int j) {
		for (RecobroPoliticaAcuerdosPalanca p : politicaAcuerdos.getPoliticaAcuerdosPalancas()){
			// a los que la prioridad es menor o igual que la que quiero cambiar les tengo que restar uno
			if ( (p.getPrioridad()> prioridadActual || p.getPrioridad().equals(prioridadActual)) 
					&& (p.getPrioridad()<prioridadAnterior || p.getPrioridad().equals(prioridadActual)) ){
				p.setPrioridad(p.getPrioridad()+j);
				genericDao.save(RecobroPoliticaAcuerdosPalanca.class, p);
			}
		}
		
	}
	
	private RecobroPoliticaDeAcuerdosDto mapeaDtoAltaPolitica(
			RecobroPoliticaDeAcuerdos politica) {
		RecobroPoliticaDeAcuerdosDto dto = new RecobroPoliticaDeAcuerdosDto();
		dto.setNombre(politica.getNombre()+"_COPIA_"+(new SimpleDateFormat("_ddMMyyyy_HHmmss").format(new Date())));
		String[] codigoCopia = politica.getCodigo().split("_");
		dto.setCodigo(codigoCopia[0]+"_CP"+(new SimpleDateFormat("ddMMyyyyHHmm").format(new Date())));
		return dto;
	}
	
	private void copiarPalancasPolitica(RecobroPoliticaDeAcuerdos copia,
			RecobroPoliticaDeAcuerdos politica) {
		for (RecobroPoliticaAcuerdosPalanca palanca: politica.getPoliticaAcuerdosPalancas() ){
			 guardaPalancaPolitica(creaDtoPalanca(palanca, copia));
		}
	}

	private RecobroPoliticaAcuerdosPalancaDto creaDtoPalanca(
			RecobroPoliticaAcuerdosPalanca palanca,
			RecobroPoliticaDeAcuerdos copia) {
		RecobroPoliticaAcuerdosPalancaDto dto = new RecobroPoliticaAcuerdosPalancaDto();
		dto.setIdPolitica(copia.getId());
		dto.setCodigoSubtipoPalanca(palanca.getSubtipoPalanca().getCodigo());
		dto.setCodigoSiNo(palanca.getDelegada().getCodigo());
		dto.setPrioridad(palanca.getPrioridad());
		return dto;
	}

	private String validaCoherencia(RecobroPoliticaDeAcuerdos politica, String codigoEstado) {
		String error= null;
		if(RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE.equals(codigoEstado)){
			if (Checks.esNulo(politica.getPoliticaAcuerdosPalancas()) || Checks.estaVacio(politica.getPoliticaAcuerdosPalancas()) ){
				error= ms.getMessage("plugin.recobroCommon.politicaAcuerdos.validaPalancas.sinPalancasDefinidas", new Object[] {}, "**Debe de definir al menos una palanca antes de liberar", MessageUtils.DEFAULT_LOCALE);
			}
		}
		return error;
	}

	
	
}
