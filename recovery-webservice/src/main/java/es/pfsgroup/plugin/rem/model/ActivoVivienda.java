package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOrientacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;


/**
 * Modelo que gestiona la información comercial específica de los activos de tipo vivienda.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_VIV_VIVIENDA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="ICO_ID")
public class ActivoVivienda extends ActivoInfoComercial implements Serializable {
				
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@ManyToOne
    @JoinColumn(name = "DD_TPR_ID")
    private DDTipoRenta tipoRenta; 
	
	@ManyToOne
    @JoinColumn(name = "DD_TPV_ID")
    private DDTipoVivienda tipoVivienda; 
	
	@ManyToOne
    @JoinColumn(name = "DD_TPO_ID")
    private DDTipoOrientacion tipoOrientacion; 
	
	@Column(name = "VIV_ULTIMA_PLANTA")
	private Integer ultimaPlanta;
	
	@Column(name = "VIV_NUM_PLANTAS_INTERIOR")
	private Integer numPlantasInter;
	
	@Column(name = "VIV_REFORMA_CARP_INT")
	private Boolean reformaCarpInt;
	
	@Column(name = "VIV_REFORMA_CARP_EXT")
	private Boolean reformaCarpExt;
	
	@Column(name = "VIV_REFORMA_COCINA")
	private Boolean reformaCocina;
	
	@Column(name = "VIV_REFORMA_BANYO")
	private Boolean reformaBanyo;
	
	@Column(name = "VIV_REFORMA_SUELO")
	private Boolean reformaSuelo;
	
	@Column(name = "VIV_REFORMA_PINTURA")
	private Boolean reformaPintura;
	
	@Column(name = "VIV_REFORMA_INTEGRAL")
	private Boolean reformaIntegral;

	@Column(name = "VIV_REFORMA_OTRO")
	private Boolean reformaOtro;
	
	@Column(name = "VIV_REFORMA_OTRO_DESC")
	private String reformaOtroDesc;
	
	@Column(name = "VIV_REFORMA_PRESUPUESTO")
	private Double reformaPresupuesto;
	
	@Column(name = "VIV_DISTRIBUCION_TXT")
	private String distribucionTxt;

    @OneToMany(mappedBy = "infoComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ICO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoDistribucion> distribucion;
    
    

	public DDTipoRenta getTipoRenta() {
		return tipoRenta;
	}

	public void setTipoRenta(DDTipoRenta tipoRenta) {
		this.tipoRenta = tipoRenta;
	}

	public DDTipoVivienda getTipoVivienda() {
		return tipoVivienda;
	}

	public void setTipoVivienda(DDTipoVivienda tipoVivienda) {
		this.tipoVivienda = tipoVivienda;
	}

	public DDTipoOrientacion getTipoOrientacion() {
		return tipoOrientacion;
	}

	public void setTipoOrientacion(DDTipoOrientacion tipoOrientacion) {
		this.tipoOrientacion = tipoOrientacion;
	}

	public Integer getUltimaPlanta() {
		return ultimaPlanta;
	}

	public void setUltimaPlanta(Integer ultimaPlanta) {
		this.ultimaPlanta = ultimaPlanta;
	}

	public Integer getNumPlantasInter() {
		return numPlantasInter;
	}

	public void setNumPlantasInter(Integer numPlantasInter) {
		this.numPlantasInter = numPlantasInter;
	}

	public Boolean getReformaCarpInt() {
		return reformaCarpInt;
	}

	public void setReformaCarpInt(Boolean reformaCarpInt) {
		this.reformaCarpInt = reformaCarpInt;
	}

	public Boolean getReformaCarpExt() {
		return reformaCarpExt;
	}

	public void setReformaCarpExt(Boolean reformaCarpExt) {
		this.reformaCarpExt = reformaCarpExt;
	}

	public Boolean getReformaCocina() {
		return reformaCocina;
	}

	public void setReformaCocina(Boolean reformaCocina) {
		this.reformaCocina = reformaCocina;
	}

	public Boolean getReformaBanyo() {
		return reformaBanyo;
	}

	public void setReformaBanyo(Boolean reformaBanyo) {
		this.reformaBanyo = reformaBanyo;
	}

	public Boolean getReformaSuelo() {
		return reformaSuelo;
	}

	public void setReformaSuelo(Boolean reformaSuelo) {
		this.reformaSuelo = reformaSuelo;
	}

	public Boolean getReformaPintura() {
		return reformaPintura;
	}

	public void setReformaPintura(Boolean reformaPintura) {
		this.reformaPintura = reformaPintura;
	}

	public Boolean getReformaIntegral() {
		return reformaIntegral;
	}

	public void setReformaIntegral(Boolean reformaIntegral) {
		this.reformaIntegral = reformaIntegral;
	}

	public Boolean getReformaOtro() {
		return reformaOtro;
	}

	public void setReformaOtro(Boolean reformaOtro) {
		this.reformaOtro = reformaOtro;
	}

	public String getReformaOtroDesc() {
		return reformaOtroDesc;
	}

	public void setReformaOtroDesc(String reformaOtroDesc) {
		this.reformaOtroDesc = reformaOtroDesc;
	}

	public Double getReformaPresupuesto() {
		return reformaPresupuesto;
	}

	public void setReformaPresupuesto(Double reformaPresupuesto) {
		this.reformaPresupuesto = reformaPresupuesto;
	}

	public String getDistribucionTxt() {
		return distribucionTxt;
	}

	public void setDistribucionTxt(String distribucionTxt) {
		this.distribucionTxt = distribucionTxt;
	}
	
	public List<ActivoDistribucion> getDistribucion() {
		return distribucion;
	}

	public void setDistribucion(List<ActivoDistribucion> distribucion) {
		this.distribucion = distribucion;
	}  

}
