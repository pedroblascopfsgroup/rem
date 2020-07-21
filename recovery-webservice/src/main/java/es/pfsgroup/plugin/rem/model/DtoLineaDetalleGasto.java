package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un una línea de detalle de un gasto
 *  
 * @author Lara Pablo
 */
public class DtoLineaDetalleGasto extends WebDto {
	

	private static final long serialVersionUID = 1L;
	

	 private Long id;  //Id de línea detalle gasto
	
	 private Long idGasto;
	 
	 private String subtipoGasto;  

	 private Double baseSujeta;  

	 private Double baseNoSujeta;  

	 private Double recargo;  

	 private String tipoRecargo;  

	 private Double interes;  

	 private Double costas;  

	 private Double otros;  

	 private Double provSupl;  

	 private String tipoImpuesto;  

	 private Double operacionExentaImp;  

	 private Boolean esRenunciaExenta;  

	 private Boolean esTipoImpositivo;  

	 private Double cuota;  

	 private Double importeTotal;  

	 private String ccBase;  

	 private String ppBase;  

	 private String ccEsp;  

	 private String ppEsp;  

	 private String ccTasas;  

	 private String ppTasas;  

	 private String ccRecargo;  

	 private String ppRecargo;  

	 private String ccInteres;  

	 private String ppInteres;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

	public String getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(String subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public Double getBaseSujeta() {
		return baseSujeta;
	}

	public void setBaseSujeta(Double baseSujeta) {
		this.baseSujeta = baseSujeta;
	}

	public Double getBaseNoSujeta() {
		return baseNoSujeta;
	}

	public void setBaseNoSujeta(Double baseNoSujeta) {
		this.baseNoSujeta = baseNoSujeta;
	}

	public Double getRecargo() {
		return recargo;
	}

	public void setRecargo(Double recargo) {
		this.recargo = recargo;
	}

	public String getTipoRecargo() {
		return tipoRecargo;
	}

	public void setTipoRecargo(String tipoRecargo) {
		this.tipoRecargo = tipoRecargo;
	}

	public Double getInteres() {
		return interes;
	}

	public void setInteres(Double interes) {
		this.interes = interes;
	}

	public Double getCostas() {
		return costas;
	}

	public void setCostas(Double costas) {
		this.costas = costas;
	}

	public Double getOtros() {
		return otros;
	}

	public void setOtros(Double otros) {
		this.otros = otros;
	}

	public Double getProvSupl() {
		return provSupl;
	}

	public void setProvSupl(Double provSupl) {
		this.provSupl = provSupl;
	}

	public String getTipoImpuesto() {
		return tipoImpuesto;
	}

	public void setTipoImpuesto(String tipoImpuesto) {
		this.tipoImpuesto = tipoImpuesto;
	}

	public Double getOperacionExentaImp() {
		return operacionExentaImp;
	}

	public void setOperacionExentaImp(Double operacionExentaImp) {
		this.operacionExentaImp = operacionExentaImp;
	}

	public Boolean getEsRenunciaExenta() {
		return esRenunciaExenta;
	}

	public void setEsRenunciaExenta(Boolean esRenunciaExenta) {
		this.esRenunciaExenta = esRenunciaExenta;
	}

	public Boolean getEsTipoImpositivo() {
		return esTipoImpositivo;
	}

	public void setEsTipoImpositivo(Boolean esTipoImpositivo) {
		this.esTipoImpositivo = esTipoImpositivo;
	}

	public Double getCuota() {
		return cuota;
	}

	public void setCuota(Double cuota) {
		this.cuota = cuota;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public String getCcBase() {
		return ccBase;
	}

	public void setCcBase(String ccBase) {
		this.ccBase = ccBase;
	}

	public String getPpBase() {
		return ppBase;
	}

	public void setPpBase(String ppBase) {
		this.ppBase = ppBase;
	}

	public String getCcEsp() {
		return ccEsp;
	}

	public void setCcEsp(String ccEsp) {
		this.ccEsp = ccEsp;
	}

	public String getPpEsp() {
		return ppEsp;
	}

	public void setPpEsp(String ppEsp) {
		this.ppEsp = ppEsp;
	}

	public String getCcTasas() {
		return ccTasas;
	}

	public void setCcTasas(String ccTasas) {
		this.ccTasas = ccTasas;
	}

	public String getPpTasas() {
		return ppTasas;
	}

	public void setPpTasas(String ppTasas) {
		this.ppTasas = ppTasas;
	}

	public String getCcRecargo() {
		return ccRecargo;
	}

	public void setCcRecargo(String ccRecargo) {
		this.ccRecargo = ccRecargo;
	}

	public String getPpRecargo() {
		return ppRecargo;
	}

	public void setPpRecargo(String ppRecargo) {
		this.ppRecargo = ppRecargo;
	}

	public String getCcInteres() {
		return ccInteres;
	}

	public void setCcInteres(String ccInteres) {
		this.ccInteres = ccInteres;
	}

	public String getPpInteres() {
		return ppInteres;
	}

	public void setPpInteres(String ppInteres) {
		this.ppInteres = ppInteres;
	}
	 
	
	
   	
}
