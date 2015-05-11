package es.pfsgroup.recovery.recobroCommon.esquema.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.core.model.RecobroAdjuntos;

/**
 * Clase que representa la relación entre el esquema y el resultado de la
 * simulación
 * 
 * @author Carlos
 * 
 */
@Entity
@Table(name = "RCF_ESS_ESQUEMA_SIMULACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class RecobroSimulacionEsquema implements Auditable, Serializable {

	private static final long serialVersionUID = -1934773194960249533L;
	public static final String COD_FICHERO_RESUMEN = "RES";
	public static final String COD_FICHERO_DETALLE = "DET";

	@Id
	@Column(name = "RCF_ESS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SimulacionEsquemaGenerator")
	@SequenceGenerator(name = "SimulacionEsquemaGenerator", sequenceName = "S_RCF_ESS_ESQUEMA_SIMULACION")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "RCF_ESQ_ID", nullable = false)
	private RecobroEsquema esquema;

	@ManyToOne
	@JoinColumn(name = "RCF_DD_ESI_ID", nullable = true)
	private RecobroDDEstadoSimulacion estado;

	@Column(name = "RCF_ESS_FECHA_PETICION")
	private Date fechaPeticion;

	@Column(name = "RCF_ESS_FECHA_RESULTADO")
	private Date fechaResultado;

	@OneToOne
	@JoinColumn(name = "REA_ID_RESUMEN", referencedColumnName= "REA_ID")
	private RecobroAdjuntos fichResumen;

	@OneToOne
	@JoinColumn(name = "REA_ID_DETALLE", referencedColumnName= "REA_ID")
	private RecobroAdjuntos fichDetalle;

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

	public RecobroEsquema getEsquema() {
		return esquema;
	}

	public void setEsquema(RecobroEsquema esquema) {
		this.esquema = esquema;
	}

	public RecobroDDEstadoSimulacion getEstado() {
		return estado;
	}

	public void setEstado(RecobroDDEstadoSimulacion estado) {
		this.estado = estado;
	}

	public Date getFechaPeticion() {
		return fechaPeticion;
	}

	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}

	public Date getFechaResultado() {
		return fechaResultado;
	}

	public void setFechaResultado(Date fechaResultado) {
		this.fechaResultado = fechaResultado;
	}

	public RecobroAdjuntos getFichResumen() {
		return fichResumen;
	}

	public void setFichResumen(RecobroAdjuntos fichResumen) {
		this.fichResumen = fichResumen;
	}

	public RecobroAdjuntos getFichDetalle() {
		return fichDetalle;
	}

	public void setFichDetalle(RecobroAdjuntos fichDetalle) {
		this.fichDetalle = fichDetalle;
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
