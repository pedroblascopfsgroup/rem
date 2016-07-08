package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_BUSQUEDA_ACTIVOS", schema = "${entity.schema}")
public class VBusquedaActivos implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "ACT_ID")
	private String id;
    
    /*@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo subtipoActivo;*/
	
	@Column(name="SUBTIPOACTIVOCODIGO")
	private String subtipoActivoCodigo;
	
	@Column(name="SUBTIPOACTIVODESCRIPCION")
	private String subtipoActivoDescripcion;
	
	@Column(name="TIPOACTIVODESCRIPCION")
	private String tipoActivoDescripcion;
	
	@Column(name="TIPOACTIVOCODIGO")
	private String tipoActivoCodigo;
	
	@Column(name = "ACT_NUM_ACTIVO")
	private String numActivo;

	@Column(name = "ACT_NUM_ACTIVO_REM")
	private String numActivoRem;
	
	/*@ManyToOne
	@JoinColumn(name = "DD_EAC_ID")
	private DDEstadoActivo estadoActivo;*/
	@Column(name="ESTADOACTIVOCODIGO")
	private String estadoActivoCodigo;

	 @Column(name = "ACT_NUM_ACTIVO_UVEM")
   	private Long numActivoUvem;
    
    @Column(name = "ACT_NUM_ACTIVO_SAREB")
   	private String numActivoSareb;
    
    @Column(name = "ACT_NUM_ACTIVO_PRINEX")
   	private Long numActivoPrinex;
    
    @Column(name = "ACT_RECOVERY_ID")
   	private Long idRecovery;
	
	/*@OneToOne
    @JoinColumn(name = "DD_TTA_ID")
	private DDTipoTituloActivo tipoTituloActivo;*/
    @Column(name = "TIPOTITULOACTIVOCODIGO")
    private String tipoTituloActivoCodigo;
    
    @Column(name = "TIPOTITULOACTIVODESCRIPCION")
    private String tipoTituloActivoDescripcion;
	
	/*@OneToOne
    @JoinColumn(name = "DD_ENP_ID")
	private DDEntidadPropietaria entidadPropietaria;*/
    @Column(name = "ENTIDADPROPIETARIACODIGO")
    private String entidadPropietariaCodigo;
    
    @Column(name = "ENTIDADPROPIETARIADESCRIPCION")
    private String entidadPropietariaDescripcion;
	
	

	
	@Column(name = "REFERENCIA_CATASTRAL")
	private String refCatastral;
	
	@Column(name = "BIE_DREG_NUM_FINCA")
	private String finca;

	/*@ManyToOne
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;*/
	@Column(name = "LOCALIDADCODIGO")
	private String localidadCodigo;
	
	@Column(name = "LOCALIDADDESCRIPCION")
	private String localidadDescripcion;
	
	@Column(name = "PROVINCIACODIGO")
	private String provinciaCodigo;
	
	@Column(name = "PROVINCIADESCRIPCION")
	private String provinciaDescripcion;
	
	
	/*@ManyToOne
	@JoinColumn(name="DD_UPO_ID")
	private DDUnidadPoblacional unidadPoblacional;*/
		
	@Column(name="PAISCODIGO")
	private String paisCodigo;
	
	@Column(name="PAISDESCRIPCION")
	private String paisDescripcion;
	
	

	@Column(name="BIE_LOC_COD_POST")
	private String codPostal;
	
	/*@ManyToOne
	@JoinColumn(name="DD_TVI_ID")
	private DDTipoVia tipoVia;*/
	@Column(name="TIPOVIACODIGO")
	private String tipoViaCodigo;
	
	
	@Column(name="BIE_LOC_NOMBRE_VIA")
	private String nombreVia;
	
	@Column(name = "TOKEN_GMAPS")
	private String tokenGmaps;
	
	/*@Column(name = "FLAG_ADMISION")
	private String flagAdmision;
	
	@Column(name = "FLAG_GESTION")
	private String flagGestion;
	
	@Column(name = "FLAG_PRECIO")
	private String flagPrecio;
	
	@Column(name = "FLAG_PUBLICACIONES")
	private String flagPublicaciones;
	
	@Column(name = "FLAG_COMERCIALIZAR")
	private String flagComercializar;*/
	@Column(name = "ACT_ADMISION")
	private Boolean admision;
	
	@Column(name = "ACT_GESTION")
	private Boolean gestion;
	
	@Column(name = "ACT_SELLO_CALIDAD")
	private Boolean selloCalidad;
	
	@Column(name = "FLAG_RATING")
	private String flagRating;

	
	@Column(name = "REG_IDUFIR")
	private String idufir;
	
	@Column(name="BIE_DREG_NUM_REGISTRO")
	private String numRegistro;
	
	/*@OneToOne
	@JoinColumn(name="LOCALIDADREGISTRODESCRIPCION")
	private Localidad localidadRegistro;*/
	
	@Column(name="LOCALIDADREGISTRODESCRIPCION")
	private String localidadRegistroDescripcion;
	
	@Column(name = "SPS_OCUPADO")
	private Integer ocupado;
	
	@Column(name = "SPS_CON_TITULO")
	private Integer conTitulo;
	
	@Column(name= "DD_SCM_DESCRIPCION")
	private String situacionComercial;
	
	@Column(name="LOC_LATITUD")
	private String latitud;
	
	@Column(name="LOC_LONGITUD")
	private String longitud;
	
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public String getNumActivoSareb() {
		return numActivoSareb;
	}

	public void setNumActivoSareb(String numActivoSareb) {
		this.numActivoSareb = numActivoSareb;
	}

	public Long getNumActivoPrinex() {
		return numActivoPrinex;
	}

	public void setNumActivoPrinex(Long numActivoPrinex) {
		this.numActivoPrinex = numActivoPrinex;
	}

	public String getRefCatastral() {
		return refCatastral;
	}

	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}

	public String getFinca() {
		return finca;
	}

	public void setFinca(String finca) {
		this.finca = finca;

	}

	public String getTokenGmaps() {
		return tokenGmaps;
	}

	public void setTokenGmaps(String tokenGmaps) {
		this.tokenGmaps = tokenGmaps;
	}

	public Boolean getAdmision() {
		return admision;
	}

	public void setAdmision(Boolean admision) {
		this.admision = admision;
	}

	public Boolean getGestion() {
		return gestion;
	}

	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}

	/*public String getFlagAdmision() {
		return flagAdmision;
	}

	public void setFlagAdmision(String flagAdmision) {
		this.flagAdmision = flagAdmision;
	}

	public String getFlagGestion() {
		return flagGestion;
	}

	public void setFlagGestion(String flagGestion) {
		this.flagGestion = flagGestion;
	}

	public String getFlagPrecio() {
		return flagPrecio;
	}

	public void setFlagPrecio(String flagPrecio) {
		this.flagPrecio = flagPrecio;
	}

	public String getFlagPublicaciones() {
		return flagPublicaciones;
	}

	public void setFlagPublicaciones(String flagPublicaciones) {
		this.flagPublicaciones = flagPublicaciones;
	}

	public String getFlagComercializar() {
		return flagComercializar;
	}

	public void setFlagComercializar(String flagComercializar) {
		this.flagComercializar = flagComercializar;
	}
*/
	public String getFlagRating() {
		return flagRating;
	}

	public void setFlagRating(String flagRating) {
		this.flagRating = flagRating;
	}

	public Long getNumActivoUvem() {
		return numActivoUvem;
	}

	public void setNumActivoUvem(Long numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}

	public Long getIdRecovery() {
		return idRecovery;
	}

	public void setIdRecovery(Long idRecovery) {
		this.idRecovery = idRecovery;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}
	
	public String getIdufir() {
		return idufir;
	}

	public void setIdufir(String idufir) {
		this.idufir = idufir;
	}

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public Integer getOcupado() {
		return ocupado;
	}

	public void setOcupado(Integer ocupado) {
		this.ocupado = ocupado;
	}

	public Integer getConTitulo() {
		return conTitulo;
	}

	public void setConTitulo(Integer conTitulo) {
		this.conTitulo = conTitulo;
	}

	public String getPaisCodigo() {
		return paisCodigo;
	}

	public void setPaisCodigo(String paisCodigo) {
		this.paisCodigo = paisCodigo;
	}

	public String getPaisDescripcion() {
		return paisDescripcion;
	}

	public void setPaisDescripcion(String paisDescripcion) {
		this.paisDescripcion = paisDescripcion;
	}

	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}

	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}

	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}

	public String getTipoTituloActivoCodigo() {
		return tipoTituloActivoCodigo;
	}

	public void setTipoTituloActivoCodigo(String tipoTituloActivoCodigo) {
		this.tipoTituloActivoCodigo = tipoTituloActivoCodigo;
	}

	public String getTipoTituloActivoDescripcion() {
		return tipoTituloActivoDescripcion;
	}

	public void setTipoTituloActivoDescripcion(String tipoTituloActivoDescripcion) {
		this.tipoTituloActivoDescripcion = tipoTituloActivoDescripcion;
	}

	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public String getLocalidadCodigo() {
		return localidadCodigo;
	}

	public void setLocalidadCodigo(String localidadCodigo) {
		this.localidadCodigo = localidadCodigo;
	}

	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}

	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}

	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}

	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}

	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}

	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}

	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}

	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}

	public String getLocalidadRegistroDescripcion() {
		return localidadRegistroDescripcion;
	}

	public void setLocalidadRegistroDescripcion(String localidadRegistroDescripcion) {
		this.localidadRegistroDescripcion = localidadRegistroDescripcion;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}
	
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}

	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}

	public Boolean getSelloCalidad() {
		return selloCalidad;
	}

	public void setSelloCalidad(Boolean selloCalidad) {
		this.selloCalidad = selloCalidad;
	}

	public String getSituacionComercial() {
		return situacionComercial;
	}

	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
	}

	public String getLatitud() {
		return latitud;
	}

	public void setLatitud(String latitud) {
		this.latitud = latitud;
	}

	public String getLongitud() {
		return longitud;
	}

	public void setLongitud(String longitud) {
		this.longitud = longitud;
	}





}