package es.pfsgroup.plugin.log.advanced.dto;


public class LogDevoWebServiceDto {
	
	private String webServiceName;
	private boolean resultOK;
	
	public LogDevoWebServiceDto(String webServiceName, boolean resultOK){
		this.webServiceName = webServiceName;
		this.resultOK = resultOK;
	}


	public String getWebServiceName() {
		return webServiceName;
	}

	public void setWebServiceName(String webServiceName) {
		this.webServiceName = webServiceName;
	}

	public boolean isResultOK() {
		return resultOK;
	}

	public void setResultOK(boolean resultOK) {
		this.resultOK = resultOK;
	}

}