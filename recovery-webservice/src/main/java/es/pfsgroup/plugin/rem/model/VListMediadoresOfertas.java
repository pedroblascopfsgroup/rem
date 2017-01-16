package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_LIST_MEDIADORES_OFERTAS", schema = "${entity.schema}")
public class VListMediadoresOfertas implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 101L;


	@Id
	@Column(name = "ID_MEDIADOR")
	private Long id;
	
	@Column(name = "ID_OFERTA")
	private Long idOferta;
	
	@Column(name = "NUM_OFERTA")
	private Long numOferta;	
	
	@Column(name = "ID_AGRUPACION")
	private Long idAgrupacion;

	@Column(name = "NUM_AGRUPACION")
	private Long numAgrupacion;
	
	@Column(name = "ID_ACTIVO")
	private Long idActivo;

	@Column(name = "NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name = "COD_ESTADO_OFERTA")
    private String codEstadoOferta;

	@Column(name = "DES_ESTADO_OFERTA")
    private String desEstadoOferta;
	
	@Column(name = "COD_TIPO_OFERTA")
   	private String codTipoOferta;

	@Column(name = "DES_TIPO_OFERTA")
   	private String desTipoOferta;
	
	@Column(name = "ID_EXPEDIENTE")
	private Long idExpediente;
	
	@Column(name= "NUM_EXPEDIENTE")
	private Long numExpediente;

	@Column(name = "COD_ESTADO_EXPEDIENTE")
	private String codEstadoExpediente;

	@Column(name = "DES_ESTADO_EXPEDIENTE")
	private String desEstadoExpediente;
	
	@Column(name = "COD_SUBTIPO_ACTIVO")
   	private String codSubtipoActivo;

	@Column(name = "DES_SUBTIPO_ACTIVO")
   	private String desSubtipoActivo;
	
	@Column(name = "IMPORTE_OFERTA")
	private Double importeAprobadoOferta;
	
	@Column(name= "ID_OFERTANTE")
	private Long idOfertante;
	
	@Column(name = "NOMBRE_OFERTANTE")
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

	public Long getNumAgrupacion() {
		return numAgrupacion;
	}

	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}	
	
	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	
	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
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