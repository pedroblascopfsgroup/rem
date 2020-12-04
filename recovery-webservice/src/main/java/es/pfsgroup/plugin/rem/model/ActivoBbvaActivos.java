package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;

/**
 * Modelo que gestiona los activos de BBVA
 * 
 * @author Javier Esbrí
 */
@Entity
@Table(name = "ACT_BBVA_ACTIVOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoBbvaActivos implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "BBVA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoBbvaActivosGenerator")
    @SequenceGenerator(name = "ActivoBbvaActivosGenerator", sequenceName = "S_ACT_BBVA_ACTIVOS")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
    @Column(name = "BBVA_NUM_ACTIVO")
    private String numActivoBbva;

    @Column(name = "BBVA_LINEA_FACTURA")
	private Long lineaFactura;
    
	@Column(name = "BBVA_ID_ORIGEN_HRE")
  	private Long idOrigenHre;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TTR_ID")
  	private DDTipoTransmision tipoTransmision;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAL_ID")
	private DDTipoAlta tipoAlta;

	@Column(name = "BBVA_UIC")
  	private String uicBbva;
    
	@Column(name = "BBVA_CEXPER")
  	private String cexperBbva;
    
	@Column(name = "BBVA_ID_PROCESO_ORIGEN")
  	private String idProcesoOrigen;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "BBVA_ACTIVO_EPA")
  	private DDSinSiNo activoEpa;
    
	@Column(name = "BBVA_EMPRESA")
  	private Long empresa;
    
	@Column(name = "BBVA_OFICINA")
  	private Long oficina;
    
	@Column(name = "BBVA_CONTRAPARTIDA")
  	private Long contrapartida;
    
	@Column(name = "BBVA_FOLIO")
  	private Long folio;
    
	@Column(name = "BBVA_CDPEN")
  	private String cdpen;
    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	@Column(name = "BBVA_COD_PROMOCION")
  	private String codPromocion;
	
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
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

	public String getNumActivoBbva() {
		return numActivoBbva;
	}

	public void setNumActivoBbva(String numActivoBbva) {
		this.numActivoBbva = numActivoBbva;
	}

	public Long getLineaFactura() {
		return lineaFactura;
	}

	public void setLineaFactura(Long lineaFactura) {
		this.lineaFactura = lineaFactura;
	}

	public Long getIdOrigenHre() {
		return idOrigenHre;
	}

	public void setIdOrigenHre(Long idOrigenHre) {
		this.idOrigenHre = idOrigenHre;
	}

	public DDTipoTransmision getTipoTransmision() {
		return tipoTransmision;
	}

	public void setTipoTransmision(DDTipoTransmision tipoTransmision) {
		this.tipoTransmision = tipoTransmision;
	}

	public DDTipoAlta getTipoAlta() {
		return tipoAlta;
	}

	public void setTipoAlta(DDTipoAlta tipoAlta) {
		this.tipoAlta = tipoAlta;
	}

	public String getUicBbva() {
		return uicBbva;
	}

	public void setUicBbva(String uicBbva) {
		this.uicBbva = uicBbva;
	}

	public String getCexperBbva() {
		return cexperBbva;
	}

	public void setCexperBbva(String cexperBbva) {
		this.cexperBbva = cexperBbva;
	}

	public DDSinSiNo getActivoEpa() {
		return activoEpa;
	}

	public void setActivoEpa(DDSinSiNo activoEpa) {
		this.activoEpa = activoEpa;
	}

	public Long getEmpresa() {
		return empresa;
	}

	public void setEmpresa(Long empresa) {
		this.empresa = empresa;
	}

	public Long getOficina() {
		return oficina;
	}

	public void setOficina(Long oficina) {
		this.oficina = oficina;
	}

	public Long getContrapartida() {
		return contrapartida;
	}

	public void setContrapartida(Long contrapartida) {
		this.contrapartida = contrapartida;
	}

	public Long getFolio() {
		return folio;
	}

	public void setFolio(Long folio) {
		this.folio = folio;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public String getCodPromocion() {
		return codPromocion;
	}

	public void setCodPromocion(String codPromocion) {
		this.codPromocion = codPromocion;
	}

	public String getIdProcesoOrigen() {
		return idProcesoOrigen;
	}

	public void setIdProcesoOrigen(String idProcesoOrigen) {
		this.idProcesoOrigen = idProcesoOrigen;
	}

	public String getCdpen() {
		return cdpen;
	}

	public void setCdpen(String cdpen) {
		this.cdpen = cdpen;
	}

}
