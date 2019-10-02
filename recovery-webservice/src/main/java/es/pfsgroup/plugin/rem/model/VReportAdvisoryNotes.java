package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_REPORT_AN", schema = "${entity.schema}")
public class VReportAdvisoryNotes implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "ID_VISTA")  
	private String id;	
	
	@Column(name = "FECHA_EMISION")
	private Date fechaEmision;
	
	@Column(name = "OFR_NUM_OFERTA")
	private Long numOferta;
	
	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name = "ACT_NUM_ACTIVO_SAN")
	private String idSantander;
	
	@Column(name = "DD_SAC_DESCRIPCION_TRADUCIDA")
	private String subtipoActivo;
	
	@Column(name = "BIE_LOC_DIRECCION")
	private String direccion;
	
    @Column(name = "DD_LOC_DESCRIPCION")
    private String municipio;
    
    @Column(name = "DD_PRV_DESCRIPCION")
    private String provincia;
    
    @Column(name = "BIE_DREG_SUPERFICIE_CONSTRUIDA")
    private Long superficieConstruida;
    
    @Column(name = "VAL_IMPORTE")
    private Double importe;
    
    @Column(name = "ACT_OFR_IMPORTE")
    private Double importeParticipacionActivo;
    
    @Column(name = "PUBLICADO")
    private String publicado;
    
    @Column(name = "PVE_NOMBRE_COMERCIAL")
    private String nombrePrescriptor;
    
    @Column(name = "ICO_ANO_CONSTRUCCION")
    private String anyoConstruccion;
    
    @Column(name = "LOC_LATITUD")
    private Double latitud;
    
    @Column(name = "LOC_LONGITUD")
    private Double longitud;
    
    @Column(name = "OCUPADO")
    private String ocupado;
    
    @Column(name = "SEGUNDA_MANO")
    private String segundaMano;
    
    @Column(name = "DD_ECV_DESCRIPCION_TRADUCIDA")
    private String estadoConservacion;
    
    @Column(name = "NUM_OFERTAS_ACT")
    private Long numOfertasActivo;
    
    @Column(name = "NUM_VISITAS_ACT")
    private Long numVisitasActivo;
    
    @Column(name = "DD_EAL_DESCRIPCION")
    private String estadoAqluiler;
    
    @Column(name = "DD_TAL_DESCRIPCION")
    private String tipoAlquiler;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
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

	public Long getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Long superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Double getImporteParticipacionActivo() {
		return importeParticipacionActivo;
	}

	public void setImporteParticipacionActivo(Double importeParticipacionActivo) {
		this.importeParticipacionActivo = importeParticipacionActivo;
	}

	public String getPublicado() {
		return publicado;
	}

	public void setPublicado(String publicado) {
		this.publicado = publicado;
	}

	public String getNombrePrescriptor() {
		return nombrePrescriptor;
	}

	public void setNombrePrescriptor(String nombrePrescriptor) {
		this.nombrePrescriptor = nombrePrescriptor;
	}

	public String getAnyoConstruccion() {
		return anyoConstruccion;
	}

	public void setAnyoConstruccion(String anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}

	public Double getLatitud() {
		return latitud;
	}

	public void setLatitud(Double latitud) {
		this.latitud = latitud;
	}

	public Double getLongitud() {
		return longitud;
	}

	public void setLongitud(Double longitud) {
		this.longitud = longitud;
	}

	public String getOcupado() {
		return ocupado;
	}

	public void setOcupado(String ocupado) {
		this.ocupado = ocupado;
	}

	public String getSegundaMano() {
		return segundaMano;
	}

	public void setSegundaMano(String segundaMano) {
		this.segundaMano = segundaMano;
	}

	public String getEstadoConservacion() {
		return estadoConservacion;
	}

	public void setEstadoConservacion(String estadoConservacion) {
		this.estadoConservacion = estadoConservacion;
	}

	public Long getNumOfertasActivo() {
		return numOfertasActivo;
	}

	public void setNumOfertasActivo(Long numOfertasActivo) {
		this.numOfertasActivo = numOfertasActivo;
	}

	public Long getNumVisitasActivo() {
		return numVisitasActivo;
	}

	public void setNumVisitasActivo(Long numVisitasActivo) {
		this.numVisitasActivo = numVisitasActivo;
	}

	public String getEstadoAqluiler() {
		return estadoAqluiler;
	}

	public void setEstadoAqluiler(String estadoAqluiler) {
		this.estadoAqluiler = estadoAqluiler;
	}

	public String getTipoAlquiler() {
		return tipoAlquiler;
	}

	public void setTipoAlquiler(String tipoAlquiler) {
		this.tipoAlquiler = tipoAlquiler;
	}

	public String getIdSantander() {
		return idSantander;
	}

	public void setIdSantander(String idSantander) {
		this.idSantander = idSantander;
	}
    
    

		
}