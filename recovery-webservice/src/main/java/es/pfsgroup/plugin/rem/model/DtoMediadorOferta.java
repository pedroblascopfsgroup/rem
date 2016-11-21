package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de la lista de ofertas del mediador.
 *  
 * @author Bender
 */
public class DtoMediadorOferta extends WebDto {

	private static final long serialVersionUID = 3574101002838449106L;

	private Long id;
	private Long idOferta;
	private Long numOferta;	
	private Long idAgrupacion; 
	private Long idActivo;  
	private String codEstadoOferta;
	private String desEstadoOferta;
	private String codTipoOferta;
	private String desTipoOferta;
	private Long idExpediente;
	private Long numExpediente;
	private String codEstadoExpediente;
	private String desEstadoExpediente;
	private String codSubtipoActivo;
	private String desSubtipoActivo;
	private Double importeAprobadoOferta;
	private Long idOfertante;
	private String nombreOfertante;
	
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	public Long getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getCodEstadoOferta() {
		return codEstadoOferta;
	}
	public void setCodEstadoOferta(String codEstadoOferta) {
		this.codEstadoOferta = codEstadoOferta;
	}
	public String getDesEstadoOferta() {
		return desEstadoOferta;
	}
	public void setDesEstadoOferta(String desEstadoOferta) {
		this.desEstadoOferta = desEstadoOferta;
	}
	public String getCodTipoOferta() {
		return codTipoOferta;
	}
	public void setCodTipoOferta(String codTipoOferta) {
		this.codTipoOferta = codTipoOferta;
	}
	public String getDesTipoOferta() {
		return desTipoOferta;
	}
	public void setDesTipoOferta(String desTipoOferta) {
		this.desTipoOferta = desTipoOferta;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	public Long getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}
	public String getCodEstadoExpediente() {
		return codEstadoExpediente;
	}
	public void setCodEstadoExpediente(String codEstadoExpediente) {
		this.codEstadoExpediente = codEstadoExpediente;
	}
	public String getDesEstadoExpediente() {
		return desEstadoExpediente;
	}
	public void setDesEstadoExpediente(String desEstadoExpediente) {
		this.desEstadoExpediente = desEstadoExpediente;
	}
	public String getCodSubtipoActivo() {
		return codSubtipoActivo;
	}
	public void setCodSubtipoActivo(String codSubtipoActivo) {
		this.codSubtipoActivo = codSubtipoActivo;
	}
	public String getDesSubtipoActivo() {
		return desSubtipoActivo;
	}
	public void setDesSubtipoActivo(String desSubtipoActivo) {
		this.desSubtipoActivo = desSubtipoActivo;
	}
	public Double getImporteAprobadoOferta() {
		return importeAprobadoOferta;
	}
	public void setImporteAprobadoOferta(Double importeAprobadoOferta) {
		this.importeAprobadoOferta = importeAprobadoOferta;
	}
	public Long getIdOfertante() {
		return idOfertante;
	}
	public void setIdOfertante(Long idOfertante) {
		this.idOfertante = idOfertante;
	}
	public String getNombreOfertante() {
		return nombreOfertante;
	}
	public void setNombreOfertante(String nombreOfertante) {
		this.nombreOfertante = nombreOfertante;
	}
	
	
}
