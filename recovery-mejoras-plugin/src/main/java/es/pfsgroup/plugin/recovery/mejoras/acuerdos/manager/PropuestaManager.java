package es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

@Service
public class PropuestaManager implements PropuestaApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ExpedienteDao expedienteDao;

	@Autowired
	private AcuerdoDao acuerdoDao;

	@BusinessOperation(BO_PROPUESTA_GET_LISTADO_PROPUESTAS)
	public List<EXTAcuerdo> listadoPropuestasByExpedienteId(Long idExpediente) {

        Order order = new Order(OrderType.ASC, "id");
        return  genericDao.getListOrdered(EXTAcuerdo.class,order, genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));
	}

	@BusinessOperation(BO_PROPUESTA_ES_GESTOR_SUPERVISOR_ACTUAL)
	public Boolean usuarioLogadoEsGestorSupervisorActual(Long idExpediente) {
		Expediente expediente = expedienteDao.get(idExpediente);

		Long idPerfilGestorActual = expediente.getIdGestorActual();
		Long idPerfilSupervisorActual = expediente.getIdSupervisorActual();

		return usuarioLogadoTienePerfil(idPerfilGestorActual) || usuarioLogadoTienePerfil(idPerfilSupervisorActual);
	}

	@Transactional(readOnly = false)
	public void proponer(Long idPropuesta) {
		Acuerdo propuesta = acuerdoDao.get(idPropuesta);
		Expediente expediente = propuesta.getExpediente();

		if (expediente != null && expediente.getEstadoItinerario() != null) {

			Boolean esEstadoCompletarExp = DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(expediente.getEstadoItinerario().getCodigo());
			Boolean esEstadoRevisarExp = DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(expediente.getEstadoItinerario().getCodigo());
			Boolean esEstadoDecisionComite = DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(expediente.getEstadoItinerario().getCodigo());

			if (esEstadoCompletarExp || esEstadoRevisarExp) {
				cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_PROPUESTO);
			} else if (esEstadoDecisionComite) {
				cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_ACEPTADO);
			}
		} else {
			throw new BusinessOperationException("PropuestaManager.proponer: No se ha encontrado expedientes asociados a esa propuesta/acuerdo");
		}
	}

	/**
	 * Cambia el estado de la prupuesta pasada por parametro
	 * @param propuesta
	 * @param nuevoCodigoEstado
	 */
	private void cambiarEstadoPropuesta(Acuerdo propuesta, String nuevoCodigoEstado) {
		DDEstadoAcuerdo nuevoEstado = (DDEstadoAcuerdo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAcuerdo.class, nuevoCodigoEstado);
		if (nuevoEstado != null) {
			propuesta.setEstadoAcuerdo(nuevoEstado);
			acuerdoDao.saveOrUpdate(propuesta);
		} else {
			throw new BusinessOperationException("PropuestaManager.cambiarEstadoPropuesta: No se encuentra el codigo del estado (DDEstadoAcuerdo)");
		}
	}

	/**
	 * comprueba si el usuario Logado dispone el perfil que se pase por parametro
	 * @param idPerfil
	 * @return
	 */
	private Boolean usuarioLogadoTienePerfil(Long idPerfil) {
		Usuario userlogged = usuarioManager.getUsuarioLogado();
		List<Perfil> perfiles = userlogged.getPerfiles();

		if (idPerfil == null) {
			return false;
		}

		for (Perfil perfil : perfiles) {
			if (idPerfil.equals(perfil.getId())) {
				return true;
			}
		}
		return false;
	}

	@BusinessOperation(BO_PROPUESTA_GET_LISTADO_CONTRATOS_DEL_EXPEDIENTE)
	public List<Contrato> listadoContratosByExpedienteId(Long idExpediente) {
		
		List<ExpedienteContrato> listaContratosExpediente = genericDao.getList(ExpedienteContrato.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));
		List<Contrato> contratos = new ArrayList<Contrato>();
		
		if (!Checks.esNulo(listaContratosExpediente) && listaContratosExpediente.size()>0) {
			for(ExpedienteContrato expCon : listaContratosExpediente){
				contratos.add(expCon.getContrato());	
			}
			
		}
		return contratos;
	}
}
