package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "BIE_CAR_CARGAS", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class NMBBienCargas implements Serializable, Auditable{

	private static final long serialVersionUID = -4497097910086775262L;

	 
	@Id
    @Column(name = "BIE_CAR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBBienCargaGenerator")
    @SequenceGenerator(name = "NMBBienCargaGenerator", sequenceName = "S_BIE_CAR_CARGAS")
    private Long idCarga;
	
	@OneToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "BIE_ID")
    private NMBBien bien;
    
	@ManyToOne
	@JoinColumn(name = "DD_TPC_ID")
	private DDTipoCarga tipoCarga;
	
    @Column(name = "BIE_CAR_LETRA")
    private String letra;
    
    @Column(name = "BIE_CAR_TITULAR")
    private String titular;
        
    @Column(name = "BIE_CAR_IMPORTE_REGISTRAL") 
    private Float importeRegistral;
    
    @Column(name = "BIE_CAR_IMPORTE_ECONOMICO") 
    private Float importeEconomico;
    
    @Column(name = " BIE_CAR_REGISTRAL")
    private Boolean registral;
    
    @ManyToOne
    @JoinColumn(name = "DD_SIC_ID")
    private DDSituacionCarga situacionCarga;
    
    @ManyToOne
    @JoinColumn(name = "DD_SIC_ID2")
    private DDSituacionCarga situacionCargaEconomica;
    
    @Column(name = "BIE_CAR_FECHA_PRESENTACION")
    private Date fechaPresentacion;
    
    @Column(name = "BIE_CAR_FECHA_INSCRIPCION")    
    private Date fechaInscripcion;
    
    @Column(name = " BIE_CAR_FECHA_CANCELACION") 
    private Date fechaCancelacion;
    
    @Column(name = "BIE_CAR_ECONOMICA")
    private boolean economica;
    
    @Embedded
    private Auditoria auditoria;
    
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public Long getIdCarga() {
		return idCarga;
	}

	public void setIdCarga(Long idCarga) {
		this.idCarga = idCarga;
	}

	public DDTipoCarga getTipoCarga() {
		return tipoCarga;
	}

	public void setTipoCarga(DDTipoCarga tipoCarga) {
		this.tipoCarga = tipoCarga;
	}

	public String getLetra() {
		return letra;
	}

	public void setLetra(String letra) {
		this.letra = letra;
	}

	public String getTitular() {
		return titular;
	}

	public void setTitular(String titular) {
		this.titular = titular;
	}

	public Float getImporteRegistral() {
		return importeRegistral;
	}

	public void setImporteRegistral(Float importeRegistral) {
		this.importeRegistral = importeRegistral;
	}

	public Float getImporteEconomico() {
		return importeEconomico;
	}

	public void setImporteEconomico(Float importeEconomico) {
		this.importeEconomico = importeEconomico;
	}

	public Boolean getRegistral() {
		return registral;
	}

	public void setRegistral(Boolean registral) {
		this.registral = registral;
	}

	public DDSituacionCarga getSituacionCarga() {
		return situacionCarga;
	}

	public void setSituacionCarga(DDSituacionCarga situacionCarga) {
		this.situacionCarga = situacionCarga;
	}

	public DDSituacionCarga getSituacionCargaEconomica() {
		return situacionCargaEconomica;
	}

	public void setSituacionCargaEconomica(DDSituacionCarga situacionCargaEconomica) {
		this.situacionCargaEconomica = situacionCargaEconomica;
	}

	public Date getFechaPresentacion() {
		return fechaPresentacion;
	}

	public void setFechaPresentacion(Date fechaPresentacion) {
		this.fechaPresentacion = fechaPresentacion;
	}

	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}

	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}

	public Date getFechaCancelacion() {
		return fechaCancelacion;
	}

	public void setFechaCancelacion(Date fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}

	public boolean isEconomica() {
		return economica;
	}

	public void setEconomica(boolean economica) {
		this.economica = economica;
	}
    
}
