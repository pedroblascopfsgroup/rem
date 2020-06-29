package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoAgendaSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgendaSaneamiento;



/**
 * Modelo que gestiona la informacion de los proveedores de los activos.
 * 
 * @author Ivan Rubio
 *
 */
@Entity
@Table(name = "ACT_ASA_AGENDA_SANEAMIENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAgendaSaneamiento implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ASA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgendaSaneamientoGenerator")
    @SequenceGenerator(name = "ActivoAgendaSaneamientoGenerator", sequenceName = "S_ACT_ASA_AGENDA_SANEAMIENTO")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo; 
    
    @ManyToOne
    @JoinColumn(name = "DD_TAS_ID")
    private DDTipoAgendaSaneamiento tipoAgendaSaneamiento; 
    
    @ManyToOne
    @JoinColumn(name = "DD_SAS_ID")
    private DDSubtipoAgendaSaneamiento subtipoAgendaSaneamiento;

    @Column(name = "ASA_OBSERVACIONES")
	private String observaciones;
	 
    @Column(name = "ASA_FECHA_ALTA")
	private String fechaAltaSaneamiento;
    
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

	public DDTipoAgendaSaneamiento getTipoAgendaSaneamiento() {
		return tipoAgendaSaneamiento;
	}

	public void setTipoAgendaSaneamiento(DDTipoAgendaSaneamiento tipoAgendaSaneamiento) {
		this.tipoAgendaSaneamiento = tipoAgendaSaneamiento;
	}

	public DDSubtipoAgendaSaneamiento getSubtipoAgendaSaneamiento() {
		return subtipoAgendaSaneamiento;
	}

	public void setSubtipoAgendaSaneamiento(DDSubtipoAgendaSaneamiento subtipoAgendaSaneamiento) {
		this.subtipoAgendaSaneamiento = subtipoAgendaSaneamiento;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getFechaAltaSaneamiento() {
		return fechaAltaSaneamiento;
	}

	public void setFechaAltaSaneamiento(String fechaAltaSaneamiento) {
		this.fechaAltaSaneamiento = fechaAltaSaneamiento;
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
