package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;


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
		
	@Column(name = "ID_ACTIVO")
	private Long idActivo;  
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "EOF_ESTADO_OFERTA")
    private DDEstadoOferta estadoOferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TOF_TIPO_OFERTA")
   	private DDTipoOferta tipoOferta;

	@Column(name = "ID_EXPEDIENTE")
	private Long idExpediente;
	
	@Column(name= "NUM_EXPEDIENTE")
	private Long numExpediente;
	
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "EEC_ESTADO_EXPEDIENTE")
	private DDEstadoExpediente estadoExpediente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SAC_SUBTIPO_ACTIVO")
   	private DDSubtipoActivo subtipoActivo;

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

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public DDEstadoOferta getEstadoOferta() {
		return estadoOferta;
	}

	public void setEstadoOferta(DDEstadoOferta estadoOferta) {
		this.estadoOferta = estadoOferta;
	}

	public DDTipoOferta getTipoOferta() {
		return tipoOferta;
	}

	public void setTipoOferta(DDTipoOferta tipoOferta) {
		this.tipoOferta = tipoOferta;
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

	public DDEstadoExpediente getEstadoExpediente() {
		return estadoExpediente;
	}

	public void setEstadoExpediente(DDEstadoExpediente estadoExpediente) {
		this.estadoExpediente = estadoExpediente;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
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