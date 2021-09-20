package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import javax.persistence.Column;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los datos básicos de las garantias de un expediente.
 *  
 * @author Sergio Gomez
 *
 */
public class DtoGarantiasExpediente extends WebDto {

	private static final long serialVersionUID = 3574353502838449106L;
	

	
	
	
	private Long idGarantias;
	private Boolean scoring;
	private String resultadoHayaDesc;
	private String resultadoHayaCod;
	private Date fechaSancion;
	private Long numeroExpediente;
	private String resultadoPropiedadDesc;
	private String resultadoPropiedadCod;
	private String motivoRechazo;
	private String motivoRechazoCod;
	private String ratingHayaDesc;
	private String ratingHayaCod;
	private Boolean aval;
	private String avalista;
	private String documento; //TODO mirad si Long o Strng
	private String entidadBancariaCod;
	private String entidadBancariaDesc;
	private Long mesesAval;
	private Double importeAval; //TODO mirad si DOuble o Float
	private Date fechaVencimiento;
	private Boolean seguroRentas;
	private String aseguradoraCod;
	private String aseguradoraDesc;
	private Date fechaSancionRentas;
	private Long mesesRentas;
	private Double importeRentas;
	private Boolean scoringEditable;
	
	public Long getIdGarantias() {
		return idGarantias;
	}
	public void setIdGarantias(Long idGarantias) {
		this.idGarantias = idGarantias;
	}
	public Boolean getScoring() {
		return scoring;
	}
	public void setScoring(Boolean scoring) {
		this.scoring = scoring;
	}
	public String getResultadoHayaDesc() {
		return resultadoHayaDesc;
	}
	public void setResultadoHayaDesc(String resultadoHayaDesc) {
		this.resultadoHayaDesc = resultadoHayaDesc;
	}
	public String getResultadoHayaCod() {
		return resultadoHayaCod;
	}
	public void setResultadoHayaCod(String resultadoHayaCod) {
		this.resultadoHayaCod = resultadoHayaCod;
	}
	public Date getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	public Long getNumeroExpediente() {
		return numeroExpediente;
	}
	public void setNumeroExpediente(Long numeroExpediente) {
		this.numeroExpediente = numeroExpediente;
	}
	public String getResultadoPropiedadDesc() {
		return resultadoPropiedadDesc;
	}
	public void setResultadoPropiedadDesc(String resultadoPropiedadDesc) {
		this.resultadoPropiedadDesc = resultadoPropiedadDesc;
	}
	public String getResultadoPropiedadCod() {
		return resultadoPropiedadCod;
	}
	public void setResultadoPropiedadCod(String resultadoPropiedadCod) {
		this.resultadoPropiedadCod = resultadoPropiedadCod;
	}
	public String getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public String getMotivoRechazoCod() {
		return motivoRechazoCod;
	}
	public void setMotivoRechazoCod(String motivoRechazoCod) {
		this.motivoRechazoCod = motivoRechazoCod;
	}
	public String getRatingHayaDesc() {
		return ratingHayaDesc;
	}
	public void setRatingHayaDesc(String ratingHayaDesc) {
		this.ratingHayaDesc = ratingHayaDesc;
	}
	public String getRatingHayaCod() {
		return ratingHayaCod;
	}
	public void setRatingHayaCod(String ratingHayaCod) {
		this.ratingHayaCod = ratingHayaCod;
	}
	public Boolean getAval() {
		return aval;
	}
	public void setAval(Boolean aval) {
		this.aval = aval;
	}
	public String getAvalista() {
		return avalista;
	}
	public void setAvalista(String avalista) {
		this.avalista = avalista;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}
	public String getEntidadBancariaCod() {
		return entidadBancariaCod;
	}
	public void setEntidadBancariaCod(String entidadBancariaCod) {
		this.entidadBancariaCod = entidadBancariaCod;
	}
	public String getEntidadBancariaDesc() {
		return entidadBancariaDesc;
	}
	public void setEntidadBancariaDesc(String entidadBancariaDesc) {
		this.entidadBancariaDesc = entidadBancariaDesc;
	}
	public Long getMesesAval() {
		return mesesAval;
	}
	public void setMesesAval(Long mesesAval) {
		this.mesesAval = mesesAval;
	}
	public Double getImporteAval() {
		return importeAval;
	}
	public void setImporteAval(Double importeAval) {
		this.importeAval = importeAval;
	}
	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public Boolean getSeguroRentas() {
		return seguroRentas;
	}
	public void setSeguroRentas(Boolean seguroRentas) {
		this.seguroRentas = seguroRentas;
	}
	public String getAseguradoraCod() {
		return aseguradoraCod;
	}
	public void setAseguradoraCod(String aseguradoraCod) {
		this.aseguradoraCod = aseguradoraCod;
	}
	public String getAseguradoraDesc() {
		return aseguradoraDesc;
	}
	public void setAseguradoraDesc(String aseguradoraDesc) {
		this.aseguradoraDesc = aseguradoraDesc;
	}
	public Date getFechaSancionRentas() {
		return fechaSancionRentas;
	}
	public void setFechaSancionRentas(Date fechaSancionRentas) {
		this.fechaSancionRentas = fechaSancionRentas;
	}
	public Long getMesesRentas() {
		return mesesRentas;
	}
	public void setMesesRentas(Long mesesRentas) {
		this.mesesRentas = mesesRentas;
	}
	public Double getImporteRentas() {
		return importeRentas;
	}
	public void setImporteRentas(Double importeRentas) {
		this.importeRentas = importeRentas;
	}
	public Boolean getScoringEditable() {
		return scoringEditable;
	}
	public void setScoringEditable(Boolean scoringEditable) {
		this.scoringEditable = scoringEditable;
	}
	
	
	
}
