package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDAccionesConcurrencia;

/**
 * Modelo que gestiona los cambios de periodo de las concurrencias.
 */
@Entity
@Table(name = "CPC_CMB_PERIODO_CONCURRENCIA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CambioPeriodoConcurrencia implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CPC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CambioPeriodoConcurrenciaGenerator")
    @SequenceGenerator(name = "CambioPeriodoConcurrenciaGenerator", sequenceName = "S_CPC_CMB_PERIODO_CONCURRENCIA")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CON_ID")
    private Concurrencia concurrencia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ACO_ID")
	private DDAccionesConcurrencia accionConcurrencia;

	@Column(name = "CPC_FECHA_FIN")
	private Date fechaFin;
    
    @Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Concurrencia getConcurrencia() {
		return concurrencia;
	}

	public void setConcurrencia(Concurrencia concurrencia) {
		this.concurrencia = concurrencia;
	}

	public DDAccionesConcurrencia getAccionConcurrencia() {
		return accionConcurrencia;
	}

	public void setAccionConcurrencia(DDAccionesConcurrencia accionConcurrencia) {
		this.accionConcurrencia = accionConcurrencia;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


}