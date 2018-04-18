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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosOcultacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;

/**
 * Modelo que gestiona el histórico de los distintos estados de publicación por los que ha pasado el activo.
 */
@Entity
@Table(name = "ACT_AHP_HIST_PUBLICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoPublicacionHistorico implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "AHP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPublicacionHistoricoGenerator")
	@SequenceGenerator(name = "ActivoPublicacionHistoricoGenerator", sequenceName = "S_ACT_AHP_HIST_PUBLICACION")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPU_ID")
	private DDTipoPublicacion tipoPublicacion;

	@ManyToOne
	@JoinColumn(name = "DD_TPU_V_ID")
	private DDTipoPublicacion tipoPublicacionVenta;

	@ManyToOne
	@JoinColumn(name = "DD_TPU_A_ID")
	private DDTipoPublicacion tipoPublicacionAlquiler;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EPV_ID")
	private DDEstadoPublicacionVenta estadoPublicacionVenta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EPA_ID")
	private DDEstadoPublicacionAlquiler estadoPublicacionAlquiler;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TCO_ID")
	private DDTipoComercializacion tipoComercializacion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MTO_V_ID")
	private DDMotivosOcultacion motivoOcultacionVenta;

	@Column(name = "AHP_MOT_OCULTACION_MANUAL_V")
	private String motivoOcultacionManualVenta;

	@Column(name = "AHP_CHECK_PUBLICAR_V")
	private Boolean checkPublicarVenta;

	@Column(name = "AHP_CHECK_OCULTAR_V")
	private Boolean checkOcultarVenta;

	@Column(name = "AHP_CHECK_OCULTAR_PRECIO_V")
	private Boolean checkOcultarPrecioVenta;

	@Column(name = "AHP_CHECK_PUB_SIN_PRECIO_V")
	private Boolean checkSinPrecioVenta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MTO_A_ID")
	private DDMotivosOcultacion motivoOcultacionAlquiler;

	@Column(name = "AHP_MOT_OCULTACION_MANUAL_A")
	private String motivoOcultacionManualAlquiler;

	@Column(name = "AHP_CHECK_PUBLICAR_A")
	private Boolean checkPublicarAlquiler;

	@Column(name = "AHP_CHECK_OCULTAR_A")
	private Boolean checkOcultarAlquiler;

	@Column(name = "AHP_CHECK_OCULTAR_PRECIO_A")
	private Boolean checkOcultarPrecioAlquiler;

	@Column(name = "AHP_CHECK_PUB_SIN_PRECIO_A")
	private Boolean checkSinPrecioAlquiler;

	@Column(name = "AHP_FECHA_INI_VENTA")
	private Date fechaInicioVenta;

	@Column(name = "AHP_FECHA_FIN_VENTA")
	private Date fechaFinVenta;

	@Column(name = "AHP_FECHA_INI_ALQUILER")
	private Date fechaInicioAlquiler;

	@Column(name = "AHP_FECHA_FIN_ALQUILER")
	private Date fechaFinAlquiler;

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

	public Date getFechaInicioVenta() {
		return fechaInicioVenta;
	}

	public void setFechaInicioVenta(Date fechaInicioVenta) {
		this.fechaInicioVenta = fechaInicioVenta;
	}

	public Date getFechaFinVenta() {
		return fechaFinVenta;
	}

	public void setFechaFinVenta(Date fechaFinVenta) {
		this.fechaFinVenta = fechaFinVenta;
	}

	public Date getFechaInicioAlquiler() {
		return fechaInicioAlquiler;
	}

	public void setFechaInicioAlquiler(Date fechaInicioAlquiler) {
		this.fechaInicioAlquiler = fechaInicioAlquiler;
	}

	public Date getFechaFinAlquiler() {
		return fechaFinAlquiler;
	}

	public void setFechaFinAlquiler(Date fechaFinAlquiler) {
		this.fechaFinAlquiler = fechaFinAlquiler;
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
