package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenDato;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;



/**
 * Modelo que gestiona la situacion posesoria de un activo.
 * 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_CRG_CARGAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCargas implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CRG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCargasGenerator")
    @SequenceGenerator(name = "ActivoCargasGenerator", sequenceName = "S_ACT_CRG_CARGAS")
    private Long id;
	
    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;    
    
    @ManyToOne
    @JoinColumn(name = "DD_TCA_ID")
    private DDTipoCargaActivo tipoCargaActivo; 
    
    @ManyToOne
    @JoinColumn(name = "DD_STC_ID")
    private DDSubtipoCarga subtipoCarga; 
	
    @OneToOne
    @JoinColumn(name = "BIE_CAR_ID")
    private NMBBienCargas cargaBien;   

    @Column(name = "CRG_DESCRIPCION")
    private String descripcionCarga;
    
    @Column(name = "CRG_ORDEN")
    private Integer ordenCarga;
    
    @Column(name="CRG_FECHA_CANCEL_REGISTRAL")
    private Date fechaCancelacionRegistral;
    
    @Column(name="CRG_OBSERVACIONES")
    private String observaciones;
    
    @ManyToOne
    @JoinColumn(name = "DD_ODT_ID")
    private DDOrigenDato origenDato;
    
    @Column(name = "CRG_CARGAS_PROPIAS")
    private Integer cargasPropias;

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

	public DDTipoCargaActivo getTipoCargaActivo() {
		return tipoCargaActivo;
	}

	public void setTipoCargaActivo(DDTipoCargaActivo tipoCargaActivo) {
		this.tipoCargaActivo = tipoCargaActivo;
	}

	public DDSubtipoCarga getSubtipoCarga() {
		return subtipoCarga;
	}

	public void setSubtipoCarga(DDSubtipoCarga subtipoCarga) {
		this.subtipoCarga = subtipoCarga;
	}

	public NMBBienCargas getCargaBien() {
		return cargaBien;
	}

	public void setCargaBien(NMBBienCargas cargaBien) {
		this.cargaBien = cargaBien;
	}

	public String getDescripcionCarga() {
		return descripcionCarga;
	}

	public void setDescripcionCarga(String descripcionCarga) {
		this.descripcionCarga = descripcionCarga;
	}

	public Integer getOrdenCarga() {
		return ordenCarga;
	}

	public void setOrdenCarga(Integer ordenCarga) {
		this.ordenCarga = ordenCarga;
	}

	public Date getFechaCancelacionRegistral() {
		return fechaCancelacionRegistral;
	}

	public void setFechaCancelacionRegistral(Date fechaCancelacionRegistral) {
		this.fechaCancelacionRegistral = fechaCancelacionRegistral;
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

	public DDOrigenDato getOrigenDato() {
		return origenDato;
	}

	public void setOrigenDato(DDOrigenDato origenDato) {
		this.origenDato = origenDato;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Integer getCargasPropias() {
		return cargasPropias;
	}

	public void setCargasPropias(Integer cargasPropias) {
		this.cargasPropias = cargasPropias;
	}
	
	

	
}
