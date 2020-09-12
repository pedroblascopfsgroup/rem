package es.pfsgroup.plugin.rem.gasto.dto;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

public class ImportesAcumuladosDto extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2313494742687018134L;
	
	Long id;
	BigDecimal importe;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public BigDecimal getImporte() {
		return importe;
	}
	public void setImporte(BigDecimal importe) {
		this.importe = importe;
	}

}
