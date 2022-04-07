package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_CUENTAS_VIRTUALES_RESTANTES", schema = "${entity.schema}")
public class VCuentasVirtualesRestantes implements Serializable {

	private static final long serialVersionUID = 750359188915093506L;

	@Id
	@Column(name = "DD_SCR_ID")
	private Long subcartera;
	
	@Column(name = "NUM_CUENTAS")	
	private Long num_cuentas;

	public Long getNum_cuentas() {
		return num_cuentas;
	}

	public void setNum_cuentas(Long num_cuentas) {
		this.num_cuentas = num_cuentas;
	}

	public Long getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(Long subcartera) {
		this.subcartera = subcartera;
	}

	

	
}
