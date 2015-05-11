package es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dao.api.RecobroAgenciaDao;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonAgenciasConstants;

/**
 * Clase donde está toda la lógica de negocio para la configuración de Agencias de Recobro
 * @author diana
 *
 */
@Component
public class RecobroAgenciaManager implements RecobroAgenciaApi{
	
	@Autowired
	private RecobroAgenciaDao recobroAgenciaDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_BUSCARAGENCIAS_BO )
	public Page buscaAgencias(RecobroAgenciaDto dto) {
		if (Integer.valueOf(dto.getLimit()) == -1) {
			dto.setLimit(1000);
		}
		if (Integer.valueOf(dto.getStart()) == -1) {
			dto.setStart(0);
		}
		Page agenciasPaginado = recobroAgenciaDao.buscaAgencias(dto);
		return agenciasPaginado;
	}
	
	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_BUSCARAGENCIAS_TODAS_BO )
	public List<RecobroAgencia> buscaAgencias() {
		return recobroAgenciaDao.getList();
	}
	

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_SAVEAGENCIA_BO )
	@Transactional(readOnly=false)
	public void saveAgencia(RecobroAgenciaDto dto) {
		if (!Checks.esNulo(dto)){
			RecobroAgencia agencia= null;
			if (!Checks.esNulo(dto.getId())){
				agencia = this.getAgencia(dto.getId());
			} else {
				agencia = new RecobroAgencia();
			}
			agencia.setNombre(dto.getNombre());
			agencia.setCodigo(dto.getCodigo());
			agencia.setContactoNombre(dto.getContactoNombre());
			agencia.setContactoApe1(dto.getContactoApe1());
			agencia.setContactoApe2(dto.getContactoApe2());
			agencia.setNif(dto.getNif());
			agencia.setNombreVia(dto.getNombreVia());
			agencia.setNumero(dto.getNumero());
			agencia.setContactoTelf(dto.getContactoTelf());
			agencia.setContactoMail(dto.getContactoMail());
			agencia.setDenominacionFiscal(dto.getDenominacionFiscal());
			if (!Checks.esNulo(dto.getCodigoMunicipio())){
				agencia.setMunicipio(proxyFactory.proxy(DiccionarioApi.class).getLocalidadByCodigo(dto.getCodigoMunicipio()));
			} else {
				agencia.setMunicipio(null);
			}
			if (!Checks.esNulo(dto.getCodigoPoblacion())){
				agencia.setPoblacion(proxyFactory.proxy(DiccionarioApi.class).getLocalidadByCodigo(dto.getCodigoPoblacion()));
			} else {
				agencia.setPoblacion(null);
			}
			if (!Checks.esNulo(dto.getCodigoProvincia())){
				agencia.setProvincia(proxyFactory.proxy(DiccionarioApi.class).getProvinciaByCodigo(dto.getCodigoProvincia()));
			} else {
				agencia.setProvincia(null);
			}
			if (!Checks.esNulo(dto.getCodigoPais())){
				agencia.setPais(proxyFactory.proxy(DiccionarioApi.class).getPaisByCodigo(dto.getCodigoPais()));
			} else {
				agencia.setPais(null);
			}
			if (!Checks.esNulo(dto.getCodigoTipoVia())){
				agencia.setTipoVia(proxyFactory.proxy(DiccionarioApi.class).getTipoViaByCodigo(dto.getCodigoTipoVia()));
			} else {
				agencia.setTipoVia(null);
			}
			if (!Checks.esNulo(dto.getUsuario())){
				agencia.setGestor(proxyFactory.proxy(UsuarioApi.class).get(dto.getUsuario()));
			} else {
				agencia.setGestor(null);
			}
			if (!Checks.esNulo(dto.getDespacho())){
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getDespacho());
				DespachoExterno despacho = genericDao.get(DespachoExterno.class, filtro);
				agencia.setDespacho(despacho);
			} else {
				agencia.setDespacho(null);
			}
			recobroAgenciaDao.saveOrUpdate(agencia);
			
		} else {
			throw new BusinessOperationException("No se ha pasado el dto de alta de agencia");
		}
		
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_DELETEAGENCIA_BO)
	@Transactional(readOnly=false)
	public void deleteAgencia(Long idAgencia) {
		if (!Checks.esNulo(idAgencia)){
			RecobroAgencia agencia = this.getAgencia(idAgencia);
			if (Checks.estaVacio(agencia.getSubcarterasAgencia())){
				recobroAgenciaDao.deleteById(idAgencia);
			} else {
				throw new BusinessOperationException("No se puede borrar una agencia asociada a un esquema");
			}
		} else {
			throw new BusinessOperationException("El id de la agencia no puede ser null");
		}
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_GET_BO )
	public RecobroAgencia getAgencia(Long idAgencia) {
		if (!Checks.esNulo(idAgencia)){
			RecobroAgencia agencia = recobroAgenciaDao.get(idAgencia);
			return agencia;
		} else {
			throw new BusinessOperationException("El id de la agencia no puede ser null");
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAgenciasConstants.PLUGIN_RECOBOR_AGENCIAAPI_BUSCABYUSUARIO)
	public List<RecobroAgencia> buscaAgenciasDeUsuario(Long idUsuario) {
		List<RecobroAgencia> agenciasUsuario = new ArrayList<RecobroAgencia>();
		List<GestorDespacho> despachos = buscaDespachosRecobroUsuario(idUsuario);
		for (GestorDespacho d : despachos){
			List<RecobroAgencia> agenciasDespacho = recobroAgenciaDao.listaAgenciasByDespacho(d.getDespachoExterno().getId());
			agenciasUsuario.addAll(agenciasDespacho);
		}
		return agenciasUsuario;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonAgenciasConstants.PLUGIN_RECOBOR_AGENCIAAPI_BUSCABYDESPACHO)
	public List<RecobroAgencia> buscaAgenciasDespacho(Long id) {
		RecobroAgenciaDto dto = new RecobroAgenciaDto();
		dto.setDespacho(id);
		return (List<RecobroAgencia>) recobroAgenciaDao.buscaAgencias(dto).getResults();
	}


	private List<GestorDespacho> buscaDespachosRecobroUsuario(Long idUsuario) {
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", idUsuario);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.codigo", DDTipoDespachoExterno.CODIGO_AGENCIA_RECOBRO);
		List<GestorDespacho> despachos = genericDao.getList(GestorDespacho.class, filtroUsuario, filtroBorrado, filtroTipoDespacho); 
		return despachos;
	}

	
}
