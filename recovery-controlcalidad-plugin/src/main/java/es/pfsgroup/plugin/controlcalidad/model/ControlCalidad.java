package es.pfsgroup.plugin.controlcalidad.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;


/**
 * Modelo de datos para la entidad de Control de Calidad
 * @author Guillem
 *
 */
@Entity
@Table(name = "CCA_CONTROL_CALIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ControlCalidad implements Auditable, Serializable{

	private static final long serialVersionUID = -8601959442901689032L;

	 @Id
	 @Column(name = "CCA_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "ControlCalidadGenerator")
	 @SequenceGenerator(name = "ControlCalidadGenerator", sequenceName = "S_CCA_CONTROL_CALIDAD")
	 private Long id;
	 
	 @Column(name = "CCA_ID_ENTIDAD")
	 private Long idEntidad;

	 @Column(name = "CCA_DESCRIPCION")
	 private String descripcion;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_EIN_ID")
	 private DDTipoEntidad tipoEntidad;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_TCC_ID")
	 private DDTipoControlCalidad tipoControlCalidad;
	 
	 @Embedded
	 private Auditoria auditoria;

	 @Version
	 private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public DDTipoEntidad getTipoEntidad() {
		return tipoEntidad;
	}

	public void setTipoEntidad(DDTipoEntidad tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}

	public DDTipoControlCalidad getTipoControlCalidad() {
		return tipoControlCalidad;
	}

	public void setTipoControlCalidad(DDTipoControlCalidad tipoControlCalidad) {
		this.tipoControlCalidad = tipoControlCalidad;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	 
}
