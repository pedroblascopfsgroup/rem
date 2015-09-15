package es.pfsgroup.plugin.recovery.mejoras.procedimiento.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "CDP_CONF_DERIV_PRC", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MEJConfiguracionDerivacionProcedimiento implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 3246294354648919436L;

	@Id
    @Column(name = "CDP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionDerivacionGenerator")
    @SequenceGenerator(name = "ConfiguracionDerivacionGenerator", sequenceName = "S_CDP_CONF_DERIV_PRC")
    private Long id;
	
	@Column(name="TPO_COD_ORIGEN")
	private String tipoProcedimientoOrigen;
	
	@Column(name="TPO_COD_DESTINO")
	private String tipoProcedimientoDestino;
	
	@Column(name="CDP_JUZGADO")
	private Boolean juzgado;
	
	@Column(name="CDP_NUM_AUTOS")
	private Boolean codigoProcedimientoEnJuzgado;
	
	@Column(name="CDP_OBSERVACIONES")
	private Boolean observacionesRecopilacion;
	
	@Column(name="CDP_PLAZO_RECUP")
	private Boolean plazoRecuperacion;
	
	@Column(name="CDP_TIPO_ACTUAC")
	private Boolean tipoActuacion;
	
	@Column(name="CDP_PORCENTAJE_RECUP")
	private Boolean porcentajeRecuperacion;
	
	@Column(name="CDP_SALDO_ORG_NVENC")
	private Boolean saldoOriginalNoVencido;
	
	@Column(name="CDP_SALDO_ORG_VENC")
	private Boolean saldoOriginalVencido;
	
	@Column(name="CDP_SALDO_RECUP")
	private Boolean saldoRecuperacion;
	
	@Column(name="CDP_TIPO_RECL")
	private Boolean tipoReclamacion;
	
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

	public String getTipoProcedimientoOrigen() {
		return tipoProcedimientoOrigen;
	}

	public void setTipoProcedimientoOrigen(String tipoProcedimientoOrigen) {
		this.tipoProcedimientoOrigen = tipoProcedimientoOrigen;
	}

	public String getTipoProcedimientoDestino() {
		return tipoProcedimientoDestino;
	}

	public void setTipoProcedimientoDestino(String tipoProcedimientoDestino) {
		this.tipoProcedimientoDestino = tipoProcedimientoDestino;
	}

	public Boolean getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(Boolean juzgado) {
		this.juzgado = juzgado;
	}

	public Boolean getCodigoProcedimientoEnJuzgado() {
		return codigoProcedimientoEnJuzgado;
	}

	public void setCodigoProcedimientoEnJuzgado(Boolean codigoProcedimientoEnJuzgado) {
		this.codigoProcedimientoEnJuzgado = codigoProcedimientoEnJuzgado;
	}

	public Boolean getObservacionesRecopilacion() {
		return observacionesRecopilacion;
	}

	public void setObservacionesRecopilacion(Boolean observacionesRecopilacion) {
		this.observacionesRecopilacion = observacionesRecopilacion;
	}

	public Boolean getPlazoRecuperacion() {
		return plazoRecuperacion;
	}

	public void setPlazoRecuperacion(Boolean plazoRecuperacion) {
		this.plazoRecuperacion = plazoRecuperacion;
	}

	public Boolean getTipoActuacion() {
		return tipoActuacion;
	}

	public void setTipoActuacion(Boolean tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	public Boolean getPorcentajeRecuperacion() {
		return porcentajeRecuperacion;
	}

	public void setPorcentajeRecuperacion(Boolean porcentajeRecuperacion) {
		this.porcentajeRecuperacion = porcentajeRecuperacion;
	}

	public Boolean getSaldoOriginalNoVencido() {
		return saldoOriginalNoVencido;
	}

	public void setSaldoOriginalNoVencido(Boolean saldoOriginalNoVencido) {
		this.saldoOriginalNoVencido = saldoOriginalNoVencido;
	}

	public Boolean getSaldoOriginalVencido() {
		return saldoOriginalVencido;
	}

	public void setSaldoOriginalVencido(Boolean saldoOriginalVencido) {
		this.saldoOriginalVencido = saldoOriginalVencido;
	}

	public Boolean getSaldoRecuperacion() {
		return saldoRecuperacion;
	}

	public void setSaldoRecuperacion(Boolean saldoRecuperacion) {
		this.saldoRecuperacion = saldoRecuperacion;
	}

	public Boolean getTipoReclamacion() {
		return tipoReclamacion;
	}

	public void setTipoReclamacion(Boolean tipoReclamacion) {
		this.tipoReclamacion = tipoReclamacion;
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
