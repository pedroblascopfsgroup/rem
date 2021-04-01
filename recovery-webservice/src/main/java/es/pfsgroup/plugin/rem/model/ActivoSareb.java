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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdecucionSareb;
import es.pfsgroup.plugin.rem.model.dd.DDSegmentoSareb;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCorrectivoSareb;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCuotaComunidad;

/**
 * @author javier.urban@pfsgroup.local
 *
 */
@Entity
@Table(name = "ACT_SAREB_ACTIVOS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoSareb implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "ASA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoSarebGenerator")
    @SequenceGenerator(name = "ActivoSarebGenerator", sequenceName = "S_ACT_SAREB_ACTIVOS")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "REO_CONTABILIZADO")
    private DDSinSiNo reoContabilizado;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoActivo tipoActivoOE;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo subtipoActivoOE;
    
	@OneToOne
	@JoinColumn(name = "DD_TVI_ID")
	private DDTipoVia tipoViaOE;
    
	@Column(name = "ASA_NOMBRE_VIA")
	private String nombreViaOE;
	
	@Column(name = "ASA_NUMERO_DOMICILIO")
	private String numeroDomicilioOE;
	
	@Column(name = "ASA_ESCALERA")
	private String escaleraOE;

	@Column(name = "ASA_PISO")
	private String pisoOE;

	@Column(name = "ASA_PUERTA")
	private String puertaOE;
	
	@OneToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provinciaOE;
	
	@OneToOne
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidadOE;
	
	@Column(name = "ASA_COD_POST")
    private String codPostalOE;
   
	@Column(name = "ASA_LATITUD")
	private BigDecimal latitudOE;
	
	@Column(name = "ASA_LONGITUD")
	private BigDecimal longitudOE;
	
	@OneToOne
	@JoinColumn(name = "DD_EAS_ID")
	private DDEstadoAdecucionSareb estadoAdecuacionSareb;
	
    @Column(name = "FECHA_PREV_ADECUACION")
    private Date fechaFinPrevistaAdecuacion;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	@Column(name = "IMP_COM_MENSUAL")
	private Double importeComunidadMensualSareb;
	
	@OneToOne
    @JoinColumn(name = "SINIESTRO")
    private DDSinSiNo siniestroSareb;
	
	@OneToOne
    @JoinColumn(name = "DD_TCS_ID")
	private DDTipoCorrectivoSareb tipoCorrectivoSareb;
	
	@Column(name = "FEC_FIN_CORRECTIVO")
    private Date fechaFinCorrectivoSareb;
	
	@OneToOne
    @JoinColumn(name = "DD_TCC_ID")
	private DDTipoCuotaComunidad tipoCuotaComunidad;
	
	@OneToOne
    @JoinColumn(name = "GGAA")
    private DDSinSiNo ggaaSareb;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SEGMENTO_SAREB")
	private DDSegmentoSareb segmentoSareb;

	

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

	public DDSinSiNo getReoContabilizado() {
		return reoContabilizado;
	}

	public void setReoContabilizado(DDSinSiNo reoContabilizado) {
		this.reoContabilizado = reoContabilizado;
	}

	public DDTipoActivo getTipoActivoOE() {
		return tipoActivoOE;
	}

	public void setTipoActivoOE(DDTipoActivo tipoActivoOE) {
		this.tipoActivoOE = tipoActivoOE;
	}

	public DDSubtipoActivo getSubtipoActivoOE() {
		return subtipoActivoOE;
	}

	public void setSubtipoActivoOE(DDSubtipoActivo subtipoActivoOE) {
		this.subtipoActivoOE = subtipoActivoOE;
	}

	public DDTipoVia getTipoViaOE() {
		return tipoViaOE;
	}

	public void setTipoViaOE(DDTipoVia tipoViaOE) {
		this.tipoViaOE = tipoViaOE;
	}

	public String getNombreViaOE() {
		return nombreViaOE;
	}

	public void setNombreViaOE(String nombreViaOE) {
		this.nombreViaOE = nombreViaOE;
	}

	public String getNumeroDomicilioOE() {
		return numeroDomicilioOE;
	}

	public void setNumeroDomicilioOE(String numeroDomicilioOE) {
		this.numeroDomicilioOE = numeroDomicilioOE;
	}

	public String getEscaleraOE() {
		return escaleraOE;
	}

	public void setEscaleraOE(String escaleraOE) {
		this.escaleraOE = escaleraOE;
	}

	public String getPisoOE() {
		return pisoOE;
	}

	public void setPisoOE(String pisoOE) {
		this.pisoOE = pisoOE;
	}

	public String getPuertaOE() {
		return puertaOE;
	}

	public void setPuertaOE(String puertaOE) {
		this.puertaOE = puertaOE;
	}

	public DDProvincia getProvinciaOE() {
		return provinciaOE;
	}

	public void setProvinciaOE(DDProvincia provinciaOE) {
		this.provinciaOE = provinciaOE;
	}

	public Localidad getLocalidadOE() {
		return localidadOE;
	}

	public void setLocalidadOE(Localidad localidadOE) {
		this.localidadOE = localidadOE;
	}

	public String getCodPostalOE() {
		return codPostalOE;
	}

	public void setCodPostalOE(String codPostalOE) {
		this.codPostalOE = codPostalOE;
	}

	public BigDecimal getLatitudOE() {
		return latitudOE;
	}

	public void setLatitudOE(BigDecimal latitudOE) {
		this.latitudOE = latitudOE;
	}

	public BigDecimal getLongitudOE() {
		return longitudOE;
	}

	public void setLongitudOE(BigDecimal longitudOE) {
		this.longitudOE = longitudOE;
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

	public DDEstadoAdecucionSareb getEstadoAdecuacionSareb() {
		return estadoAdecuacionSareb;
	}

	public void setEstadoAdecuacionSareb(DDEstadoAdecucionSareb estadoAdecuacionSareb) {
		this.estadoAdecuacionSareb = estadoAdecuacionSareb;
	}

	public Date getFechaFinPrevistaAdecuacion() {
		return fechaFinPrevistaAdecuacion;
	}

	public void setFechaFinPrevistaAdecuacion(Date fechaFinPrevistaAdecuacion) {
		this.fechaFinPrevistaAdecuacion = fechaFinPrevistaAdecuacion;
	}

	public Double getImporteComunidadMensualSareb() {
		return importeComunidadMensualSareb;
	}

	public void setImporteComunidadMensualSareb(Double importeComunidadMensualSareb) {
		this.importeComunidadMensualSareb = importeComunidadMensualSareb;
	}

	public DDSinSiNo getSiniestroSareb() {
		return siniestroSareb;
	}

	public void setSiniestroSareb(DDSinSiNo siniestroSareb) {
		this.siniestroSareb = siniestroSareb;
	}

	public DDTipoCorrectivoSareb getTipoCorrectivoSareb() {
		return tipoCorrectivoSareb;
	}

	public void setTipoCorrectivoSareb(DDTipoCorrectivoSareb tipoCorrectivoSareb) {
		this.tipoCorrectivoSareb = tipoCorrectivoSareb;
	}

	public Date getFechaFinCorrectivoSareb() {
		return fechaFinCorrectivoSareb;
	}

	public void setFechaFinCorrectivoSareb(Date fechaFinCorrectivoSareb) {
		this.fechaFinCorrectivoSareb = fechaFinCorrectivoSareb;
	}

	public DDTipoCuotaComunidad getTipoCuotaComunidad() {
		return tipoCuotaComunidad;
	}

	public void setTipoCuotaComunidad(DDTipoCuotaComunidad tipoCuotaComunidad) {
		this.tipoCuotaComunidad = tipoCuotaComunidad;
	}

	public DDSinSiNo getGgaaSareb() {
		return ggaaSareb;
	}

	public void setGgaaSareb(DDSinSiNo ggaaSareb) {
		this.ggaaSareb = ggaaSareb;
	}
	
	public DDSegmentoSareb getSegmentoSareb() {
		return segmentoSareb;
	}

	public void setSegmentoSareb(DDSegmentoSareb segmentoSareb) {
		this.segmentoSareb = segmentoSareb;
	}
	
}
