package es.pfsgroup.recovery.recobroCommon.metasVolantes.manager.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSubCarteraApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.api.RecobroItinerarioDao;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.api.RecobroTipoMetaVolanteDao;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoItinerario;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoMetaVolante;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.manager.api.RecobroItinerarioApi;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroDDTipoMetaVolante;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroMetaVolante;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.ItinerariosCommonConstants;

/**
 * Clase donde está toda la lógica de negocio para la configuración de Itinerarios de Metas Volantes
 * @author vanesa
 *
 */
@Component
public class RecobroItinerarioManager implements RecobroItinerarioApi{
	
	@Autowired
	private RecobroItinerarioDao recobroItinerarioDao;
	
	@Autowired
	private RecobroTipoMetaVolanteDao recobroTipoMetaVolanteDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private AbstractMessageSource ms = MessageUtils.getMessageSource();

	@Override
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_BUSCAR_ITINERARIOS_BO)
	public Page buscaItinerarios(RecobroDtoItinerario dto) {
		Page itinerarios = recobroItinerarioDao.buscaItinerarios(dto);
		return itinerarios;
	}

	@SuppressWarnings("unchecked")
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_ITINERARIO_BO)
	@Transactional(readOnly=false)
	public Long guardaItinerarioRecobro(RecobroDtoItinerario dto) {
		
		Boolean altaNuevo = true;
		
		if (!Checks.esNulo(dto)){
			RecobroItinerarioMetasVolantes itinerario= null;
			if (!Checks.esNulo(dto.getId())){
				Long id = Long.valueOf(dto.getId());
				itinerario = this.getItinerarioRecobro(id);
				altaNuevo = false;
			} else {
				itinerario = new RecobroItinerarioMetasVolantes();
				itinerario.setFechaAlta(new Date());
				itinerario.setEstado((RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION));
				itinerario.setPropietario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());
			}
			itinerario.setNombre(dto.getNombre());
			itinerario.setPlazoMaxGestion(Long.valueOf(dto.getPlazoMaxGestion()));
			itinerario.setPlazoSinGestion(Long.valueOf(dto.getPlazoSinGestion()));
			if (!Checks.esNulo(dto.getPorcentajeCobroParcial())){
				itinerario.setPorcentajeCobroParcial(Float.valueOf(dto.getPorcentajeCobroParcial()));
			}
			RecobroItinerarioMetasVolantes itinerarioNew = genericDao.save(RecobroItinerarioMetasVolantes.class, itinerario);
			
			if (altaNuevo){
				List<RecobroDDTipoMetaVolante> listaMetas = recobroTipoMetaVolanteDao.getMetasVolantes();
			
				if(!Checks.esNulo(listaMetas)){
					for (int i=0; i<listaMetas.size(); i++){
						RecobroMetaVolante metaIti = new RecobroMetaVolante();
						metaIti.setItinerario(itinerarioNew);
						metaIti.setOrden(listaMetas.get(i).getOrden());
						metaIti.setTipoMeta(listaMetas.get(i));
						genericDao.save(RecobroMetaVolante.class, metaIti);			
					}
				}
			}
			
			return itinerarioNew.getId();
			
		} else {
			throw new BusinessOperationException("No se ha pasado el dto de alta del itinerario");
		}
		
	}

	
	@SuppressWarnings("unchecked")
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_ELIMINAR_ITINERARIOS_BO)
	@Transactional(readOnly=false)
	public void eliminaItinerario(Long idItinerario) {
		
		if (!Checks.esNulo(idItinerario)){
			
			//Comprobar que el itineriario no pertenece a ningún esquema (no está asociado a una subcartera)
			List<RecobroSubCartera> subcarteras = proxyFactory.proxy(RecobroSubCarteraApi.class).buscaSubCarteraPorItinerario(idItinerario);
			
			if (Checks.estaVacio(subcarteras)){
				// Primero borramos las metas asociadas al itinerario
				RecobroItinerarioMetasVolantes itinerario = recobroItinerarioDao.get(idItinerario);
				List<RecobroMetaVolante> metasItinerario = itinerario.getMetasItinerario();
				if(!Checks.esNulo(itinerario.getMetasItinerario())){
					for(int i = 0; i < metasItinerario.size(); i++){
						genericDao.deleteById(RecobroMetaVolante.class, metasItinerario.get(i).getId());
					}
				}
				// Y finalmente podemos borrar el itinerario
				recobroItinerarioDao.deleteById(idItinerario);
			} else {
				throw new BusinessOperationException("No se puede eliminar el itinerario porque está asociado a algún esquema");
			}
			
		} else {
			throw new BusinessOperationException("El id de la itinerario no puede ser null");
		}
		
	}

	@SuppressWarnings("rawtypes")
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_BUSCA_METAS_POR_ITI_BO)
	@Transactional(readOnly=false)
	public List<RecobroMetaVolante> buscaMetasPorItinerario(Long id){
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "itinerario.id", id);
		Order order = new Order(OrderType.ASC,"orden");
		List<RecobroMetaVolante> metas = genericDao.getListOrdered(RecobroMetaVolante.class,order, filtro1);
		return metas;
	}
	
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GET_ITINERARIO_BO)
	public RecobroItinerarioMetasVolantes getItinerarioRecobro(Long idItinerario) {
		if (!Checks.esNulo(idItinerario)){
			RecobroItinerarioMetasVolantes itinerario = recobroItinerarioDao.get(idItinerario);
			return itinerario;
		} else {
			throw new BusinessOperationException("El id del itinerario no puede ser null");
		}
	}
	
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_METAS_BO)
	@Transactional(readOnly=false)
	public void guardaMetasVolantes(RecobroDtoMetaVolante dto){
		
		if (!Checks.esNulo(dto)){
			RecobroMetaVolante meta= null;
			if (!Checks.esNulo(dto.getId())){

				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
				meta = genericDao.get(RecobroMetaVolante.class, f1);
				
				//meta.setBloqueo(dto.getBloqueo());
				meta.setDiasDesdeEntrega(Integer.valueOf(dto.getDiasDesdeEntrega()));
				
				genericDao.update(RecobroMetaVolante.class, meta);
				
			} else {
				throw new BusinessOperationException("El id de la meta a modificar no puede ser null");
			} 
		}else {
			throw new BusinessOperationException("La meta a modificar no puede ser null");
		}	
			
	}

	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GET_ITINERARIOS_METAS_VOLANTES_BO)
	public List<RecobroItinerarioMetasVolantes> getItinerariosMetasVolantes() {
		return recobroItinerarioDao.getModelosDSPoBLQ();
	}

	@Override
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_LISTAMETAS_BO)
	@Transactional(readOnly=false)
	public void guardaListaMetasVolantes(List<RecobroDtoMetaVolante> dtos) {
		for(RecobroDtoMetaVolante dto : dtos){
			RecobroMetaVolante meta = this.getRecobroMetaVolante(dto.getId());
			if (DDSiNo.SI.equals(dto.getBloqueo())){
				meta.setBloqueo(true);
			}else {
				meta.setBloqueo(false);
			}
			meta.setDiasDesdeEntrega(dto.getDiasDesdeEntrega());
			genericDao.save(RecobroMetaVolante.class, meta);
		}
		
	}

	@Override
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_LISTDDSINO_BO)
	public List<DDSiNo> getListDDSiNO() {
		return proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);
	}

	@Override
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GET_RECOBROMETA_BO)
	public RecobroMetaVolante getRecobroMetaVolante(Long idRecobroMeta) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idRecobroMeta);
		return genericDao.get(RecobroMetaVolante.class, filtro);
	}

	@Override
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_BUSCA_DTOMETAS_POR_ITI_BO)
	@Transactional(readOnly=false)
	public List<RecobroDtoMetaVolante> buscaDtoMetasPorIti(Long id) {
		List<RecobroDtoMetaVolante> dtoMetas = new ArrayList<RecobroDtoMetaVolante>();
		
		List<RecobroMetaVolante> metas = this.buscaMetasPorItinerario(id);
		for (RecobroMetaVolante m : metas){
			RecobroDtoMetaVolante dto = new RecobroDtoMetaVolante();
			dto.setId(m.getId());
			dto.setIdItinerario(m.getItinerario().getId());
			dto.setCodigo(m.getTipoMeta().getCodigo());
			dto.setDescripcion(m.getTipoMeta().getDescripcion());
			dto.setPlazoMaxGestion(m.getItinerario().getPlazoMaxGestion());
			dto.setPlazoSinGestion(m.getItinerario().getPlazoSinGestion());
			dto.setDiasDesdeEntrega(m.getDiasDesdeEntrega());
			dto.setOrden(m.getOrden());
			if (!Checks.esNulo(m.getBloqueo())){
				if (m.getBloqueo()){
					dto.setBloqueo(DDSiNo.SI);
				} else {
					dto.setBloqueo(DDSiNo.NO);
				}
			}
			dtoMetas.add(dto);
		}
		return dtoMetas;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_COPIAR_ITINERARIOS_BO)
	@Transactional(readOnly=false)
	public void copiaItinerarioMetasVolantes(Long id) {
		RecobroItinerarioMetasVolantes itinerario = this.getItinerarioRecobro(id);
		Long idCopia = this.guardaItinerarioRecobro(mapeaDtoAltaItinerario(itinerario));
		RecobroItinerarioMetasVolantes copia = this.getItinerarioRecobro(idCopia);
		guardaListaMetasVolantes(creaDtosMetasVolantes(copia, itinerario));
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_CAMBIAESTADO_ITINERARIOS_BO)
	@Transactional(readOnly=false)
	public void cambiaEstadoItinerario(Long id, String codigoEstado) {
		RecobroItinerarioMetasVolantes itinerario = this.getItinerarioRecobro(id);
		RecobroDDEstadoComponente estado = (RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class,codigoEstado);
		if (!Checks.esNulo(itinerario) && !Checks.esNulo(estado)){
			String errores = compruebaDatosCoherentes(itinerario, codigoEstado);
			if (Checks.esNulo(errores)){
				itinerario.setEstado(estado);
			} else {
				throw new BusinessOperationException(errores);
			}
		}
	}

	private List<RecobroDtoMetaVolante> creaDtosMetasVolantes(
			RecobroItinerarioMetasVolantes copia,
			RecobroItinerarioMetasVolantes itinerario) {
		List<RecobroDtoMetaVolante> metas = new ArrayList<RecobroDtoMetaVolante>();
		List<RecobroMetaVolante> metasCopia = this.buscaMetasPorItinerario(copia.getId());
		if (!Checks.esNulo(metasCopia) && !Checks.estaVacio(metasCopia)){
			for (RecobroMetaVolante meta : itinerario.getMetasItinerario()){
				for (RecobroMetaVolante metaCopia: metasCopia){
					if (meta.getTipoMeta().getCodigo().equals(metaCopia.getTipoMeta().getCodigo())){
						RecobroDtoMetaVolante dto = new RecobroDtoMetaVolante();
						dto.setId(metaCopia.getId());
						dto.setDiasDesdeEntrega(meta.getDiasDesdeEntrega());
						String bloqueo = null;
						if (!Checks.esNulo(meta.getBloqueo())){
							if (meta.getBloqueo()){
								bloqueo=DDSiNo.SI;
							} else{
								bloqueo=DDSiNo.NO;
							}
						}
						dto.setBloqueo(bloqueo);
						metas.add(dto);
					}
					
				}
			}
		}	
		
		return metas;
	}

	private RecobroDtoItinerario mapeaDtoAltaItinerario(
			RecobroItinerarioMetasVolantes itinerario) {
		RecobroDtoItinerario dto = new RecobroDtoItinerario();
		dto.setNombre(itinerario.getNombre()+"_COPIA_"+(new SimpleDateFormat("_ddMMyyyy_HHmmss").format(new Date())));
		dto.setPlazoMaxGestion(itinerario.getPlazoMaxGestion().toString());
		dto.setPlazoSinGestion(itinerario.getPlazoSinGestion().toString());
		if (!Checks.esNulo(itinerario.getPorcentajeCobroParcial())){
			dto.setPorcentajeCobroParcial(itinerario.getPorcentajeCobroParcial().toString());
		}
		
		return dto;
	}
	
	private String compruebaDatosCoherentes(
			RecobroItinerarioMetasVolantes itinerario, String codigoEstado) {
		if (RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE.equals(codigoEstado)){
			if (itinerario.getPlazoMaxGestion()<1){
				return ms.getMessage("plugin.recobroConfig.itinerario.validaCambioEstadoLiberado.plazoMaxInsuficiente", null, "**El plazo máximo de gestión debe de ser mayor a 0", MessageUtils.DEFAULT_LOCALE);	
			} 
			RecobroMetaVolante metaCBP = dameMetaVolante(itinerario.getId(), RecobroDDTipoMetaVolante.RCF_TIPO_META_COBRO_PARCIAL);
			if (!Checks.esNulo(metaCBP)){
				if (Checks.esNulo(metaCBP.getDiasDesdeEntrega())){
					return ms.getMessage("plugin.recobroConfig.itinerario.validaCambioEstadoLiberado.noCobroParcial",new Object[]{RecobroDDTipoMetaVolante.RCF_TIPO_META_COBRO_PARCIAL}, "**Debe definir un plazo para la meta {0}", MessageUtils.DEFAULT_LOCALE);	
				}
			}
			RecobroMetaVolante metaCBT = dameMetaVolante(itinerario.getId(), RecobroDDTipoMetaVolante.RCF_TIPO_META_COBRO_TOTAL);
			if (!Checks.esNulo(metaCBT)){
				if (Checks.esNulo(metaCBT.getDiasDesdeEntrega())){
					return ms.getMessage("plugin.recobroConfig.itinerario.validaCambioEstadoLiberado.noCobroParcial",new Object[]{RecobroDDTipoMetaVolante.RCF_TIPO_META_COBRO_TOTAL}, "**Debe definir un plazo para la meta {0}", MessageUtils.DEFAULT_LOCALE);	
				}
			}
		}
		return null;
	}

	private RecobroMetaVolante dameMetaVolante(Long id,
			String codigoTipoMeta) {
		
		Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "itinerario.id", id);
		Filter filtroTipoMeta = genericDao.createFilter(FilterType.EQUALS, "tipoMeta.codigo", codigoTipoMeta);
		
		return genericDao.get(RecobroMetaVolante.class, filtroId, filtroTipoMeta);
		
	}

	
}
