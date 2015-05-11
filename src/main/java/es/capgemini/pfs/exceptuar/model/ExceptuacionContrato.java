package es.capgemini.pfs.exceptuar.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.contrato.model.Contrato;

@Entity
@Table(name = "ECO_EXCEPTUACION_CONTRATO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "EXC_ID")
public class ExceptuacionContrato extends Exceptuacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1267973976400188051L;

	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

}
