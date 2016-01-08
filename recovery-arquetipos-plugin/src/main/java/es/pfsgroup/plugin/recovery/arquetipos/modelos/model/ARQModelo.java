package es.pfsgroup.plugin.recovery.arquetipos.modelos.model;

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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.model.ARQDDEstadoModelo;


@Entity
@Table(name = "MOA_MODELOS_ARQ" ,schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ARQModelo implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2784155345726810119L;
	
	
	@Id
	@Column(name = "MOA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "modeloGenerator")
	@SequenceGenerator(name = "modeloGenerator", sequenceName = "S_MOA_MODELOS_ARQ")
	private Long id;
	
	@Column(name="MOA_DESCRIPCION")
	private String descripcion;
	
	@Column(name ="MOA_NOMBRE")
	private String nombre;
	
	@ManyToOne
	@JoinColumn(name = "DD_ESM_ID")
	private ARQDDEstadoModelo estado;
	
	@Column(name = "MOA_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "MOA_FECHA_INI_VIGENCIA")
	private Date fechaInicioVigencia;
	
	@Column(name = "MOA_FECHA_FIN_VIGENCIA")
	private Date fechaFinVigencia;
	
	@Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;


	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}
	
	public void setEstado(ARQDDEstadoModelo estado) {
		this.estado = estado;
	}

	public ARQDDEstadoModelo getEstado() {
		return estado;
	}
	

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}

	public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}

	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}

	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}	

}
