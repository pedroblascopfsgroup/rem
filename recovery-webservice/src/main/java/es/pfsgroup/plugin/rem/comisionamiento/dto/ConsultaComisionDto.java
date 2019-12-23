package es.pfsgroup.plugin.rem.comisionamiento.dto;

/**
 * DTO para consultar al Microservicio Commission los honorarios
 * 
 * @author mariam.lliso@pfsgroup.es
 *
 */
public class ConsultaComisionDto {

	private String codTipoOferta;
	private Double importeOferta;
	private String codTipoActivo;
	private String codSubtipoActivo;
	private String codTipoComercializar; 
	private String codLeadOrigin;
	
	public String getCodTipoOferta() {
		return codTipoOferta;
	}
	public void setCodTipoOferta(String codTipoOferta) {
		this.codTipoOferta = codTipoOferta;
	}
	public Double getImporteOferta() {
		return importeOferta;
	}
	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}
	public String getCodTipoActivo() {
		return codTipoActivo;
	}
	public void setCodTipoActivo(String codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}
	public String getCodSubtipoActivo() {
		return codSubtipoActivo;
	}
	public void setCodSubtipoActivo(String codSubtivoActivo) {
		this.codSubtipoActivo = codSubtivoActivo;
	}
	public String getCodTipoComercializar() {
		return codTipoComercializar;
	}
	public void setCodTipoComercializar(String codTipoComercializar) {
		this.codTipoComercializar = codTipoComercializar;
	}
	public String getCodLeadOrigin() {
		return codLeadOrigin;
	}
	public void setCodLeadOrigin(String codLeadOrigin) {
		this.codLeadOrigin = codLeadOrigin;
	}	
	
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
	private String commisionType;
	private String providerType;

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
	public String getCommisionType() {
		return commisionType;
	}
	public void setCommisionType(String commisionType) {
		this.commisionType = commisionType;
	}
	public String getProviderType() {
		return providerType;
	}
	public void setProviderType(String providerType) {
		this.providerType = providerType;
	}
	
}