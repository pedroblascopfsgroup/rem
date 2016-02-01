package es.pfsgroup.recovery.hrebcc.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.vencidos.model.DDTipoVencido;


@Entity
@Table(name="VEN_VENCIDOS", schema = "${entity.schema}")
public class Vencidos implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4374913319377831699L;
	
	@Id
	@Column(name="VEN_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator="VencidosGenerator")
	@SequenceGenerator(name="VencidosGenerator", sequenceName= "S_VEN_VENCIDOS")
	private Long id;
	
	@Column(name = "CNT_ID")
	private Long cntId;
	
	@ManyToOne
	@JoinColumn(name="DD_TVE_ID")
	private DDTipoVencido tipoVencido;
	
	@ManyToOne
	@JoinColumn(name="DD_TVE_ANTERIOR")
	private DDTipoVencido tipoVencidoAnterior;
	
	@Embedded
	private Auditoria auditoria;

	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCntId() {
		return cntId;
	}

	public void setCntId(Long cntId) {
		this.cntId = cntId;
	}

	public DDTipoVencido getTipoVencido() {
		return tipoVencido;
	}

	public void setTipoVencido(DDTipoVencido tipoVencido) {
		this.tipoVencido = tipoVencido;
	}

	public DDTipoVencido getTipoVencidoAnterior() {
		return tipoVencidoAnterior;
	}

	public void setTipoVencidoAnterior(DDTipoVencido tipoVencidoAnterior) {
		this.tipoVencidoAnterior = tipoVencidoAnterior;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}

}
