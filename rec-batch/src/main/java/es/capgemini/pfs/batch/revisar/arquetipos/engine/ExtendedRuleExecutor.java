package es.capgemini.pfs.batch.revisar.arquetipos.engine;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.revisar.arquetipos.ExtendedRuleExecutorConfig;
import es.capgemini.pfs.batch.revisar.arquetipos.database.ConnectionFacade;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotCommitOrCloseConnectionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotExecuteDDLException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotExecuteInsertException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotOpenConnectionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotParseRuleDefinitionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.ExtendedRuleExecutorException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.RuleDefinitionTypeNotSupportedException;
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleResult;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleManager;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * Extiende el motor de arquetipado para soportar dos algoritmos distintos.
 * 
 * <ul>
 * <li>Política UPDATE (algoritmo clásico original)</li>
 * <li>Política INSERT (nuevo algoritmo empleado por primera vez por el batch de
 * agencias de recobro
 * <li>
 * </ul>
 * 
 * @author bruno
 * 
 */
public class ExtendedRuleExecutor extends RuleExecutor {

	private final Log logger = LogFactory.getLog(getClass());

	/* Se debe inyectar explícitamente */
	private RuleExecutor engine;

	@Autowired
	private ConnectionFacade cnnFacade;

	@Autowired
	private SQLStatementBuilder builder;
	
	@Autowired
	private DDRuleManager rManager;

	@Override
	public List<RuleResult> execRules(final List<RuleEndState> endStates) {
		if (this.getConfig() instanceof ExtendedRuleExecutorConfig) {
			final ExtendedRuleExecutorConfig myLocalConfig = (ExtendedRuleExecutorConfig) this
					.getConfig();
			if ("UPDATE".equals(myLocalConfig.getPolicy())) {
				logger.debug("Elegimos la estrategia UPDATE para arquetipar");
				return delegate(endStates);
			} else if ("INSERT".equals(myLocalConfig.getPolicy())) {
				logger.debug("Elegimos la neva estrategia INSERT para arquetipar");
				return runInsertAlgorithm(endStates, new Date());
			} else {
				throw new IllegalArgumentException(
						"El valor de 'policy' para esta configuración no es válido. Se esperaba INSERT o UPDATE");
			}
		} else {
			return delegate(endStates);
		}
	}

	/**
	 * Ejecuta el nuevo algoritmo de arquetipación basado en la política INSERT
	 * 
	 * @param rules
	 * @param currentDate 
	 * @return
	 * @throws ExtendedRuleExecutorException
	 */
	public List<RuleResult> runInsertAlgorithm(final List<RuleEndState> rules, Date currentDate)
			throws ExtendedRuleExecutorException {
		logger.debug("Comprobando configuración");
		if ((getConfig() == null)
				|| !(getConfig() instanceof ExtendedRuleExecutorConfig)) {
			logger.debug(" - Configuración no disponible, se va a producir un error");
			throw new IllegalStateException(
					"Executor no configurado. Compruebe que sea del tipo "
							+ ExtendedRuleExecutorConfig.class.getName() + ".");
		}
		final ExtendedRuleExecutorConfig config = (ExtendedRuleExecutorConfig)getConfig();
		// Comprobamos primero que el tipo de definición sea XML
		if ("XML".equals(this.getConfig().getRuleDefinitionType())) {
			logger.debug(" - Arquetipos basados en XML");
			// Si la lista de reglas está vacía devolvemos una lista de
			// resultados
			// vacía y logueamos
			logger.debug("Comprobando si hay reglas que procesar.");
			if ((rules == null) || rules.isEmpty()) {
				logger.warn("No se han encontrado reglas que procesar");
				return new ArrayList<RuleResult>();
			}
			// Si no continuamos
			Connection cnn = null;
			try {
				logger.debug("Inicio del procesado de las relgas.");
				cnn = cnnFacade.openConnection();
				
				// Borramos la tabla temporal si existiera.
				try{
					logger.debug("Intentamos eliminar la tabla temporal.");
					cnnFacade.executeDDL(cnn, builder.buildDDL4DropTemp(config, currentDate), false);
					// Si existía avisamos
					logger.warn(builder.getTempTableName(config) + ": Se ha borrado la tabla existente de una ejecución anterior, probablemente inacabada.");
				}catch (CannotExecuteDDLException e){
					logger.debug("Tabla temporal no encontrada, esto es normal, continuamos. " + e.getMessage());
				}
				logger.debug("Creamos la tabla temporal");
				cnnFacade.executeDDL(cnn, builder.buildDDL4CreateTemp(config, currentDate), true);
				
				if (config.getRefreshViews() != null){
					logger.debug("Inicamos el refresco de vistas");
					for (String view : config.getRefreshViews()){
						cnnFacade.refreshView(view);
					}
				}
				logger.debug("Inicio del procesado de reglas. Total: " + ((rules != null) ? rules.size() : "0") + " reglas");
				logger.debug("El resultado del procesado se almacena en la tabla temporal: " + builder.getTempTableName(config));
				final List<RuleResult> results = procesaReglas(rules, cnn, currentDate);
				logger.debug("Fin del procesado de reglas");
				
				logger.debug("Moviendo resultado de la arquetipación a la tabla definiva");
				cnnFacade.executeInsert(cnn, builder.buildSQL4MoveData(config, currentDate), true);
				
				logger.debug("Borrando tabla temporal");
				cnnFacade.executeDDL(cnn, builder.buildDDL4DropTemp(config, currentDate), true);

				cnnFacade.commitAndClose(cnn);

				return results;
			} catch (CannotOpenConnectionException e) {
				logger.fatal("No se ha podido abrir la conexión con la BBDD.",
						e);
				throw new ExtendedRuleExecutorException(e);
			} catch (CannotExecuteInsertException e) {
				logger.fatal("No se ha podido ejecutar algún insert", e);
				throw new ExtendedRuleExecutorException(e);
			} catch (CannotCommitOrCloseConnectionException e) {
				logger.fatal("No se ha podido comitear o cerrar la conexión.",
						e);
				throw new ExtendedRuleExecutorException(e);
			} catch (CannotExecuteDDLException e) {
				logger.fatal("Ha habido un error en la ejecución de los DDL's.",
						e);
				throw new ExtendedRuleExecutorException(e);
			}finally{
				if(cnn != null){
					try {
						cnn.close();
					} catch (SQLException e) {
						logger.warn("No se ha podido cerrar la conexión: " + e.getMessage());
					}
				}
			}
		} else {
			// Si no es XML fallamos
			logger.debug(" - Arquetipos basados un lenguaje no soportado, se producirá un error.");
			throw new RuleDefinitionTypeNotSupportedException(getConfig());
		}

	}

	/**
	 * Recorre la lista de reglas, parsea la definición de la misma y ejecuta el
	 * insert contra la BBDD.
	 * 
	 * @param rules
	 *            List de reglas
	 * @param cnn
	 *            Conexión a la BBDD
	 * @param currentDate 
	 * @return Resultados
	 * @throws CannotExecuteInsertException
	 */
	private List<RuleResult> procesaReglas(final List<RuleEndState> rules,
			final Connection cnn, final Date currentDate) throws CannotExecuteInsertException {
		final ArrayList<RuleResult> results = new ArrayList<RuleResult>();
		for (RuleEndState rule : rules) {
			logger.debug("Regla: " + rule.getName());
			final RuleResult r = new RuleResult(rule.getName());
			r.start();
			if (rule.getRuleDefinition() == null) {
				String msg = "El END_STATE: " + rule.getName() + "_"
						+ rule.getValue() + "  no ha definido ninguna regla!";
				logger.warn(msg);
				r.finishWithWarnings(msg);
			} else {
				try {
					long rows = cnnFacade.executeInsert(cnn,
							builder.buildSQL4Insert(rule,
									(ExtendedRuleExecutorConfig) this
											.getConfig(), currentDate), true);
					r.finishOK(rows);
					logger.debug("Finish OK");
				} catch (CannotParseRuleDefinitionException e) {
					r.finishWithErrors(e);
					logger.debug("Finish With Errors");
				}
			}
			results.add(r);
		}
		return results;
	}

	private List<RuleResult> delegate(final List<RuleEndState> endStates) {
		rManager.regenerateData(getConfig());
		engine.setConfig(getConfig());
		return engine.execRules(endStates);
	}

	public RuleExecutor getEngine() {
		return engine;
	}

	public void setEngine(RuleExecutor engine) {
		this.engine = engine;
	}

}
