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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;


/**
 * Modelo que gestiona la informacion de las ocupaciones ilegales
 * 
 * @author alberto.garcia@pfsgroup.es
 */
@Entity
@Table(name = "OKU_DEMANDA_OCUPACION_ILEGAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoOcupacionIlegal implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3683968298723662678L;

	@Id
    @Column(name = "OKU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoOcupacionIlegalGenerator")
    @SequenceGenerator(name = "ActivoOcupacionIlegalGenerator", sequenceName = "S_OKU_DEMANDA_OCUPACION_ILEGAL")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "ACT_ID")
	private Activo activo;

	@Column(name = "OKU_NUM_ASUNTO")
	private String numAsunto;
	
	@Column(name = "OKU_FECHA_INICIO_ASUNTO")
	private Date fechaInicioAsunto;
	
	@Column(name = "OKU_FECHA_FIN_ASUNTO")
	private Date fechaFinAsunto;
	
	@Column(name = "OKU_FECHA_LANZAMIENTO")
	private Date fechaLanzamiento;

	@ManyToOne
    @JoinColumn(name = "DD_TAO_ID")
	private TipoAsuntoOcupacionIlegal tipoAsunto;
	
	@ManyToOne
    @JoinColumn(name = "DD_TCO_ID")
	private TipoActuacionOcupacionIlegal tipoActuacion;

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

	public String getNumAsunto() {
		return numAsunto;
	}

	public void setNumAsunto(String numAsunto) {
		this.numAsunto = numAsunto;
	}

	public Date getFechaInicioAsunto() {
		return fechaInicioAsunto;
	}

	public void setFechaInicioAsunto(Date fechaInicioAsunto) {
		this.fechaInicioAsunto = fechaInicioAsunto;
	}

	public Date getFechaFinAsunto() {
		return fechaFinAsunto;
	}

	public void setFechaFinAsunto(Date fechaFinAsunto) {
		this.fechaFinAsunto = fechaFinAsunto;
	}

	public Date getFechaLanzamiento() {
		return fechaLanzamiento;
	}

	public void setFechaLanzamiento(Date fechaLanzamiento) {
		this.fechaLanzamiento = fechaLanzamiento;
	}

	public TipoAsuntoOcupacionIlegal getTipoAsunto() {
		return tipoAsunto;
	}

	public void setTipoAsunto(TipoAsuntoOcupacionIlegal tipoAsunto) {
		this.tipoAsunto = tipoAsunto;
	}

	public TipoActuacionOcupacionIlegal getTipoActuacion() {
		return tipoActuacion;
	}

	public void setTipoActuacion(TipoActuacionOcupacionIlegal tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
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
