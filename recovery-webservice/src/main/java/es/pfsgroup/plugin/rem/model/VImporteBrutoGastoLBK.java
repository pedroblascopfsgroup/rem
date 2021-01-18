package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_IMPORTE_BRUTO_GASTO_LBK", schema = "${entity.schema}")
public class VImporteBrutoGastoLBK implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "GPV_ID")
	private Long id;
	
	@Column(name="IMPORTE_BRUTO")
	private Double importeBrutoLbk;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Double getImporteBrutoLbk() {
		return importeBrutoLbk;
	}

	public void setImporteBrutoLbk(Double importeBrutoLbk) {
		this.importeBrutoLbk = importeBrutoLbk;
	}

	
}