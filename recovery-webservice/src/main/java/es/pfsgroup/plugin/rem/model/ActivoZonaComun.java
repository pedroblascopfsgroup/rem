package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * Modelo que gestiona la informacion de la calidad de las zonas comunes de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ZCO_ZONA_COMUN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoZonaComun implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ZCO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoZonaComunGenerator")
    @SequenceGenerator(name = "ActivoZonaComunGenerator", sequenceName = "S_ACT_ZCO_ZONA_COMUN")
    private Long id;
	
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@Column(name = "ZCO_ZONAS_COMUNES")
    private Integer zonasComunes;
	
	@Column(name = "ZCO_JARDINES")
    private Integer jardines;   
	
	@Column(name = "ZCO_PISCINA")
	private Integer piscina;
	 
	@Column(name = "ZCO_INST_DEP")
	private Integer instalacionesDeportivas;
	
	@Column(name = "ZCO_PADEL")
	private Integer padel;
	
	@Column(name = "ZCO_TENIS")
    private Integer tenis;   
	
	@Column(name = "ZCO_PISTA_POLIDEP")
	private Integer pistaPolideportiva;
	 
	@Column(name = "ZCO_OTROS")
	private String instalacionesDeportivasOtros;
	
	@Column(name = "ZCO_ZONA_INFANTIL")
	private Integer zonaInfantil;
	
	@Column(name = "ZCO_CONSERJE_VIGILANCIA")
    private Integer conserjeVigilancia;   
	
	@Column(name = "ZCO_GIMNASIO")
	private Integer gimnasio;
	
	@Column(name = "ZCO_ZONA_COMUN_OTROS")
	private String zonaComunOtros;

	
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

	public Integer getZonasComunes() {
		return zonasComunes;
	}

	public void setZonasComunes(Integer zonasComunes) {
		this.zonasComunes = zonasComunes;
	}

	public Integer getJardines() {
		return jardines;
	}

	public void setJardines(Integer jardines) {
		this.jardines = jardines;
	}

	public Integer getPiscina() {
		return piscina;
	}

	public void setPiscina(Integer piscina) {
		this.piscina = piscina;
	}

	public Integer getInstalacionesDeportivas() {
		return instalacionesDeportivas;
	}

	public void setInstalacionesDeportivas(Integer instalacionesDeportivas) {
		this.instalacionesDeportivas = instalacionesDeportivas;
	}

	public Integer getPadel() {
		return padel;
	}

	public void setPadel(Integer padel) {
		this.padel = padel;
	}

	public Integer getTenis() {
		return tenis;
	}

	public void setTenis(Integer tenis) {
		this.tenis = tenis;
	}

	public Integer getPistaPolideportiva() {
		return pistaPolideportiva;
	}

	public void setPistaPolideportiva(Integer pistaPolideportiva) {
		this.pistaPolideportiva = pistaPolideportiva;
	}

	public String getInstalacionesDeportivasOtros() {
		return instalacionesDeportivasOtros;
	}

	public void setInstalacionesDeportivasOtros(String instalacionesDeportivasOtros) {
		this.instalacionesDeportivasOtros = instalacionesDeportivasOtros;
	}

	public Integer getZonaInfantil() {
		return zonaInfantil;
	}

	public void setZonaInfantil(Integer zonaInfantil) {
		this.zonaInfantil = zonaInfantil;
	}

	public Integer getConserjeVigilancia() {
		return conserjeVigilancia;
	}

	public void setConserjeVigilancia(Integer conserjeVigilancia) {
		this.conserjeVigilancia = conserjeVigilancia;
	}

	public Integer getGimnasio() {
		return gimnasio;
	}

	public void setGimnasio(Integer gimnasio) {
		this.gimnasio = gimnasio;
	}

	public String getZonaComunOtros() {
		return zonaComunOtros;
	}

	public void setZonaComunOtros(String zonaComunOtros) {
		this.zonaComunOtros = zonaComunOtros;
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
