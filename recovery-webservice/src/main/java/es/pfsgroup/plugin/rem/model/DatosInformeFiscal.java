package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Entity
@Table(name = "DFS_DATOS_FISCALES_OFR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class DatosInformeFiscal implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "DFS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DatosInformeFiscalGenerator")
    @SequenceGenerator(name = "DatosInformeFiscalGenerator", sequenceName = "S_DFS_DATOS_FISCALES_OFR")
    private Long id;
	
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta; 
	
    @Column(name="DFS_NECESIDAD_IF")
	private Boolean necesidadIf;
    
    @Column(name="DFS_EXCLUSION_IF")
	private Boolean exclusionIf;
    
    @Column(name="DFS_OBSERVACIONES_IF")
    private String observacionesIf;
    
    @Column(name="DFS_SF_VAL_INFORME_FISCAL")
    private Boolean validacionDocumentoIf;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIT_ID")
	private DDTiposImpuesto tiposImpuesto;
	
	@Column(name="DFS_TIPO_APLICABLE")
	private Double tipoAplicable;
	
	@Column(name="DFS_OPERACION_EXENTA")
    private Boolean operacionExenta;
	
	@Column(name="DFS_RENUNCIA_EXENCION")
    private Boolean renunciaExencion;
	
	@Column(name="DFS_TRIBUTOS_PROPIEDAD")
    private Boolean tributosSobrePropiedad;
	
	@Column(name="DFS_INVERSION_SUJETO_PASIVO")
    private Boolean inversionDeSujetoPasivo;
	
	@Column(name="DFS_RESERVA_CON_IMPUESTO")
    private Boolean reservaConImpuesto;
    
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

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Boolean getNecesidadIf() {
		return necesidadIf;
	}

	public void setNecesidadIf(Boolean necesidadIf) {
		this.necesidadIf = necesidadIf;
	}

	public Boolean getExclusionIf() {
		return exclusionIf;
	}

	public void setExclusionIf(Boolean exclusionIf) {
		this.exclusionIf = exclusionIf;
	}

	public String getObservacionesIf() {
		return observacionesIf;
	}

	public void setObservacionesIf(String observacionesIf) {
		this.observacionesIf = observacionesIf;
	}

	public DDTiposImpuesto getTiposImpuesto() {
		return tiposImpuesto;
	}

	public void setTiposImpuesto(DDTiposImpuesto tiposImpuesto) {
		this.tiposImpuesto = tiposImpuesto;
	}

	public Double getTipoAplicable() {
		return tipoAplicable;
	}

	public void setTipoAplicable(Double tipoAplicable) {
		this.tipoAplicable = tipoAplicable;
	}

	public Boolean getOperacionExenta() {
		return operacionExenta;
	}

	public void setOperacionExenta(Boolean operacionExenta) {
		this.operacionExenta = operacionExenta;
	}

	public Boolean getRenunciaExencion() {
		return renunciaExencion;
	}

	public void setRenunciaExencion(Boolean renunciaExencion) {
		this.renunciaExencion = renunciaExencion;
	}

	public Boolean getTributosSobrePropiedad() {
		return tributosSobrePropiedad;
	}

	public void setTributosSobrePropiedad(Boolean tributosSobrePropiedad) {
		this.tributosSobrePropiedad = tributosSobrePropiedad;
	}

	public Boolean getInversionDeSujetoPasivo() {
		return inversionDeSujetoPasivo;
	}

	public void setInversionDeSujetoPasivo(Boolean inversionDeSujetoPasivo) {
		this.inversionDeSujetoPasivo = inversionDeSujetoPasivo;
	}

	public Boolean getReservaConImpuesto() {
		return reservaConImpuesto;
	}

	public void setReservaConImpuesto(Boolean reservaConImpuesto) {
		this.reservaConImpuesto = reservaConImpuesto;
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

	public Boolean getValidacionDocumentoIf() {
		return validacionDocumentoIf;
	}

	public void setValidacionDocumentoIf(Boolean validacionDocumentoIf) {
		this.validacionDocumentoIf = validacionDocumentoIf;
	}



}
