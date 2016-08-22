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
 * Modelo que gestiona la informacion de la calidad de los paramentos verticales de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PRV_PARAMENTO_VERTICAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoParamentoVertical implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "PRV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoParamentoVerticalGenerator")
    @SequenceGenerator(name = "ActivoParamentoVerticalGenerator", sequenceName = "S_ACT_PRV_PARAMENTO_VERTICAL")
    private Long id;
	
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	           						
	@Column(name = "PRV_HUMEDAD_PARED")
    private Integer humedadPared;   
	
	@Column(name = "PRV_HUMEDAD_TECHO")
	private Integer humedadTecho;
	 
	@Column(name = "PRV_GRIETA_PARED")
	private Integer grietaPared;
	
	@Column(name = "PRV_GRIETA_TECHO")
	private Integer grietoTecho;
	
	@Column(name = "PRV_GOTELE")
	private Integer gotele;
	
	@Column(name = "PRV_PLASTICA_LISA")
	private Integer plasticaLisa;
	
	@Column(name = "PRV_PAPEL_PINTADO")
	private Integer papelPintado;

	@Column(name = "PRV_PINTURA_LISA_TECHO")
	private Integer pinturaLisaTecho;

	@Column(name = "PRV_PINTURA_LISA_TECHO_EST")
	private Integer pinturaLisaTechoEstado;

	@Column(name = "PRV_MOLDURA_ESCAYOLA")
	private Integer molduraEscayola;
	
	@Column(name = "PRV_MOLDURA_ESCAYOLA_EST")
	private Integer molduraEscayolaEstado;
	
	@Column(name = "PRV_PARAMENTOS_OTROS")
	private String paramentosOtros;

	
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

	public Integer getHumedadPared() {
		return humedadPared;
	}

	public void setHumedadPared(Integer humedadPared) {
		this.humedadPared = humedadPared;
	}

	public Integer getHumedadTecho() {
		return humedadTecho;
	}

	public void setHumedadTecho(Integer humedadTecho) {
		this.humedadTecho = humedadTecho;
	}

	public Integer getGrietaPared() {
		return grietaPared;
	}

	public void setGrietaPared(Integer grietaPared) {
		this.grietaPared = grietaPared;
	}

	public Integer getGrietoTecho() {
		return grietoTecho;
	}

	public void setGrietoTecho(Integer grietoTecho) {
		this.grietoTecho = grietoTecho;
	}

	public Integer getGotele() {
		return gotele;
	}

	public void setGotele(Integer gotele) {
		this.gotele = gotele;
	}

	public Integer getPlasticaLisa() {
		return plasticaLisa;
	}

	public void setPlasticaLisa(Integer plasticaLisa) {
		this.plasticaLisa = plasticaLisa;
	}

	public Integer getPapelPintado() {
		return papelPintado;
	}

	public void setPapelPintado(Integer papelPintado) {
		this.papelPintado = papelPintado;
	}

	public Integer getPinturaLisaTecho() {
		return pinturaLisaTecho;
	}

	public void setPinturaLisaTecho(Integer pinturaLisaTecho) {
		this.pinturaLisaTecho = pinturaLisaTecho;
	}

	public Integer getPinturaLisaTechoEstado() {
		return pinturaLisaTechoEstado;
	}

	public void setPinturaLisaTechoEstado(Integer pinturaLisaTechoEstado) {
		this.pinturaLisaTechoEstado = pinturaLisaTechoEstado;
	}

	public Integer getMolduraEscayola() {
		return molduraEscayola;
	}

	public void setMolduraEscayola(Integer molduraEscayola) {
		this.molduraEscayola = molduraEscayola;
	}

	public Integer getMolduraEscayolaEstado() {
		return molduraEscayolaEstado;
	}

	public void setMolduraEscayolaEstado(Integer molduraEscayolaEstado) {
		this.molduraEscayolaEstado = molduraEscayolaEstado;
	}

	public String getParamentosOtros() {
		return paramentosOtros;
	}

	public void setParamentosOtros(String paramentosOtros) {
		this.paramentosOtros = paramentosOtros;
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
