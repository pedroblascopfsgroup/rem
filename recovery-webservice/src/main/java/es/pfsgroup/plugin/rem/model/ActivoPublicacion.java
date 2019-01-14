package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.*;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * Modelo que gestiona los distintos estados de publicación por los que pasa el activo.
 */
@Entity
@Table(name = "ACT_APU_ACTIVO_PUBLICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoPublicacion implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "APU_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPublicacionGenerator")
	@SequenceGenerator(name = "ActivoPublicacionGenerator", sequenceName = "S_ACT_APU_ACTIVO_PUBLICACION")
	private Long id;

	@OneToOne
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@ManyToOne
	@JoinColumn(name = "DD_TPU_ID")
	private DDTipoPublicacion tipoPublicacion;

	@ManyToOne
	@JoinColumn(name = "DD_TPU_V_ID")
	private DDTipoPublicacion tipoPublicacionVenta;

	@ManyToOne
	@JoinColumn(name = "DD_TPU_A_ID")
	private DDTipoPublicacion tipoPublicacionAlquiler;

	@ManyToOne
	@JoinColumn(name = "DD_EPV_ID")
	private DDEstadoPublicacionVenta estadoPublicacionVenta;

	@ManyToOne
	@JoinColumn(name = "DD_EPA_ID")
	private DDEstadoPublicacionAlquiler estadoPublicacionAlquiler;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TCO_ID")
	private DDTipoComercializacion tipoComercializacion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MTO_V_ID")
	private DDMotivosOcultacion motivoOcultacionVenta;

	@Column(name = "APU_MOT_OCULTACION_MANUAL_V")
	private String motivoOcultacionManualVenta;

	@Column(name = "APU_CHECK_PUBLICAR_V")
	private Boolean checkPublicarVenta;

	@Column(name = "APU_CHECK_OCULTAR_V")
	private Boolean checkOcultarVenta;

	@Column(name = "APU_CHECK_OCULTAR_PRECIO_V")
	private Boolean checkOcultarPrecioVenta;

	@Column(name = "APU_CHECK_PUB_SIN_PRECIO_V")
	private Boolean checkSinPrecioVenta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MTO_A_ID")
	private DDMotivosOcultacion motivoOcultacionAlquiler;

	@Column(name = "APU_MOT_OCULTACION_MANUAL_A")
	private String motivoOcultacionManualAlquiler;

	@Column(name = "APU_CHECK_PUBLICAR_A")
	private Boolean checkPublicarAlquiler;

	@Column(name = "APU_CHECK_OCULTAR_A")
	private Boolean checkOcultarAlquiler;

	@Column(name = "APU_CHECK_OCULTAR_PRECIO_A")
	private Boolean checkOcultarPrecioAlquiler;

	@Column(name = "APU_CHECK_PUB_SIN_PRECIO_A")
	private Boolean checkSinPrecioAlquiler;

	@Column(name = "APU_FECHA_INI_VENTA")
	private Date fechaInicioVenta;

	@Column(name = "APU_FECHA_INI_ALQUILER")
	private Date fechaInicioAlquiler;
	
	@Column(name = "APU_MOTIVO_PUBLICACION")
	private String motivoPublicacion;

	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Date getFechaInicioVenta() {
		return fechaInicioVenta;
	}

	public void setFechaInicioVenta(Date fechaInicioVenta) {
		this.fechaInicioVenta = fechaInicioVenta;
	}

	public Date getFechaInicioAlquiler() {
		return fechaInicioAlquiler;
	}

	public void setFechaInicioAlquiler(Date fechaInicioAlquiler) {
		this.fechaInicioAlquiler = fechaInicioAlquiler;
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

	public DDTipoPublicacion getTipoPublicacion() {
		return tipoPublicacion;
	}

	public void setTipoPublicacion(DDTipoPublicacion tipoPublicacion) {
		this.tipoPublicacion = tipoPublicacion;
	}

	public DDTipoPublicacion getTipoPublicacionVenta() {
		return tipoPublicacionVenta;
	}

	public void setTipoPublicacionVenta(DDTipoPublicacion tipoPublicacionVenta) {
		this.tipoPublicacionVenta = tipoPublicacionVenta;
	}

	public DDTipoPublicacion getTipoPublicacionAlquiler() {
		return tipoPublicacionAlquiler;
	}

	public void setTipoPublicacionAlquiler(DDTipoPublicacion tipoPublicacionAlquiler) {
		this.tipoPublicacionAlquiler = tipoPublicacionAlquiler;
	}

	public DDMotivosOcultacion getMotivoOcultacionVenta() {
		return motivoOcultacionVenta;
	}

	public void setMotivoOcultacionVenta(DDMotivosOcultacion motivoOcultacionVenta) {
		this.motivoOcultacionVenta = motivoOcultacionVenta;
	}

	public String getMotivoOcultacionManualVenta() {
		return motivoOcultacionManualVenta;
	}

	public void setMotivoOcultacionManualVenta(String motivoOcultacionManualVenta) {
		this.motivoOcultacionManualVenta = motivoOcultacionManualVenta;
	}

	public Boolean getCheckPublicarVenta() {
		return checkPublicarVenta;
	}

	public void setCheckPublicarVenta(Boolean checkPublicarVenta) {
		this.checkPublicarVenta = checkPublicarVenta;
	}

	public Boolean getCheckOcultarVenta() {
		return checkOcultarVenta;
	}

	public void setCheckOcultarVenta(Boolean checkOcultarVenta) {
		this.checkOcultarVenta = checkOcultarVenta;
	}

	public Boolean getCheckOcultarPrecioVenta() {
		return checkOcultarPrecioVenta;
	}

	public void setCheckOcultarPrecioVenta(Boolean checkOcultarPrecioVenta) {
		this.checkOcultarPrecioVenta = checkOcultarPrecioVenta;
	}

	public Boolean getCheckSinPrecioVenta() {
		return checkSinPrecioVenta;
	}

	public void setCheckSinPrecioVenta(Boolean checkSinPrecioVenta) {
		this.checkSinPrecioVenta = checkSinPrecioVenta;
	}

	public DDMotivosOcultacion getMotivoOcultacionAlquiler() {
		return motivoOcultacionAlquiler;
	}

	public void setMotivoOcultacionAlquiler(DDMotivosOcultacion motivoOcultacionAlquiler) {
		this.motivoOcultacionAlquiler = motivoOcultacionAlquiler;
	}

	public String getMotivoOcultacionManualAlquiler() {
		return motivoOcultacionManualAlquiler;
	}

	public void setMotivoOcultacionManualAlquiler(String motivoOcultacionManualAlquiler) {
		this.motivoOcultacionManualAlquiler = motivoOcultacionManualAlquiler;
	}

	public Boolean getCheckPublicarAlquiler() {
		return checkPublicarAlquiler;
	}

	public void setCheckPublicarAlquiler(Boolean checkPublicarAlquiler) {
		this.checkPublicarAlquiler = checkPublicarAlquiler;
	}

	public Boolean getCheckOcultarAlquiler() {
		return checkOcultarAlquiler;
	}

	public void setCheckOcultarAlquiler(Boolean checkOcultarAlquiler) {
		this.checkOcultarAlquiler = checkOcultarAlquiler;
	}

	public Boolean getCheckOcultarPrecioAlquiler() {
		return checkOcultarPrecioAlquiler;
	}

	public void setCheckOcultarPrecioAlquiler(Boolean checkOcultarPrecioAlquiler) {
		this.checkOcultarPrecioAlquiler = checkOcultarPrecioAlquiler;
	}

	public Boolean getCheckSinPrecioAlquiler() {
		return checkSinPrecioAlquiler;
	}

	public void setCheckSinPrecioAlquiler(Boolean checkSinPrecioAlquiler) {
		this.checkSinPrecioAlquiler = checkSinPrecioAlquiler;
	}

	public DDEstadoPublicacionVenta getEstadoPublicacionVenta() {
		return estadoPublicacionVenta;
	}

	public void setEstadoPublicacionVenta(DDEstadoPublicacionVenta estadoPublicacionVenta) {
		this.estadoPublicacionVenta = estadoPublicacionVenta;
	}

	public DDEstadoPublicacionAlquiler getEstadoPublicacionAlquiler() {
		return estadoPublicacionAlquiler;
	}

	public void setEstadoPublicacionAlquiler(DDEstadoPublicacionAlquiler estadoPublicacionAlquiler) {
		this.estadoPublicacionAlquiler = estadoPublicacionAlquiler;
	}

	public DDTipoComercializacion getTipoComercializacion() {
		return tipoComercializacion;
	}

	public void setTipoComercializacion(DDTipoComercializacion tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
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

	public String getMotivoPublicacion() {
		return motivoPublicacion;
	}

	public void setMotivoPublicacion(String motivoPublicacion) {
		this.motivoPublicacion = motivoPublicacion;
	}

}
