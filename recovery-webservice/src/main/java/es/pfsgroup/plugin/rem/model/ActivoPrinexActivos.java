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
import es.pfsgroup.plugin.rem.model.dd.DDDisponibleAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDDisponibleTecnico;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoTecnico;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;

/**
 * Modelo que gestiona los activos de BBVA
 * 
 * @author Adrián Molina
 */
@Entity
@Table(name = "ACT_PRINEX_ACTIVOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoPrinexActivos implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "PRINEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPrinexActivosGenerator")
    @SequenceGenerator(name = "ActivoPrinexActivosGenerator", sequenceName = "S_ACT_PRINEX_ACTIVOS")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_DIA_ID")
  	private DDDisponibleAdministracion disponibleAdministracion;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_DIT_ID")
  	private DDDisponibleTecnico disponibleTecnico;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MTC_ID")
  	private DDMotivoTecnico motivoTecnico;
    
    @Column(name = "PRINEX_COSTE_ADQUISICION")
    private Float costeAdquisicion;
    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

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
	
	public DDDisponibleAdministracion getDisponibleAdministracion() {
		return disponibleAdministracion;
	}

	public void setDisponibleAdministracion(DDDisponibleAdministracion disponibleAdministracion) {
		this.disponibleAdministracion = disponibleAdministracion;
	}
	
	public DDDisponibleTecnico getDisponibleTecnico() {
		return disponibleTecnico;
	}

	public void setDisponibleTecnico(DDDisponibleTecnico disponibleTecnico) {
		this.disponibleTecnico = disponibleTecnico;
	}
	
	public DDMotivoTecnico getMotivoTecnico() {
		return motivoTecnico;
	}

	public void setMotivoTecnico(DDMotivoTecnico motivoTecnico) {
		this.motivoTecnico = motivoTecnico;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Float getCosteAdquisicion() {
		return costeAdquisicion;
	}

	public void setCosteAdquisicion(Float costeAdquisicion) {
		this.costeAdquisicion = costeAdquisicion;
	}
	
}
