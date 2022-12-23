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
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFachada;



/**
 * Modelo que gestiona la información comercial de los edificios en los que se ubican los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_EDI_EDIFICIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoEdificio implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "EDI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoEdificioGenerator")
    @SequenceGenerator(name = "ActivoEdificioGenerator", sequenceName = "S_ACT_EDI_EDIFICIO")
    private Long id;

	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@NotFound(action = NotFoundAction.EXCEPTION)
	@JoinColumn(name = "DD_ECV_ID")
	private DDEstadoConservacion estadoConservacionEdificio;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPF_ID")
	private DDTipoFachada tipoFachada;
	
	@Column(name = "EDI_ANO_REHABILITACION")
    private Integer anyoRehabilitacionEdificio;   
	
	@Column(name = "EDI_NUM_PLANTAS")
	private Integer numPlantas;
	 
	@Column(name = "EDI_ASCENSOR")
	private Integer ascensorEdificio;
	
	@Column(name = "EDI_NUM_ASCENSORES")
	private Integer numAscensores;
	
	@Column(name = "EDI_REFORMA_FACHADA")
	private Boolean reformaFachada;
	
	@Column(name = "EDI_REFORMA_ESCALERA")
	private Boolean reformaEscalera;
	
	@Column(name = "EDI_REFORMA_PORTAL")
	private Boolean reformaPortal;
	
	@Column(name = "EDI_REFORMA_ASCENSOR")
	private Boolean reformaAscensor;

	@Column(name = "EDI_REFORMA_CUBIERTA")
	private Boolean reformaCubierta;
	
	@Column(name = "EDI_REFORMA_OTRA_ZONA")
	private Boolean reformaOtraZona;
	
	@Column(name = "EDI_REFORMA_OTRO")
	private Boolean reformaOtro;
	
	@Column(name = "EDI_REFORMA_OTRO_DESC")
	private String reformaOtroDescEdificio;
	
	@Column(name = "EDI_DESCRIPCION")
	private String ediDescripcion;
	
	@Column(name = "EDI_ENTORNO_INFRAESTRUCTURA")
	private String entornoInfraestructura;
	
	@Column(name = "EDI_ENTORNO_COMUNICACION")
	private String entornoComunicacion;
	
	@Column(name = "EDI_DIVISIBLE")
	private Integer edificioDivisible;
	
	@Column(name = "EDI_DESC_PLANTAS")
	private String edificioDescPlantas;
	
	@Column(name = "EDI_OTRAS_CARACTERISTICAS")
	private String edificioOtrasCaracteristicas;
	
	
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

	public ActivoInfoComercial getInfoComercial() {
		return infoComercial;
	}

	public void setInfoComercial(ActivoInfoComercial infoComercial) {
		this.infoComercial = infoComercial;
	}

	public DDEstadoConservacion getEstadoConservacionEdificio() {
		return estadoConservacionEdificio;
	}

	public void setEstadoConservacionEdificio(DDEstadoConservacion estadoConservacionEdificio) {
		this.estadoConservacionEdificio = estadoConservacionEdificio;
	}

	public DDTipoFachada getTipoFachada() {
		return tipoFachada;
	}

	public void setTipoFachada(DDTipoFachada tipoFachada) {
		this.tipoFachada = tipoFachada;
	}

	public Integer getAnyoRehabilitacionEdificio() {
		return anyoRehabilitacionEdificio;
	}

	public void setAnyoRehabilitacionEdificio(Integer anyoRehabilitacionEdificio) {
		this.anyoRehabilitacionEdificio = anyoRehabilitacionEdificio;
	}

	public Integer getNumPlantas() {
		return numPlantas;
	}

	public void setNumPlantas(Integer numPlantas) {
		this.numPlantas = numPlantas;
	}

	public Integer getAscensorEdificio() {
		return ascensorEdificio;
	}

	public void setAscensorEdificio(Integer ascensorEdificio) {
		this.ascensorEdificio = ascensorEdificio;
	}

	public Integer getNumAscensores() {
		return numAscensores;
	}

	public void setNumAscensores(Integer numAscensores) {
		this.numAscensores = numAscensores;
	}

	public Boolean getReformaFachada() {
		return reformaFachada;
	}

	public void setReformaFachada(Boolean reformaFachada) {
		this.reformaFachada = reformaFachada;
	}

	public Boolean getReformaEscalera() {
		return reformaEscalera;
	}

	public void setReformaEscalera(Boolean reformaEscalera) {
		this.reformaEscalera = reformaEscalera;
	}

	public Boolean getReformaPortal() {
		return reformaPortal;
	}

	public void setReformaPortal(Boolean reformaPortal) {
		this.reformaPortal = reformaPortal;
	}

	public Boolean getReformaAscensor() {
		return reformaAscensor;
	}

	public void setReformaAscensor(Boolean reformaAscensor) {
		this.reformaAscensor = reformaAscensor;
	}

	public Boolean getReformaCubierta() {
		return reformaCubierta;
	}

	public void setReformaCubierta(Boolean reformaCubierta) {
		this.reformaCubierta = reformaCubierta;
	}

	public Boolean getReformaOtraZona() {
		return reformaOtraZona;
	}

	public void setReformaOtraZona(Boolean reformaOtraZona) {
		this.reformaOtraZona = reformaOtraZona;
	}

	public Boolean getReformaOtro() {
		return reformaOtro;
	}

	public void setReformaOtro(Boolean reformaOtro) {
		this.reformaOtro = reformaOtro;
	}

	public String getReformaOtroDescEdificio() {
		return reformaOtroDescEdificio;
	}

	public void setReformaOtroDescEdificio(String reformaOtroDescEdificio) {
		this.reformaOtroDescEdificio = reformaOtroDescEdificio;
	}

	public String getEdiDescripcion() {
		return ediDescripcion;
	}

	public void setEdiDescripcion(String ediDescripcion) {
		this.ediDescripcion = ediDescripcion;
	}

	public String getEntornoInfraestructura() {
		return entornoInfraestructura;
	}

	public void setEntornoInfraestructura(String entornoInfraestructura) {
		this.entornoInfraestructura = entornoInfraestructura;
	}

	public String getEntornoComunicacion() {
		return entornoComunicacion;
	}

	public void setEntornoComunicacion(String entornoComunicacion) {
		this.entornoComunicacion = entornoComunicacion;
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

	public Integer getEdificioDivisible() {
		return edificioDivisible;
	}

	public void setEdificioDivisible(Integer edificioDivisible) {
		this.edificioDivisible = edificioDivisible;
	}

	public String getEdificioDescPlantas() {
		return edificioDescPlantas;
	}

	public void setEdificioDescPlantas(String edificioDescPlantas) {
		this.edificioDescPlantas = edificioDescPlantas;
	}

	public String getEdificioOtrasCaracteristicas() {
		return edificioOtrasCaracteristicas;
	}

	public void setEdificioOtrasCaracteristicas(String edificioOtrasCaracteristicas) {
		this.edificioOtrasCaracteristicas = edificioOtrasCaracteristicas;
	}


}
