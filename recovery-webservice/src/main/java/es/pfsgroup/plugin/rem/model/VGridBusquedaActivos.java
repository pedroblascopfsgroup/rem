package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GRID_BUSQUEDA_ACTIVOS", schema = "${entity.schema}")
public class VGridBusquedaActivos implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long id;
	
	@Column(name = "TOKEN_GMAPS")
	private String tokenGmaps;
	
	@Column(name="LATITUD")
	private String latitud;
	
	@Column(name="LONGITUD")
	private String longitud;
	
	@Column(name = "NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name = "BBVA_NUM_ACTIVO")
    private String numActivoBbva;

	
	@Column(name = "NUM_ACTIVO_SAREB")
	private String numActivoSareb;
	
	@Column(name = "NUM_ACTIVO_PRINEX")
	private Long numActivoPrinex;
	
	@Column(name = "NUM_ACTIVO_UVEM")
	private Long numActivoUvem;
	
	@Column(name = "NUM_ACTIVO_CAIXA")
	private String numActivoCaixa;
	
	@Column(name = "NUM_ACTIVO_DIVARIAN")
	private String numActivoDivarian;
	
	@Column(name = "NUM_RECOVERY")
	private Long numActivoRecovery;
	
	@Column(name="TIPO_ACTIVO_CODIGO")
	private String tipoActivoCodigo;
	
	@Column(name="TIPO_ACTIVO_DESCRIPCION")
	private String tipoActivoDescripcion;
		
	@Column(name="SUBTIPO_ACTIVO_CODIGO")
	private String subtipoActivoCodigo;
	
	@Column(name="SUBTIPO_ACTIVO_DESCRIPCION")
	private String subtipoActivoDescripcion;
	
    @Column(name = "CARTERA_CODIGO")
    private String carteraCodigo;
    
    @Column(name = "CARTERA_DESCRIPCION")
    private String carteraDescripcion;
    
    @Column(name = "SUBCARTERA_CODIGO")
    private String subcarteraCodigo;
    
    @Column(name = "SUBCARTERA_DESCRIPCION")
    private String subcarteraDescripcion;
    
    @Column(name = "TIPO_TITULO_ACTIVO_CODIGO")
    private String tipoTituloActivoCodigo;
    
    @Column(name = "SUBTIPO_TITULO_ACTIVO_CODIGO")
    private String subtipoTituloActivoCodigo;
    
    @Column(name = "TIPO_TITULO_ACTIVO_DESCRIPCION")
    private String tipoTituloActivoDescripcion;
    
	@Column(name="TIPO_VIA_CODIGO")
	private String tipoViaCodigo;
	
	@Column(name="TIPO_VIA_DESCRIPCION")
	private String tipoViaDescripcion;
	
	@Column(name="NOMBRE_VIA")
	private String nombreVia;
	
	@Column(name = "LOCALIDAD_CODIGO")
	private String localidadCodigo;
	
	@Column(name = "LOCALIDAD_DESCRIPCION")
	private String localidadDescripcion;
	
	@Column(name = "PROVINCIA_CODIGO")
	private String provinciaCodigo;
	
	@Column(name = "PROVINCIA_DESCRIPCION")
	private String provinciaDescripcion;
	
	@Column(name="COD_POSTAL")
	private String codPostal;

	@Column(name = "SITUACION_COMERCIAL_CODIGO")
	private String situacionComercialCodigo;
	
	@Column(name= "SITUACION_COMERCIAL_DESCRIPCION")
	private String situacionComercialDescripcion;
	
	@Column(name = "ADMISION")
	private Integer admision;
	
	@Column(name = "GESTION")
	private Integer gestion;
		
	@Column(name = "SELLO_CALIDAD")
	private Integer selloCalidad;
	
	@Column(name = "FLAG_RATING_CODIGO")
	private String flagRatingCodigo;
	
	@Column(name = "FLAG_RATING_DESCRIPCION")
	private String flagRatingDescripcion;
	
	@Column(name = "COD_PROMO_PRINEX")
	private String codPromoPrinex;
	
	@Column(name = "NUM_FINCA")
	private String numFinca;
	
	@Column(name = "ESTADO_ACTIVO_CODIGO")
	private String estadoActivoCodigo;
	
	@Column(name = "ESTADO_ACTIVO_DESCRIPCION")
	private String estadoActivoDescripcion;
	
	@Column(name = "PAIS_CODIGO")
	private String paisCodigo;

	@Column(name = "TIPO_USO_DESTINO_CODIGO")
	private String tipoUsoDestinoCodigo;	
	
	@Column(name = "CLASE_ACTIVO_BANCARIO_CODIGO")
	private String claseActivoBancarioCodigo;	
	
	@Column(name = "SUBCLASE_ACTIVO_BANCARIO_CODIGO")
	private String subclaseActivoBancarioCodigo;
	
	@Column(name = "LOCALIDAD_REGISTRO_DESCRIPCION")
	private String localidadRegistroDescripcion;
	
	@Column(name = "NUM_REGISTRO")
	private String numRegistro;
	
	@Column(name = "IDUFIR")
	private String idufir;
	
	@Column(name = "FECHA_INSCRIPCION_REGISTRO")
	private Date fechaInscripcionReg;
	
	@Column(name = "DIVISION_HORIZONTAL")
	private Integer divHorizontal;
	
	@Column(name = "NOMBRE_PROPIETARIO")
	private String nombrePropietario;
	
	@Column(name = "DOCUMENTO_PROPIETARIO")
	private String docPropietario;
	
	@Column(name = "OCUPADO")
	private Integer ocupado;
	
	@Column(name = "FECHA_TOMA_POSESION")
	private Date fechaPosesion;
	
	@Column(name = "ACCESO_TAPIADO")
	private Integer tapiado;
	
	@Column(name = "ACCESO_ANTIOCUPA")
	private Integer antiocupa;
	
	@Column(name = "TITULO_POSESORIO_CODIGO")
	private String tituloPosesorioCodigo;
	
	@Column(name = "TITULO_POSESORIO_DESCRIPCION")
	private String tituloPosesorioDescripcion;	
	
	@Column(name = "CON_TITULO_CODIGO")
	private String conTituloCodigo;
	
	@Column(name = "TIPO_COMERCIALIZACION_CODIGO")
	private String tipoComercializacionCodigo;
	
    @Column(name = "CON_CARGAS")
   	private Integer conCargas; 
    
    @Column(name = "ESTADO_COMUNICACION_GENCAT")
   	private String estadoComunicacionGencatCodigo; 
    
    @Column(name ="DIRECCION_COMERCIAL")
	private String direccionComercialCodigo;
    
    @Column(name ="PERIMETRO_MACC")
   	private Integer perimetroMacc;
    
    @Column(name ="TIPO_SEGMENTO_CODIGO")
   	private String tipoSegmentoCodigo;

	@Column(name = "DD_EQG_EQUIPO_GESTION")
	private String equipoGestion;
	
	@Column(name = "BBVA_COD_PROMOCION")
	private String codPromocionBbva;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTokenGmaps() {
		return tokenGmaps;
	}

	public void setTokenGmaps(String tokenGmaps) {
		this.tokenGmaps = tokenGmaps;
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

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
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

	public Long getNumActivoUvem() {
		return numActivoUvem;
	}

	public void setNumActivoUvem(Long numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}

	public String getNumActivoDivarian() {
		return numActivoDivarian;
	}

	public void setNumActivoDivarian(String numActivoDivarian) {
		this.numActivoDivarian = numActivoDivarian;
	}

	public Long getNumActivoRecovery() {
		return numActivoRecovery;
	}

	public void setNumActivoRecovery(Long numActivoRecovery) {
		this.numActivoRecovery = numActivoRecovery;
	}

	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}

	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
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

	public String getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}

	public String getCarteraDescripcion() {
		return carteraDescripcion;
	}

	public void setCarteraDescripcion(String carteraDescripcion) {
		this.carteraDescripcion = carteraDescripcion;
	}

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public String getSubcarteraDescripcion() {
		return subcarteraDescripcion;
	}

	public void setSubcarteraDescripcion(String subcarteraDescripcion) {
		this.subcarteraDescripcion = subcarteraDescripcion;
	}

	public String getTipoTituloActivoCodigo() {
		return tipoTituloActivoCodigo;
	}

	public void setTipoTituloActivoCodigo(String tipoTituloActivoCodigo) {
		this.tipoTituloActivoCodigo = tipoTituloActivoCodigo;
	}

	public String getSubtipoTituloActivoCodigo() {
		return subtipoTituloActivoCodigo;
	}

	public void setSubtipoTituloActivoCodigo(String subtipoTituloActivoCodigo) {
		this.subtipoTituloActivoCodigo = subtipoTituloActivoCodigo;
	}

	public String getTipoTituloActivoDescripcion() {
		return tipoTituloActivoDescripcion;
	}

	public void setTipoTituloActivoDescripcion(String tipoTituloActivoDescripcion) {
		this.tipoTituloActivoDescripcion = tipoTituloActivoDescripcion;
	}

	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}

	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}

	public String getTipoViaDescripcion() {
		return tipoViaDescripcion;
	}

	public void setTipoViaDescripcion(String tipoViaDescripcion) {
		this.tipoViaDescripcion = tipoViaDescripcion;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
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

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getSituacionComercialCodigo() {
		return situacionComercialCodigo;
	}

	public void setSituacionComercialCodigo(String situacionComercialCodigo) {
		this.situacionComercialCodigo = situacionComercialCodigo;
	}

	public String getSituacionComercialDescripcion() {
		return situacionComercialDescripcion;
	}

	public void setSituacionComercialDescripcion(String situacionComercialDescripcion) {
		this.situacionComercialDescripcion = situacionComercialDescripcion;
	}

	public Integer getAdmision() {
		return admision;
	}

	public void setAdmision(Integer admision) {
		this.admision = admision;
	}

	public Integer getGestion() {
		return gestion;
	}

	public void setGestion(Integer gestion) {
		this.gestion = gestion;
	}

	public Integer getSelloCalidad() {
		return selloCalidad;
	}

	public void setSelloCalidad(Integer selloCalidad) {
		this.selloCalidad = selloCalidad;
	}

	public String getFlagRatingCodigo() {
		return flagRatingCodigo;
	}

	public void setFlagRatingCodigo(String flagRatingCodigo) {
		this.flagRatingCodigo = flagRatingCodigo;
	}

	public String getFlagRatingDescripcion() {
		return flagRatingDescripcion;
	}

	public void setFlagRatingDescripcion(String flagRatingDescripcion) {
		this.flagRatingDescripcion = flagRatingDescripcion;
	}

	public String getCodPromoPrinex() {
		return codPromoPrinex;
	}

	public void setCodPromoPrinex(String codPromoPrinex) {
		this.codPromoPrinex = codPromoPrinex;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}

	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}

	public String getEstadoActivoDescripcion() {
		return estadoActivoDescripcion;
	}

	public void setEstadoActivoDescripcion(String estadoActivoDescripcion) {
		this.estadoActivoDescripcion = estadoActivoDescripcion;
	}

	public String getPaisCodigo() {
		return paisCodigo;
	}

	public void setPaisCodigo(String paisCodigo) {
		this.paisCodigo = paisCodigo;
	}

	public String getTipoUsoDestinoCodigo() {
		return tipoUsoDestinoCodigo;
	}

	public void setTipoUsoDestinoCodigo(String tipoUsoDestinoCodigo) {
		this.tipoUsoDestinoCodigo = tipoUsoDestinoCodigo;
	}

	public String getClaseActivoBancarioCodigo() {
		return claseActivoBancarioCodigo;
	}

	public void setClaseActivoBancarioCodigo(String claseActivoBancarioCodigo) {
		this.claseActivoBancarioCodigo = claseActivoBancarioCodigo;
	}

	public String getSubclaseActivoBancarioCodigo() {
		return subclaseActivoBancarioCodigo;
	}

	public void setSubclaseActivoBancarioCodigo(String subclaseActivoBancarioCodigo) {
		this.subclaseActivoBancarioCodigo = subclaseActivoBancarioCodigo;
	}

	public String getLocalidadRegistroDescripcion() {
		return localidadRegistroDescripcion;
	}

	public void setLocalidadRegistroDescripcion(String localidadRegistroDescripcion) {
		this.localidadRegistroDescripcion = localidadRegistroDescripcion;
	}

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getIdufir() {
		return idufir;
	}

	public void setIdufir(String idufir) {
		this.idufir = idufir;
	}

	public Date getFechaInscripcionReg() {
		return fechaInscripcionReg;
	}

	public void setFechaInscripcionReg(Date fechaInscripcionReg) {
		this.fechaInscripcionReg = fechaInscripcionReg;
	}

	public Integer getDivHorizontal() {
		return divHorizontal;
	}

	public void setDivHorizontal(Integer divHorizontal) {
		this.divHorizontal = divHorizontal;
	}

	public String getNombrePropietario() {
		return nombrePropietario;
	}

	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}

	public String getDocPropietario() {
		return docPropietario;
	}

	public void setDocPropietario(String docPropietario) {
		this.docPropietario = docPropietario;
	}

	public Integer getOcupado() {
		return ocupado;
	}

	public void setOcupado(Integer ocupado) {
		this.ocupado = ocupado;
	}

	public Date getFechaPosesion() {
		return fechaPosesion;
	}

	public void setFechaPosesion(Date fechaPosesion) {
		this.fechaPosesion = fechaPosesion;
	}

	public Integer getTapiado() {
		return tapiado;
	}

	public void setTapiado(Integer tapiado) {
		this.tapiado = tapiado;
	}

	public Integer getAntiocupa() {
		return antiocupa;
	}

	public void setAntiocupa(Integer antiocupa) {
		this.antiocupa = antiocupa;
	}

	public String getTituloPosesorioCodigo() {
		return tituloPosesorioCodigo;
	}

	public void setTituloPosesorioCodigo(String tituloPosesorioCodigo) {
		this.tituloPosesorioCodigo = tituloPosesorioCodigo;
	}

	public String getTituloPosesorioDescripcion() {
		return tituloPosesorioDescripcion;
	}

	public void setTituloPosesorioDescripcion(String tituloPosesorioDescripcion) {
		this.tituloPosesorioDescripcion = tituloPosesorioDescripcion;
	}

	public String getConTituloCodigo() {
		return conTituloCodigo;
	}

	public void setConTituloCodigo(String conTituloCodigo) {
		this.conTituloCodigo = conTituloCodigo;
	}

	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}

	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}

	public Integer getConCargas() {
		return conCargas;
	}

	public void setConCargas(Integer conCargas) {
		this.conCargas = conCargas;
	}

	public String getEstadoComunicacionGencatCodigo() {
		return estadoComunicacionGencatCodigo;
	}

	public void setEstadoComunicacionGencatCodigo(String estadoComunicacionGencatCodigo) {
		this.estadoComunicacionGencatCodigo = estadoComunicacionGencatCodigo;
	}

	public String getDireccionComercialCodigo() {
		return direccionComercialCodigo;
	}

	public void setDireccionComercialCodigo(String direccionComercialCodigo) {
		this.direccionComercialCodigo = direccionComercialCodigo;
	}

	public Integer getPerimetroMacc() {
		return perimetroMacc;
	}

	public void setPerimetroMacc(Integer perimetroMacc) {
		this.perimetroMacc = perimetroMacc;
	}

	public String getTipoSegmentoCodigo() {
		return tipoSegmentoCodigo;
	}

	public void setTipoSegmentoCodigo(String tipoSegmentoCodigo) {
		this.tipoSegmentoCodigo = tipoSegmentoCodigo;
	}

	public String getEquipoGestion() {
		return equipoGestion;
	}

	public void setEquipoGestion(String equipoGestion) {
		this.equipoGestion = equipoGestion;
	}

	public String getNumActivoBbva() {
		return numActivoBbva;
	}

	public void setNumActivoBbva(String numActivoBbva) {
		this.numActivoBbva = numActivoBbva;
	}

	public String getCodPromocionBbva() {
		return codPromocionBbva;
	}

	public void setCodPromocionBbva(String codPromocionBbva) {
		this.codPromocionBbva = codPromocionBbva;
	}

	public String getNumActivoCaixa() {
		return numActivoCaixa;
	}

	public void setNumActivoCaixa(String numActivoCaixa) {
		this.numActivoCaixa = numActivoCaixa;
	}
    
}