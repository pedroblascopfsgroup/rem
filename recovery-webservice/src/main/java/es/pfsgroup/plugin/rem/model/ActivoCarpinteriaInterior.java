package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
import es.pfsgroup.plugin.rem.model.dd.DDAcabadoCarpinteria;



/**
 * Modelo que gestiona la informacion de la calidad de la carpinteria interior de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_CRI_CARPINTERIA_INT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCarpinteriaInterior implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CRI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCarpinteriaInteriorGenerator")
    @SequenceGenerator(name = "ActivoCarpinteriaInteriorGenerator", sequenceName = "S_ACT_CRI_CARPINTERIA_INT")
    private Long id;
	
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@ManyToOne
    @JoinColumn(name = "DD_ACR_ID")
    private DDAcabadoCarpinteria acabadoCarpinteria;   
	           						
	@Column(name = "CRI_PTA_ENT_NORMAL")
    private Integer puertaEntradaNormal;   
	
	@Column(name = "CRI_PTA_ENT_BLINDADA")
	private Integer puertaEntradaBlindada;
	 
	@Column(name = "CRI_PTA_ENT_ACORAZADA")
	private Integer puertaEntradaAcorazada;
	
	@Column(name = "CRI_PTA_PASO_MACIZAS")
	private Integer puertaPasoMaciza;
	
	@Column(name = "CRI_PTA_PASO_HUECAS")
	private Integer puertaPasoHueca;
	
	@Column(name = "CRI_PTA_PASO_LACADAS")
	private Integer puertaPasoLacada;
	
	@Column(name = "CRI_ARMARIOS_EMPOTRADOS")
	private Integer armariosEmpotrados;
	
	@Column(name = "CRI_CRP_INT_OTROS")
	private String carpinteriaInteriorOtros;

	
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

	public DDAcabadoCarpinteria getAcabadoCarpinteria() {
		return acabadoCarpinteria;
	}

	public void setAcabadoCarpinteria(DDAcabadoCarpinteria acabadoCarpinteria) {
		this.acabadoCarpinteria = acabadoCarpinteria;
	}

	public Integer getPuertaEntradaNormal() {
		return puertaEntradaNormal;
	}

	public void setPuertaEntradaNormal(Integer puertaEntradaNormal) {
		this.puertaEntradaNormal = puertaEntradaNormal;
	}

	public Integer getPuertaEntradaBlindada() {
		return puertaEntradaBlindada;
	}

	public void setPuertaEntradaBlindada(Integer puertaEntradaBlindada) {
		this.puertaEntradaBlindada = puertaEntradaBlindada;
	}

	public Integer getPuertaEntradaAcorazada() {
		return puertaEntradaAcorazada;
	}

	public void setPuertaEntradaAcorazada(Integer puertaEntradaAcorazada) {
		this.puertaEntradaAcorazada = puertaEntradaAcorazada;
	}

	public Integer getPuertaPasoMaciza() {
		return puertaPasoMaciza;
	}

	public void setPuertaPasoMaciza(Integer puertaPasoMaciza) {
		this.puertaPasoMaciza = puertaPasoMaciza;
	}

	public Integer getPuertaPasoHueca() {
		return puertaPasoHueca;
	}

	public void setPuertaPasoHueca(Integer puertaPasoHueca) {
		this.puertaPasoHueca = puertaPasoHueca;
	}

	public Integer getPuertaPasoLacada() {
		return puertaPasoLacada;
	}

	public void setPuertaPasoLacada(Integer puertaPasoLacada) {
		this.puertaPasoLacada = puertaPasoLacada;
	}

	public Integer getArmariosEmpotrados() {
		return armariosEmpotrados;
	}

	public void setArmariosEmpotrados(Integer armariosEmpotrados) {
		this.armariosEmpotrados = armariosEmpotrados;
	}

	public String getCarpinteriaInteriorOtros() {
		return carpinteriaInteriorOtros;
	}

	public void setCarpinteriaInteriorOtros(String carpinteriaInteriorOtros) {
		this.carpinteriaInteriorOtros = carpinteriaInteriorOtros;
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
