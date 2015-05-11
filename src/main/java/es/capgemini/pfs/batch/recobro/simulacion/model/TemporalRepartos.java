package es.capgemini.pfs.batch.recobro.simulacion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

@Entity
@Table(name="TMP_REC_EXP_AGE_CNT_EXC", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class TemporalRepartos implements Serializable {

	/**
	 *SERIALUID
	 */
	private static final long serialVersionUID = 7082207570990065335L;
	
	@Id
	@Column(name="ROWID")
	private String rowId;
	
	@OneToOne
	@JoinColumn(name="RCF_AGE_ID")
	private RecobroAgencia recobroAgencia;
	
	@OneToOne
	@JoinColumn(name="RCF_SCA_ID")
	private RecobroSubCartera recobroSubCartera;
	
	@OneToOne
	@JoinColumn(name="EXP_ID")
	private Expediente expediente;
	
	@OneToOne
	@JoinColumn(name="PER_ID")
	private Persona persona;
	
	@OneToOne
	@JoinColumn(name="CNT_ID")
	private Contrato contrato;
	
	@Column(name="GES_ID")
	private Boolean gestionCompartida;

	public RecobroAgencia getRecobroAgencia() {
		return recobroAgencia;
	}

	public void setRecobroAgencia(RecobroAgencia recobroAgencia) {
		this.recobroAgencia = recobroAgencia;
	}

	public RecobroSubCartera getRecobroSubCartera() {
		return recobroSubCartera;
	}

	public void setRecobroSubCartera(RecobroSubCartera recobroSubCartera) {
		this.recobroSubCartera = recobroSubCartera;
	}

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Boolean getGestionCompartida() {
		return gestionCompartida;
	}

	public void setGestionCompartida(Boolean gestionCompartida) {
		this.gestionCompartida = gestionCompartida;
	}

	public String getRowId() {
		return rowId;
	}

	public void setRowId(String rowId) {
		this.rowId = rowId;
	}
	
}
