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
 * Modelo que gestiona la informacion de la calidad de los baños de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_BNY_BANYO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoBanyo implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "BNY_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoBanyoGenerator")
    @SequenceGenerator(name = "ActivoBanyoGenerator", sequenceName = "S_ACT_BNY_BANYO")
    private Long id;
	 
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@Column(name = "BNY_DUCHA_BANYERA")
	private Integer duchaBanyera;
	 
	@Column(name = "BNY_DUCHA")
    private Integer ducha;   
	
	@Column(name = "BNY_BANYERA")
	private Integer banyera;
	 
	@Column(name = "BNY_BANYERA_HIDROMASAJE")
	private Integer banyeraHidromasaje;
	
	@Column(name = "BNY_COLUMNA_HIDROMASAJE")
	private Integer columnaHidromasaje;
	
	@Column(name = "BNY_ALICATADO_MARMOL")
    private Integer alicatadoMarmol;   
	
	@Column(name = "BNY_ALICATADO_GRANITO")
	private Integer alicatadoGranito;
	 
	@Column(name = "BNY_ALICATADO_AZULEJO")
	private Integer alicatadoAzulejo;
	
	@Column(name = "BNY_ENCIMERA")
	private Integer encimeraBanyo;
	
	@Column(name = "BNY_MARMOL")
    private Integer encimeraBanyoMarmol;   
	
	@Column(name = "BNY_GRANITO")
	private Integer encimeraBanyoGranito;
	 
	@Column(name = "BNY_OTRO_MATERIAL")
	private Integer encimeraBanyoOtroMaterial;
	
	@Column(name = "BNY_SANITARIOS")
	private Integer sanitarios;
	
	@Column(name = "BNY_SANITARIOS_EST")
	private Integer estadoSanitarios;

	@Column(name = "BNY_SUELOS")
	private Integer suelosBanyo;

	@Column(name = "BNY_GRIFO_MONOMANDO")
	private Integer grifoMonomando;
	
	@Column(name = "BNY_GRIFO_MONOMANDO_EST")
	private Integer estadoGrifoMonomando;
	
	@Column(name = "BNY_BANYO_OTROS")
	private String banyoOtros;

	
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

	public Integer getDuchaBanyera() {
		return duchaBanyera;
	}

	public void setDuchaBanyera(Integer duchaBanyera) {
		this.duchaBanyera = duchaBanyera;
	}

	public Integer getDucha() {
		return ducha;
	}

	public void setDucha(Integer ducha) {
		this.ducha = ducha;
	}

	public Integer getBanyera() {
		return banyera;
	}

	public void setBanyera(Integer banyera) {
		this.banyera = banyera;
	}

	public Integer getBanyeraHidromasaje() {
		return banyeraHidromasaje;
	}

	public void setBanyeraHidromasaje(Integer banyeraHidromasaje) {
		this.banyeraHidromasaje = banyeraHidromasaje;
	}

	public Integer getColumnaHidromasaje() {
		return columnaHidromasaje;
	}

	public void setColumnaHidromasaje(Integer columnaHidromasaje) {
		this.columnaHidromasaje = columnaHidromasaje;
	}

	public Integer getAlicatadoMarmol() {
		return alicatadoMarmol;
	}

	public void setAlicatadoMarmol(Integer alicatadoMarmol) {
		this.alicatadoMarmol = alicatadoMarmol;
	}

	public Integer getAlicatadoGranito() {
		return alicatadoGranito;
	}

	public void setAlicatadoGranito(Integer alicatadoGranito) {
		this.alicatadoGranito = alicatadoGranito;
	}

	public Integer getAlicatadoAzulejo() {
		return alicatadoAzulejo;
	}

	public void setAlicatadoAzulejo(Integer alicatadoAzulejo) {
		this.alicatadoAzulejo = alicatadoAzulejo;
	}

	public Integer getEncimeraBanyo() {
		return encimeraBanyo;
	}

	public void setEncimeraBanyo(Integer encimeraBanyo) {
		this.encimeraBanyo = encimeraBanyo;
	}

	public Integer getEncimeraBanyoMarmol() {
		return encimeraBanyoMarmol;
	}

	public void setEncimeraBanyoMarmol(Integer encimeraBanyoMarmol) {
		this.encimeraBanyoMarmol = encimeraBanyoMarmol;
	}

	public Integer getEncimeraBanyoGranito() {
		return encimeraBanyoGranito;
	}

	public void setEncimeraBanyoGranito(Integer encimeraBanyoGranito) {
		this.encimeraBanyoGranito = encimeraBanyoGranito;
	}

	public Integer getEncimeraBanyoOtroMaterial() {
		return encimeraBanyoOtroMaterial;
	}

	public void setEncimeraBanyoOtroMaterial(Integer encimeraBanyoOtroMaterial) {
		this.encimeraBanyoOtroMaterial = encimeraBanyoOtroMaterial;
	}

	public Integer getSanitarios() {
		return sanitarios;
	}

	public void setSanitarios(Integer sanitarios) {
		this.sanitarios = sanitarios;
	}

	public Integer getEstadoSanitarios() {
		return estadoSanitarios;
	}

	public void setEstadoSanitarios(Integer estadoSanitarios) {
		this.estadoSanitarios = estadoSanitarios;
	}

	public Integer getSuelosBanyo() {
		return suelosBanyo;
	}

	public void setSuelosBanyo(Integer suelosBanyo) {
		this.suelosBanyo = suelosBanyo;
	}

	public Integer getGrifoMonomando() {
		return grifoMonomando;
	}

	public void setGrifoMonomando(Integer grifoMonomando) {
		this.grifoMonomando = grifoMonomando;
	}

	public Integer getEstadoGrifoMonomando() {
		return estadoGrifoMonomando;
	}

	public void setEstadoGrifoMonomando(Integer estadoGrifoMonomando) {
		this.estadoGrifoMonomando = estadoGrifoMonomando;
	}

	public String getBanyoOtros() {
		return banyoOtros;
	}

	public void setBanyoOtros(String banyoOtros) {
		this.banyoOtros = banyoOtros;
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
