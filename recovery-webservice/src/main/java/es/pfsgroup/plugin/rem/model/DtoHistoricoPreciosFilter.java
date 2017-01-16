package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona el filtro del historico de valores precios del activo
 *
 */
public class DtoHistoricoPreciosFilter extends WebDto {
	
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String idActivo;
	

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	
	
}
