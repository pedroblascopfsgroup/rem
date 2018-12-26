package es.pfsgroup.plugin.gestorDocumental.dto;

import java.io.Serializable;

public class PersonaOutputDto implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String resultCode;
	private String resultDescription;
	private String idIntervinienteHaya;
	
	public String toString(){
		String result = "";
		
		if(resultCode != null){
			result = result + "resultCode: "+ resultCode + "\\n"; 
		}
		
		if(resultDescription != null){
			result = result + "resultDescription: "+ resultDescription + "\\n"; 
		}
		
		if(idIntervinienteHaya != null){
			result = result + "idIntervinienteHaya: "+ idIntervinienteHaya + "\\n"; 
		}
		
		return result;
	}

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}

	public String getResultDescription() {
		return resultDescription;
	}

	public void setResultDescription(String resultDescription) {
		this.resultDescription = resultDescription;
	}
	
	public String getIdIntervinienteHaya() {
		return idIntervinienteHaya;
	}
	
	public void setIdIntervinienteHaya(String idIntervinienteHaya) {
		this.idIntervinienteHaya = idIntervinienteHaya;
	}

}
