package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dao.api.RecobroAccionesExtrajudicialesDaoApi;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.api.RecobroAccionesExtrajudicialesManagerApi;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDResultadoGestionTelefonica;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDTipoGestion;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.FuncionesConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonAccionesExtrajudicialesConstants;

/**
 * Implementación del manager de las acciones extrajudiciales de recobro
 * 
 * @author Guillem
 * 
 */
@Service
public class RecobroAccionesExtrajudicialesManagerImpl implements RecobroAccionesExtrajudicialesManagerApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private RecobroAccionesExtrajudicialesDaoApi recobroAccionesExtrajudicialesDao;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private FuncionManager funcionManager;

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_BO)
	public List<RecobroAccionesExtrajudiciales> obtenerAccionesExtrajudicialesPorAgenciaResultadoFechaGestion(RecobroAgencia agencia, Date fechaGestion,
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica) {

		return recobroAccionesExtrajudicialesDao.getAccionesPorAgenciaResultadoFechaGestion(agencia, fechaGestion, resultadoGestionTelefonica);

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_OBTENER_ACCIONES_POR_AGENCIA_CONTRATO_RESULTADO_FECHA_BO)
	public List<RecobroAccionesExtrajudiciales> obtenerAccionesExtrajudicialesPorAgenciaContratoResultadoFechaGestion(RecobroAgencia agencia, Contrato contrato, Date fechaGestion,
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica) {

		return recobroAccionesExtrajudicialesDao.getAccionesPorAgenciaContratoResultadoFechaGestion(agencia, contrato, fechaGestion, resultadoGestionTelefonica);

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_CICLORECOBROCONTRATO_BO)
	public Page getPageAccionesCicloRecobroContrato(RecobroAccionesExtrajudicialesDto dto) {
		return recobroAccionesExtrajudicialesDao.getPageAccionesCicloRecobroContrato(dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_CICLORECOBROPERSONA_BO)
	public Page getPageAccionesCicloRecobroPersona(RecobroAccionesExtrajudicialesDto dto) {
		Page pagina = recobroAccionesExtrajudicialesDao.getPageAccionesCicloRecobroPersona(dto);

		return pagina;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.api
	 * .RecobroAccionesExtrajudicialesManagerApi
	 * #getPageAccionesRecobroExpediente
	 * (es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales
	 * .dto.RecobroAccionesExtrajudicialesExpedienteDto)
	 */
	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_EXPEDIENTE_BO)
	public Page getPageAccionesRecobroExpediente(RecobroAccionesExtrajudicialesExpedienteDto dto) {
		return recobroAccionesExtrajudicialesDao.getPageAccionesRecobroExpediente(dto);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.api
	 * .RecobroAccionesExtrajudicialesManagerApi#get(java.lang.Long)
	 */
	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_BO)
	public RecobroAccionesExtrajudiciales getAccionExtrajudicial(Long idAccionExtrajudicial) {
		return recobroAccionesExtrajudicialesDao.get(idAccionExtrajudicial);
	}

	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.BO_EXP_GET_LISTADO_TIPO_GESTION)
	public List<RecobroDDTipoGestion> getListadoTipoGestion() {
		return genericDao.getList(RecobroDDTipoGestion.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.BO_EXP_GET_LISTADO_TIPO_RESULTADO)
	public List<RecobroDDResultadoGestionTelefonica> getListadoTipoResultado() {
		return genericDao.getList(RecobroDDResultadoGestionTelefonica.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@BusinessOperation(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_GET_LISTADO_CICLO_RECOBRO_EXPEDIENTE)
	public List<CicloRecobroExpediente> getListadoCiclosRecobroExpediente(Long expId) {
		return genericDao.getList(CicloRecobroExpediente.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@BusinessOperation(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_GET_ACCION_EXTRAJUDICIAL_BY_ID)
	public RecobroAccionesExtrajudiciales getAccionExtrajudicialById(Long id) {
		return genericDao.get(RecobroAccionesExtrajudiciales.class, genericDao.createFilter(FilterType.EQUALS, "id", id), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	/**
	 * Método que devuelve si un usuario pertenece a un despacho de tipo agencia
	 * @param usuario
	 */
	@Override
	@BusinessOperation(RecobroAccionesExtrajudicialesManagerApi.BO_EXP_ES_AGENCIA)
	public Boolean esAgencia(Long usuId) {

		GestorDespacho usd = genericDao.get(GestorDespacho.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuId),
				genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.codigo","AGER"), //TODO poner constante
				genericDao.createFilter(FilterType.EQUALS, "despachoExterno.auditoria.borrado", false),
				genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.auditoria.borrado", false),
				genericDao.createFilter(FilterType.EQUALS, "usuario.auditoria.borrado", false));
		
		if(!Checks.esNulo(usd)){
			return true;
		}
		
		return false;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_GET_PAGE_ACCIONES_EXP_BYUSU_BO)
	public Page getPageAccionesRecobroExpedientePorTipoUsuario(
			RecobroAccionesExtrajudicialesExpedienteDto dto) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Boolean visibilidadCompleta = usuarioTieneVisibilidadCompleta();
		if (!visibilidadCompleta){
			List<RecobroAgencia> agencias =proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgenciasDeUsuario(usuarioLogado.getId()); 
			if (!Checks.esNulo(agencias) && !Checks.estaVacio(agencias)){
				List<Long> listaAgencias = new ArrayList<Long>();
				for (RecobroAgencia agencia : agencias){
					listaAgencias.add(agencia.getId());
				}
				dto.setListaAgencias(listaAgencias);
			} else{
				return null;
			}
		}
		Page acciones= recobroAccionesExtrajudicialesDao.getPageAccionesRecobroExpediente(dto);
		List<RecobroAccionAgenciaDto> accionesMapeadas = new ArrayList<RecobroAccionAgenciaDto>();
		for(Object acc : acciones.getResults()){
			if (acc.getClass().equals(RecobroAccionesExtrajudiciales.class)){
				RecobroAccionesExtrajudiciales accion = (RecobroAccionesExtrajudiciales)acc;
				RecobroAccionAgenciaDto accionMapeada = new RecobroAccionAgenciaDto();
				accionMapeada.setAccion(accion);
				List<RecobroAgencia> agenciasUsuario = proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgenciasDeUsuario(usuarioLogado.getId());
				String agencia = "---";
				if (!usuarioLogado.getUsuarioExterno()){
					agencia = accion.getAgencia().getNombre();
				} else {
					if (!Checks.esNulo(agenciasUsuario) && !Checks.estaVacio(agenciasUsuario)){
						if (agenciasUsuario.contains(accion.getAgencia())){
							agencia = accion.getAgencia().getNombre();
						}
					}
				}
				accionMapeada.setAgencia(agencia);
				accionesMapeadas.add(accionMapeada);
			}
		}
		Page accionesMapeadasPage = new PageSql();
		((PageSql) accionesMapeadasPage).setResults(accionesMapeadas);
		//((PageSql) accionesMapeadasPage).setTotalCount(accionesMapeadas.size());
		((PageSql) accionesMapeadasPage).setTotalCount(acciones.getTotalCount());
		
		return accionesMapeadasPage;
	}

	private Boolean usuarioTieneVisibilidadCompleta() {
		Boolean tieneVisibilidadCompleta=false;
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (!usuarioLogado.getUsuarioExterno()){
			tieneVisibilidadCompleta=true;
		} else {
			if (funcionManager.tieneFuncion(usuarioLogado, FuncionesConstants.TODAS_LAS_ACCIONES_SIN_AGENCIA)){
				tieneVisibilidadCompleta = true;
			}	
		}
		
		return tieneVisibilidadCompleta;
	}

}
