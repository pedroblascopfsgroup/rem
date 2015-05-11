package es.capgemini.pfs.batch.revisar.arquetipos.engine.test.sqlStatementBuilder;

import es.capgemini.pfs.batch.revisar.arquetipos.ExtendedRuleExecutorConfig;

public class AbstractInsertStatementBuilderTests {

	protected static final String COLUM_NAME_ARQ_PRIORITY = "arq_priority";
	protected static final String COLUMN_NAME_ARQ_ID = "arq_id";
	protected static final String COLUMN_NAME_REF = "per_id";
	protected static final String TABLE_NAME_TO_INSERT = "tmp_bruno_dev_arq";

	public AbstractInsertStatementBuilderTests() {
		super();
	}

	protected ExtendedRuleExecutorConfig createConfig() {
		final ExtendedRuleExecutorConfig myConfig = new ExtendedRuleExecutorConfig();
		myConfig.setPolicy("INSERT");
		myConfig.setRuleDefinitionType("XML");
	
		myConfig.setTableFrom("data_rule_engine");
		myConfig.setColumnFromRef(COLUMN_NAME_REF);
	
		myConfig.setTableToInsert(TABLE_NAME_TO_INSERT);
		myConfig.setPkColumn("tmp_id");
		myConfig.setPkSequence("s_tmp_bruno_dev_arq");
		myConfig.setColumnToRef(COLUMN_NAME_REF);
		myConfig.setColumnArqId(COLUMN_NAME_ARQ_ID);
		myConfig.setColumnArqName("arq_name");
		myConfig.setColumnArqPriority(COLUM_NAME_ARQ_PRIORITY);
		myConfig.setColumnArqDate("arq_date");
		return myConfig;
	}

}