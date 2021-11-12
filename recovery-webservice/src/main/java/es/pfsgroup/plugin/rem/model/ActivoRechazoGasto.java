package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.model.dd.DDEscaleraEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComercialAlquilerCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComercialVentaCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTecnicoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDListadoErrores;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoNecesidadArras;
import es.pfsgroup.plugin.rem.model.dd.DDPlantaEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicacion;

@Entity
@Table(name = "ACT_RGS_RECHAZOS_GASTOS_SAPBC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoRechazoGasto implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "RGS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoRechazoGastosGenerator")
    @SequenceGenerator(name = "ActivoRechazoGastosGenerator", sequenceName = "S_ACT_RGS_RECHAZOS_GASTOS_SAPBC")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
	private GastoProveedor gasto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LES_ID")
    private DDListadoErrores errores;
	
	@Column(name = "MENSAJE_ERROR")
	private String mensajeError;
	
	@Column(name = "FECHA_PROCESADO")
    private Date fechaProcesado;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
	private GastoLineaDetalle gastoLineaDetalle;
	
	@Column(name = "TIPO_IMPORTE")
	private String tipoImporte;
			
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

	public GastoProveedor getGasto() {
		return gasto;
	}

	public void setGasto(GastoProveedor gasto) {
		this.gasto = gasto;
	}

	public String getMensajeError() {
		return mensajeError;
	}

	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}

	public Date getFechaProcesado() {
		return fechaProcesado;
	}

	public void setFechaProcesado(Date fechaProcesado) {
		this.fechaProcesado = fechaProcesado;
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

	public DDListadoErrores getErrores() {
		return errores;
	}

	public void setErrores(DDListadoErrores errores) {
		this.errores = errores;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public GastoLineaDetalle getGastoLineaDetalle() {
		return gastoLineaDetalle;
	}

	public void setGastoLineaDetalle(GastoLineaDetalle gastoLineaDetalle) {
		this.gastoLineaDetalle = gastoLineaDetalle;
	}

	public String getTipoImporte() {
		return tipoImporte;
	}

	public void setTipoImporte(String tipoImporte) {
		this.tipoImporte = tipoImporte;
	}

	
}
