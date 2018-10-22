package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_LISTADO_ACT_EXP", schema = "${entity.schema}")
public class VListadoActivosExpediente implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "ID_VISTA")  
	private Long id;	
	
	@Column(name = "ECO_ID")
	private Long idExpediente;
	
	@Column(name = "ACT_ID")  
	private Long idActivo;
	
	@Column(name = "PORCENTAJE_PARTICIPACION")  
	private Double porcentajeParticipacion;
	
	@Column(name = "IMP_ACT_OFERTA")
	private Double importeParticipacion;
	
	@Column(name = "IMPORTE_TPC_APR")
	private Double precioAprobadoVenta;

	@Column(name = "CODIGO_APR")
	private String codigoTipoPrecioAprobado;
	
	@Column(name = "IMPORTE_TPC_MIN")
	private Double precioMinimo;

	@Column(name = "CODIGO_MIN")
	private String codigoTipoPrecioMinimo;
	
	@Column(name = "BLOQUEO")
	private Integer bloqueos;

	@Column(name = "CONDICIONES")
	private Integer condiciones;
	
	@Column(name = "CONDICIONANTE")
	private Integer tanteos;
	
	@Column(name = "ACT_NUM_ACTIVO")
	private String numActivo;
	
	@Column(name = "DD_TPA_DESCRIPCION")
	private String tipoActivo;
	
	@Column(name = "DD_SAC_DESCRIPCION")
	private String subtipoActivo;
	
	@Column(name = "DD_LOC_DESCRIPCION")
	private String municipio;
	
	@Column(name = "DD_PRV_DESCRIPCION")
	private String provincia;
	
	@Column(name = "BIE_DREG_NUM_FINCA")
	private String fincaRegistral;
	
	@Column(name = "BIE_LOC_DIRECCION")
	private String direccion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Double getPorcentajeParticipacion() {
		return porcentajeParticipacion;
	}

	public void setPorcentajeParticipacion(Double porcentajeParticipacion) {
		this.porcentajeParticipacion = porcentajeParticipacion;
	}

	public Double getImporteParticipacion() {
		return importeParticipacion;
	}

	public void setImporteParticipacion(Double importeParticipacion) {
		this.importeParticipacion = importeParticipacion;
	}

	public Double getPrecioAprobadoVenta() {
		return precioAprobadoVenta;
	}

	public void setPrecioAprobadoVenta(Double precioAprobadoVenta) {
		this.precioAprobadoVenta = precioAprobadoVenta;
	}

	public String getCodigoTipoPrecioAprobado() {
		return codigoTipoPrecioAprobado;
	}

	public void setCodigoTipoPrecioAprobado(String codigoTipoPrecioAprobado) {
		this.codigoTipoPrecioAprobado = codigoTipoPrecioAprobado;
	}

	public Double getPrecioMinimo() {
		return precioMinimo;
	}

	public void setPrecioMinimo(Double precioMinimo) {
		this.precioMinimo = precioMinimo;
	}

	public String getCodigoTipoPrecioMinimo() {
		return codigoTipoPrecioMinimo;
	}

	public void setCodigoTipoPrecioMinimo(String codigoTipoPrecioMinimo) {
		this.codigoTipoPrecioMinimo = codigoTipoPrecioMinimo;
	}

	public Integer getBloqueos() {
		return bloqueos;
	}

	public void setBloqueos(Integer bloqueos) {
		this.bloqueos = bloqueos;
	}

	public Integer getCondiciones() {
		return condiciones;
	}

	public void setCondiciones(Integer condiciones) {
		this.condiciones = condiciones;
	}

	public Integer getTanteos() {
		return tanteos;
	}

	public void setTanteos(Integer tanteos) {
		this.tanteos = tanteos;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getFincaRegistral() {
		return fincaRegistral;
	}

	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
		
}