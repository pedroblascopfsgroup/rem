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
	private String codSubtivoActivo;
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
	public String getCodSubtivoActivo() {
		return codSubtivoActivo;
	}
	public void setCodSubtivoActivo(String codSubtivoActivo) {
		this.codSubtivoActivo = codSubtivoActivo;
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
}