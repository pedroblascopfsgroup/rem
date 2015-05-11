package es.capgemini.pfs.batch.revisar.arquetipos.repo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.revisar.arquetipos.RepositorioArquetipos;
import es.capgemini.pfs.batch.revisar.arquetipos.repo.dao.ArquetiposBatchDao;
import es.capgemini.pfs.batch.revisar.arquetipos.repo.exception.CannotGetRuleEndState;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * Este repositorio permite mapear el resultado de cualquier consula en
 * Arquetipos
 * 
 * @author bruno
 * 
 */
public class RepositorioArquetiposGenerico implements RepositorioArquetipos {

	public DataSource getDataSource() {
		return dataSource;
	}

	
	@Autowired
	private ArquetiposBatchDao dao;

	// Se inyecta explícitamente
	private RepositorioConfig repoConfig;

	// Se inyecta explícitamente
	private DataSource dataSource;

	@Override
	public List<RuleEndState> getList() {
		if (repoConfig == null) {
			throw new IllegalStateException("No existe configuración");
		}
		if (dataSource == null) {
			throw new IllegalStateException("No se le ha asociado el dataSource a este componente.");
		}
		dao.setDataSource(this.dataSource);
		final List<Map<String, Object>> rs = dao.executeSelect(repoConfig
				.getQuery());
		final List<RuleEndState> rules = mapeaResultados(rs);
		return rules;
	}

	private List<RuleEndState> mapeaResultados(List<Map<String, Object>> rs) {
		final ArrayList<RuleEndState> list = new ArrayList<RuleEndState>();
		if (rs != null) {
			for (final Map<String, Object> m : rs) {
				try {
					
					final long priority = parsePriority(m);

					list.add(new RuleEndState() {

						@Override
						public String getValue() {
							return convertToString(m.get(repoConfig
									.getColumnForValue()));
						}

						@Override
						public String getRuleDefinition() {
							return convertToString(m.get(repoConfig
									.getColumnForRuleDefinition()));
						}

						@Override
						public long getPriority() {
							return priority;
						}

						@Override
						public String getName() {
							return convertToString(m.get(repoConfig.getColumnForName()));
						}
					});
				} catch (NumberFormatException nfe) {
					throw new CannotGetRuleEndState(m, nfe);
				}
			}
		}
		return list;
	}

	public void setRepoConfig(final RepositorioConfig config) {
		this.repoConfig = config;
	}
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	private long parsePriority(final Map<String, Object> m) {
		long priority;
		final Object o = m.get(repoConfig.getColumnForPriority());
		if ((o != null) && (o instanceof Long)) {
			priority =  (Long) o;
		} else {
			priority =  Long.parseLong(o.toString());
		}
		return priority;
	}
	
	private String convertToString(final Object o){
		if (o == null){
			return null;
		}
		if (o instanceof String ){
			return (String) o;
		}else{
			return o.toString();
		}
	}
	
	


}
