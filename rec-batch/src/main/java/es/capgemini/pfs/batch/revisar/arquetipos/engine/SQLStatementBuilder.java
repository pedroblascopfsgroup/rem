package es.capgemini.pfs.batch.revisar.arquetipos.engine;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map.Entry;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.batch.revisar.arquetipos.ExtendedRuleExecutorConfig;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotParseRuleDefinitionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.RuleDefinitionTypeNotSupportedException;
import es.capgemini.pfs.ruleengine.RuleConverterUtil;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * Clase encargada de la construcción del INSERT de los arquetipos en base a una
 * {@link RuleEndState}
 * 
 * @author bruno
 * 
 */
@Component
public class SQLStatementBuilder {

	public static final String AUDITORIA_CAMPOS = "USUARIOCREAR, FECHACREAR, BORRADO";
	public static final String AUDITORIA_VALORES = "'BATCH', SYSDATE, 0 BORRADO";

	public static final String AUDITORIA_CAMPOS_KEYWORD = "auditFields";
	public static final String AUDITORIA_VALORES_KEYWORD = "auditValues";

	private static final String TABLE_TO_INSERT_KEYWORD = "tableToInsert";
	private static final String TEMPORARY_TABLE_KEYWORD = "temporaryTable";
	private static final String PK_COLUMN_KEYWORD = "pkColumn";
	private static final String PK_SEQUENCE_KEYWORD = "pkSequence";
	private static final String COLUMN_TO_REF_KEYWORD = "columnToRef";
	private static final String COLUMN_ARQ_ID_KEYWORD = "columnArqId";
	private static final String COLUMN_ARQ_NAME_KEYWORD = "columnArqName";
	private static final String COLUMN_ARQ_PRIORITY_KEYWORD = "columnArqPriority";
	private static final String COLUMN_ARQ_DATE_KEYWORD = "columnArqDate";
	private static final String COLUM_FROM_REF_KEYWORD = "columnFromRef";
	private static final String ARQ_ID_KEYWORD = "arqId";
	private static final String ARQ_NAME_KEYWORD = "arqName";
	private static final String ARQ_PRORITY_KEYWORD = "arqPriority";
	private static final String ARQ_DATE_KEYWORD = "arqDate";
	private static final String TABLE_FROM_NAME_KEYWORD = "tableFrom";
	private static final String WHERE_KEYWORD = "where";

	private static final String TEMPLATE_PROPERTY_4_DROP_KEY = "batch.recobro.sqlStatementBuilder.template4drop";
	private static final String TEMPLATE_PROPERTY_4_CREATE_KEY = "batch.recobro.sqlStatementBuilder.template4create";
	private static final String TEMPLATE_PROPERTY_4_INSERT_KEY = "batch.recobro.sqlStatementBuilder.template4insert";
	private static final String TEMPLATE_PROPERTY_4_MOVE_KEY = "batch.recobro.sqlStatementBuilder.template4move";

	@Autowired
	private RuleConverterUtil rcUtil;

	@Resource
	private Properties appProperties;

	/**
	 * Genera la DDL para hace un DROP TABLE
	 * 
	 * @param config
	 * @param currentDate
	 * @return
	 */
	public String buildDDL4DropTemp(final ExtendedRuleExecutorConfig config,
			final Date currentDate) {
		doChecks(config);
		final String sqlTemplate = appProperties
				.getProperty(TEMPLATE_PROPERTY_4_DROP_KEY);

		if (sqlTemplate == null) {
			throw new IllegalStateException(TEMPLATE_PROPERTY_4_DROP_KEY
					+ ": no se ha podido obtener la propiedad.");
		}

		final HashMap<String, String> params = new HashMap<String, String>();
		populateParams(config, params, currentDate);

		return parseSQLString(sqlTemplate, params);
	}

	/**
	 * Genera la DDL para hace un CREATE TABLE
	 * 
	 * @param config
	 * @param currentDate
	 * @return
	 */
	public String buildDDL4CreateTemp(final ExtendedRuleExecutorConfig config,
			final Date currentDate) {
		doChecks(config);
		final String sqlTemplate = appProperties
				.getProperty(TEMPLATE_PROPERTY_4_CREATE_KEY);

		if (sqlTemplate == null) {
			throw new IllegalStateException(TEMPLATE_PROPERTY_4_CREATE_KEY
					+ ": no se ha podido obtener la propiedad.");
		}

		final HashMap<String, String> params = new HashMap<String, String>();
		populateParams(config, params, currentDate);

		return parseSQLString(sqlTemplate, params);
	}

	/**
	 * Genera la SQL para mover los arquetipos de la tabla temporal a la bunea
	 * 
	 * @param config
	 * @param currentDate
	 * @return
	 */
	public String buildSQL4MoveData(final ExtendedRuleExecutorConfig config,
			final Date currentDate) {
		final String sqlTemplate = appProperties
				.getProperty(TEMPLATE_PROPERTY_4_MOVE_KEY);

		if (sqlTemplate == null) {
			throw new IllegalStateException(TEMPLATE_PROPERTY_4_MOVE_KEY
					+ ": no se ha podido obtener la propiedad.");
		}
		final HashMap<String, String> params = new HashMap<String, String>();
		populateParams(config, params, currentDate);

		return parseSQLString(sqlTemplate, params);
	}

	/**
	 * Genera la SQL con el INSERT.
	 * 
	 * @param rule
	 * @param config
	 * @param currentDate
	 * @return
	 * @throws RuleDefinitionTypeNotSupportedException
	 * @throws CannotParseRuleDefinitionException
	 */
	public String buildSQL4Insert(final RuleEndState rule,
			final ExtendedRuleExecutorConfig config, Date currentDate)
			throws RuleDefinitionTypeNotSupportedException,
			CannotParseRuleDefinitionException {
		if (rule == null) {
			throw new IllegalArgumentException("'rule' no puede ser null");
		}
		doChecks(config);

		final String sqlTemplate = appProperties
				.getProperty(TEMPLATE_PROPERTY_4_INSERT_KEY);

		if (sqlTemplate == null) {
			throw new IllegalStateException(TEMPLATE_PROPERTY_4_INSERT_KEY
					+ ": no se ha podido obtener la propiedad.");
		}

		checkConfigState(config);

		if ("XML".equals(config.getRuleDefinitionType())) {
			final HashMap<String, String> params = new HashMap<String, String>();
			populateParams(rule, config, params, currentDate);

			String parsedSQL = parseSQLString(sqlTemplate, params);

			return parsedSQL;
		} else {
			throw new RuleDefinitionTypeNotSupportedException(config);
		}
	}

	/**
	 * Devueleve el nombre de la tabla que se va a usar como temporal al
	 * ejecutar los inserts
	 * 
	 * @param config
	 * @return
	 */
	public String getTempTableName(final ExtendedRuleExecutorConfig config) {
		if (config == null) {
			throw new IllegalArgumentException("'config' no puede ser null.");
		}
		if ((config.getTableToInsert() == null)
				|| ("".equals(config.getTableToInsert().trim()))) {
			throw new IllegalStateException(
					"No se ha especificado la talba en la que insertar");
		}
		return "T_" + config.getTableToInsert();
	}

	/**
	 * Realiza comprobaciones generales para todos los métodos
	 * 
	 * @param config
	 */
	private void doChecks(final ExtendedRuleExecutorConfig config) {
		if (config == null) {
			throw new IllegalArgumentException("'config' no puede ser null");
		}

		if (appProperties == null) {
			throw new IllegalStateException(
					"No se han podido obtener las 'appProperties'.");
		}
	}

	private void checkConfigState(final ExtendedRuleExecutorConfig config) {
		checkNotNulls(config.getTableToInsert(), config.getPolicy(),
				config.getColumnToRef(), config.getColumnArqId(),
				config.getColumnArqName(), config.getColumnArqPriority(),
				config.getColumnArqDate(), config.getColumnFromRef(),
				config.getTableFrom(), config.getRuleDefinitionType());
	}

	private void checkNotNulls(Object... os) {
		if (os != null) {
			for (Object o : os) {
				if (o == null) {
					throw new IllegalStateException(
							ExtendedRuleExecutorConfig.class.getSimpleName()
									+ " no está suficientemente configurado.");
				}
			}
		}
	}

	private void populateParams(final RuleEndState rule,
			final ExtendedRuleExecutorConfig config,
			final HashMap<String, String> params, final Date currentDate)
			throws CannotParseRuleDefinitionException {
		try {
			populateParams(config, params, currentDate);

			params.put(ARQ_ID_KEYWORD, rule.getValue());
			params.put(ARQ_NAME_KEYWORD, rule.getName());
			params.put(ARQ_PRORITY_KEYWORD, rule.getPriority() + "");
			params.put(WHERE_KEYWORD,
					rcUtil.XMLToRule(rule.getRuleDefinition(), config)
							.generateSQL());
		} catch (ValidationException e) {
			throw new CannotParseRuleDefinitionException(e);
		}
	}

	private void populateParams(final ExtendedRuleExecutorConfig config,
			final HashMap<String, String> params, final Date currentDate) {
		
		if (currentDate == null) {
			throw new IllegalArgumentException("currentDate no puede ser null");
		}

		params.put(TABLE_TO_INSERT_KEYWORD, config.getTableToInsert());
		params.put(PK_COLUMN_KEYWORD, config.getPkColumn());
		params.put(PK_SEQUENCE_KEYWORD, config.getPkSequence());
		params.put(COLUMN_TO_REF_KEYWORD, config.getColumnToRef());
		params.put(COLUMN_ARQ_ID_KEYWORD, config.getColumnArqId());
		params.put(COLUMN_ARQ_NAME_KEYWORD, config.getColumnArqName());
		params.put(COLUMN_ARQ_PRIORITY_KEYWORD, config.getColumnArqPriority());
		params.put(COLUMN_ARQ_DATE_KEYWORD, config.getColumnArqDate());
		params.put(COLUM_FROM_REF_KEYWORD, config.getColumnFromRef());

		params.put(TABLE_FROM_NAME_KEYWORD, config.getTableFrom());
		params.put(AUDITORIA_CAMPOS_KEYWORD, AUDITORIA_CAMPOS);
		params.put(AUDITORIA_VALORES_KEYWORD, AUDITORIA_VALORES);

		params.put(TEMPORARY_TABLE_KEYWORD, this.getTempTableName(config));

		params.put(ARQ_DATE_KEYWORD,
				new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(currentDate));
	}

	private String parseSQLString(final String sqlTemplate,
			final HashMap<String, String> params) {
		String parsedSQL = sqlTemplate;
		for (Entry<String, String> e : params.entrySet()) {
			parsedSQL = parsedSQL.replaceAll("\\$\\{" + e.getKey() + "\\}",
					e.getValue());
		}
		return parsedSQL;
	}

}
