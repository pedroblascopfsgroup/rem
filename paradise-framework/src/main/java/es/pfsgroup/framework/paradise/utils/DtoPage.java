package es.pfsgroup.framework.paradise.utils;

import java.util.List;


public class DtoPage {
	
	private int totalCount;
	
	public List<?> results;

	public DtoPage() {}
	
	public DtoPage(List<?> results, int totalCount) {
		
		setTotalCount(totalCount);
		setResults(results);

	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public List<?> getResults() {
		return results;
	}

	public void setResults(List<?> results) {
		this.results = results;
	}
	
	

}
