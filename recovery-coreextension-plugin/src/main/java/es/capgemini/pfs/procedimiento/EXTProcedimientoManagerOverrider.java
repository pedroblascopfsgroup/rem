package es.capgemini.pfs.procedimiento;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.registro.ModificarProcedimientoListener;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Component
public class EXTProcedimientoManagerOverrider extends
		BusinessOperationOverrider<ProcedimientoApi> implements
		ProcedimientoApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired(required = false)
	private List<ModificarProcedimientoListener> listeners;
	
	@Autowired
	private AdjuntoApi adjuntosApi;

	/**
	 * Devuelve un procedimiento a partir de su id.
	 * 
	 * @param idProcedimiento
	 *            el id del proceimiento
	 * @return el procedimiento
	 */
	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO)
	public Procedimiento getProcedimiento(Long idProcedimiento) {
		EventFactory.onMethodStart(this.getClass());
		Procedimiento p = parent().getProcedimiento(idProcedimiento);
		Hibernate.initialize(p);
		return p;
	}

	@Override
	public String managerName() {
		return "procedimientoManager";
	}

	/**
	 * Devuelve los tipos de reclamaci�n.
	 * 
	 * @return la lista de Tipos de reclamaci�n
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_PRC_MGR_GET_TIPOS_RECLAMACION)
	public List<DDTipoReclamacion> getTiposReclamacion() {
		return parent().getTiposReclamacion();
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_CORE_PROCEDIMIENTO_PRC_SAVE)
	public Procedimiento actualizaProcedimiento(
			ActualizarProcedimientoDtoInfo dto) {
		Procedimiento p = null;
		if (!Checks.esNulo(dto.getId())) {
			p = genericDao.get(Procedimiento.class, genericDao.createFilter(
					FilterType.EQUALS, "id", dto.getId()));
		} else {
			throw new BusinessOperationException(
					"plugin.santander.actualizaProcedimiento.idNulo");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(ModificarProcedimientoListener.ID_PROCEDIMIENTO, dto.getId());
		if (!Checks.esNulo(dto.getEstimacion()) && !dto.getEstimacion().equals(p.getPorcentajeRecuperacion())) {
			map.put(ModificarProcedimientoListener.CLAVE_ESTIMACION_ANTERIOR, p
					.getPorcentajeRecuperacion());
			map.put(ModificarProcedimientoListener.CLAVE_ESTIMACION_POSTERIOR,
					dto.getEstimacion());
		}
		if (!Checks.esNulo(dto.getPlazoRecuperacion()) && !dto.getPlazoRecuperacion().equals(p.getPlazoRecuperacion())) {
			map.put(ModificarProcedimientoListener.CLAVE_PLAZO_ANTERIOR, p
					.getPlazoRecuperacion());
			map.put(ModificarProcedimientoListener.CLAVE_PLAZO_POSTERIOR, dto
					.getPlazoRecuperacion());
		}
		if (!Checks.esNulo(dto.getPrincipal()) && !dto.getPrincipal().equals(p.getSaldoRecuperacion())) {
			map.put(ModificarProcedimientoListener.CLAVE_PRINCIPAL_ANTERIOR, p
					.getSaldoRecuperacion());
			map.put(ModificarProcedimientoListener.CLAVE_PRINCIPAL_POSTERIOR,
					dto.getPrincipal());
		}
		if (!Checks.esNulo(p.getJuzgado())) {
			if (!p.getJuzgado().getId().equals(dto.getTipoJuzgado())) {
				map.put(ModificarProcedimientoListener.CLAVE_JUZGADO_ANTERIOR,
						p.getJuzgado().getId());
				if (!Checks.esNulo(dto.getTipoJuzgado())) {
					map.put(ModificarProcedimientoListener.CLAVE_JUZGADO_POSTERIOR,
							dto.getTipoJuzgado());
				}
			}
		} else {
			if (!Checks.esNulo(dto.getTipoJuzgado())) {
				map.put(ModificarProcedimientoListener.CLAVE_JUZGADO_POSTERIOR,
						dto.getTipoJuzgado());
			}
		}
		
		if (!Checks.esNulo(dto.getNumeroAutos()) && !dto.getNumeroAutos().equals(p.getCodigoProcedimientoEnJuzgado())) {
			map.put(ModificarProcedimientoListener.CLAVE_NUMERO_AUTOS_ANTERIOR, p
					.getCodigoProcedimientoEnJuzgado());
			map.put(ModificarProcedimientoListener.CLAVE_NUMERO_AUTOS_POSTERIOR,
					dto.getNumeroAutos());
		}

		if (!Checks.esNulo(dto.getTipoReclamacion()) && !dto.getTipoReclamacion().equals(p.getTipoReclamacion().getId())) {
			map
					.put(
							ModificarProcedimientoListener.CLAVE_TIPO_RECLAMACION_ANTERIOR,
							p.getTipoReclamacion().getId());
			map
					.put(
							ModificarProcedimientoListener.CLAVE_TIPO_RECLAMACION_POSTERIOR,
							dto.getTipoReclamacion());
		}

		if (!Checks.esNulo(dto.getTipoReclamacion())) {
			Filter filtroTipoReclamacion = genericDao.createFilter(
					FilterType.EQUALS, "id", dto.getTipoReclamacion());
			DDTipoReclamacion reclamacion = genericDao.get(
					DDTipoReclamacion.class, filtroTipoReclamacion);
			p.setTipoReclamacion(reclamacion);
		}
		if (!Checks.esNulo(dto.getTipoJuzgado())) {
			Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS,
					"id", dto.getTipoJuzgado());
			TipoJuzgado juzgado = genericDao.get(TipoJuzgado.class,
					filtroJuzgado);
			p.setJuzgado(juzgado);
		}
		if (!Checks.esNulo(dto.getPrincipal())) {
			p.setSaldoRecuperacion(dto.getPrincipal());
		}
		if (!Checks.esNulo(dto.getEstimacion())) {
			p.setPorcentajeRecuperacion(dto.getEstimacion());
		}
		if (!Checks.esNulo(dto.getPlazoRecuperacion())) {
			p.setPlazoRecuperacion(dto.getPlazoRecuperacion());
		}
		if (!Checks.esNulo(dto.getNumeroAutos())){
			p.setCodigoProcedimientoEnJuzgado(dto.getNumeroAutos());
		}

		genericDao.update(Procedimiento.class, p);
		if (listeners != null) {
			for (ModificarProcedimientoListener l : listeners) {
				l.fireEvent(map);
			}
		}

		// GuardarTrazaDto traza = creaTrazaProcedimiento(infotraza, p);
		// proxyFactory.proxy(SANRegistroApi.class).guardatTrazaEvento(traza);

		return p;
	}

	@Override
	@BusinessOperation(BO_CORE_PROCEDIMIENTO_GET_CONTRATO_PRINCIPAL)
	public Contrato buscaContratoPrincipalProcedimiento(Long idProcedimiento) {
		EventFactory.onMethodStart(this.getClass());
		Procedimiento proc = proxyFactory.proxy(ProcedimientoApi.class)
				.getProcedimiento(idProcedimiento);
		List<ExpedienteContrato> listaPce = proc.getExpedienteContratos();
		
		Contrato cnt = null;
		for (ExpedienteContrato ec : listaPce) {
			if (ec.getContrato().equals(
					proc.getAsunto().getExpediente().getContratoPase())) {
				cnt = ec.getContrato();
			}
		}
		if (Checks.esNulo(cnt) && (!Checks.estaVacio(listaPce))) {
			cnt = listaPce.get(0).getContrato();
		}
		EventFactory.onMethodStop(this.getClass());
		return cnt;

	}
	

	/**
	 * Indica si el Usuario Logado es el gestor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el gestor.
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_PRC_MGR_ES_GESTOR)
	public Boolean esGestor(Long idProcedimiento) {
		Asunto asunto = getProcedimiento(idProcedimiento).getAsunto();
		return proxyFactory.proxy(AsuntoApi.class).esGestor(asunto.getId());
	}

	/**
	 * Indica si el Usuario Logado es el supervisor del asunto.
	 * 
	 * @param idProcedimiento
	 *            el id del asunto
	 * @return true si es el Supervisor.
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_PRC_MGR_ES_SUPERVISOR)
	public Boolean esSupervisor(Long idProcedimiento) {
		Asunto asunto = getProcedimiento(idProcedimiento).getAsunto();
		return proxyFactory.proxy(AsuntoApi.class).esSupervisor(asunto.getId());
	}

	/**
	 * Método que va a ser implementado en AsuntoAPi, ya que se van a reutilizar
	 * métodos privados de ordenación y permisos
	 */
	@Override
	@BusinessOperation(BO_CORE_PROCEDIMIENTO_ADJUNTOSMAPEADOS)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		return adjuntosApi.getAdjuntosConBorradoByPrcId(prcId);
	}	
	
}
