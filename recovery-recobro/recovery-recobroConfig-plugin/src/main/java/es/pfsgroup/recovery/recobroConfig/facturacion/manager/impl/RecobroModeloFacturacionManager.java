package es.pfsgroup.recovery.recobroConfig.facturacion.manager.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroDDTipoCobroDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionTramoCorrectorDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.manager.api.RecobroModeloFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroCobroFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroCorrectorFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroDDConceptoCobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroDDTipoCobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroDDTipoCorrector;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobroTramo;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTramoFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.serder.ConceptosItem;
import es.pfsgroup.recovery.recobroCommon.facturacion.serder.RecobroTarifaCobroTramoItems;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroProcesoFacturacionDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonModeloFacturacionConstants;
import es.pfsgroup.recovery.recobroConfig.facturacion.dao.api.RecobroCorrectorFacturacionDao;
import es.pfsgroup.recovery.recobroConfig.facturacion.dao.api.RecobroDDTipoCobroDao;
import es.pfsgroup.recovery.recobroConfig.facturacion.dao.api.RecobroModeloFacturacionDao;

@Component
public class RecobroModeloFacturacionManager implements RecobroModeloFacturacionApi{
	
	@Resource
	private Properties appProperties;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private RecobroModeloFacturacionDao modeloFacturacionDao;
	
	@Autowired
	private RecobroDDTipoCobroDao recobroDDTipoCobroDao;
		
	@Autowired
	private RecobroCorrectorFacturacionDao recobroCorrectorFacturacionDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private RecobroProcesoFacturacionDao procesoFacturacionDao;
	
	private AbstractMessageSource ms = MessageUtils.getMessageSource();
	
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_BO)
	public List<RecobroModeloFacturacion> getListModelosFacturacion() {
		return modeloFacturacionDao.getModelosDSPoBLQ();
	}

	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GET_BO)
	public RecobroModeloFacturacion getModeloFacturacion(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		return genericDao.get(RecobroModeloFacturacion.class, filtro);
	}

	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_GET_TRAMO_CORRECTOR_BO)
	public RecobroCorrectorFacturacion getCorrectorFacturacion(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		return genericDao.get(RecobroCorrectorFacturacion.class, filtro);
	}
	
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GET_COBROS_BO)
	public Page getCobros(RecobroDDTipoCobroDto dto) {
		return recobroDDTipoCobroDao.getCobrosFacturacion(dto);
	}

	/**
	 * @{inhericDoc}
	 */
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_HABILITAR_COBRO_BO)
	@Transactional(readOnly=false)
	public void habilitarCobro(Long idModFact, Long idTipoCobro) {
		RecobroModeloFacturacion modeloFacturacion = modeloFacturacionDao.get(idModFact);		
		DDSubtipoCobroPago tipoCobro = (DDSubtipoCobroPago) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionario(DDSubtipoCobroPago.class, idTipoCobro);
		
		if (!Checks.esNulo(modeloFacturacion) && !Checks.esNulo(tipoCobro)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "modeloFacturacion.id", idModFact);
			List<RecobroTramoFacturacion> tramosFacturacion = genericDao.getList(RecobroTramoFacturacion.class, filtro);
			
			RecobroCobroFacturacion cobroFacturacion = new RecobroCobroFacturacion();
			cobroFacturacion.setModeloFacturacion(modeloFacturacion);
			cobroFacturacion.setTipoCobro(tipoCobro);
			
			genericDao.save(RecobroCobroFacturacion.class, cobroFacturacion);
			
			//Añade todo el rango de conceptos al cobro
			List<RecobroDDConceptoCobro> coneptosCobro = genericDao.getList(RecobroDDConceptoCobro.class);
			for (RecobroDDConceptoCobro recobroDDConceptoCobro : coneptosCobro) {
				RecobroTarifaCobro tarifaCobro = new RecobroTarifaCobro();
				tarifaCobro.setCobroFacturacion(cobroFacturacion);
				tarifaCobro.setTipoTarifa(recobroDDConceptoCobro);
				tarifaCobro.setMinimo(0.0f);
				tarifaCobro.setPorcentajePorDefecto(0.0f);
				
				genericDao.save(RecobroTarifaCobro.class, tarifaCobro);

				// Añadimos la relación entre las tarifas y los tramos
				for (RecobroTramoFacturacion tramoFacturacion: tramosFacturacion) {
					creaNuevaRelacionCobroTarifaTramo(tarifaCobro, tramoFacturacion);
										
				}
			}
		}
		
	}

	/**
	 * @{inhericDoc}
	 */
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_DESHABILITAR_COBRO_BO)
	@Transactional(readOnly=false)
	public void desHabilitarCobro(Long idModFact, Long idTipoCobro) {
		
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "modeloFacturacion.id", idModFact);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoCobro.id", idTipoCobro);
		RecobroCobroFacturacion cobroFacturacion = genericDao.get(RecobroCobroFacturacion.class, f1,f2);
		if (!Checks.esNulo(cobroFacturacion)) {
			
			List<RecobroTarifaCobro> tarifasCobro = cobroFacturacion.getTarifasCobro();
			for (RecobroTarifaCobro recobroTarifaCobro : tarifasCobro) {				
				List<RecobroTarifaCobroTramo> tarifasCobrosTramos = recobroTarifaCobro.getTarifasCobrosTramos();
				for (RecobroTarifaCobroTramo recobroTarifaCobroTramo : tarifasCobrosTramos) {
					genericDao.deleteById(RecobroTarifaCobroTramo.class, recobroTarifaCobroTramo.getId());
				}
				genericDao.deleteById(RecobroTarifaCobro.class, recobroTarifaCobro.getId());
			}
			
			genericDao.deleteById(RecobroCobroFacturacion.class, cobroFacturacion.getId());		
			
		}
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_BUSCARMODELOS_BO)
	public Page buscarModelosFacturacion(RecobroModeloFacturacionDto dto) {
		return modeloFacturacionDao.buscaModelosFacturacion(dto);
	}

	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_SAVEMODELO_BO)
	@Transactional(readOnly=false)
	public RecobroModeloFacturacion guardaModeloFacturacion(
			RecobroModeloFacturacionDto dto) {
		RecobroModeloFacturacion modelo;
		if (Checks.esNulo(dto.getId())){
			modelo=new RecobroModeloFacturacion();
			modelo.setEstado((RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION));
		}else{
			modelo= this.getModeloFacturacion(dto.getId());
		}
		modelo.setNombre(dto.getNombre());
		modelo.setDescripcion(dto.getDescripcion());
		modelo.setPropietario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());	
		modeloFacturacionDao.saveOrUpdate(modelo);
		
		return modelo;
	}


	/**
	 * @{inhericDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_TRAMOS_BO)
	public List<RecobroTramoFacturacion> getListTramosFacturacion(Long idModFact) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "modeloFacturacion.id", idModFact);
		Order order = new Order(OrderType.ASC,"tramoDias");
		
		return genericDao.getListOrdered(RecobroTramoFacturacion.class, order, filtro);
	}

	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_TARIFAS_COBRO_BO)
	public List<RecobroTarifaCobro> getListTarifasCobro(Long idModFact,
			Long idCobro) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "cobroFacturacion.modeloFacturacion.id", idModFact);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "cobroFacturacion.tipoCobro.id", idCobro);
			return genericDao.getList(RecobroTarifaCobro.class,f1,f2);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_DELETE_MODELO_BO)
	@Transactional(readOnly=false)
	public void borrarModeloFacturacion(Long id) {
		RecobroModeloFacturacion modelo = this.getModeloFacturacion(id);
		List<RecobroProcesoFacturacion> procesosFacturacionRelacionados = procesoFacturacionDao.dameProcesosFacturacionRelacionadosModelo(id);
		if (!Checks.estaVacio(procesosFacturacionRelacionados)){
			throw new BusinessOperationException("No se puede borrar este modelo de facturación porque está asociado a procesos de facturación");
		}
		if (!Checks.estaVacio(modelo.getSubCarteras())){
			throw new BusinessOperationException("No se puede borrar este modelo de facturación porque está asociado a subcarteras");
		}
		modeloFacturacionDao.deleteById(id);
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_SAVE_TRAMO_FACTURACION_BO)
	@Transactional(readOnly=false)
	public void guradarTramoFacturacion(RecobroModeloFacturacionDto dto) {
		RecobroModeloFacturacion modelo = this.getModeloFacturacion(dto.getIdModFact());
		if (compruebaMaximoDeTramos(modelo)){
			RecobroTramoFacturacion tramo = new RecobroTramoFacturacion();
			tramo.setModeloFacturacion(modelo);
			tramo.setTramoDias(dto.getTramoDias());
			genericDao.save(RecobroTramoFacturacion.class, tramo);
			if (!Checks.esNulo(modelo.getCobrosAsociados())){
				for (RecobroCobroFacturacion cobro : modelo.getCobrosAsociados()){
					for (RecobroTarifaCobro tarifa : cobro.getTarifasCobro()){
						creaNuevaRelacionCobroTarifaTramo(tarifa, tramo);
					}
				}
			}	
			
		} else {
			throw new BusinessOperationException("Este modelo ya tiene el máximo de tramos permitidos creados");
		}
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_DELETE_TRAMO_BO)
	@Transactional(readOnly=false)
	public void borrarTramoFacturacion(Long idTramoFacturacion) {
		RecobroTramoFacturacion tramo = this.getTramoFacturacion(idTramoFacturacion);
		for (RecobroTarifaCobroTramo tarifa : tramo.getTarifasCobrosTramos()){
			borrarTarifaCobroTramo(tarifa.getId());
		}
		genericDao.deleteById(RecobroTramoFacturacion.class, idTramoFacturacion);
		
	}


	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GET_TRAMO_BO)
	public RecobroTramoFacturacion getTramoFacturacion(Long idTramoFacturacion) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idTramoFacturacion);
		return genericDao.get(RecobroTramoFacturacion.class, filtro);
	}
	
	private boolean compruebaMaximoDeTramos(RecobroModeloFacturacion modelo) {
		String resultado = appProperties.getProperty("modeloFacturacion.tramos.numMaxTramosFacturacion");
		Integer maximoTramos = Integer.parseInt(resultado);
		if (!Checks.esNulo(modelo.getTramosFacturacion())){
			if (!(modelo.getTramosFacturacion().size()< maximoTramos)){
				return false;
			} else{
			   return true;
			}
		} else{
			return true;
		}
	}
	
	private void creaNuevaRelacionCobroTarifaTramo(
			RecobroTarifaCobro tarifaCobro,
			RecobroTramoFacturacion tramoFacturacion) {
		RecobroTarifaCobroTramo tarifaCobroTramo = new RecobroTarifaCobroTramo();
		tarifaCobroTramo.setTramoFacturacion(tramoFacturacion);
		tarifaCobroTramo.setTarifaCobro(tarifaCobro);
		genericDao.save(RecobroTarifaCobroTramo.class, tarifaCobroTramo);
		
	}

	private void borrarTarifaCobroTramo(Long id) {
		genericDao.deleteById(RecobroTarifaCobroTramo.class, id);
	}
	
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GUARDAR_TIPO_CORRECTOR)
	@Transactional(readOnly=false)
	public void guardarTipoDeCorrector(RecobroModeloFacturacionDto dto) {
		if (!Checks.esNulo(dto)){
			RecobroModeloFacturacion modeloFacturacion= null;
			if (!Checks.esNulo(dto.getId())){
				modeloFacturacion = this.getModeloFacturacion(Long.valueOf(dto.getId()));
			} else {
				modeloFacturacion = new RecobroModeloFacturacion();
			}
			
			if (!Checks.esNulo(dto.getTipoDeCorrector())){
//				Long idTipoCorrector = Long.parseLong(dto.getTipoDeCorrector());
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoDeCorrector());
				RecobroDDTipoCorrector tipoCorrector = genericDao.get(RecobroDDTipoCorrector.class, f1);
				
				// en caso de cambio de tipo de corrector borrar los tramos que hubiera definidos
				if (!Checks.esNulo(modeloFacturacion.getTipoCorrector())){
					if (!tipoCorrector.getCodigo().equals(modeloFacturacion.getTipoCorrector().getCodigo())){
						for (RecobroCorrectorFacturacion tramoCorrector : modeloFacturacion.getTramosCorrectores()){
							genericDao.deleteById(RecobroCorrectorFacturacion.class, tramoCorrector.getId());
						}
					}
				}
				
				modeloFacturacion.setTipoCorrector(tipoCorrector);
				modeloFacturacion.setObjetivoRecobro(dto.getObjetivoRecobro());
			} else {
				modeloFacturacion.setTipoCorrector(null);
				modeloFacturacion.setObjetivoRecobro(null);
				for (RecobroCorrectorFacturacion tramoCorrector : dameTramosCorrectores(modeloFacturacion.getId())){
					genericDao.deleteById(RecobroCorrectorFacturacion.class, tramoCorrector.getId());
				}
			}
			
			modeloFacturacionDao.saveOrUpdate(modeloFacturacion);
			
		} else {
			throw new BusinessOperationException("No se han pasado los parámetros necesarios, consulte con el administrador");
		}
	}

	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GUARDAR_TRAMO_CORRECTOR_BO)
	@Transactional(readOnly=false)
	public void guardarTramoCorrector(RecobroModeloFacturacionTramoCorrectorDto dto) {
		if (!Checks.esNulo(dto)){
			RecobroCorrectorFacturacion correctorFacturacion= null;
			if (!Checks.esNulo(dto.getIdTramoCorrector())){
				correctorFacturacion = this.getCorrectorFacturacion(Long.valueOf(dto.getIdTramoCorrector()));
			} else {
				correctorFacturacion = new RecobroCorrectorFacturacion();
			}
			
			RecobroModeloFacturacion modeloFacturacion= null;
			if (!Checks.esNulo(dto.getIdModFact())){
				modeloFacturacion = this.getModeloFacturacion(Long.valueOf(dto.getIdModFact()));
				correctorFacturacion.setModeloFacturacion(modeloFacturacion);
				correctorFacturacion.setObjetivoFin(dto.getObjetivoFin());
				correctorFacturacion.setObjetivoInicio(dto.getObjetivoInicio());
				correctorFacturacion.setRankingPosicion(dto.getRankingPosicion());
				correctorFacturacion.setCoeficiente(dto.getCoeficiente());
				recobroCorrectorFacturacionDao.saveOrUpdate(correctorFacturacion);
			} else {
				throw new BusinessOperationException("No se han pasado los parámetros necesarios, consulte con el administrador");
			}
				
		}
	}

	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DELETE_TRAMO_CORRECTOR_BO)
	@Transactional(readOnly=false)
	public void borrarTramoCorrector(Long idTramoCorrector) {
		RecobroCorrectorFacturacion tramoCorrector = this.getCorrectorFacturacion(idTramoCorrector);
		
		if (!Checks.esNulo(tramoCorrector)){
			genericDao.deleteById(RecobroCorrectorFacturacion.class, tramoCorrector.getId());
			
		}

	}

	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_SAVE_TARIFAS_TRAMOS_BO)
	@Transactional(readOnly=false)
	public void guardaTarifasTramos(RecobroTarifaCobroTramoItems gridItems) {
		List<ConceptosItem> items = gridItems.getConceptosItems();
		
		for (ConceptosItem item : items) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", item.getId());
			if ("tarifas".equals(item.getTabla())) {
				RecobroTarifaCobro tarifaCobro =  genericDao.get(RecobroTarifaCobro.class, filtro);
				if (!Checks.esNulo(tarifaCobro)) {
					if ("maximo".equals(item.getCampo())) {
						tarifaCobro.setMaximo(item.getValor());
					} else if ("minimo".equals(item.getCampo())) {
						tarifaCobro.setMinimo((item.getValor()!=null)?item.getValor():0.0f);
					} else if ("porcentajeDefecto".equals(item.getCampo())){
						tarifaCobro.setPorcentajePorDefecto((item.getValor()!=null)?item.getValor():0.0f);
					}
					genericDao.save(RecobroTarifaCobro.class, tarifaCobro);
				}
			} else {
				RecobroTarifaCobroTramo tarifaCobroTramo = genericDao.get(RecobroTarifaCobroTramo.class, filtro);
				if (!Checks.esNulo(tarifaCobroTramo)) {
					tarifaCobroTramo.setPorcentaje((item.getValor()!=null)?item.getValor():0.0f);
					genericDao.save(RecobroTarifaCobroTramo.class, tarifaCobroTramo);
				}
			}
		}
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_CAMBIAESTADO_BO)
	@Transactional(readOnly=false)
	public void cambiaEstadoModeloFacturacion(Long idModFact,
			String codigoEstado) {
		RecobroModeloFacturacion modelo = this.getModeloFacturacion(idModFact);
		RecobroDDEstadoComponente estado = (RecobroDDEstadoComponente) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoComponente.class, codigoEstado);
		if (!Checks.esNulo(modelo) && !Checks.esNulo(estado)){
			String error = compruebaCoherencia(modelo, codigoEstado);
			if (Checks.esNulo(error)){
				modelo.setEstado(estado);
				modeloFacturacionDao.save(modelo);
			} else {
				throw new BusinessOperationException(error);
			}
		}
		
	}
	
	@Override
	@BusinessOperation(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_COPIAMODELO_BO)
	@Transactional(readOnly=false)
	public void copiarModeloFacturacion(Long idModFact) {
		RecobroModeloFacturacion modelo = this.getModeloFacturacion(idModFact);
		RecobroModeloFacturacion copia = this.guardaModeloFacturacion(creaDtoAltaModeloFacturacion(modelo));
		copiarTramosFacturacion(copia, modelo);
		copiarCobrosHabilitados(copia, modelo);
		copiarTarifasCobrosTramos(copia, modelo);
		copiarCorrectoresFacturacion(copia, modelo);
		copiarTramosCorrectores(copia, modelo);
	}

	

	private void copiarTramosCorrectores(RecobroModeloFacturacion copia,
			RecobroModeloFacturacion modelo) {
		for (RecobroCorrectorFacturacion tramoCorrector : modelo.getTramosCorrectores()){
			RecobroModeloFacturacionTramoCorrectorDto dto = new RecobroModeloFacturacionTramoCorrectorDto();
			dto.setIdModFact(copia.getId());
			dto.setObjetivoInicio(tramoCorrector.getObjetivoInicio());
			dto.setObjetivoFin(tramoCorrector.getObjetivoFin());
			dto.setCoeficiente(tramoCorrector.getCoeficiente());
			dto.setRankingPosicion(tramoCorrector.getRankingPosicion());
			guardarTramoCorrector(dto);
		}
		
	}

	private void copiarCorrectoresFacturacion(RecobroModeloFacturacion copia,
			RecobroModeloFacturacion modelo) {
		RecobroModeloFacturacionDto dto = new RecobroModeloFacturacionDto();
		if (!Checks.esNulo(modelo.getTipoCorrector())){
			dto.setTipoDeCorrector(modelo.getTipoCorrector().getCodigo());
			dto.setIdModFact(copia.getId());
			dto.setId(copia.getId());
			dto.setObjetivoRecobro(modelo.getObjetivoRecobro());
			this.guardarTipoDeCorrector(dto);
		}	
	}

	private void copiarTarifasCobrosTramos(RecobroModeloFacturacion copia,
			RecobroModeloFacturacion modelo) {
		if (!Checks.esNulo(modelo.getCobrosAsociados())){
			for (RecobroCobroFacturacion cobro : modelo.getCobrosAsociados()){
				for (RecobroCobroFacturacion cobroCopia : this.getListaCobrosHabilitados(copia.getId())){
					if (cobro.getTipoCobro().getCodigo().equals(cobroCopia.getTipoCobro().getCodigo())){
						for (RecobroTarifaCobro tarifa : cobro.getTarifasCobro()){
							for (RecobroTarifaCobro tarifaCopia: dameRecobroTarifaCobro(cobroCopia.getId())){
								if(tarifa.getTipoTarifa().getCodigo().equals(tarifaCopia.getTipoTarifa().getCodigo())){
									tarifaCopia.setMaximo(tarifa.getMaximo());
									tarifaCopia.setMinimo(tarifa.getMinimo());
									tarifaCopia.setPorcentajePorDefecto(tarifa.getPorcentajePorDefecto());
									genericDao.save(RecobroTarifaCobro.class, tarifaCopia);
								}
							}
						}
					}	
				}
			}
		}
		if (!Checks.esNulo(modelo.getTramosFacturacion())){
			for (RecobroTramoFacturacion tramo: modelo.getTramosFacturacion()){
				for (RecobroTramoFacturacion tramoCopia : dameTramosFacturacion(copia.getId())){
					if (tramo.getTramoDias().equals(tramoCopia.getTramoDias())){
						for(RecobroTarifaCobroTramo tarifaTramo : tramo.getTarifasCobrosTramos()){
							for (RecobroTarifaCobroTramo tarifaTramoCopia : dameTarifasCobrosTramos(tramoCopia.getId())){
								if (tarifaTramo.getTarifaCobro().getTipoTarifa().getCodigo().equals(tarifaTramoCopia.getTarifaCobro().getTipoTarifa().getCodigo())){
									tarifaTramoCopia.setPorcentaje(tarifaTramo.getPorcentaje());
									genericDao.save(RecobroTarifaCobroTramo.class, tarifaTramoCopia);
								}
								
							}
						}
					}
				}
			}
		}
		
	}

	private List<RecobroTramoFacturacion> dameTramosFacturacion(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "modeloFacturacion.id", id);
		return genericDao.getList(RecobroTramoFacturacion.class, filtro);
	}

	private List<RecobroTarifaCobro> dameRecobroTarifaCobro(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "cobroFacturacion.id", id);
		return genericDao.getList(RecobroTarifaCobro.class, filtro);
	}

	private List<RecobroTarifaCobroTramo> dameTarifasCobrosTramos(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tramoFacturacion.id", id);
		return genericDao.getList(RecobroTarifaCobroTramo.class, filtro);
	}

	private List<RecobroCobroFacturacion> getListaCobrosHabilitados(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "modeloFacturacion.id", id);
		return genericDao.getList(RecobroCobroFacturacion.class, filtro);
	}
	
	private List<RecobroCorrectorFacturacion> dameTramosCorrectores(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "modeloFacturacion.id", id);
		return genericDao.getList(RecobroCorrectorFacturacion.class, filtro);
	}


	private void copiarCobrosHabilitados(RecobroModeloFacturacion copia,
			RecobroModeloFacturacion modelo) {
		if (!Checks.esNulo(modelo.getCobrosAsociados())){
			for(RecobroCobroFacturacion cobro: modelo.getCobrosAsociados()){
				this.habilitarCobro(copia.getId(), cobro.getTipoCobro().getId());
			}
		}
	}

	private void copiarTramosFacturacion(RecobroModeloFacturacion copia,
			RecobroModeloFacturacion modelo) {
		if (!Checks.esNulo(modelo.getTramosFacturacion())){
			for (RecobroTramoFacturacion tramo : modelo.getTramosFacturacion()){
				RecobroModeloFacturacionDto dto = new RecobroModeloFacturacionDto();
				dto.setIdModFact(copia.getId());
				dto.setTramoDias(tramo.getTramoDias());
				this.guradarTramoFacturacion(dto);
			}
		}
	}

	private RecobroModeloFacturacionDto creaDtoAltaModeloFacturacion(
			RecobroModeloFacturacion modelo) {
		RecobroModeloFacturacionDto dto = new RecobroModeloFacturacionDto();
		String[] nombreCopia = modelo.getNombre().split("_COPIA_");
		dto.setNombre(nombreCopia[0]+"_COPIA_"+(new SimpleDateFormat("_ddMMyyyy_HHmmss").format(new Date())));
		if (dto.getNombre().length()>250){
			dto.setNombre(dto.getNombre().substring(0, 249));
		}
		if (!Checks.esNulo(modelo.getDescripcion())){
			dto.setDescripcion(modelo.getDescripcion()+" (COPIA)");
		}
		return dto;
	}

	private String compruebaCoherencia(RecobroModeloFacturacion modelo,
			String codigoEstado) {
		if (RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE.equals(codigoEstado)){
			if(Checks.esNulo(modelo.getTramosFacturacion()) || Checks.estaVacio(modelo.getTramosFacturacion())){
				return ms.getMessage("plugin.recobroConfig.modeloFacturacionManager.validaCambioLiberar.tramosDefinidos", new Object[] {}, "**Debe definir al menos un tramo de facturación", MessageUtils.DEFAULT_LOCALE);
			}
			if (Checks.esNulo(modelo.getCobrosAsociados()) || Checks.estaVacio(modelo.getCobrosAsociados())){
				return ms.getMessage("plugin.recobroConfig.modeloFacturacionManager.validaCambioLiberar.cobrosAsociados", new Object[] {}, "**Debe de asociar algún cobro al modelo antes de liberar", MessageUtils.DEFAULT_LOCALE);
			} else {
				for(RecobroCobroFacturacion cobro : modelo.getCobrosAsociados()){
					Boolean correcto = false;
					for (RecobroTarifaCobro tarifa :cobro.getTarifasCobro()){
						if (!Checks.esNulo(tarifa.getMaximo()) || !Checks.esNulo(tarifa.getMinimo()) || !Checks.esNulo(tarifa.getPorcentajePorDefecto())){
							correcto = true;
							break;
						}
					}
					if (!correcto){
						return ms.getMessage("plugin.recobroConfig.modeloFacturacionManager.validaCambioLiberar.tarifasCobrosAsociados", new Object[] {cobro.getTipoCobro().getDescripcion()}, "**Debe establecer al menos una tarifa para el tipo de cobro {0}", MessageUtils.DEFAULT_LOCALE);
					}
				}
			}
		}
		return null;
	}

	

	
}
