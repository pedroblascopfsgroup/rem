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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;



/**
 * Modelo que gestiona las valoraciones de los activos
 * 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_VAL_VALORACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoValoraciones implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "VAL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoValoracionGenerator")
    @SequenceGenerator(name = "ActivoValoracionGenerator", sequenceName = "S_ACT_VAL_VALORACIONES")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID")
    private DDTipoPrecio tipoPrecio;
	
	@Column(name = "VAL_IMPORTE")
	private Double importe;
		
	@Column(name = "VAL_FECHA_INICIO")
	private Date fechaInicio;
	
	@Column(name = "VAL_FECHA_FIN")
	private Date fechaFin;	
	
	@Column(name = "VAL_FECHA_APROBACION")
	private Date fechaAprobacion;
	
	@Column(name = "VAL_FECHA_CARGA")
	private Date fechaCarga;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "USU_ID")
	private Usuario gestor;
	
	@Column(name = "VAL_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "VAL_FECHA_VENTA")
	private Date fechaVentaHaya;
	
	@Column(name = "VAL_LIQUIDEZ")
	private String liquidez;
	
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

	public DDTipoPrecio getTipoPrecio() {
		return tipoPrecio;
	}

	public void setTipoPrecio(DDTipoPrecio tipoPrecio) {
		this.tipoPrecio = tipoPrecio;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
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

	public Date getFechaAprobacion() {
		return fechaAprobacion;
	}

	public void setFechaAprobacion(Date fechaAprobacion) {
		this.fechaAprobacion = fechaAprobacion;
	}

	public Date getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public Usuario getGestor() {
		return gestor;
	}

	public void setGestor(Usuario gestor) {
		this.gestor = gestor;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Date getFechaVentaHaya() {
		return fechaVentaHaya;
	}

	public void setFechaVentaHaya(Date fechaVentaHaya) {
		this.fechaVentaHaya = fechaVentaHaya;
	}

	public String getLiquidez() {
		return liquidez;
	}

	public void setLiquidez(String liquidez) {
		this.liquidez = liquidez;
	}

}
