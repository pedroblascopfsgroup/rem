package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "VI_LIST_OFERTAS_CES", schema = "${entity.schema}")
public class VListOfertasCES implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "OFR_ID")
	private Long idOferta;
	
	@Column(name = "OFR_NUM_OFERTA")  
	private Long numOferta;
	
	@Column(name = "OFR_FECHA_ALTA")
	private Date fechaAltaOferta;
	
	@Column(name = "ACT_NUM_ACTIVO")  
	private String numActivo;
	
	@Column(name = "ID_CES")  
	private String idServicer;
	
	@Column(name = "ID_SANTANDER")  
	private String idInmuebleBS;
	
	@Column(name = "OFR_IMPORTE")
	private String importeOferta;
	
	@Column(name = "OFR_IMPORTE_CONTRAOFERTA")
	private String importeContraoferta;

	@Column(name = "POS_FECHA_POSICIONAMIENTO")
	private Date fechaPosicionamientoPrevista;
	
	@Column(name = "BIE_DREG_NUM_FINCA")
	private String fincaRegistral;
	
	@Column(name = "CAT_REF_CATASTRAL")
	private String referenciaCatastral;
	
	@Column(name = "BIE_LOC_DIRECCION")
	private String direccion;
	
	@Column(name = "DD_LOC_DESCRIPCION")
	private String localidad;
	
	@Column(name = "DD_PRV_DESCRIPCION")
	private String provincia;
	
	@Column(name = "DD_CCA_DESCRIPCION")
	private String comunidadAutonoma;
	
	@Column(name = "VAL_IMPORTE")
	private String importeVentaActivo;
	
	@Column(name = "N_LEADS")
	private String numeroLeadsActivo;

	@Column(name = "N_OFERTAS")
	private String numeroOfertasActivo;
	
	@Column(name = "N_VISITAS")
	private String numeroVisitasActivo;
	
	@Column(name = "COMPRADORES")
	private String compradoresExpediente;

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

	public Date getFechaAltaOferta() {
		return fechaAltaOferta;
	}

	public void setFechaAltaOferta(Date fechaAltaOferta) {
		this.fechaAltaOferta = fechaAltaOferta;
	}

	public String getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(String importeOferta) {
		this.importeOferta = importeOferta;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getIdServicer() {
		return idServicer;
	}

	public void setIdServicer(String idServicer) {
		this.idServicer = idServicer;
	}

	public String getIdInmuebleBS() {
		return idInmuebleBS;
	}

	public void setIdInmuebleBS(String idInmuebleBS) {
		this.idInmuebleBS = idInmuebleBS;
	}

	public String getImporteContraoferta() {
		return importeContraoferta;
	}

	public void setImporteContraoferta(String importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
	}

	public Date getFechaPosicionamientoPrevista() {
		return fechaPosicionamientoPrevista;
	}

	public void setFechaPosicionamientoPrevista(Date fechaPosicionamientoPrevista) {
		this.fechaPosicionamientoPrevista = fechaPosicionamientoPrevista;
	}

	public String getFincaRegistral() {
		return fincaRegistral;
	}

	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getLocalidad() {
		return localidad;
	}

	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getComunidadAutonoma() {
		return comunidadAutonoma;
	}

	public void setComunidadAutonoma(String comunidadAutonoma) {
		this.comunidadAutonoma = comunidadAutonoma;
	}

	public String getImporteVentaActivo() {
		return importeVentaActivo;
	}

	public void setImporteVentaActivo(String importeVentaActivo) {
		this.importeVentaActivo = importeVentaActivo;
	}

	public String getNumeroLeadsActivo() {
		return numeroLeadsActivo;
	}

	public void setNumeroLeadsActivo(String numeroLeadsActivo) {
		this.numeroLeadsActivo = numeroLeadsActivo;
	}
	
	public String getNumeroOfertasActivo() {
		return numeroOfertasActivo;
	}

	public void setNumeroOfertasActivo(String numeroOfertasActivo) {
		this.numeroOfertasActivo = numeroOfertasActivo;
	}

	public String getNumeroVisitasActivo() {
		return numeroVisitasActivo;
	}

	public void setNumeroVisitasActivo(String numeroVisitasActivo) {
		this.numeroVisitasActivo = numeroVisitasActivo;
	}

	public String getCompradoresExpediente() {
		return compradoresExpediente;
	}

	public void setCompradoresExpediente(String compradoresExpediente) {
		this.compradoresExpediente = compradoresExpediente;
	}

}