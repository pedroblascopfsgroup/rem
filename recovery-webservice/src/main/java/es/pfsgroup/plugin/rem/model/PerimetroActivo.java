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
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;

/**
 * Modelo que gestiona el perímetro de un activo
 * 
 * @author jros
 */
@Entity
@Table(name = "ACT_PAC_PERIMETRO_ACTIVO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PerimetroActivo implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    @Id
    @Column(name = "PAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PerimetroActivoGenerator")
    @SequenceGenerator(name = "PerimetroActivoGenerator", sequenceName = "S_ACT_PAC_PERIMETRO_ACTIVO")
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @Column(name = "PAC_INCLUIDO")
	private Integer incluidoEnPerimetro; 
    
    @Column(name = "PAC_CHECK_TRA_ADMISION")
	private Integer aplicaTramiteAdmision; 
    
    @Column(name = "PAC_FECHA_TRA_ADMISION")
	private Date fechaAplicaTramiteAdmision; 
    
    @Column(name = "PAC_MOTIVO_TRA_ADMISION")
	private String motivoAplicaTramiteAdmision;
    
    @Column(name = "PAC_CHECK_GESTIONAR")
	private Integer aplicaGestion; 
    
    @Column(name = "PAC_FECHA_GESTIONAR")
	private Date fechaAplicaGestion; 
    
    @Column(name = "PAC_MOTIVO_GESTIONAR")
	private String motivoAplicaGestion;
    
    @Column(name = "PAC_CHECK_ASIGNAR_MEDIADOR")
	private Integer aplicaAsignarMediador; 
    
    @Column(name = "PAC_FECHA_ASIGNAR_MEDIADOR")
	private Date fechaAplicaAsignarMediador; 
    
    @Column(name = "PAC_MOTIVO_ASIGNAR_MEDIADOR")
	private String motivoAplicaAsignarMediador;
    
    @Column(name = "PAC_CHECK_COMERCIALIZAR")
	private Integer aplicaComercializar; 
    
    @Column(name = "PAC_FECHA_COMERCIALIZAR")
	private Date fechaAplicaComercializar; 
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MCO_ID")
	private DDMotivoComercializacion motivoAplicaComercializar;
    
    @Column(name = "PAC_MOT_EXCL_COMERCIALIZAR")
	private String motivoNoAplicaComercializar;
    
    @Column(name = "PAC_CHECK_FORMALIZAR")
	private Integer aplicaFormalizar; 
    
    @Column(name = "PAC_FECHA_FORMALIZAR")
	private Date fechaAplicaFormalizar;
    
    @Column(name = "PAC_MOTIVO_FORMALIZAR")
	private String motivoAplicaFormalizar;
    
    @Column(name = "PAC_CHECK_PUBLICAR")
	private Boolean aplicaPublicar; 
    
    @Column(name = "PAC_FECHA_PUBLICAR")
	private Date fechaAplicaPublicar;
    
    @Column(name = "PAC_MOTIVO_PUBLICAR")
	private String motivoAplicaPublicar;
    
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Integer getIncluidoEnPerimetro() {
		return incluidoEnPerimetro;
	}

	public void setIncluidoEnPerimetro(Integer incluidoEnPerimetro) {
		this.incluidoEnPerimetro = incluidoEnPerimetro;
	}

	public Integer getAplicaTramiteAdmision() {
		return aplicaTramiteAdmision;
	}

	public void setAplicaTramiteAdmision(Integer aplicaTramiteAdmision) {
		this.aplicaTramiteAdmision = aplicaTramiteAdmision;
	}

	public Date getFechaAplicaTramiteAdmision() {
		return fechaAplicaTramiteAdmision;
	}

	public void setFechaAplicaTramiteAdmision(Date fechaAplicaTramiteAdmision) {
		this.fechaAplicaTramiteAdmision = fechaAplicaTramiteAdmision;
	}

	public String getMotivoAplicaTramiteAdmision() {
		return motivoAplicaTramiteAdmision;
	}

	public void setMotivoAplicaTramiteAdmision(String motivoAplicaTramiteAdmision) {
		this.motivoAplicaTramiteAdmision = motivoAplicaTramiteAdmision;
	}

	public Integer getAplicaGestion() {
		return aplicaGestion;
	}

	public void setAplicaGestion(Integer aplicaGestion) {
		this.aplicaGestion = aplicaGestion;
	}

	public Date getFechaAplicaGestion() {
		return fechaAplicaGestion;
	}

	public void setFechaAplicaGestion(Date fechaAplicaGestion) {
		this.fechaAplicaGestion = fechaAplicaGestion;
	}

	public String getMotivoAplicaGestion() {
		return motivoAplicaGestion;
	}

	public void setMotivoAplicaGestion(String motivoAplicaGestion) {
		this.motivoAplicaGestion = motivoAplicaGestion;
	}

	public Integer getAplicaAsignarMediador() {
		return aplicaAsignarMediador;
	}

	public void setAplicaAsignarMediador(Integer aplicaAsignarMediador) {
		this.aplicaAsignarMediador = aplicaAsignarMediador;
	}

	public Date getFechaAplicaAsignarMediador() {
		return fechaAplicaAsignarMediador;
	}

	public void setFechaAplicaAsignarMediador(Date fechaAplicaAsignarMediador) {
		this.fechaAplicaAsignarMediador = fechaAplicaAsignarMediador;
	}

	public String getMotivoAplicaAsignarMediador() {
		return motivoAplicaAsignarMediador;
	}

	public void setMotivoAplicaAsignarMediador(String motivoAplicaAsignarMediador) {
		this.motivoAplicaAsignarMediador = motivoAplicaAsignarMediador;
	}

	public Integer getAplicaComercializar() {
		return aplicaComercializar;
	}

	public void setAplicaComercializar(Integer aplicaComercializar) {
		this.aplicaComercializar = aplicaComercializar;
	}

	public Date getFechaAplicaComercializar() {
		return fechaAplicaComercializar;
	}

	public void setFechaAplicaComercializar(Date fechaAplicaComercializar) {
		this.fechaAplicaComercializar = fechaAplicaComercializar;
	}

	public DDMotivoComercializacion getMotivoAplicaComercializar() {
		return motivoAplicaComercializar;
	}

	public void setMotivoAplicaComercializar(
			DDMotivoComercializacion motivoAplicaComercializar) {
		this.motivoAplicaComercializar = motivoAplicaComercializar;
	}

	public String getMotivoNoAplicaComercializar() {
		return motivoNoAplicaComercializar;
	}

	public void setMotivoNoAplicaComercializar(String motivoNoAplicaComercializar) {
		this.motivoNoAplicaComercializar = motivoNoAplicaComercializar;
	}

	public Integer getAplicaFormalizar() {
		return aplicaFormalizar;
	}

	public void setAplicaFormalizar(Integer aplicaFormalizar) {
		this.aplicaFormalizar = aplicaFormalizar;
	}

	public Date getFechaAplicaFormalizar() {
		return fechaAplicaFormalizar;
	}

	public void setFechaAplicaFormalizar(Date fechaAplicaFormalizar) {
		this.fechaAplicaFormalizar = fechaAplicaFormalizar;
	}

	public String getMotivoAplicaFormalizar() {
		return motivoAplicaFormalizar;
	}

	public void setMotivoAplicaFormalizar(String motivoAplicaFormalizar) {
		this.motivoAplicaFormalizar = motivoAplicaFormalizar;
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

	public Boolean getAplicaPublicar() {
		return aplicaPublicar;
	}

	public void setAplicaPublicar(Boolean aplicaPublicar) {
		this.aplicaPublicar = aplicaPublicar;
	}

	public Date getFechaAplicaPublicar() {
		return fechaAplicaPublicar;
	}

	public void setFechaAplicaPublicar(Date fechaAplicaPublicar) {
		this.fechaAplicaPublicar = fechaAplicaPublicar;
	}

	public String getMotivoAplicaPublicar() {
		return motivoAplicaPublicar;
	}

	public void setMotivoAplicaPublicar(String motivoAplicaPublicar) {
		this.motivoAplicaPublicar = motivoAplicaPublicar;
	}
	

}
