package es.pfsgroup.plugin.rem.comisionamiento.dto;

public class RespuestaComisionReglaDto {
	private String id;
	private String leadOrigin;
	private String assetType;
	private String assetSubtype;
	private String offerType;
	private String commissionType;
	private String comercialType;
	private String stretchMin;
	private String stretchMax;
	private String commissionPercentage;
	private String maxCommissionAmount;
	private String minCommissionAmount;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getLeadOrigin() {
		return leadOrigin;
	}
	public void setLeadOrigin(String leadOrigin) {
		this.leadOrigin = leadOrigin;
	}
	public String getAssetType() {
		return assetType;
	}
	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}
	public String getAssetSubtype() {
		return assetSubtype;
	}
	public void setAssetSubtype(String assetSubtype) {
		this.assetSubtype = assetSubtype;
	}
	public String getOfferType() {
		return offerType;
	}
	public void setOfferType(String offerType) {
		this.offerType = offerType;
	}
	public String getCommissionType() {
		return commissionType;
	}
	public void setCommissionType(String commissionType) {
		this.commissionType = commissionType;
	}
	public String getComercialType() {
		return comercialType;
	}
	public void setComercialType(String comercialType) {
		this.comercialType = comercialType;
	}
	public String getStretchMin() {
		return stretchMin;
	}
	public void setStretchMin(String stretchMin) {
		this.stretchMin = stretchMin;
	}
	public String getStretchMax() {
		return stretchMax;
	}
	public void setStretchMax(String stretchMax) {
		this.stretchMax = stretchMax;
	}
	public String getCommissionPercentage() {
		return commissionPercentage;
	}
	public void setCommissionPercentage(String commissionPercentage) {
		this.commissionPercentage = commissionPercentage;
	}
	public String getMaxCommissionAmount() {
		return maxCommissionAmount;
	}
	public void setMaxCommissionAmount(String maxCommissionAmount) {
		this.maxCommissionAmount = maxCommissionAmount;
	}
	public String getMinCommissionAmount() {
		return minCommissionAmount;
	}
	public void setMinCommissionAmount(String minCommissionAmount) {
		this.minCommissionAmount = minCommissionAmount;
	}
	
	
}
