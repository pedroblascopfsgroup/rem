package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los datos básicos de las condiciones de un expediente.
 *  
 * @author Jose Villel
 *
 */
public class DtoCondiciones extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idCondiciones;
	
	private Integer solicitaFinanciacion;
	

	public Long getIdCondiciones() {
		return idCondiciones;
	}

	public void setIdCondiciones(Long idCondiciones) {
		this.idCondiciones = idCondiciones;
	}
	
	public Integer getSolicitaFinanciacion() {
		return solicitaFinanciacion;
	}

	public void setSolicitaFinanciacion(Integer solicitaFinanciacion) {
		this.solicitaFinanciacion = solicitaFinanciacion;
	}

	
	

	   
   	
   	
   	
}
