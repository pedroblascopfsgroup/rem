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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona la informacion del historico de condicionantes de un expediente comercial
 *  
 * @author Adrian Daniel Casiean
 *
 */


@Entity
@Table(name = "HIC_HISTO_CON", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class HistoricoCondicionanteExpediente implements Serializable, Auditable{
	
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "HIC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HisCondicionantesExpedienteGenerator")
    @SequenceGenerator(name = "HisCondicionantesExpedienteGenerator", sequenceName = "S_HIC_HISTO_CON")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COE_ID")
    private CondicionanteExpediente condicionante;
	
	@Column(name = "HIC_FECHA")
	private Date fecha;
	
	@Column(name = "HIC_INCREMENTO_RENTA")
	private Double incrementoRenta;
	
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

	public CondicionanteExpediente getCondicionante() {
		return condicionante;
	}

	public void setCondicionante(CondicionanteExpediente condicionante) {
		this.condicionante = condicionante;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public Double getIncrementoRenta() {
		return incrementoRenta;
	}

	public void setIncrementoRenta(Double incrementoRenta) {
		this.incrementoRenta = incrementoRenta;
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
