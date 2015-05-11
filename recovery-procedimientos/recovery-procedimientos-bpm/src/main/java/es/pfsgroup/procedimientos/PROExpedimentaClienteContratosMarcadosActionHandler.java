package es.pfsgroup.procedimientos;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.Node;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.tareaNotificacion.dao.PlazoTareasDefaultDao;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ClienteApi;
import es.pfsgroup.recovery.api.JBPMProcessApi;
import es.pfsgroup.recovery.ext.impl.bpm.handler.utils.AmbitoContratosMarcadosHandler;
import es.pfsgroup.recovery.ext.impl.bpm.handler.utils.BPMParametros;

public class PROExpedimentaClienteContratosMarcadosActionHandler extends PROBaseActionHandler
		implements ClienteBPMConstants, ExpedienteBPMConstants {

	private static final long serialVersionUID = 5260805596046039095L;
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private PlazoTareasDefaultDao plazoTareaDefaultDao;


	@Autowired
	private Executor executor;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		if (logger.isDebugEnabled()) {
			logger.debug("ExpedimentaClienteActionHandler......");
		}
		try {
			parcheaBpm(executionContext);

			BPMParametros parametros = new BPMParametros(executionContext,
					proxyFactory);
			AmbitoContratosMarcadosHandler contratosMarcadosHandler = new AmbitoContratosMarcadosHandler(
					parametros, proxyFactory, executor);

			Cliente cli = parametros.getCliente();

			// Si el cliente no existe o se ha borrado se mata el BPM actual
			if (cli == null || cli.getAuditoria().isBorrado()) {
				finalizaBPMClienteBorrado(cli,executionContext);
			} else {
				Date fechaUmbral = cli.getPersona().getFechaUmbral();
				Float umbral = cli.getPersona().getImporteUmbral();
				Float importe = cli.getPersona().getRiesgoDirectoVencido();

				if (superadaFechaUmbral(fechaUmbral) || (umbral < importe)) {
					if (contratosMarcadosHandler
							.necestaGenerarVariosExpedientes()) {
						// Genera un expediente por marca
						for (Long idContrato : contratosMarcadosHandler
								.getContratosPase()) {
							parametros.put(CONTRATO_ID, idContrato);
							lanzaBPMExpediente(parametros);
						}
					} else {
						lanzaBPMExpediente(parametros);
					}
					finalizaBPMCliente(executionContext);

				} else {
					// Se tiene que quedar en GV
					toGestionVencidos(cli, executionContext);
				}

			}
		} catch (Exception e) {
			logger.error("SE HA PROUDUCIDO UN ERROR AL EXPEDIENTAR AL CLIENTE");
			throw new GenericRollbackException(
					"SE HA PROUDUCIDO UN ERROR AL EXPEDIENTAR AL CLIENTE", e);
		}

	}

	private void finalizaBPMCliente(ExecutionContext executionContext) {
		try {
			executionContext.getToken().signal("Fin");
		} catch (Exception e) {
			if (executionContext.getNode().getLeavingTransitions() != null
					&& executionContext.getNode()
							.getLeavingTransitions().size() == 1) {
				executionContext.getToken().signal();
			}
		}
	}

	private void lanzaBPMExpediente(BPMParametros parametros) {
		proxyFactory.proxy(JBPMProcessApi.class).crearNewProcess(
				EXPEDIENTE_PROCESO, parametros.getParamsMap());

	}

	private boolean superadaFechaUmbral(Date fechaUmbral) {
		return fechaUmbral != null
				&& (fechaUmbral.getTime() < System.currentTimeMillis());
	}

	private void toGestionVencidos(Cliente cli, ExecutionContext executionContext) {
		cli.setFechaGestionVencidos(new Date());
		proxyFactory.proxy(ClienteApi.class).saveOrUpdate(cli);
		// clienteMgr.saveOrUpdate(cli);
		PlazoTareasDefault ptd = plazoTareaDefaultDao
				.buscarPorCodigo(PlazoTareasDefault.CODIGO_VERIFICACION_UMBRAL);
		Date dueDate = new Date(System.currentTimeMillis() + ptd.getPlazo());

		// Compruebo si la transición existe y si no existe la
		// creo para el contexto nuevo

		nuevaTransicion(executionContext, TRANSITION_GESTION_VENCIDOS,
				"GestionVencidos");

		BPMUtils.createTimer(executionContext, TIMER_GESTION_VENCIDO_CLIETE,
				dueDate, TRANSITION_GESTION_VENCIDOS);
		logger.warn("\n\n\nMando de nuevo por umbral al cliente " + cli.getId()
				+ "\n\n\n");
	}

	/**
	 * Finaliza el BPM por estar el cliente borrado
	 * 
	 * @param cli
	 */
	private void finalizaBPMClienteBorrado(Cliente cli, ExecutionContext executionContext) {
		logger
				.debug("Cliente "
						+ cli.getId()
						+ " ya fue borrado por otro proceso. Se controla la paralelización");
		executionContext.getToken().signal("Fin");
	}

	/**
	 * Aplica algunos parches al BPM para resolver algunos BUGS
	 */
	private void parcheaBpm(ExecutionContext executionContext) {
		// Parche que se ha tenido que hacer por no seguir el estandard de
		// llamar a todos las transiciones 'Fin'
		cambiarNombreTransicion(executionContext, "fin", "Fin");

		// Otro parche por si existen clientes viejos que no tienen
		// transición a fin
		nuevaTransicion(executionContext, "Fin", "Fin");
	}

	/**
	 * @param executionContext
	 *            ExecutionContext
	 * @param oldName
	 *            String
	 * @param newName
	 *            String
	 */
	protected void cambiarNombreTransicion(ExecutionContext executionContext,
			String oldName, String newName) {
		if (!existeTransicion(executionContext, oldName)) {
			return;
		}

		Node node = executionContext.getNode();
		Transition t = node.getLeavingTransition(oldName);
		t.setName(newName);
	}

	/**
	 * Comprueba si existe la transicion.
	 * 
	 * @param executionContext
	 *            ExecutionContext
	 * @param name
	 *            String
	 * @return boolean
	 */
	protected boolean existeTransicion(ExecutionContext executionContext,
			String name) {
		Node node = executionContext.getNode();
		return node.hasLeavingTransition(name);
	}

	/**
	 * Le añade una transición al nodo.
	 * 
	 * @param executionContext
	 *            ExecutionContext
	 * @param name
	 *            String
	 * @param nodo
	 *            String
	 */
	protected void nuevaTransicion(ExecutionContext executionContext,
			String name, String nodo) {
		if (existeTransicion(executionContext, name)) {
			return;
		}
		Node nodoOrigen = executionContext.getNode();
		Node nodoDestino = executionContext.getProcessDefinition()
				.getNode(nodo);

		if (nodoOrigen != null && nodoDestino != null) {

			Transition transition = new Transition();
			transition.setFrom(nodoOrigen);
			transition.setTo(nodoDestino);
			transition.setName(name);
			transition.setProcessDefinition(executionContext
					.getProcessDefinition());

			nodoOrigen.addLeavingTransition(transition);
		}
	}
}
