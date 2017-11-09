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
 * Modelo que gestiona la relacion de los copropietarios y los activos y su porcentaje de propiedad
 * 
 * @author Juanjo Arbona
 *
 */
@Entity
@Table(name = "ACT_CAC_COPROP_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ActivoCopropietarioActivo implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3836191709700209057L;

	 @Id
	 @Column(name = "CAC_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCopropietarioActivoGenerator")
	 @SequenceGenerator(name = "ActivoCopropietarioActivoGenerator", sequenceName = "S_ACT_CAC_COPROP_ACTIVO")
	 private Long id;
	
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "ACT_ID")
	 private Activo activo;
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "CPR_ID")
	 private ActivoCopropietario coPropietario;
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "DD_TGP_ID")
	 private DDTipoGradoPropiedad tipoGradoPropiedad;
	 		
	 @Column(name = "CAC_PORC_PROPIEDAD")
	 private Float porcPropiedad;
		
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

	public ActivoCopropietario getCoPropietario() {
		return coPropietario;
	}

	public void setCoPropietario(ActivoCopropietario coPropietario) {
		this.coPropietario = coPropietario;
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

	 
}

