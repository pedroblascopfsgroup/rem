package es.capgemini.pfs.batch.revisar.arquetipos;

import java.util.List;

import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;

/**
 * Clase que incorpora a la configuración del {@link RuleExecutor} nuevas
 * propiedades para dar soporte a dos algoritmos diferentes de arquetipado.
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
public class ExtendedRuleExecutorConfig extends RuleExecutorConfig {

	private String policy;
	private String tableToInsert;
	private String pkColumn;
	private String pkSequence;
	private String columnArqId;
	private String columnArqName;
	private String columnArqPriority;
	private String columnArqDate;
	private List<String> refreshViews;

	public String getPolicy() {
		return policy;
	}

	public void setPolicy(String policy) {
		this.policy = policy;
	}

	public String getTableToInsert() {
		return tableToInsert;
	}

	public void setTableToInsert(String tableToInsert) {
		this.tableToInsert = tableToInsert;
	}

	public String getColumnArqId() {
		return columnArqId;
	}

	public void setColumnArqId(String columnArqId) {
		this.columnArqId = columnArqId;
	}

	public String getColumnArqName() {
		return columnArqName;
	}

	public void setColumnArqName(String columnArqName) {
		this.columnArqName = columnArqName;
	}

	public String getColumnArqPriority() {
		return columnArqPriority;
	}

	public void setColumnArqPriority(String columnArqPriority) {
		this.columnArqPriority = columnArqPriority;
	}

	public String getColumnArqDate() {
		return columnArqDate;
	}

	public void setColumnArqDate(String columnArqDate) {
		this.columnArqDate = columnArqDate;
	}

	public List<String> getRefreshViews() {
		return refreshViews;
	}

	public void setRefreshViews(List<String> refreshViews) {
		this.refreshViews = refreshViews;
	}

	public String getPkColumn() {
		return pkColumn;
	}

	public void setPkColumn(String pkColumn) {
		this.pkColumn = pkColumn;
	}

	public String getPkSequence() {
		return pkSequence;
	}

	public void setPkSequence(String pkSequence) {
		this.pkSequence = pkSequence;
	}

}
