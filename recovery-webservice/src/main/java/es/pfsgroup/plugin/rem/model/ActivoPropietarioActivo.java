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
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;

/**
 * Modelo que gestiona la relacion de los propietarios y los activos y su porcentaje de propiedad
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PAC_PROPIETARIO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ActivoPropietarioActivo implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3836191709700209057L;

	 @Id
	 @Column(name = "PAC_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPropietarioGenerator")
	 @SequenceGenerator(name = "ActivoPropietarioGenerator", sequenceName = "S_ACT_PAC_PROPIETARIO_ACTIVO")
	 private Long id;
	
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "ACT_ID")
	 private Activo activo;
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "PRO_ID")
	 private ActivoPropietario propietario;
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "DD_TGP_ID")
	 private DDTipoGradoPropiedad tipoGradoPropiedad;
		
	 @Column(name = "PAC_PORC_PROPIEDAD")
	 private Float porcPropiedad;
		
	 @Column(name = "PAC_ANYO_CONCES")
	 private Integer anyoConcesion;
	
	 @Column(name = "PAC_FEC_FIN_CONCES")
     private Date fechaFinConcesion;

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

	public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public DDTipoGradoPropiedad getTipoGradoPropiedad() {
		return tipoGradoPropiedad;
	}

	public void setTipoGradoPropiedad(DDTipoGradoPropiedad tipoGradoPropiedad) {
		this.tipoGradoPropiedad = tipoGradoPropiedad;
	}

	public Float getPorcPropiedad() {
		return porcPropiedad;
	}

	public void setPorcPropiedad(Float porcPropiedad) {
		this.porcPropiedad = porcPropiedad;
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

	public Integer getAnyoConcesion() {
		return anyoConcesion;
	}

	public void setAnyoConcesion(Integer anyoConcesion) {
		this.anyoConcesion = anyoConcesion;
	}

	public Date getFechaFinConcesion() {
		return fechaFinConcesion;
	}

	public void setFechaFinConcesion(Date fechaFinConcesion) {
		this.fechaFinConcesion = fechaFinConcesion;
	}

}

