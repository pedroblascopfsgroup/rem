package es.capgemini.pfs.batch.revisar.arquetipos.repo;

/**
 * Contiene la configuración del del repositorio
 * 
 * <ul>
 * <li>SELECT a ejecutar</li>
 * <li>Mapeo del resultado del SELECT a Arquetipos</li>
 * </ul>
 * 
 * @author bruno
 * 
 */
public class RepositorioConfig {

	private String query;
	private String columnForValue;
	private String columnForPriority;
	private String columnForName;
	private String columnForRuleDefinition;

	public void setQuery(final String string) {
		this.query = string;
	}

	public String getQuery() {
		return this.query;
	}

	public String getColumnForValue() {
		return columnForValue;
	}

	public void setColumnForValue(String columnForValue) {
		this.columnForValue = columnForValue;
	}

	public String getColumnForPriority() {
		return columnForPriority;
	}

	public void setColumnForPriority(String columnForPriority) {
		this.columnForPriority = columnForPriority;
	}

	public String getColumnForName() {
		return columnForName;
	}

	public void setColumnForName(String columnForName) {
		this.columnForName = columnForName;
	}

	public String getColumnForRuleDefinition() {
		return columnForRuleDefinition;
	}

	public void setColumnForRuleDefinition(String columnForRuleDefinition) {
		this.columnForRuleDefinition = columnForRuleDefinition;
	}

}
