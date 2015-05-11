package es.pfsgroup.recovery.recobroCommon.esquema.manager.impl;

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
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroCarteraEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraAgenciaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraRankingDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroCarteraEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarteraDto;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroCarteraEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSimulacionEsquemaManager;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSubCarteraApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoSimulacion;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDModeloTransicion;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoGestionCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoRepartoSubcartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraRanking;
import es.pfsgroup.recovery.recobroCommon.esquema.serder.recobroSubCarAgencias.RecobroSubcarteraAgenciasGrid;
import es.pfsgroup.recovery.recobroCommon.esquema.serder.recobroSubCarAgencias.SubCarAgenItem;
import es.pfsgroup.recovery.recobroCommon.esquema.serder.recobroSubCarAgencias.SubCarRankingItem;
import es.pfsgroup.recovery.recobroCommon.facturacion.manager.api.RecobroModeloFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.manager.api.RecobroItinerarioApi;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.api.RecobroPoliticaDeAcuerdosApi;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroCommon.ranking.manager.api.RecobroModeloDeRankingApi;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;

@Component
public class RecobroEsquemaManager implements RecobroEsquemaApi {

	@Autowired
	private RecobroEsquemaDao recobroEsquemaDao;

	@Autowired
	private RecobroSubCarteraDao recobroSubCarteraDao;
	
	@Autowired
	private RecobroCarteraEsquemaDao recobroCarteraEsquemaDao;
	
	@Autowired 
	private RecobroSubCarteraAgenciaDao recobroSubCarteraAgenciaDao;
	
	@Autowired
	private RecobroSubCarteraRankingDao recobroSubCarteraRankingDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private AbstractMessageSource ms = MessageUtils.getMessageSource();

	@Autowired
	private RecobroSubCarteraApi subcarteraApi;
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants .PLUGIN_RCF_API_ESQUEMA_BUSCAR_ESQUEMAS_BO)
	public Page buscarRecobroEsquema(RecobroEsquemaDto dto) {
		return recobroEsquemaDao.buscarRecobroEsquema(dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_GET_BO)
	public RecobroEsquema getRecobroEsquema(Long idEsquema) {
		return recobroEsquemaDao.get(idEsquema);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_DELETEESQUEMA_BO)
	@Transactional(readOnly=false)
	public void borrarRecobroEsquema(Long idEsquema) {
		RecobroEsquema esquema = this.getRecobroEsquema(idEsquema);
		
		if (!Checks.esNulo(esquema)){
			for (RecobroCarteraEsquema car : esquema.getCarterasEsquema()){
				if (!Checks.estaVacio(car.getSubcarteras())) {
					for (RecobroSubCartera sub : car.getSubcarteras()) {
						genericDao.deleteById(RecobroSubCartera.class, sub.getId());
						if (!Checks.estaVacio(sub.getAgencias())) {
							for (RecobroSubcarteraAgencia agen : sub.getAgencias()) {
								genericDao.deleteById(RecobroSubcarteraAgencia.class, agen.getId());
							}
						}
						if (!Checks.estaVacio(sub.getRanking())) {
							for (RecobroSubcarteraRanking ran : sub.getRanking()) {
								genericDao.deleteById(RecobroSubcarteraRanking.class, ran.getId());
							}
						}
					}
				}
				genericDao.deleteById(RecobroCarteraEsquema.class, car.getId());
			}
			genericDao.deleteById(RecobroEsquema.class, idEsquema);
		}
		
		recobroEsquemaDao.deleteById(idEsquema);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_SAVEESQUEMA_BO)
	@Transactional(readOnly = false)
	public Long guardarRecobroEsquema(RecobroEsquemaDto dto) {

		if (!Checks.esNulo(dto)) {
			RecobroEsquema esquema = null;
			if (!Checks.esNulo(dto.getId())) {
				esquema = this.getRecobroEsquema(Long.valueOf(dto.getId()));
			} else {
				esquema = new RecobroEsquema();
				esquema.setPropietario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());
				esquema.setEstadoEsquema((RecobroDDEstadoEsquema) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoEsquema.class, RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION));
				esquema.setVersionrelease(dto.getVersionrelease());
				esquema.setMajorRelease(dto.getMajorRelease());
				esquema.setMinorRelease(dto.getMinorRelease());
				esquema.setFechaAlta(new Date());
				esquema.setIdGrupoVersion(0L);
			}
			esquema.setNombre(dto.getNombre());
			esquema.setDescripcion(dto.getDescripcion());

			if (!Checks.esNulo(dto.getPlazoActivacion()))
				esquema.setPlazo(Integer.valueOf(dto.getPlazoActivacion()));

			/*
			 * Long idEstado = Long.parseLong(dto.getEstado()); Filter f1 =
			 * genericDao.createFilter(FilterType.EQUALS, "id", idEstado);
			 * RecobroDDEstadoEsquema estadoEsquema =
			 * genericDao.get(RecobroDDEstadoEsquema.class, f1);
			 * esquema.setEstadoEsquema(estadoEsquema);
			 */

			Long idModelo = Long.parseLong(dto.getModeloTransicion());
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "id",
					idModelo);
			RecobroDDModeloTransicion modeloTransicion = genericDao.get(
					RecobroDDModeloTransicion.class, f2);
			esquema.setModeloTransicion(modeloTransicion);

			Long idEsquema = recobroEsquemaDao.save(esquema);
			RecobroEsquema esquemaNuevo = this.getRecobroEsquema(idEsquema);
			if (!Checks.esNulo(dto.getIdGrupoVersion())){
				esquemaNuevo.setIdGrupoVersion(dto.getIdGrupoVersion());
			} else {
				esquemaNuevo.setIdGrupoVersion(esquemaNuevo.getId());
			}
			return recobroEsquemaDao.save(esquemaNuevo);

		} else {
			throw new BusinessOperationException(
					"No se ha pasado el dto del esquema que se va a modificar");
		}

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_GET_CARTERA_ESQUEMA_BO)
	public RecobroCarteraEsquema getRecobroCarteraEsquema(Long id) {
		RecobroCarteraEsquema carteraEsquema = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		carteraEsquema = genericDao.get(RecobroCarteraEsquema.class, filtro);

		return carteraEsquema;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERA_BY_ESQUEMACARTERA_BO)
	public List<? extends RecobroSubCartera> getSubcarterasCarteraEsquema(
			Long idCarteraEsquema) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,
				"carteraEsquema.id", idCarteraEsquema);
		List<RecobroSubCartera> subcarterasEstaticas = genericDao.getList(
				RecobroSubCartera.class, filtro);

		return subcarterasEstaticas;
	}

	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_ULTIMA_VERSION_ESQUEMA_BO)
	public boolean ultimaVersionDelEsquema(Long idEsquema) {
		RecobroEsquema esquema = getUltimaVersionDelEsquema(idEsquema);
		if (esquema.getId().equals(idEsquema)){
			return true;
		}
		return false;
	}
	
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_GET_ULTIMA_VERSION_ESQUEMA_BO)
	public RecobroEsquema getUltimaVersionDelEsquema(Long idEsquema) {
		
		return recobroEsquemaDao.getUltimaVersionDelEsquema(idEsquema);
	}
	
	
	
	
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_SAVE_MODELOS_SUBCARTERA_BO)
	@Transactional(readOnly = false)
	public void guardarModelosSubcartera(RecobroSubcarteraDto dto) {
		
		boolean editado = false; 
		RecobroSubcarteraDto dtoDatosModificados= new RecobroSubcarteraDto();
		
		if (!Checks.esNulo(dto.getId())) {
			dtoDatosModificados.setId(dto.getId());
			RecobroSubCartera subcarteraOriginal = subcarteraApi.getRecobroSubCartera(dto.getId());
			
			if (!Checks.esNulo(subcarteraOriginal.getModeloDeRanking())){
				dtoDatosModificados.setModeloDeRanking(subcarteraOriginal.getModeloDeRanking().getId());
			}
			if (!Checks.esNulo(subcarteraOriginal.getModeloFacturacion())){
				dtoDatosModificados.setModeloFacturacion(subcarteraOriginal.getModeloFacturacion().getId());
			}
			if (!Checks.esNulo(subcarteraOriginal.getItinerarioMetasVolantes())){
				dtoDatosModificados.setItinerarioMetasVolantes(subcarteraOriginal.getItinerarioMetasVolantes().getId());
			}
			if (!Checks.esNulo(subcarteraOriginal.getPoliticaAcuerdos())){
				dtoDatosModificados.setPoliticaDeAcuerdo(subcarteraOriginal.getPoliticaAcuerdos().getId());
			}
			
			
			RecobroEsquema esquema = getEsquemaAModificar(subcarteraOriginal.getCarteraEsquema().getEsquema());
			RecobroSubCartera subcarteraAModificar = getSubcarteraAModificar(esquema, subcarteraOriginal);
			
			// modelo facturacion
			RecobroModeloFacturacion nuevoModeloFacturacion = null;
			if (!Checks.esNulo(dto.getModeloFacturacion())) {
				nuevoModeloFacturacion = proxyFactory
						.proxy(RecobroModeloFacturacionApi.class)
						.getModeloFacturacion(dto.getModeloFacturacion());
			} 
			if ( (Checks.esNulo(nuevoModeloFacturacion) && !Checks.esNulo(subcarteraAModificar.getModeloFacturacion())) ||
				 (!Checks.esNulo(nuevoModeloFacturacion) && Checks.esNulo(subcarteraAModificar.getModeloFacturacion())) ||
				 (!Checks.esNulo(nuevoModeloFacturacion) && (!nuevoModeloFacturacion.getId().equals(subcarteraAModificar.getModeloFacturacion().getId()))) ) {
				versionarMinorRelease(esquema);
				subcarteraAModificar.setModeloFacturacion(nuevoModeloFacturacion);
				editado = true;
			}
			
			// modelo metas volantes
			RecobroItinerarioMetasVolantes nuevoModeloMetasVolantes = null;
			if (!Checks.esNulo(dto.getItinerarioMetasVolantes())) {
				nuevoModeloMetasVolantes = proxyFactory
						.proxy(RecobroItinerarioApi.class)
						.getItinerarioRecobro(dto.getItinerarioMetasVolantes());
			} 
			if ( (Checks.esNulo(nuevoModeloMetasVolantes) && !Checks.esNulo(subcarteraAModificar.getItinerarioMetasVolantes())) ||
				 (!Checks.esNulo(nuevoModeloMetasVolantes) && Checks.esNulo(subcarteraAModificar.getItinerarioMetasVolantes())) ||
				 (!Checks.esNulo(nuevoModeloMetasVolantes) && (!nuevoModeloMetasVolantes.getId().equals(subcarteraAModificar.getItinerarioMetasVolantes().getId()))) ) {
				versionarMajorRelease(esquema);
				subcarteraAModificar.setItinerarioMetasVolantes(nuevoModeloMetasVolantes);
				editado = true;
			}
			
			// modelo palancas permitidas
			RecobroPoliticaDeAcuerdos nuevoModeloPoliticas = null;
			if (!Checks.esNulo(dto.getPoliticaDeAcuerdo())) {
				nuevoModeloPoliticas = proxyFactory.proxy(
						RecobroPoliticaDeAcuerdosApi.class)
						.getPoliticaDeAcuerdo(dto.getPoliticaDeAcuerdo());
			} 
			if ( (Checks.esNulo(nuevoModeloPoliticas) && !Checks.esNulo(subcarteraAModificar.getPoliticaAcuerdos())) ||
				 (!Checks.esNulo(nuevoModeloPoliticas) && Checks.esNulo(subcarteraAModificar.getPoliticaAcuerdos())) ||
				 (!Checks.esNulo(nuevoModeloPoliticas) && (!nuevoModeloPoliticas.getId().equals(subcarteraAModificar.getPoliticaAcuerdos().getId()))) ) {
				versionarMajorRelease(esquema);
				subcarteraAModificar.setPoliticaAcuerdos(nuevoModeloPoliticas);	
				editado = true;
			}
			
			// modelo ranking
			RecobroModeloDeRanking nuevoModeloDeRanking = null;
			if (!Checks.esNulo(dto.getModeloDeRanking())) {
				nuevoModeloDeRanking = proxyFactory.proxy(
						RecobroModeloDeRankingApi.class).getModeloDeRanking(
						dto.getModeloDeRanking());
			} 
			if ( (Checks.esNulo(nuevoModeloDeRanking) && !Checks.esNulo(subcarteraAModificar.getModeloDeRanking())) ||
				 (!Checks.esNulo(nuevoModeloDeRanking) && Checks.esNulo(subcarteraAModificar.getModeloDeRanking())) ||
				 (!Checks.esNulo(nuevoModeloDeRanking) && (!nuevoModeloDeRanking.getId().equals(subcarteraAModificar.getModeloDeRanking().getId()))) ) {
				versionarVersionRelease(esquema);
				subcarteraAModificar.setModeloDeRanking(nuevoModeloDeRanking);	
				editado = true;
			}
			
			if (editado) recobroSubCarteraDao.save(subcarteraAModificar);
			// save del esquema
			
			// cambiar los estados de los modelos a bloqueados o a liberados dependiendo de que se haya modificado
			cambiaEstadoModelos(dto,dtoDatosModificados);
		}
	}

	/**
	 * A partir de un esquema indica se es una version del esquema liberado o no.
	 */
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_EN_ESQUEMA_LIBERADO_BO)
	public Boolean esVersionDelEsquemaliberado(RecobroEsquema esquema) {
		RecobroEsquema esquemaLiberado = getEsquemaLiberado();
		if (!Checks.esNulo(esquemaLiberado)){
			if (esquemaLiberado.getIdGrupoVersion().equals(esquema.getIdGrupoVersion())){
				return true;
			}
		}
		return false;
	}


	/**
	 * Metodo que comprueba si el esquema recibido es version del esquema liberado y 
	 * en tal caso sube la version del version release si no esta subida ya. 
	 */
	private void versionarVersionRelease(RecobroEsquema esquema) {
		if (esVersionDelEsquemaliberado(esquema)){
			RecobroEsquema esquemaLiberado = getEsquemaLiberado();
			if (esquema.getVersionrelease().equals(esquemaLiberado.getVersionrelease())){
				esquema.setVersionrelease(esquema.getVersionrelease()+1);
			}
		}
	}

	/**
	 * Metodo que comprueba si el esquema recibido es version del esquema liberado y 
	 * en tal caso sube la version del major release si no esta subida ya. 
	 */
	private void versionarMajorRelease(RecobroEsquema esquema) {
		if (esVersionDelEsquemaliberado(esquema)){
			RecobroEsquema esquemaLiberado = getEsquemaLiberado();
			if (esquema.getMajorRelease().equals(esquemaLiberado.getMajorRelease())){
				esquema.setMajorRelease(esquema.getMajorRelease()+1);
			}
		}
	}

	/**
	 * Metodo que comprueba si el esquema recibido es version del esquema liberado y 
	 * en tal caso sube la version del minor release si no esta subida ya. 
	 */
	private void versionarMinorRelease(RecobroEsquema esquema) {
		if (esVersionDelEsquemaliberado(esquema)){
			RecobroEsquema esquemaLiberado = getEsquemaLiberado();
			if (esquema.getMinorRelease().equals(esquemaLiberado.getMinorRelease())){
				esquema.setMinorRelease(esquema.getMinorRelease()+1);
			}
		}
	}

	/**
	 * A partir de un esquema y una subcartera, devuelve la subcartera del esquema
	 * recibido que tiene el mismo 'nombre' que la subcartera recibida
	 */
	private RecobroSubCartera getSubcarteraAModificar(RecobroEsquema esquema,
			RecobroSubCartera subcarteraOriginal) {
		return recobroSubCarteraDao.getSubcarteraPorNombreYEsquema(esquema,	subcarteraOriginal);
	}
	
	private RecobroCarteraEsquema getCarteraEsquemaAModificar(RecobroEsquema esquema, RecobroCarteraEsquema carteraEsquema) {
		return recobroCarteraEsquemaDao.getCarteraEsquemaPorNombreYEsquema(esquema, carteraEsquema);
	}

	/**
	 * A partir de un esquema que se quiere modificar, devuelve el esquema a modificar 
	 * segun sea el esquema recibido una version o un esquema liberado.
	 * return: Si es un esquema liberado devuelve la copia
	 * 		   Si es un esquema versionado o no liberado devuelve el mismo esquema recibido
	 */
	private RecobroEsquema getEsquemaAModificar(RecobroEsquema esquema) {
		RecobroEsquema esquemaLiberado = getEsquemaLiberado();
		if (!Checks.esNulo(esquemaLiberado)){
			if (esquemaLiberado.getId().equals(esquema.getId())){
				Long idNuevoEsquema = copiaEsquema(esquemaLiberado.getId(),false);
				esquema = recobroEsquemaDao.get(idNuevoEsquema);
			} 
		} 
		return esquema;
	}

	
	/**
	 * Metodo que devuelve el esquema liberado
	 */
	private RecobroEsquema getEsquemaLiberado() {
		
		Filter f2 = genericDao.createFilter(FilterType.EQUALS,"estadoEsquema.codigo", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO);
		return genericDao.get(RecobroEsquema.class, f2);
		
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_GET_ESQUEMAS_BLOQUEADOS)
	public List<RecobroEsquema> getEsquemasBloqueados() {
		return recobroEsquemaDao.getEsquemasBloqueados();
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERAAGENCIAS_BO)
	public List<RecobroSubcarteraAgencia> getSubCarterasAgencias(
			Long idSubCartera) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,
				"subCartera.id", idSubCartera);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS,
				"auditoria.borrado", false);
		return genericDao.getList(RecobroSubcarteraAgencia.class, filtro, f2);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERARANKING_BO)
	public List<RecobroSubcarteraRanking> getSubCarterasRanking(
			Long idSubCartera) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,
				"subCartera.id", idSubCartera);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS,
				"auditoria.borrado", false);
		return genericDao.getList(RecobroSubcarteraRanking.class, filtro, f2);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_GETLIST_BO)
	public List<RecobroEsquema> getListaEsquemas() {
		return recobroEsquemaDao.getList();
	}

	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_SAVE_AGENCIAS_SUBCARTERA_BO)
	@Transactional(readOnly = false)
	public void guardarAgenciasSubcartera(RecobroSubcarAgenciaDto dto,	RecobroSubcarteraAgenciasGrid gridItems) {
		RecobroCarteraEsquema carteraEsquema = proxyFactory.proxy(RecobroCarteraEsquemaApi.class)
				.getRecobroCarteraEsquema(dto.getIdCarteraEsquema());
		
		if (!compruebaSuperaMaximoPorcentage(carteraEsquema, dto.getParticion(), dto.getIdSubCartera())) {
			
			RecobroEsquema esquema = getEsquemaAModificar(carteraEsquema.getEsquema());
			
			RecobroSubCartera subcarteraAModificar;
			if (dto.getIdSubCartera() == -1) { 
				//Nueva subCartera
				subcarteraAModificar = new RecobroSubCartera();
				RecobroCarteraEsquema carteraEsquemaModificar = getCarteraEsquemaAModificar(esquema, carteraEsquema);
				subcarteraAModificar.setCarteraEsquema(carteraEsquemaModificar);

				RecobroDDTipoRepartoSubcartera ddTipoReparto = (RecobroDDTipoRepartoSubcartera) proxyFactory
						.proxy(DiccionarioApi.class).dameValorDiccionario(RecobroDDTipoRepartoSubcartera.class,	dto.getIdTipoReparto());
				subcarteraAModificar.setTipoRepartoSubcartera(ddTipoReparto);

				subcarteraAModificar.setNombre(dto.getNomSubCartera());
				subcarteraAModificar.setParticion(dto.getParticion());

			} else {
				
				//Modificar Subcartera
				RecobroSubCartera subcarteraOriginal = subcarteraApi.getRecobroSubCartera(dto.getIdSubCartera());
				subcarteraAModificar = getSubcarteraAModificar(esquema, subcarteraOriginal);
				
				subcarteraAModificar.setNombre(dto.getNomSubCartera());
				subcarteraAModificar.setParticion(dto.getParticion());

				if (!Checks.esNulo(subcarteraOriginal.getAgencias())) {
					// Borrar todo el reparto de agencias de la subcartera
					for (RecobroSubcarteraAgencia subCarAgencia : subcarteraOriginal.getAgencias()) {
						RecobroSubcarteraAgencia subCarAgenciaAModificar = recobroSubCarteraAgenciaDao
								.getSubcarteraAgenciaPorAgenciaYSubCartera(subcarteraAModificar,subCarAgencia);
								
						genericDao.deleteById(RecobroSubcarteraAgencia.class, subCarAgenciaAModificar.getId());
					}	
				}

				if (!Checks.esNulo(subcarteraOriginal.getRanking())) {
					// Borrar todo el ranking de la subcartera
					for (RecobroSubcarteraRanking subCarRanking : subcarteraOriginal.getRanking()) {
						RecobroSubcarteraRanking subCarRankingAModificar = recobroSubCarteraRankingDao
								.getSubcarteraRankingPorPosicionYSubCartera(subcarteraAModificar, subCarRanking);
						
						genericDao.deleteById(RecobroSubcarteraRanking.class, subCarRankingAModificar.getId());
					}
				}
			}

			recobroSubCarteraDao.saveOrUpdate(subcarteraAModificar);

			// Guardar las agencias
			List<SubCarAgenItem> itemsAgen = gridItems.getSubCarAgenItems();
			for (SubCarAgenItem item : itemsAgen) {
				RecobroSubcarteraAgencia subCarAgen = new RecobroSubcarteraAgencia();

				subCarAgen.setAgencia(proxyFactory.proxy(RecobroAgenciaApi.class).getAgencia(item.getIdAgencia()));
				subCarAgen.setSubCartera(subcarteraAModificar);
				subCarAgen.setReparto(item.getCoeficiente());

				genericDao.save(RecobroSubcarteraAgencia.class, subCarAgen);

			}

			// Guardar el ranking
			List<SubCarRankingItem> itemsRanking = gridItems.getSubCarRankingItems();
			for (SubCarRankingItem item : itemsRanking) {
				RecobroSubcarteraRanking subCarRanking = new RecobroSubcarteraRanking();

				subCarRanking.setSubCartera(subcarteraAModificar);
				subCarRanking.setPosicion(item.getPosicion());
				subCarRanking.setPorcentaje(item.getPorcentaje());

				genericDao.save(RecobroSubcarteraRanking.class, subCarRanking);

			}
			
			//Versionar el esquema
			versionarMajorRelease(esquema);			
			recobroEsquemaDao.saveOrUpdate(esquema);

		} else {
			throw new BusinessOperationException("El porcentage de partición supera el 100%");
		}

	}

	private boolean compruebaSuperaMaximoPorcentage(
			RecobroCarteraEsquema carteraEsquema, Integer particion,
			Long idSubcartera) {
		Boolean superior = false;
		Integer suma = particion;
		if (particion > 100) {
			return false;
		}
		if (!Checks.esNulo(carteraEsquema.getSubcarteras())){
			for (RecobroSubCartera subCartera : carteraEsquema.getSubcarteras()) {
				if (!subCartera.getId().equals(idSubcartera)) {
					suma = suma + subCartera.getParticion();
					if (suma > 100) {
						return true;
					}
				}
			}
		}
		return superior;
	}

	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_ESQUEMA_CABIAR_ESTADO_BO)
	@Transactional(readOnly = false)
	public void cambiarEstadoRecobroEsquema(Long idEsquema, String codEstado) {
		
		if (!Checks.esNulo(idEsquema) && !Checks.esNulo(codEstado)) {
			RecobroEsquema esquema = this.getRecobroEsquema(idEsquema);
			
			if (RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR.equals(codEstado)) {
				String errores = validaCambioEstadoRecobroEsquema(esquema);
				if (!Checks.esNulo(errores)) {
					throw new BusinessOperationException(errores);
				}
			} else if (RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTELIBERAR.equals(codEstado)) {
				String errores = validaCambioEstadoPendienteLiberar(esquema);
				if (!Checks.esNulo(errores)){
					throw new BusinessOperationException(errores);
				}
			} else if (RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION.equals(codEstado)) {								
				List<RecobroSimulacionEsquema> simulacionesPendientes = proxyFactory.proxy(RecobroSimulacionEsquemaManager.class).getSimulacionesDelEsquema(idEsquema);
				for (RecobroSimulacionEsquema recobroSimulacionEsquema : simulacionesPendientes) {
					genericDao.deleteById(RecobroSimulacionEsquema.class, recobroSimulacionEsquema.getId());					
				}
			}
			
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", codEstado);
			RecobroDDEstadoEsquema estadoEsquema = genericDao.get(RecobroDDEstadoEsquema.class, f1);
			esquema.setEstadoEsquema(estadoEsquema);
			recobroEsquemaDao.saveOrUpdate(esquema);
			
			if (RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR.equals(codEstado)) {
				//TODO - LIMPIAR SIMULACIONES PENDIENTES ANTERIOR
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", RecobroDDEstadoSimulacion.RCF_DD_ESI_ESTADO_SIMULACION_PENDIENTE_SIMULAR);
				RecobroDDEstadoSimulacion estadoSimulacion = genericDao.get(RecobroDDEstadoSimulacion.class, f1);
				if (Checks.esNulo(estadoSimulacion)) {
					throw new BusinessOperationException(
							"No se ha encontrado el estado Pendiente de simular");
				}
//				
//				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "estado", estadoSimulacion);				
//				List<RecobroSimulacionEsquema> simulacionesPendientes = genericDao.getList(RecobroSimulacionEsquema.class, f2);
				List<RecobroSimulacionEsquema> simulacionesPendientes = proxyFactory.proxy(RecobroSimulacionEsquemaManager.class).getSimulacionesPorEstado(estadoSimulacion.getId());
				for (RecobroSimulacionEsquema recobroSimulacionEsquema : simulacionesPendientes) {
					genericDao.deleteById(RecobroSimulacionEsquema.class, recobroSimulacionEsquema.getId());					
				}
				
				// Dejar el estado de la simulación en pendiente				
				RecobroSimulacionEsquema simulacionEsquema = new RecobroSimulacionEsquema();
				
				simulacionEsquema.setEsquema(esquema);
				simulacionEsquema.setFechaPeticion(new Date());
				
				
				simulacionEsquema.setEstado(estadoSimulacion);
				
				genericDao.save(RecobroSimulacionEsquema.class, simulacionEsquema);
			}
			
		} else {
			throw new BusinessOperationException(
					"No se han pasado los parámetros necesarios para ejecutar la operación");
		}
	}

	
	

	/**
	 * Comprueba que esté todo ok para cambiar el estado del esquema, de lo contrario devolverá un String con el error encontrado
	 * @param esquema
	 * @return
	 */
	private String validaCambioEstadoRecobroEsquema(RecobroEsquema esquema) {
		
		//Deberá haber al menos una cartera definida
		if (Checks.estaVacio(esquema.getCarterasEsquema())) {
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.sinCarterasDefinidas", new Object[] {}, "**El esquema no tiene carteras definidas", MessageUtils.DEFAULT_LOCALE);
		}
		
		String errores = validaCarterasEsquema(esquema.getCarterasEsquema());
		if (!Checks.esNulo(errores)) return errores;
		
		//El estado anterior del esquema deberá ser definición
		if (!RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION.equals(esquema.getEstadoEsquema().getCodigo())) {
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.estadoNoDefinicion", new Object[] {}, "**El esquema no estaba en estado definición", MessageUtils.DEFAULT_LOCALE);
		}
		// No debe de existir ningún esquema que esté en estado pte de liberar
		List<RecobroEsquema> esquemasPtesSimular = buscaEsquemasPtesSimular();
		if (!Checks.esNulo(esquemasPtesSimular) && !Checks.estaVacio(esquemasPtesSimular)){
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.existeEsquemaPteSimular", new Object[] {}, "**Ya existe un esquema en estado Pte. de simular", MessageUtils.DEFAULT_LOCALE);
			
		}
		return null;
	}
	
	private List<RecobroEsquema> buscaEsquemasPtesSimular() {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "estadoEsquema.codigo", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<RecobroEsquema> esquemas = genericDao.getList(RecobroEsquema.class, filtro, filtroBorrado);
		return esquemas;
	}

	/**
	 * Comprueba que esté todo ok para cambiar el estado del esquema, de lo contrario devolverá un String con el error encontrado
	 * @param esquema
	 * @return
	 */
	private String validaCambioEstadoPendienteLiberar(RecobroEsquema esquema) {
		//Deberá haber al menos una cartera definida
		if (Checks.estaVacio(esquema.getCarterasEsquema())) {
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.sinCarterasDefinidas", new Object[] {}, "**El esquema no tiene carteras definidas", MessageUtils.DEFAULT_LOCALE);
		}
				
		String errores = validaCarterasEsquema(esquema.getCarterasEsquema());
		if (!Checks.esNulo(errores)) return errores;
				
		//El estado anterior del esquema deberá ser liberado o en definición si es la última 
		//versión del esquema liberado y sólo se ha modificado la major o la minor release
		if (!RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO.equals(esquema.getEstadoEsquema().getCodigo())){
			if (RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION.equals(esquema.getEstadoEsquema().getCodigo()) ){
				if ( !this.esVersionDelEsquemaliberado(esquema)){
					return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.estadoDefinicion", new Object[] {}, "**Para liberar un esquema primero lo debe de simular", MessageUtils.DEFAULT_LOCALE);
				} else {
					RecobroEsquema esquemaLiberado = this.getEsquemaLiberado();
					if (!esquemaLiberado.getVersion().equals(esquema.getVersion())){
						return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.cambioVersion", new Object[] {}, "**Ha habido un cambio en la versión del esquema, por lo tanto debe de simular antes de liberar", MessageUtils.DEFAULT_LOCALE);
					}
				}	
			} else {
				return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.estadoNoErroneo", new Object[] {}, "**El esquema no esta en estado permitido para liberar", MessageUtils.DEFAULT_LOCALE);
			}
		}
		
		// No debe de existir ningún esquema que esté en estado pte de liberar
		List<RecobroEsquema> esquemasPtesLiberar = buscaEsquemasPtesLiberar();
		if (!Checks.esNulo(esquemasPtesLiberar) && !Checks.estaVacio(esquemasPtesLiberar)){
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.existeEsquemaPteLiberar", new Object[] {}, "**Ya existe un esquema en estado Pte. de liberar", MessageUtils.DEFAULT_LOCALE);			
		}
			
		return null;	
				
	}
	
	private List<RecobroEsquema> buscaEsquemasPtesLiberar() {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "estadoEsquema.codigo", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTELIBERAR);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<RecobroEsquema> esquemas = genericDao.getList(RecobroEsquema.class, filtro, filtroBorrado);
		return esquemas;
	}

	/**
	 * Realiza validaciones en las carteras del esquema
	 * @param carterasEsquema
	 * @return
	 */
	private String validaCarterasEsquema(List<RecobroCarteraEsquema> carterasEsquema) {
		
		String errores = null;
		boolean hayCarterasGestion = false;
		for (RecobroCarteraEsquema carteraEsquema : carterasEsquema) {
			//Deberá haber al menos una cartera definida
			if (Checks.esNulo(carteraEsquema.getCartera())) {
				return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.sinCarterasDefinidas", new Object[] {}, "**El esquema no tiene carteras definidas", MessageUtils.DEFAULT_LOCALE);
			} else {
				if (RecobroDDTipoCarteraEsquema.TIPO_CARTERA_GESTION.equals(carteraEsquema.getTipoCarteraEsquema().getCodigo())) {
					Boolean gestionable=false;
					if (!Checks.esNulo(carteraEsquema.getTipoGestionCarteraEsquema())){
						if(!RecobroDDTipoGestionCartera.CODIGO_TIPO_SIN_GESTION.equals(carteraEsquema.getTipoGestionCarteraEsquema().getCodigo())){
							hayCarterasGestion = true;
							gestionable=true;
						}
					}
					//Todas las carteras que haya definidas deberán tener todos los campos rellenados
					if (!isDatosCarteraRellenos(carteraEsquema.getCartera())) {
						return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.faltanDatos", new Object[] {carteraEsquema.getCartera().getNombre()}, "**La cartera {0} no contiene todos los datos informados", MessageUtils.DEFAULT_LOCALE);
					}				
					if (hayCarterasGestion){
						
					}
					if (gestionable){
						errores = validaSubCarterasCartera(carteraEsquema);
						if (!Checks.esNulo(errores)) {
							return errores;
						}
					}
					
				}
			}
		}
		if (!hayCarterasGestion) {
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.sinCarterasGestionDefinidas", new Object[] {}, "**El esquema no tiene carteras de gestión definidas", MessageUtils.DEFAULT_LOCALE);
		}
		return null;
	}
	
	/**
	 * Comprueba que todos los datos de la cartera estén como mínimo rellenos
	 * @param cartera
	 * @return
	 */
	private boolean isDatosCarteraRellenos(RecobroCartera cartera) {
		if (Checks.esNulo(cartera.getNombre()) 
				|| Checks.esNulo(cartera.getDescripcion()) 
				|| Checks.esNulo(cartera.getRegla())
				|| Checks.esNulo(cartera.getEstado())
				|| Checks.esNulo(cartera.getFechaAlta())) {
			return false;
		}
		return true;
	}

	/**
	 * Realiza validaciones en las subcarteras de la cartera
	 * @param carteraEsquema
	 * @return
	 */
	private String validaSubCarterasCartera(RecobroCarteraEsquema carteraEsquema) {

		if (Checks.estaVacio(carteraEsquema.getSubcarteras())) {
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.sinSubCarteras", new Object[] {carteraEsquema.getCartera().getNombre()}, "**La cartera {0} no tiene asociada ninguna subcartera", MessageUtils.DEFAULT_LOCALE);
		}
		int porcentaje = 0;
		for(RecobroSubCartera subCartera : carteraEsquema.getSubcarteras()) {
			porcentaje += subCartera.getParticion();
			
			//Toda subcartera deberá tener asociado un modelo de facturación, de ranking, de metas volantes y de política de acuerdos	
			if (Checks.esNulo(subCartera.getModeloFacturacion())) {
				return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.subCartera.faltaModFactu", new Object[] {subCartera.getNombre()}, "**La subcartera {0} no tiene asociado ningún modelo de facturación", MessageUtils.DEFAULT_LOCALE);	
			}
			if (Checks.esNulo(subCartera.getModeloDeRanking())) {
				return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.subCartera.faltaModRanking", new Object[] {subCartera.getNombre()}, "**La subcartera {0} no tiene asociado ningún modelo de ranking", MessageUtils.DEFAULT_LOCALE);	
			}
			if (Checks.esNulo(subCartera.getItinerarioMetasVolantes())) {
				return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.subCartera.faltaMetasVolantes", new Object[] {subCartera.getNombre()}, "**La subcartera {0} no tiene asociado ningún itinerario de metas volantes", MessageUtils.DEFAULT_LOCALE);	
			}
			if (Checks.esNulo(subCartera.getPoliticaAcuerdos())) {
				return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.subCartera.faltaPoliticaAcuerdos", new Object[] {subCartera.getNombre()}, "**La subcartera {0} no tiene asociada ninguna política de acuerdos", MessageUtils.DEFAULT_LOCALE);	
			}
		}
		//Toda cartera definida en el esquema deberá tener subcarteras que cubran el 100% de la cartera
		if (porcentaje != 100) {
			return ms.getMessage("plugin.recobroConfig.esquemaManager.validaCambioEstadoRecobroEsquema.porcentajeSubcarteraNoCubierto", new Object[] {carteraEsquema.getCartera().getNombre()}, "**La suma de los porcentajes de las subcarteras no cubre el 100% de la cartera {0}", MessageUtils.DEFAULT_LOCALE);
		}
		
		
		return null;
	}
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_GET_SIMULACION_ESQUEMA_BO)
	public RecobroSimulacionEsquema getSimulacion(Long idEsquema) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "esquema.id", idEsquema);
		List<RecobroSimulacionEsquema> simulaciones = genericDao.getList(RecobroSimulacionEsquema.class, f1);
		if (!Checks.esNulo(simulaciones) && !Checks.estaVacio(simulaciones)){
			return simulaciones.get(0);
		} else {
			return null;
		}
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_GET_FICHERO_SIMULACION_BO)
	public FileItem getFicheroSimulacion(Long idEsquema, String tipoFichero) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "esquema.id", idEsquema);
		RecobroSimulacionEsquema simulacionEsquema = genericDao.get(RecobroSimulacionEsquema.class, f1);
		FileItem fichero = null;
		if (!Checks.esNulo(simulacionEsquema)) {
			if (RecobroSimulacionEsquema.COD_FICHERO_RESUMEN.equals(tipoFichero)) {
				fichero = simulacionEsquema.getFichResumen().getFileItem();
			} else {
				fichero = simulacionEsquema.getFichDetalle().getFileItem();
			}
		}
		return fichero;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_COPIAR_ESQUEMA_BO)
	@Transactional(readOnly=false)
	public Long copiaEsquema(Long idEsquema, Boolean resetVersion) {
		RecobroEsquema esquema = this.getRecobroEsquema(idEsquema);
		Long idCopia = this.guardarCopiaRecobroEsquema(creaDtoCopiaEsquema(esquema, resetVersion));
		RecobroEsquema copia = this.getRecobroEsquema(idCopia);
		copiaCarterasEsquema(esquema, copia);
		copiarRepartosEsquema (esquema, copia);
		copiarModelosGestion(esquema, copia);
		return idCopia;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_ESQUEMAAPI_APTOLIBERAR_BO)
	public Boolean compruebaEstadoCorrectoLiberar(Long idEsquema) {
		RecobroEsquema esquema = this.getRecobroEsquema(idEsquema);
		if (!RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO.equals(esquema.getEstadoEsquema().getCodigo())){
			if (RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION.equals(esquema.getEstadoEsquema().getCodigo()) ){
				if ( !this.esVersionDelEsquemaliberado(esquema)){
					return false;
				} else {
					RecobroEsquema esquemaLiberado = this.getEsquemaLiberado();
					if (!esquemaLiberado.getVersion().equals(esquema.getVersion())){
						return false;
					}
				}	
			} else {
				return false;
			}
		}
		return true;
	}
	
	private Long guardarCopiaRecobroEsquema(
			RecobroEsquemaDto dto) {
		if (!Checks.esNulo(dto)) {
			RecobroEsquema esquema = null;
			if (!Checks.esNulo(dto.getId())) {
				esquema = this.getRecobroEsquema(Long.valueOf(dto.getId()));
			} else {
				esquema = new RecobroEsquema();
				esquema.setPropietario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());
				esquema.setEstadoEsquema((RecobroDDEstadoEsquema) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoEsquema.class, RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION));
				esquema.setVersionrelease(dto.getVersionrelease());
				esquema.setMajorRelease(dto.getMajorRelease());
				esquema.setMinorRelease(dto.getMinorRelease());
				esquema.setFechaAlta(new Date());
				esquema.setIdGrupoVersion(0L);
			}
			esquema.setNombre(dto.getNombre());
			esquema.setDescripcion(dto.getDescripcion());

			if (!Checks.esNulo(dto.getPlazoActivacion()))
				esquema.setPlazo(Integer.valueOf(dto.getPlazoActivacion()));

			/*
			 * Long idEstado = Long.parseLong(dto.getEstado()); Filter f1 =
			 * genericDao.createFilter(FilterType.EQUALS, "id", idEstado);
			 * RecobroDDEstadoEsquema estadoEsquema =
			 * genericDao.get(RecobroDDEstadoEsquema.class, f1);
			 * esquema.setEstadoEsquema(estadoEsquema);
			 */

			Long idModelo = Long.parseLong(dto.getModeloTransicion());
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "id",
					idModelo);
			RecobroDDModeloTransicion modeloTransicion = genericDao.get(
					RecobroDDModeloTransicion.class, f2);
			esquema.setModeloTransicion(modeloTransicion);

			Long idEsquema = recobroEsquemaDao.save(esquema);
			RecobroEsquema esquemaNuevo = this.getRecobroEsquema(idEsquema);
			if (!Checks.esNulo(dto.getIdGrupoVersion())){
				esquemaNuevo.setIdGrupoVersion(dto.getIdGrupoVersion());
			} else {
				esquemaNuevo.setIdGrupoVersion(esquemaNuevo.getId());
			}
			return recobroEsquemaDao.save(esquemaNuevo);

		} else {
			throw new BusinessOperationException(
					"No se ha pasado el dto del esquema que se va a modificar");
		}

	}

	private void copiarModelosGestion(RecobroEsquema esquema,
			RecobroEsquema copia) {
		for (RecobroCarteraEsquema carteraEsquema : esquema.getCarterasEsquema()){
			for (RecobroCarteraEsquema carteraEsquemaCopia : dameCarteras(copia.getId())){
				if (carteraEsquema.getCartera().getId().equals(carteraEsquemaCopia.getCartera().getId())){
					if (!Checks.esNulo(carteraEsquema.getSubcarteras())){
						for(RecobroSubCartera subcartera : carteraEsquema.getSubcarteras()){
							for(RecobroSubCartera subcarteraCopia : dameSubcarteras(carteraEsquemaCopia.getId())){
								if(subcartera.getNombre().equals(subcarteraCopia.getNombre())){
									copiaModelosGestion(subcartera, subcarteraCopia);
								}
							}
						}
							
					}
				}
			}
		}
		
	}

	
	private void copiaModelosGestion(RecobroSubCartera subcartera,
			RecobroSubCartera subcarteraCopia) {
		if (!Checks.esNulo(subcartera.getItinerarioMetasVolantes())){
			subcarteraCopia.setItinerarioMetasVolantes(subcartera.getItinerarioMetasVolantes());
		}
		if (!Checks.esNulo(subcartera.getModeloFacturacion())){
			subcarteraCopia.setModeloFacturacion(subcartera.getModeloFacturacion());
		}
		if (!Checks.esNulo(subcartera.getModeloDeRanking())){
			subcarteraCopia.setModeloDeRanking(subcartera.getModeloDeRanking());
		}
		if (!Checks.esNulo(subcartera.getPoliticaAcuerdos())){
			subcarteraCopia.setPoliticaAcuerdos(subcartera.getPoliticaAcuerdos());
		}
		
		genericDao.save(RecobroSubCartera.class, subcarteraCopia);
	}

	private void copiarRepartosEsquema(RecobroEsquema esquema,
			RecobroEsquema copia) {
		for (RecobroCarteraEsquema carteraEsquema : esquema.getCarterasEsquema()){
			for (RecobroCarteraEsquema carteraEsquemaCopia : dameCarteras(copia.getId())){
				if (carteraEsquema.getCartera().getId().equals(carteraEsquemaCopia.getCartera().getId())){
					if (!Checks.esNulo(carteraEsquema.getSubcarteras())){
							copiaRepartosCartera(carteraEsquema, carteraEsquemaCopia);
					}
				}
			}
		}
		
	}

	private void copiaRepartosCartera(RecobroCarteraEsquema carteraEsquema,
			RecobroCarteraEsquema carteraEsquemaCopia) {
		for (RecobroSubCartera subcartera : carteraEsquema.getSubcarteras()){
			RecobroSubcarAgenciaDto dto = new RecobroSubcarAgenciaDto();
			dto.setIdCarteraEsquema(carteraEsquemaCopia.getId());
			dto.setIdTipoReparto(subcartera.getTipoRepartoSubcartera().getId());
			dto.setNomSubCartera(subcartera.getNombre());
			dto.setParticion(subcartera.getParticion());
			dto.setIdSubCartera(-1L);
			RecobroSubcarteraAgenciasGrid gridItems = new RecobroSubcarteraAgenciasGrid();
			List<SubCarAgenItem> subCarAgenItems = new ArrayList<SubCarAgenItem>();
			for (RecobroSubcarteraAgencia agencia : subcartera.getAgencias()){
				SubCarAgenItem ageItem = new SubCarAgenItem();
				ageItem.setIdAgencia(agencia.getAgencia().getId());
				ageItem.setCoeficiente(agencia.getReparto());
				subCarAgenItems.add(ageItem);
			}
			gridItems.setSubCarAgenItems(subCarAgenItems);
			List<SubCarRankingItem> subCarRankingItems = new ArrayList<SubCarRankingItem>();
			for (RecobroSubcarteraRanking ranking : subcartera.getRanking()){
				SubCarRankingItem rankItem= new SubCarRankingItem();
				rankItem.setPorcentaje(ranking.getPorcentaje());
				rankItem.setPosicion(ranking.getPosicion());
				subCarRankingItems.add(rankItem);
			}
			gridItems.setSubCarRankingItems(subCarRankingItems);
			this.guardarCopiaAgenciasSubcartera( dto,
					 gridItems);
		}
		
	}

	private void guardarCopiaAgenciasSubcartera(RecobroSubcarAgenciaDto dto,
			RecobroSubcarteraAgenciasGrid gridItems) {
		RecobroCarteraEsquema carteraEsquema = proxyFactory.proxy(
				RecobroCarteraEsquemaApi.class).getRecobroCarteraEsquema(
				dto.getIdCarteraEsquema());
		if (!compruebaSuperaMaximoPorcentage(carteraEsquema,
				dto.getParticion(), dto.getIdSubCartera())) {
			RecobroSubCartera subCartera;
			if (dto.getIdSubCartera() == -1) {
				subCartera = new RecobroSubCartera();
				subCartera.setCarteraEsquema(carteraEsquema);

				RecobroDDTipoRepartoSubcartera ddTipoReparto = (RecobroDDTipoRepartoSubcartera) proxyFactory
						.proxy(DiccionarioApi.class).dameValorDiccionario(
								RecobroDDTipoRepartoSubcartera.class,
								dto.getIdTipoReparto());
				subCartera.setTipoRepartoSubcartera(ddTipoReparto);

				subCartera.setNombre(dto.getNomSubCartera());
				subCartera.setParticion(dto.getParticion());

			} else {
				subCartera = proxyFactory.proxy(RecobroSubCarteraApi.class)
						.getRecobroSubCartera(dto.getIdSubCartera());

				subCartera.setNombre(dto.getNomSubCartera());
				subCartera.setParticion(dto.getParticion());

				// Borrar todo el reparto de agencias de la subcartera
				for (RecobroSubcarteraAgencia subCarAgencia : subCartera
						.getAgencias()) {
					genericDao.deleteById(RecobroSubcarteraAgencia.class,
							subCarAgencia.getId());
				}

				// Borrar todo el ranking de la subcartera
				for (RecobroSubcarteraRanking subCarRanking : subCartera
						.getRanking()) {
					genericDao.deleteById(RecobroSubcarteraRanking.class,
							subCarRanking.getId());
				}

			}

			recobroSubCarteraDao.saveOrUpdate(subCartera);

			// Guardar las agencias
			List<SubCarAgenItem> itemsAgen = gridItems.getSubCarAgenItems();
			for (SubCarAgenItem item : itemsAgen) {
				RecobroSubcarteraAgencia subCarAgen = new RecobroSubcarteraAgencia();

				subCarAgen.setAgencia(proxyFactory.proxy(
						RecobroAgenciaApi.class)
						.getAgencia(item.getIdAgencia()));
				subCarAgen.setSubCartera(subCartera);
				subCarAgen.setReparto(item.getCoeficiente());

				genericDao.save(RecobroSubcarteraAgencia.class, subCarAgen);

			}

			// Guardar el ranking
			List<SubCarRankingItem> itemsRanking = gridItems
					.getSubCarRankingItems();
			for (SubCarRankingItem item : itemsRanking) {
				RecobroSubcarteraRanking subCarRanking = new RecobroSubcarteraRanking();

				subCarRanking.setSubCartera(subCartera);
				subCarRanking.setPosicion(item.getPosicion());
				subCarRanking.setPorcentaje(item.getPorcentaje());

				genericDao.save(RecobroSubcarteraRanking.class, subCarRanking);

			}

		} else {
			throw new BusinessOperationException(
					"El porcentage de partición supera el 100%");
		}
		
	}

	private List<RecobroCarteraEsquema> dameCarteras(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "esquema.id", id);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"id");
		return genericDao.getListOrdered(RecobroCarteraEsquema.class,order, filtroBorrado, filtro);
	}
	
	private List<RecobroSubCartera> dameSubcarteras(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "carteraEsquema.id", id);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"id");
		return genericDao.getListOrdered(RecobroSubCartera.class,order, filtroBorrado, filtro);
	}


	private void copiaCarterasEsquema(RecobroEsquema esquema,
			RecobroEsquema copia) {
		for (RecobroCarteraEsquema cartera : esquema.getCarterasEsquema()){
			proxyFactory.proxy(RecobroCarteraEsquemaApi.class).guardarRecobroCarteraEsquema(creaDtoAgregarCarteraEsquema(cartera, copia));
		}
		
	}

	private RecobroCarteraEsquemaDto creaDtoAgregarCarteraEsquema(
			RecobroCarteraEsquema cartera, RecobroEsquema copia) {
		RecobroCarteraEsquemaDto dto = new RecobroCarteraEsquemaDto();
		dto.setIdEsquema(copia.getId());
		dto.setCodigoTipoCarteraEsquema(cartera.getTipoCarteraEsquema().getCodigo());
		if (!Checks.esNulo(cartera.getAmbitoExpedienteRecobro())){
			dto.setIdAmbitoExpedienteRecobro(cartera.getAmbitoExpedienteRecobro().getId());
		}
		dto.setIdCartera(cartera.getCartera().getId());
		dto.setPrioridad(cartera.getPrioridad());
		if (!Checks.esNulo(cartera.getTipoGestionCarteraEsquema())){
			dto.setIdTipoGestionCarteraEsquema(cartera.getTipoGestionCarteraEsquema().getId());
		}
		return dto;
	}

	private RecobroEsquemaDto creaDtoCopiaEsquema(RecobroEsquema esquema,
			Boolean resetVersion) {
		RecobroEsquemaDto dto = new RecobroEsquemaDto();
		if (resetVersion){
			String[] nombreCopia = esquema.getNombre().split("_");
			dto.setNombre(nombreCopia[0]+"_COPIA_"+(new SimpleDateFormat("_ddMMyyyy_HHmmss").format(new Date())));
			dto.setVersionrelease(1);
			dto.setMajorRelease(0);
			dto.setMinorRelease(0);
			
		} else {
			dto.setNombre(esquema.getNombre());
			dto.setIdGrupoVersion(esquema.getIdGrupoVersion());
			dto.setVersionrelease(esquema.getVersionrelease());
			dto.setMajorRelease(esquema.getMajorRelease());
			dto.setMinorRelease(esquema.getMinorRelease());
			
		}
		if (!Checks.esNulo(esquema.getDescripcion())){
			dto.setDescripcion(esquema.getDescripcion());
		}
		if (!Checks.esNulo(esquema.getModeloTransicion())){
			dto.setModeloTransicion(esquema.getModeloTransicion().getId().toString());
		}
		if (!Checks.esNulo(esquema.getPlazo())){
			dto.setPlazoActivacion(esquema.getPlazo().toString());
		}
		return dto;
	}
	
	/**
	 * Comprueba los modelos que se han modificado y les cambia el estado a bloqueado o disponible según si han salido de una subcartera
	 * o se han asociado a una subcartera
	 * @param dto
	 * @param dtoDatosModificados
	 */
	private void cambiaEstadoModelos(RecobroSubcarteraDto dto,
			RecobroSubcarteraDto dtoDatosModificados) {
		if (dto.getItinerarioMetasVolantes() != dtoDatosModificados.getItinerarioMetasVolantes()){
			if (!Checks.esNulo(dto.getItinerarioMetasVolantes())){
				proxyFactory.proxy(RecobroItinerarioApi.class).cambiaEstadoItinerario(dto.getItinerarioMetasVolantes(), RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
			}
			modificaEstadoItinerario(dtoDatosModificados.getItinerarioMetasVolantes());
		}
		if (dto.getModeloDeRanking() != dtoDatosModificados.getModeloDeRanking()){
			if (!Checks.esNulo(dto.getModeloDeRanking())){
				proxyFactory.proxy(RecobroModeloDeRankingApi.class).cambiaEstadoModelo(dto.getModeloDeRanking(), RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
			}
			modificaEstadoModeloRanking(dtoDatosModificados.getModeloDeRanking());
		}
		if (dto.getModeloFacturacion() != dtoDatosModificados.getModeloFacturacion()){
			if (!Checks.esNulo(dto.getModeloFacturacion())){
				proxyFactory.proxy(RecobroModeloFacturacionApi.class).cambiaEstadoModeloFacturacion(dto.getModeloFacturacion(), RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
			}
			modificaEstadoModeloFacturacion(dtoDatosModificados.getModeloFacturacion());
		}
		if (dto.getPoliticaDeAcuerdo() != dtoDatosModificados.getPoliticaDeAcuerdo()){
			if (!Checks.esNulo(dto.getPoliticaDeAcuerdo())){
				proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).cambiarEstadoPoliticaAcuerdos(dto.getPoliticaDeAcuerdo(), RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
			}
			modificaEstadoPoliticaAcuerdos(dtoDatosModificados.getPoliticaDeAcuerdo());
		}
		
	}

	private void modificaEstadoPoliticaAcuerdos(Long idPoliticaDeAcuerdo) {
		if (!Checks.esNulo(idPoliticaDeAcuerdo)){
			List<RecobroSubCartera> subcarteras = dameSubcarterasPolitica(idPoliticaDeAcuerdo);
			if (Checks.esNulo(subcarteras) || Checks.estaVacio(subcarteras)){
					proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).cambiarEstadoPoliticaAcuerdos(idPoliticaDeAcuerdo, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
			} 
		}
		
	}

	private List<RecobroSubCartera> dameSubcarterasPolitica(
			Long idPoliticaDeAcuerdo) {
		 Filter filtro = genericDao.createFilter(FilterType.EQUALS, "politicaAcuerdos.id", idPoliticaDeAcuerdo);
		 Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		 Order order = new Order(OrderType.ASC,"id");
		 return genericDao.getListOrdered(RecobroSubCartera.class,order, filtroBorrado, filtro );
		
	}

	private void modificaEstadoModeloFacturacion(Long idModeloFacturacion) {
		if (!Checks.esNulo(idModeloFacturacion)){
			List<RecobroSubCartera> subcarteras = dameSubcarterasModeloFacturacion(idModeloFacturacion);
			if (Checks.esNulo(subcarteras) || Checks.estaVacio(subcarteras)){
				proxyFactory.proxy(RecobroModeloFacturacionApi.class).cambiaEstadoModeloFacturacion(idModeloFacturacion, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);		
			} 
		}
		
	}

	private List<RecobroSubCartera> dameSubcarterasModeloFacturacion(
			Long idModeloFacturacion) {
		 Filter filtro = genericDao.createFilter(FilterType.EQUALS, "modeloFacturacion.id", idModeloFacturacion);
		 Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		 Order order = new Order(OrderType.ASC,"id");
		 return genericDao.getListOrdered(RecobroSubCartera.class,order, filtroBorrado, filtro);
	}

	private void modificaEstadoModeloRanking(Long idModeloDeRanking) {
		if (!Checks.esNulo(idModeloDeRanking)){
			List<RecobroSubCartera> subcarteras= dameSubcarterasModeloRanking(idModeloDeRanking);
			if (Checks.esNulo(subcarteras) || Checks.estaVacio(subcarteras)){
				proxyFactory.proxy(RecobroModeloDeRankingApi.class).cambiaEstadoModelo(idModeloDeRanking, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
			} 
		}
		
	}

	private List<RecobroSubCartera> dameSubcarterasModeloRanking(
			Long idModeloDeRanking) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "modeloDeRanking.id", idModeloDeRanking);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(RecobroSubCartera.class, filtro, filtroBorrado);
	}

	private void modificaEstadoItinerario(Long idItinerarioMetasVolantes) {
		if (!Checks.esNulo(idItinerarioMetasVolantes)){
			List<RecobroSubCartera> subcarteras= dameSubcarterasItinerario(idItinerarioMetasVolantes);
			if (Checks.esNulo(subcarteras) || Checks.estaVacio(subcarteras)){
				proxyFactory.proxy(RecobroItinerarioApi.class).cambiaEstadoItinerario(idItinerarioMetasVolantes, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
			}	
		}
		
	}

	private List<RecobroSubCartera> dameSubcarterasItinerario(
			Long idItinerarioMetasVolantes) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "itinerarioMetasVolantes.id", idItinerarioMetasVolantes);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"id");
		List<RecobroSubCartera> subcarteras= genericDao.getListOrdered(RecobroSubCartera.class, order,filtroBorrado, filtro);
		return subcarteras;
	}

	

	

	
}
