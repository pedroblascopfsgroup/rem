package es.pfsgroup.recovery.recobroCommon.expediente.manager.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.exceptuar.api.ExceptuacionApi;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.contrato.manager.CicloRecobroContratoApi;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.expediente.dao.CicloRecobroExpedienteDao;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroContratoExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroPersonaExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.CicloRecobroExpedienteApi;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.ExpedienteRecobroApi;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.persona.dao.api.CicloRecobroPersonaDao;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.CicloRecobroExpedienteConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.FuncionesConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonCicloRecobroExpedienteConstants;

@Component
public class CicloRecobroExpedienteManager implements CicloRecobroExpedienteApi {

	@Autowired
	private CicloRecobroExpedienteDao cicloRecobroExpedienteDao;
	
	@Autowired
	private ExceptuacionApi exceptuacionApi;

	@Autowired
	private CicloRecobroPersonaDao cicloRecobroPersonaDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private FuncionManager funcionManager;
	
	public static final String TIPO_PERSONA = "1";
	public static final String TIPO_CONTRATO = "2";

	@Override
	@BusinessOperation(RecobroCommonCicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXP_GETPAGE_BO)
	public Page getPageCicloRecobroExpediente(CicloRecobroExpedienteDto dto) {
		return cicloRecobroExpedienteDao.getPage(dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonCicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXP_BY_USU_GETPAGE_BO)
	public Page getPageCicloRecobroExpedienteTipoUsuario(CicloRecobroExpedienteDto dto) {
		if (!usuarioTieneVisibilidadCompleta()) {
			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			List<RecobroAgencia> agencias = this.buscaAgenciasUsuarioLogado(usuarioLogado.getId());
			if (!Checks.esNulo(agencias) && !Checks.estaVacio(agencias)) {
				List<Long> listaAgencias = new ArrayList<Long>();
				for (RecobroAgencia agencia : agencias) {
					listaAgencias.add(agencia.getId());
				}
				dto.setListaAgencias(listaAgencias);
			} else {
				return null;
			}
		}
		return cicloRecobroExpedienteDao.getPage(dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(CicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSPERSONAEXP_BO)
	public List<CicloRecobroPersona> getListCiclosRecobroPersonaExpediente(Long idExpediente, Long idPersona) {

		List<CicloRecobroPersona> cliclosRecobro = cicloRecobroPersonaDao.getCiclosRecobroPersonaExpediente(idExpediente, idPersona);

		return cliclosRecobro;
	}

	@Override
	@BusinessOperation(CicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSPERSONAEXPDTO_BO)
	public List<CicloRecobroPersonaExpedienteDto> dameListaMapeadaCiclosRecobroPersonaExpediente(Long idExpediente) {
		List<CicloRecobroPersonaExpedienteDto> ciclosRecobroCliente = new ArrayList<CicloRecobroPersonaExpedienteDto>();
		
		ExpedienteRecobro exp = proxyFactory.proxy(ExpedienteRecobroApi.class).getExpedienteRecobro(idExpediente);
		if (!Checks.esNulo(exp)) {
			for (ExpedientePersona ep : exp.getPersonas()) {
				CicloRecobroPersonaExpedienteDto dto = new CicloRecobroPersonaExpedienteDto();
				List<CicloRecobroPersona> ciclosPersona = new ArrayList<CicloRecobroPersona>();
				List<CicloRecobroPersona> recobros = new ArrayList<CicloRecobroPersona>();
				if (usuarioTieneVisibilidadCompleta()) {
					recobros = cicloRecobroPersonaDao.getCiclosRecobroPersonaExpediente(idExpediente, ep.getPersona().getId());
					dto.setCiclosRecobro(recobros);
					dto.setExpedientePersona(ep);
					ciclosRecobroCliente.add(dto);
				} else {
					Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
					if (proxyFactory.proxy(ExpedienteRecobroApi.class).esGestorRecobroExpediente(idExpediente, usuarioLogado.getId())) {
						// se muestran todos los ciclos de recobro de este
						// expediente de las agencias a las que pertenezca el
						// usuario logado
						
						List<RecobroAgencia> agenciasGestoras = buscaAgenciasUsuarioLogado(usuarioLogado.getId());
						if (!Checks.esNulo(agenciasGestoras) && !Checks.estaVacio(agenciasGestoras)) {
							for (RecobroAgencia age : agenciasGestoras) {
								ciclosPersona = cicloRecobroPersonaDao.getCiclosRecobroPersonaExpAgenciaActual(idExpediente, ep.getPersona().getId(), age.getId());
								recobros.addAll(ciclosPersona);
							}
						}
						// solo se muestra la persona que haya tenido algún
						// ciclo de recobro con la agencia del usuario logado
						if (!Checks.estaVacio(recobros)) {
							dto.setCiclosRecobro(recobros);
							ciclosRecobroCliente.add(dto);
						}
						
						boolean activo = false;
						if (!Checks.estaVacio(ciclosPersona)) {
							for (CicloRecobroPersona ciclo : ciclosPersona) {
								if (ciclo.getFechaBaja() == null) {
									activo = true;
								}
							}
						}
						
						if (!exceptuacionApi.existeExceptuacion(ep.getPersona().getId(), TIPO_PERSONA) && activo){
							dto.setExpedientePersona(ep);
						}
						
					}
				}
			}

		}
		return ciclosRecobroCliente;

	}

	@Override
	@BusinessOperation(CicloRecobroExpedienteConstants.PLUGIN_RECOBRO_CICLORECOBROEXPAPI_BUSCARCICLOSCNTEXPDTO_BO)
	public List<CicloRecobroContratoExpedienteDto> dameListaMapeadaCiclosRecobroContratoExpediente(Long idExpediente) {
		List<CicloRecobroContratoExpedienteDto> ciclosRecobroContratoExpedienteDtos = new ArrayList<CicloRecobroContratoExpedienteDto>();
		ExpedienteRecobro exp = proxyFactory.proxy(ExpedienteRecobroApi.class).getExpedienteRecobro(idExpediente);
		if (!Checks.esNulo(exp)) {
			for (ExpedienteContrato cnt : exp.getContratos()) {
				CicloRecobroContratoExpedienteDto dto = new CicloRecobroContratoExpedienteDto();
				List<CicloRecobroContrato> ciclos = new ArrayList<CicloRecobroContrato>();
				
				if (usuarioTieneVisibilidadCompleta()) {
					ciclos = proxyFactory.proxy(CicloRecobroContratoApi.class).getCiclosRecobroPersonaExpediente(idExpediente, cnt.getContrato().getId());
					dto.setCiclosRecobroContrato(ciclos);
					dto.setExpedienteContrato(cnt);
					ciclosRecobroContratoExpedienteDtos.add(dto);
				} else {
					Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
					if (proxyFactory.proxy(ExpedienteRecobroApi.class).esGestorRecobroExpediente(idExpediente, usuarioLogado.getId())) {
						// se muestran todos los ciclos de recobro de este
						// expediente de las agencias a las que pertenezca el
						// usuario logado
						
						List<RecobroAgencia> agenciasGestoras = buscaAgenciasUsuarioLogado(usuarioLogado.getId());
						if (!Checks.esNulo(agenciasGestoras) && !Checks.estaVacio(agenciasGestoras)) {
							for (RecobroAgencia age : agenciasGestoras) {
								List<CicloRecobroContrato> ciclosContrato = proxyFactory.proxy(CicloRecobroContratoApi.class).getCiclosRecobroContratoExpedienteAgencia(idExpediente, cnt.getContrato().getId(), age.getId());
								ciclos.addAll(ciclosContrato);
							}
						}
						// solo se muestra la persona que haya tenido algún
						// ciclo de recobro con la agencia del usuario logado
						if (!Checks.estaVacio(ciclos)) {
							dto.setCiclosRecobroContrato(ciclos);
							ciclosRecobroContratoExpedienteDtos.add(dto);
						}
						
						boolean activo = false;
						if (!Checks.estaVacio(ciclos)) {
							for (CicloRecobroContrato ciclo : ciclos) {
								if (ciclo.getFechaBaja() == null) {
									activo = true;
								}
							}
						}
						
						if (!exceptuacionApi.existeExceptuacion(cnt.getContrato().getId(), TIPO_CONTRATO) && activo ){
							dto.setExpedienteContrato(cnt);
						}
					}
				}
			}
		}
		return ciclosRecobroContratoExpedienteDtos;
	}

	private Boolean usuarioTieneVisibilidadCompleta() {
		Boolean tieneVisibilidadCompleta = false;
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (!usuarioLogado.getUsuarioExterno()) {
			tieneVisibilidadCompleta = true;
		} else {
			if (funcionManager.tieneFuncion(usuarioLogado, FuncionesConstants.ROLE_VISIB_COMPLETA_RECOBRO_EXT)) {
				tieneVisibilidadCompleta = true;
			}
		}

		return tieneVisibilidadCompleta;
	}

	private List<RecobroAgencia> buscaAgenciasUsuarioLogado(Long id) {
		return proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgenciasDeUsuario(id);
	}

}
