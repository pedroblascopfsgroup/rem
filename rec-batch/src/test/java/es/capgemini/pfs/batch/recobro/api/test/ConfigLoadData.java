package es.capgemini.pfs.batch.recobro.api.test;

import java.util.ArrayList;

/**
 * Bean de configuración del método loadDataTest
 * @author Guillem
 *
 */
public class ConfigLoadData {

	ArrayList<String> sqlSentence;
	
	String sqlFile;

	public ArrayList<String> getSqlSentence() {
		return sqlSentence;
	}

	public void setSqlSentence(ArrayList<String> sqlSentence) {
		this.sqlSentence = sqlSentence;
	}

	public String getSqlFile() {
		return sqlFile;
	}

	public void setSqlFile(String sqlFile) {
		this.sqlFile = sqlFile;
	}
		
}
