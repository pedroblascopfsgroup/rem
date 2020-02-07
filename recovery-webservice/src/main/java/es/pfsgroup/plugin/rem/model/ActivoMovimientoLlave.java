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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;


/**
 * Modelo que gestiona la informacion de los movimientos de las llaves
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_MLV_MOVIMIENTO_LLAVE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ActivoMovimientoLlave implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "MLV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoMovimientoLlaveGenerator")
    @SequenceGenerator(name = "ActivoMovimientoLlaveGenerator", sequenceName = "S_ACT_MLV_MOVIMIENTO_LLAVE")
    private Long id;

	@ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "LLV_ID")
	private ActivoLlave activoLlave;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TTE_ID")
	private DDTipoTenedor tipoTenedor;

	@Column(name = "MLV_COD_TENEDOR")
	private String codTenedor;

	@Column(name = "MLV_NOM_TENEDOR")
	private String nomTenedor;

	@Column(name = "MLV_FECHA_ENTREGA")
	private Date fechaEntrega;

	@Column(name = "MLV_FECHA_DEVOLUCION")
	private Date fechaDevolucion;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTE_ID_POSEEDOR")
	private DDTipoTenedor tipoTenedorPoseedor;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MLV_COD_TENEDOR_POSEEDOR")
	private ActivoProveedor poseedor;
	
	@Column(name = "MLV_COD_TENEDOR_POS_NO_PVE")
	private String codNoPoseedor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTE_ID_PEDIDOR")
	private DDTipoTenedor tipoTenedorPedidor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MLV_COD_TENEDOR_PEDIDOR")
	private ActivoProveedor pedidor;

	@Column(name = "MLV_COD_TENEDOR_PED_NO_PVE")
	private String codNoPedidor;
	
	@Column(name = "MLV_ENVIO")
	private String envio;
	
	@Column(name ="MLV_FECHA_RECEPCION")
	private Date fechaRecepcion;
	
	@Column(name ="MLV_OBSERVACIONES")
	private String observaciones;
	
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MLV_ESTADO")
	private DDTipoEstado tipoEstado;
	
	@Column(name ="MLV_FECHA_ENVIO")
	private Date fechaEnvio;
	
	
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ActivoLlave getActivoLlave() {
		return activoLlave;
	}

	public void setActivoLlave(ActivoLlave activoLlave) {
		this.activoLlave = activoLlave;
	}

	public DDTipoTenedor getTipoTenedor() {
		return tipoTenedor;
	}

	public void setTipoTenedor(DDTipoTenedor tipoTenedor) {
		this.tipoTenedor = tipoTenedor;
	}

	public String getCodTenedor() {
		return codTenedor;
	}

	public void setCodTenedor(String codTenedor) {
		this.codTenedor = codTenedor;
	}

	public String getNomTenedor() {
		return nomTenedor;
	}

	public void setNomTenedor(String nomTenedor) {
		this.nomTenedor = nomTenedor;
	}

	public Date getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}

	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}

	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
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

	public DDTipoTenedor getTipoTenedorPoseedor() {
		return tipoTenedorPoseedor;
	}

	public void setTipoTenedorPoseedor(DDTipoTenedor tipoTenedorPoseedor) {
		this.tipoTenedorPoseedor = tipoTenedorPoseedor;
	}

	public ActivoProveedor getPoseedor() {
		return poseedor;
	}

	public void setPoseedor(ActivoProveedor poseedor) {
		this.poseedor = poseedor;
	}

	public String getCodNoPoseedor() {
		return codNoPoseedor;
	}

	public void setCodNoPoseedor(String codNoPoseedor) {
		this.codNoPoseedor = codNoPoseedor;
	}

	public DDTipoTenedor getTipoTenedorPedidor() {
		return tipoTenedorPedidor;
	}

	public void setTipoTenedorPedidor(DDTipoTenedor tipoTenedorPedidor) {
		this.tipoTenedorPedidor = tipoTenedorPedidor;
	}

	public ActivoProveedor getPedidor() {
		return pedidor;
	}

	public void setPedidor(ActivoProveedor pedidor) {
		this.pedidor = pedidor;
	}

	public String getCodNoPedidor() {
		return codNoPedidor;
	}

	public void setCodNoPedidor(String codNoPedidor) {
		this.codNoPedidor = codNoPedidor;
	}

	public String getEnvio() {
		return envio;
	}

	public void setEnvio(String envio) {
		this.envio = envio;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public DDTipoEstado getTipoEstado() {
		return tipoEstado;
	}

	public void setTipoEstado(DDTipoEstado tipoEstado) {
		this.tipoEstado = tipoEstado;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	

}
