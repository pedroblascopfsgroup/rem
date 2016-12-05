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
 * Modelo que gestiona la informacion de la calidad de las cocinas de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_COC_COCINA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCocina implements Serializable, Auditable {
		
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "COC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCocinaGenerator")
    @SequenceGenerator(name = "ActivoCocinaGenerator", sequenceName = "S_ACT_COC_COCINA")
    private Long id;
    				
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@Column(name = "COC_AMUEBLADA")
    private Integer amueblada; 
	
	@Column(name = "COC_AMUEBLADA_EST")
    private Integer estadoAmueblada; 

	@Column(name = "COC_ENCIMERA")
    private Integer encimera;   
	
	@Column(name = "COC_ENCI_GRANITO")
	private Integer encimeraGranito;
	 
	@Column(name = "COC_ENCI_MARMOL")
	private Integer encimeraMarmol;
	
	@Column(name = "COC_ENCI_OTRO_MATERIAL")
	private Integer encimeraOtroMaterial;	
	
	@Column(name = "COC_VITRO")
	private Integer vitro;
	
	@Column(name = "COC_LAVADORA")
    private Integer lavadora;   
	
	@Column(name = "COC_FRIGORIFICO")
	private Integer frigorifico;
	 
	@Column(name = "COC_LAVAVAJILLAS")
	private Integer lavavajillas;
	
	@Column(name = "COC_MICROONDAS")
	private Integer microondas;
	
	@Column(name = "COC_HORNO")
    private Integer horno;   
	
	@Column(name = "COC_SUELOS")
	private Integer suelosCocina;
	 
	@Column(name = "COC_AZULEJOS")
	private Integer azulejos;
	
	@Column(name = "COC_AZULEJOS_EST")
	private Integer estadoAzulejos;
	
	@Column(name = "COC_GRIFOS_MONOMANDO")
	private Integer grifosMonomandos;
	
	@Column(name = "COC_GRIFOS_MONOMANDO_EST")
	private Integer estadoGrifosMonomandos;
	
	@Column(name = "COC_COCINA_OTROS")
	private String cocinaOtros;

	
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

	public Integer getAmueblada() {
		return amueblada;
	}

	public void setAmueblada(Integer amueblada) {
		this.amueblada = amueblada;
	}

	public Integer getEstadoAmueblada() {
		return estadoAmueblada;
	}

	public void setEstadoAmueblada(Integer estadoAmueblada) {
		this.estadoAmueblada = estadoAmueblada;
	}

	public Integer getEncimeraCocina() {
		return encimera;
	}

	public void setEncimeraCocina(Integer encimera) {
		this.encimera = encimera;
	}

	public Integer getEncimeraGranito() {
		return encimeraGranito;
	}
	
	public void setEncimeraGranito(Integer encimeraGranito) {
		this.encimeraGranito = encimeraGranito;
	}
	
	public Integer getEncimeraMarmol() {
		return encimeraMarmol;
	}
	
	public void setEncimeraMarmol(Integer encimeraMarmol) {
		this.encimeraMarmol = encimeraMarmol;
	}
	
	public Integer getEncimeraOtroMaterial() {
		return encimeraOtroMaterial;
	}
	
	public void setEncimeraOtroMaterial(Integer encimeraOtroMaterial) {
		this.encimeraOtroMaterial = encimeraOtroMaterial;
	}
	
	public Integer getVitro() {
		return vitro;
	}

	public void setVitro(Integer vitro) {
		this.vitro = vitro;
	}

	public Integer getLavadora() {
		return lavadora;
	}

	public void setLavadora(Integer lavadora) {
		this.lavadora = lavadora;
	}

	public Integer getFrigorifico() {
		return frigorifico;
	}

	public void setFrigorifico(Integer frigorifico) {
		this.frigorifico = frigorifico;
	}

	public Integer getLavavajillas() {
		return lavavajillas;
	}

	public void setLavavajillas(Integer lavavajillas) {
		this.lavavajillas = lavavajillas;
	}

	public Integer getMicroondas() {
		return microondas;
	}

	public void setMicroondas(Integer microondas) {
		this.microondas = microondas;
	}

	public Integer getHorno() {
		return horno;
	}

	public void setHorno(Integer horno) {
		this.horno = horno;
	}

	public Integer getSuelosCocina() {
		return suelosCocina;
	}

	public void setSuelosCocina(Integer suelos) {
		this.suelosCocina = suelos;
	}

	public Integer getAzulejos() {
		return azulejos;
	}

	public void setAzulejos(Integer azulejos) {
		this.azulejos = azulejos;
	}

	public Integer getEstadoAzulejos() {
		return estadoAzulejos;
	}

	public void setEstadoAzulejos(Integer estadoAzulejos) {
		this.estadoAzulejos = estadoAzulejos;
	}

	public Integer getGrifosMonomandos() {
		return grifosMonomandos;
	}

	public void setGrifosMonomandos(Integer grifosMonomandos) {
		this.grifosMonomandos = grifosMonomandos;
	}

	public Integer getEstadoGrifosMonomandos() {
		return estadoGrifosMonomandos;
	}

	public void setEstadoGrifosMonomandos(Integer estadoGrifosMonomandos) {
		this.estadoGrifosMonomandos = estadoGrifosMonomandos;
	}

	public String getCocinaOtros() {
		return cocinaOtros;
	}

	public void setCocinaOtros(String cocinaOtros) {
		this.cocinaOtros = cocinaOtros;
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
