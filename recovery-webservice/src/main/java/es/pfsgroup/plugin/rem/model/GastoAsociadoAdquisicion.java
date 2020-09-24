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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGastoAsociado;
/**
 * Modelo que gestiona los gastos asociados a la adquisicion
 *  
 * @author Carlos Augusto
 *
 */

@Entity
@Table(name = "GAA_GASTO_ASOCIADO_ADQ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class GastoAsociadoAdquisicion implements Serializable, Auditable{
	
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "GAA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoAsociadoAdquisicionGenerator")
    @SequenceGenerator(name = "GastoAsociadoAdquisicionGenerator", sequenceName = "S_GAA_GASTO_ASOCIADO_ADQ")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_TGA_TPO_ID")
	private DDTipoGastoAsociado gastoAsociado;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="GAA_GESTOR_ALTA")
	private Usuario usuarioGestordeAlta;
	
	@Column(name="GAA_FECHA_ALTA")
	private Date fechaAltaGastoAsociado;
	
	
	@Column(name="GAA_FECHA_SOLICITUD")
	private Date fechaSolicitudGastoAsociado;
	
	@Column(name="GAA_FECHA_PAGO")
	private Date fechaPagoGastoAsociado;
		
	@Column(name = "GAA_IMPORTE")
	private Double importe;
	
	@Column(name = "GAA_NUM_GASTO_ASOCIADO")
	private Long numGastoAsociado;
	
	@Column(name = "GAA_OBSERVACIONES")
	private String observaciones;

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

	public DDTipoGastoAsociado getGastoAsociado() {
		return gastoAsociado;
	}

	public void setGastoAsociado(DDTipoGastoAsociado gastoAsociado) {
		this.gastoAsociado = gastoAsociado;
	}

	public Usuario getUsuarioGestordeAlta() {
		return usuarioGestordeAlta;
	}

	public void setUsuarioGestordeAlta(Usuario usuarioGestordeAlta) {
		this.usuarioGestordeAlta = usuarioGestordeAlta;
	}

	public Date getFechaAltaGastoAsociado() {
		return fechaAltaGastoAsociado;
	}

	public void setFechaAltaGastoAsociado(Date fechaAltaGastoAsociado) {
		this.fechaAltaGastoAsociado = fechaAltaGastoAsociado;
	}

	public Date getFechaSolicitudGastoAsociado() {
		return fechaSolicitudGastoAsociado;
	}

	public void setFechaSolicitudGastoAsociado(Date fechaSolicitudGastoAsociado) {
		this.fechaSolicitudGastoAsociado = fechaSolicitudGastoAsociado;
	}

	public Date getFechaPagoGastoAsociado() {
		return fechaPagoGastoAsociado;
	}

	public void setFechaPagoGastoAsociado(Date fechaPagoGastoAsociado) {
		this.fechaPagoGastoAsociado = fechaPagoGastoAsociado;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}


	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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

	public Long getNumGastoAsociado() {
		return numGastoAsociado;
	}

	public void setNumGastoAsociado(Long numGastoAsociado) {
		this.numGastoAsociado = numGastoAsociado;
	}
	
}
