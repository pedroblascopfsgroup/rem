package es.pfsgroup.plugin.rem.comisionamiento.dto;

/**
 * DTO para consultar al Microservicio Commission los honorarios
 * 
 * @author mariam.lliso@pfsgroup.es
 *
 */
public class ConsultaComisionDto {
	
	//Nombres de campos del microservicio.
	private String leadOrigin;
	private Double amount;
	private String offerType;
	private String comercialType;
	private String assetType;
	private String assetSubtype;
	private String portfolio;
	private String subPortfolio;
	private String classType;
	private String commissionType;
	private String providerType;
	private String visitPrescriber;
	private String visitMaker;
	private String offerPrescriber;

	public String getLeadOrigin() {
		return leadOrigin;
	}
	public void setLeadOrigin(String leadOrigin) {
		this.leadOrigin = leadOrigin;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public String getOfferType() {
		return offerType;
	}
	public void setOfferType(String offerType) {
		this.offerType = offerType;
	}
	public String getComercialType() {
		return comercialType;
	}
	public void setComercialType(String comercialType) {
		this.comercialType = comercialType;
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
	public String getPortfolio() {
		return portfolio;
	}
	public void setPortfolio(String portfolio) {
		this.portfolio = portfolio;
	}
	public String getSubPortfolio() {
		return subPortfolio;
	}
	public void setSubPortfolio(String subPortfolio) {
		this.subPortfolio = subPortfolio;
	}
	public String getClassType() {
		return classType;
	}
	public void setClassType(String classType) {
		this.classType = classType;
	}
	public String getCommissionType() {
		return commissionType;
	}
	public void setCommissionType(String commissionType) {
		this.commissionType = commissionType;
	}
	public String getProviderType() {
		return providerType;
	}
	public String getVisitPrescriber() {
		return visitPrescriber;
	}
	public String getVisitMaker() {
		return visitMaker;
	}
	public String getOfferPrescriber() {
		return offerPrescriber;
	}
	public void setProviderType(String providerType) {
		this.providerType = providerType;
	}
	public void setVisitPrescriber(String visitPrescriber) {
		this.visitPrescriber = visitPrescriber;
	}
	public void setVisitMaker(String visitMaker) {
		this.visitMaker = visitMaker;
	}
	public void setOfferPrescriber(String offerPrescriber) {
		this.offerPrescriber = offerPrescriber;
	}
	
}