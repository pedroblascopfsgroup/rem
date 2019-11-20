package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import es.pfsgroup.commons.utils.Checks;


@Entity
@Table(name = "VGR_GASTOS_REFACTURABLES", schema = "${entity.schema}")
public class VGastosRefacturados implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "NUM_GASTO_HAYA")
	private String numGastoHaya;

	public String getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(String numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}
}