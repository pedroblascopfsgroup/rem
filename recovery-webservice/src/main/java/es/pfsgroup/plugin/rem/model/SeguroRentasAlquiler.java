package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoScoring;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoSeguroRentas;



/**
 * Modelo que gestiona el Seguro rentas del modulo alquiler
 * 
 * @author Sergio Beleña
 *
 */
@Entity
@Table(name = "SRE_SEGURO_RENTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class SeguroRentasAlquiler implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "SRE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "SeguroRentasAlquilerGenerator")
    @SequenceGenerator(name = "SeguroRentasAlquilerGenerator", sequenceName = "S_SRE_SEGURO_RENTAS")
    private Long id;
	
	@Column(name = "SRE_MOTIVO_RECHAZO")
    private String motivoRechazo;
	
	
	@Column(name = "SRE_EN_REVISION")
	private Integer enRevision;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ESR_ID")
    private DDEstadoSeguroRentas estadoSeguroRentas;

	@Column(name = "SRE_ASEGURADORAS")
	private String aseguradoras;
	
	@Column(name = "SRE_EMAIL_POLIZA_ASEGURADORA")
	private String emailPolizaAseguradora;
	
	@Column(name = "COMENTARIOS")
	private String comentarios;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public Integer getEnRevision() {
		return enRevision;
	}

	public void setEnRevision(Integer enRevision) {
		this.enRevision = enRevision;
	}

	public DDEstadoSeguroRentas getEstadoSeguroRentas() {
		return estadoSeguroRentas;
	}

	public void setEstadoSeguroRentas(DDEstadoSeguroRentas estadoSeguroRentas) {
		this.estadoSeguroRentas = estadoSeguroRentas;
	}

	public String getAseguradoras() {
		return aseguradoras;
	}

	public void setAseguradoras(String aseguradoras) {
		this.aseguradoras = aseguradoras;
	}

	public String getEmailPolizaAseguradora() {
		return emailPolizaAseguradora;
	}

	public void setEmailPolizaAseguradora(String emailPolizaAseguradora) {
		this.emailPolizaAseguradora = emailPolizaAseguradora;
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	
	
}
