package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_BUSQUEDA_GASTOS_ACTIVOS", schema = "${entity.schema}")
public class VBusquedaGastoActivo implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "GPV_ACT_ID")
	private Long id;
		
	@Column(name = "GPV_ID")
	private Long idGasto;

	@Column(name = "ACT_ID")
	private Long idActivo;

	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;

	@Column(name = "DIRECCION")
	private String direccion;

	@Column(name = "GPV_PARTICIPACION_GASTO")
	private Double participacionGasto;

	@Column(name = "IMPORTE_PROPORCIONAL_TOTAL")
	private Double importeProporcinalTotal;

	@Column(name = "REFERENCIAS")
	private String referenciasCatastrales;
	
	@Column(name="DD_SAC_CODIGO")
	private String subtipoCodigo;
	
	@Column(name="DD_SAC_DESCRIPCION")
	private String subtipoDescripcion;
	
	@Column(name="GPV_REFERENCIA_CATASTRAL")
	private String referenciaCatastral;
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
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
	
	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Double getParticipacionGasto() {
		return participacionGasto;
	}

	public void setParticipacionGasto(Double participacionGasto) {
		this.participacionGasto = participacionGasto;
	}

	public Double getImporteProporcinalTotal() {
		return importeProporcinalTotal;
	}

	public void setImporteProporcinalTotal(Double importeProporcinalTotal) {
		this.importeProporcinalTotal = importeProporcinalTotal;
	}

	public String getReferenciasCatastrales() {
		return referenciasCatastrales;
	}

	public void setReferenciasCatastrales(String referenciasCatastrales) {
		this.referenciasCatastrales = referenciasCatastrales;
	}

	public String getSubtipoCodigo() {
		return subtipoCodigo;
	}

	public void setSubtipoCodigo(String subtipoCodigo) {
		this.subtipoCodigo = subtipoCodigo;
	}

	public String getSubtipoDescripcion() {
		return subtipoDescripcion;
	}

	public void setSubtipoDescripcion(String subtipoDescripcion) {
		this.subtipoDescripcion = subtipoDescripcion;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	

}