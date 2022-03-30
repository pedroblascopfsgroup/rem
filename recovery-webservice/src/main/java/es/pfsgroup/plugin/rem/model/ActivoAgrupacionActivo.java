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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Modelo que gestiona la relacion entre las agrupaciones y los activos
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_AGA_AGRUPACION_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAgrupacionActivo implements Serializable , Auditable {
	

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AGA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgrupacionActivoGenerator")
    @SequenceGenerator(name = "ActivoAgrupacionActivoGenerator", sequenceName = "S_ACT_AGA_AGRUPACION_ACTIVO")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    private ActivoAgrupacion agrupacion;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @Column(name = "AGA_FECHA_INCLUSION")
	private Date fechaInclusion;
    
	@Column(name = "AGA_PRINCIPAL")
	private Integer principal;
		
	@Column(name = "ACT_AGA_PARTICIPACION_UA")
	private Double participacionUA;

	@Column(name = "ACT_AGA_ID_PRINEX_HPM")
	private String idPrinexHPM;
	
	@Column(name = "PISO_PILOTO")
	private Boolean pisoPiloto = false;
	
	@Column(name = "AGA_FECHA_ESCRITURACION")
	private Date fechaEscrituracion;
	
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

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getFechaInclusion() {
		return fechaInclusion;
	}

	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
	}


	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Integer getPrincipal() {
		return principal;
	}

	public void setPrincipal(Integer principal) {
		this.principal = principal;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	public Double getParticipacionUA() {
		return participacionUA;
	}

	public void setParticipacionUA(Double participacionUA) {
		this.participacionUA = participacionUA;
	}

	public String getIdPrinexHPM() {
		return idPrinexHPM;
	}

	public void setIdPrinexHPM(String idPrinexHPM) {
		this.idPrinexHPM = idPrinexHPM;
	}

	public Boolean getPisoPiloto() {
		return pisoPiloto;
	}

	public void setPisoPiloto(Boolean pisoPiloto) {
		this.pisoPiloto = pisoPiloto;
	}

	public Date getFechaEscrituracion() {
		return fechaEscrituracion;
	}

	public void setFechaEscrituracion(Date fechaEscrituracion) {
		this.fechaEscrituracion = fechaEscrituracion;
	}
	
	
}
