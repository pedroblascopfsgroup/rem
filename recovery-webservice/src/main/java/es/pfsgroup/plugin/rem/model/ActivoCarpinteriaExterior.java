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
 * Modelo que gestiona la informacion de la calidad de la carpinteria exterior de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_CRE_CARPINTERIA_EXT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCarpinteriaExterior implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CRE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCarpinteriaExteriorGenerator")
    @SequenceGenerator(name = "ActivoCarpinteriaExteriorGenerator", sequenceName = "S_ACT_CRE_CARPINTERIA_EXT")
    private Long id;	
	
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	           						
	@Column(name = "CRE_VTNAS_HIERRO")
    private Integer ventanasHierro;   
	
	@Column(name = "CRE_VTNAS_ALU_ANODIZADO")
	private Integer ventanasAluAnodizado;
	 
	@Column(name = "CRE_VTNAS_ALU_LACADO")
	private Integer ventanasAluLacado;
	
	@Column(name = "CRE_VTNAS_PVC")
	private Integer ventanasPVC;
	
	@Column(name = "CRE_VTNAS_MADERA")
	private Integer ventanasMadera;
	
	@Column(name = "CRE_PERS_PLASTICO")
	private Integer persianasPlatico;
	
	@Column(name = "CRE_PERS_ALU")
	private Integer persianasAluminio;
	
	@Column(name = "CRE_VTNAS_CORREDERAS")
	private Integer ventanasCorrederas;

	@Column(name = "CRE_VTNAS_ABATIBLES")
	private Integer ventanasAbatibles;

	@Column(name = "CRE_VTNAS_OSCILOBAT")
	private Integer ventanasOscilobatientes;

	@Column(name = "CRE_DOBLE_CRISTAL")
	private Integer dobleCristal;
	
	@Column(name = "CRE_EST_DOBLE_CRISTAL")
	private Integer dobleCristalEstado;
	
	@Column(name = "CRE_CRP_EXT_OTROS")
	private String carpinteriaExteriorOtros;

	
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

	public Integer getVentanasHierro() {
		return ventanasHierro;
	}

	public void setVentanasHierro(Integer ventanasHierro) {
		this.ventanasHierro = ventanasHierro;
	}

	public Integer getVentanasAluAnodizado() {
		return ventanasAluAnodizado;
	}

	public void setVentanasAluAnodizado(Integer ventanasAluAnodizado) {
		this.ventanasAluAnodizado = ventanasAluAnodizado;
	}

	public Integer getVentanasAluLacado() {
		return ventanasAluLacado;
	}

	public void setVentanasAluLacado(Integer ventanasAluLacado) {
		this.ventanasAluLacado = ventanasAluLacado;
	}

	public Integer getVentanasPVC() {
		return ventanasPVC;
	}

	public void setVentanasPVC(Integer ventanasPVC) {
		this.ventanasPVC = ventanasPVC;
	}

	public Integer getVentanasMadera() {
		return ventanasMadera;
	}

	public void setVentanasMadera(Integer ventanasMadera) {
		this.ventanasMadera = ventanasMadera;
	}

	public Integer getPersianasPlatico() {
		return persianasPlatico;
	}

	public void setPersianasPlatico(Integer persianasPlatico) {
		this.persianasPlatico = persianasPlatico;
	}

	public Integer getPersianasAluminio() {
		return persianasAluminio;
	}

	public void setPersianasAluminio(Integer persianasAluminio) {
		this.persianasAluminio = persianasAluminio;
	}

	public Integer getVentanasCorrederas() {
		return ventanasCorrederas;
	}

	public void setVentanasCorrederas(Integer ventanasCorrederas) {
		this.ventanasCorrederas = ventanasCorrederas;
	}

	public Integer getVentanasAbatibles() {
		return ventanasAbatibles;
	}

	public void setVentanasAbatibles(Integer ventanasAbatibles) {
		this.ventanasAbatibles = ventanasAbatibles;
	}

	public Integer getVentanasOscilobatientes() {
		return ventanasOscilobatientes;
	}

	public void setVentanasOscilobatientes(Integer ventanasOscilobatientes) {
		this.ventanasOscilobatientes = ventanasOscilobatientes;
	}

	public Integer getDobleCristal() {
		return dobleCristal;
	}

	public void setDobleCristal(Integer dobleCristal) {
		this.dobleCristal = dobleCristal;
	}

	public Integer getDobleCristalEstado() {
		return dobleCristalEstado;
	}

	public void setDobleCristalEstado(Integer dobleCristalEstado) {
		this.dobleCristalEstado = dobleCristalEstado;
	}

	public String getCarpinteriaExteriorOtros() {
		return carpinteriaExteriorOtros;
	}

	public void setCarpinteriaExteriorOtros(String carpinteriaExteriorOtros) {
		this.carpinteriaExteriorOtros = carpinteriaExteriorOtros;
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
