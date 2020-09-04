package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de la pestaña contabilidad de un gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoVImporteGastoLbk extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idElemento;
	private String tipoElemento;
	private Double importeGasto;
	
	public Long getIdElemento() {
		return idElemento;
	}
	public void setIdElemento(Long idElemento) {
		this.idElemento = idElemento;
	}
	public String getTipoElemento() {
		return tipoElemento;
	}
	public void setTipoElemento(String tipoElemento) {
		this.tipoElemento = tipoElemento;
	}
	public Double getImporteGasto() {
		return importeGasto;
	}
	public void setImporteGasto(Double importeGasto) {
		this.importeGasto = importeGasto;
	}

   	
}
