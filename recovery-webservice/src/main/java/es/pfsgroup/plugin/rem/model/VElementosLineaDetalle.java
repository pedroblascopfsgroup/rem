package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "VI_ELEMENTOS_LINEA_DETALLE", schema = "${entity.schema}")
public class VElementosLineaDetalle implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GLD_ENT_ID")
	private Long id;
	
	@Column(name = "GLD_ID")
	private Long idLinea;
	
	@Column(name = "ACTIVO")
	private Long idActivo;
	
	@Column(name = "DESCRIPCION_LINEA")
	private String descripcionLinea;
	
	@Column(name = "GPV_ID")
	private Long idGasto;
	
	@Column(name = "ENTIDAD")
	private String idElemento;
		
	@Column(name = "TIPOENTIDAD_DESC")
	private String tipoElemento;
	
	@Column(name = "TIPOENTIDAD_COD")
	private String tipoElementoCodigo;
	
	@Column(name = "GLD_REFERENCIA_CATASTRAL")
	private String referenciaCatastral;
	
	@Column(name = "GLD_PARTICIPACION_GASTO")
	private Double participacion;
	
	@Column(name = "TIPOACTIVO")
	private String tipoActivo;
	
	@Column(name = "DIRECCION")
	private String direccion;
	
	@Column(name = "IMPORTE_PROPORCIONAL_TOTAL")
	private Double importeProporcinalTotal;
	
	@Column(name = "GLD_IMPORTE_TOTAL")
	private Double importeTotalLinea;
	
	@Column(name = "BBVA_LINEA_FACTURA")
	private String lineaFactura;

	@Column(name = "IMPORTE_SUJETO_TOTAL")
	private Double importeTotalSujetoLinea;
	
	@Column(name = "IMPORTE_PROPORCIONAL_SUJETO")
	private Double importeProporcinalSujeto;
	
	@Column(name = "ESTADOALQ_COD")
	private String estadoAlquilerCodigo;
	
	@Column(name = "ESTADOALQ_DESC")
	private String estadoAlquiler;
	
	@Column(name = "TIPOCOMERC_COD")
	private String tipoComercializacionCodigo;
	
	@Column(name = "TIPOCOMERC_DESC")
	private String tipoComercializacion;
	
	@Column(name = "TIPOTRANS_COD")
	private String tipoTransmisionCodigo;
	
	@Column(name = "TIPOTRANS_DESC")
	private String tipoTransmision;
	
	@Column(name = "GRUPO")
	private String grupo;
	
	@Column(name = "TIPO")
	private String tipo;
	
	@Column(name = "SUBTIPO")
	private String subtipo;
	
	@Column(name = "PRIM_TOMA_POSESION")
	private String primeraPosesion;
	
	@Column(name = "SUBPARTEDIF_COD")
	private String subpartidaEdifCodigo;
	
	@Column(name = "SUBPARTEDIF_DESC")
	private String subpartidaEdif;
	
	@Column(name = "ELEMENTO_PEP")
	private String elementoPep;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdLinea() {
		return idLinea;
	}

	public void setIdLinea(Long idLinea) {
		this.idLinea = idLinea;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getDescripcionLinea() {
		return descripcionLinea;
	}

	public void setDescripcionLinea(String descripcionLinea) {
		this.descripcionLinea = descripcionLinea;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

	public String getIdElemento() {
		return idElemento;
	}

	public void setIdElemento(String idElemento) {
		this.idElemento = idElemento;
	}

	public String getTipoElemento() {
		return tipoElemento;
	}

	public void setTipoElemento(String tipoElemento) {
		this.tipoElemento = tipoElemento;
	}

	public String getTipoElementoCodigo() {
		return tipoElementoCodigo;
	}

	public void setTipoElementoCodigo(String tipoElementoCodigo) {
		this.tipoElementoCodigo = tipoElementoCodigo;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public Double getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Double participacion) {
		this.participacion = participacion;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Double getImporteProporcinalTotal() {
		return importeProporcinalTotal;
	}

	public void setImporteProporcinalTotal(Double importeProporcinalTotal) {
		this.importeProporcinalTotal = importeProporcinalTotal;
	}

	public Double getImporteTotalLinea() {
		return importeTotalLinea;
	}

	public void setImporteTotalLinea(Double importeTotalLinea) {
		this.importeTotalLinea = importeTotalLinea;
	}

	public String getLineaFactura() {
		return lineaFactura;
	}

	public void setLineaFactura(String lineaFactura) {
		this.lineaFactura = lineaFactura;
	}

	public Double getImporteTotalSujetoLinea() {
		return importeTotalSujetoLinea;
	}

	public void setImporteTotalSujetoLinea(Double importeTotalSujetoLinea) {
		this.importeTotalSujetoLinea = importeTotalSujetoLinea;
	}

	public Double getImporteProporcinalSujeto() {
		return importeProporcinalSujeto;
	}

	public void setImporteProporcinalSujeto(Double importeProporcinalSujeto) {
		this.importeProporcinalSujeto = importeProporcinalSujeto;
	}

	public String getEstadoAlquilerCodigo() {
		return estadoAlquilerCodigo;
	}

	public void setEstadoAlquilerCodigo(String estadoAlquilerCodigo) {
		this.estadoAlquilerCodigo = estadoAlquilerCodigo;
	}

	public String getEstadoAlquiler() {
		return estadoAlquiler;
	}

	public void setEstadoAlquiler(String estadoAlquiler) {
		this.estadoAlquiler = estadoAlquiler;
	}

	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}

	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}

	public String getTipoComercializacion() {
		return tipoComercializacion;
	}

	public void setTipoComercializacion(String tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}

	public String getTipoTransmisionCodigo() {
		return tipoTransmisionCodigo;
	}

	public void setTipoTransmisionCodigo(String tipoTransmisionCodigo) {
		this.tipoTransmisionCodigo = tipoTransmisionCodigo;
	}

	public String getTipoTransmision() {
		return tipoTransmision;
	}

	public void setTipoTransmision(String tipoTransmision) {
		this.tipoTransmision = tipoTransmision;
	}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getSubtipo() {
		return subtipo;
	}

	public void setSubtipo(String subtipo) {
		this.subtipo = subtipo;
	}

	public String getPrimeraPosesion() {
		return primeraPosesion;
	}

	public void setPrimeraPosesion(String primeraPosesion) {
		this.primeraPosesion = primeraPosesion;
	}

	public String getSubpartidaEdifCodigo() {
		return subpartidaEdifCodigo;
	}

	public void setSubpartidaEdifCodigo(String subpartidaEdifCodigo) {
		this.subpartidaEdifCodigo = subpartidaEdifCodigo;
	}

	public String getSubpartidaEdif() {
		return subpartidaEdif;
	}

	public void setSubpartidaEdif(String subpartidaEdif) {
		this.subpartidaEdif = subpartidaEdif;
	}

	public String getElementoPep() {
		return elementoPep;
	}

	public void setElementoPep(String elementoPep) {
		this.elementoPep = elementoPep;
	}

}
