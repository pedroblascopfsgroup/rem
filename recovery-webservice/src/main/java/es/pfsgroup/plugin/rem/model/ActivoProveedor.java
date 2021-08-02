package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedorRetirar;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDOperativa;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoProcesoBlanqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivosCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoZonaGeografica;
import es.pfsgroup.plugin.rem.model.dd.DDTiposColaborador;



/**
 * Modelo que gestiona la informacion de los proveedores de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PVE_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoProveedor implements Serializable, Auditable {
	public static final String DOCIDENTIF_HAYA = "A86744349";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "PVE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoProveedorGenerator")
    @SequenceGenerator(name = "ActivoProveedorGenerator", sequenceName = "S_ACT_PVE_PROVEEDOR")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "DD_TPR_ID")
    private DDTipoProveedor tipoProveedor; 
    
    @ManyToOne
    @JoinColumn(name = "DD_TPC_ID")
    private DDTiposColaborador tipoColaborador; 

    @Column(name = "PVE_COD_UVEM")
	private String codProveedorUvem;
	 
    @Column(name = "PVE_NOMBRE")
	private String nombre;
	 
	@Column(name = "PVE_NOMBRE_COMERCIAL")
	private String nombreComercial;

	@ManyToOne
    @JoinColumn(name = "DD_TDI_ID")
    private DDTipoDocumento tipoDocIdentificativo; 
	
	@Column(name = "PVE_DOCIDENTIF")
	private String docIdentificativo;
	
	@ManyToOne
    @JoinColumn(name = "DD_ZNG_ID")
    private DDTipoZonaGeografica zonaGeografica; 
	
	@ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
	
	@ManyToOne
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;

	@Column(name = "PVE_CP")
	private Integer codigoPostal;
	
	@Column(name = "PVE_DIRECCION")
	private String direccion;
	
	@Column(name = "PVE_TELF1")
	private String telefono1;
	
	@Column(name = "PVE_TELF2")
	private String telefono2;
	
	@Column(name = "PVE_FAX")
	private String fax;

	@Column(name = "PVE_EMAIL")
	private String email;
	
	@Column(name = "PVE_PAGINA_WEB")
	private String paginaWeb;
	
	
	@Column(name = "PVE_FRANQUICIA")
	private Float franquicia;

	@Column(name = "PVE_IVA_CAJA")
	private Integer ivaCaja;

	@Column(name = "PVE_NUM_CUENTA")
	private String numCuenta;

	@ManyToOne
	@JoinColumn(name = "DD_TPE_ID")
	private DDTipoPersona tipoPersona;
	
	@Column(name = "PVE_NIF")
	private String nif;
    
	@Column(name = "PVE_FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "PVE_FECHA_BAJA")
	private Date fechaBaja;
	
	@Column(name = "PVE_LOCALIZADA")
	private Integer localizada;
	
	@ManyToOne
	@JoinColumn(name = "DD_EPR_ID")
	private DDEstadoProveedor estadoProveedor;
	
	@Column(name = "PVE_FECHA_CONSTITUCION")
	private Date fechaConstitucion;
	
	@Column(name = "PVE_AMBITO")
	private String ambito;
	
	@Column(name = "PVE_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "PVE_HOMOLOGADO")
	private Integer homologado;
	
	@ManyToOne
	@JoinColumn(name = "DD_OPE_ID")
	private DDOperativa operativa;
	
	@ManyToOne
	@JoinColumn(name = "DD_CPR_ID")
	private DDCalificacionProveedor calificacionProveedor;
	
	@Column(name = "PVE_TOP")
	private Integer top;
	
	@Column(name = "PVE_TITULAR_CUENTA")
	private String titularCuenta;
	
	@Column(name = "PVE_RETENER")
	private Integer retener;
	
	@ManyToOne
	@JoinColumn(name = "DD_MRE_ID")
	private DDMotivoRetencion motivoRetencion;
	
	@Column(name = "PVE_FECHA_RETENCION")
	private Date fechaRetencion;
	
	@Column(name = "PVE_FECHA_PBC")
	private Date fechaProcesoBlanqueo;
	
	@Column(name = "PVE_CUSTODIO")
	private Integer custodio;
	
	@ManyToOne
	@JoinColumn(name = "DD_RPB_ID")
	private DDResultadoProcesoBlanqueo resultadoProcesoBlanqueo;
	
	@ManyToOne
	@JoinColumn(name = "DD_TAC_ID")
	private DDTipoActivosCartera tipoActivosCartera;
	
	@OneToMany(mappedBy = "proveedor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<ActivoAdjuntoProveedor> adjuntos;
	
	@Column(name = "PVE_COD_REM")
	private Long codigoProveedorRem;
	
	@Column(name = "PVE_COD_API_PROVEEDOR")
	private String codigoApiProveedor;
	
	@Column(name = "PVE_AUTORIZACION_WEB")
	private Integer autorizacionWeb;

	@Column(name = "PVE_CRITERIO_CAJA_IVA")
	private Integer criterioCajaIVA;
	
	@Column(name = "PVE_FECHA_EJERCICIO_OPCION")
	private Date fechaEjercicioOpcion;
	
	@ManyToOne
	@JoinColumn(name = "DD_CPR_ID_PROP")
	private DDCalificacionProveedorRetirar calificacionProveedorPropuesta;
	
	@Column(name = "PVE_TOP_PROP")
	private Integer topPropuesto;
	
	@Column(name = "PVE_TELF_CONTACTO_VIS")
	private String telefonoContactoVisitas;
	
    @Column(name = "PVE_ID_PERSONA_HAYA")
    private String idPersonaHaya;
    
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_MEDIADOR_REL")
    private ActivoProveedor mediadorRelacionado;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "IAP_ID")
	private InfoAdicionalPersona infoAdicionalPersona;


	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	/**
     * Agrega un adjunto al proveedor.
     */
    public void addAdjunto(FileItem fileItem) {
		ActivoAdjuntoProveedor adjuntoProveedor = new ActivoAdjuntoProveedor(fileItem);
		adjuntoProveedor.setProveedor(this);
        Auditoria.save(adjuntoProveedor);
        getAdjuntos().add(adjuntoProveedor);

    }
    
    /**
     * Devuelve el adjunto por Id.
     * 
     * @param id : id.
     * @return adjunto.
     */
    public ActivoAdjuntoProveedor getAdjunto(Long id) {
        for (ActivoAdjuntoProveedor adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }
	
	public DDTipoProveedor getTipoProveedor() {
		return tipoProveedor;
	}

	public void setTipoProveedor(DDTipoProveedor tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
	}

	public DDTiposColaborador getTipoColaborador() {
		return tipoColaborador;
	}

	public void setTipoColaborador(DDTiposColaborador tipoColaborador) {
		this.tipoColaborador = tipoColaborador;
	}

	public String getCodProveedorUvem() {
		return codProveedorUvem;
	}

	public void setCodProveedorUvem(String codProveedorUvem) {
		this.codProveedorUvem = codProveedorUvem;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombreComercial() {
		return nombreComercial;
	}

	public void setNombreComercial(String nombreComercial) {
		this.nombreComercial = nombreComercial;
	}

	public DDTipoDocumento getTipoDocIdentificativo() {
		return tipoDocIdentificativo;
	}

	public void setTipoDocIdentificativo(
			DDTipoDocumento tipoDocIdentificativo) {
		this.tipoDocIdentificativo = tipoDocIdentificativo;
	}

	public String getDocIdentificativo() {
		return docIdentificativo;
	}

	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}

	public DDTipoZonaGeografica getZonaGeografica() {
		return zonaGeografica;
	}

	public void setZonaGeografica(DDTipoZonaGeografica zonaGeografica) {
		this.zonaGeografica = zonaGeografica;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}

	public Integer getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getTelefono1() {
		return telefono1;
	}

	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	public String getTelefono2() {
		return telefono2;
	}

	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPaginaWeb() {
		return paginaWeb;
	}

	public void setPaginaWeb(String paginaWeb) {
		this.paginaWeb = paginaWeb;
	}

	public Float getFranquicia() {
		return franquicia;
	}

	public void setFranquicia(Float franquicia) {
		this.franquicia = franquicia;
	}

	public Integer getIvaCaja() {
		return ivaCaja;
	}

	public void setIvaCaja(Integer ivaCaja) {
		this.ivaCaja = ivaCaja;
	}

	public String getNumCuenta() {
		return numCuenta;
	}

	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}

	public DDTipoPersona getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(DDTipoPersona tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public Integer getLocalizada() {
		return localizada;
	}

	public void setLocalizada(Integer localizada) {
		this.localizada = localizada;
	}

	public DDEstadoProveedor getEstadoProveedor() {
		return estadoProveedor;
	}

	public void setEstadoProveedor(DDEstadoProveedor estadoProveedor) {
		this.estadoProveedor = estadoProveedor;
	}

	public Date getFechaConstitucion() {
		return fechaConstitucion;
	}

	public void setFechaConstitucion(Date fechaConstitucion) {
		this.fechaConstitucion = fechaConstitucion;
	}

	public String getAmbito() {
		return ambito;
	}

	public void setAmbito(String ambito) {
		this.ambito = ambito;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Integer getHomologado() {
		return homologado;
	}

	public void setHomologado(Integer homologado) {
		this.homologado = homologado;
	}

	public DDCalificacionProveedor getCalificacionProveedor() {
		return calificacionProveedor;
	}

	public void setCalificacionProveedor(
			DDCalificacionProveedor calificacionProveedor) {
		this.calificacionProveedor = calificacionProveedor;
	}

	public Integer getTop() {
		return top;
	}

	public void setTop(Integer top) {
		this.top = top;
	}

	public String getTitularCuenta() {
		return titularCuenta;
	}

	public void setTitularCuenta(String titularCuenta) {
		this.titularCuenta = titularCuenta;
	}

	public Integer getRetener() {
		return retener;
	}

	public void setRetener(Integer retener) {
		this.retener = retener;
	}

	public DDMotivoRetencion getMotivoRetencion() {
		return motivoRetencion;
	}

	public void setMotivoRetencion(DDMotivoRetencion motivoRetencion) {
		this.motivoRetencion = motivoRetencion;
	}

	public Date getFechaRetencion() {
		return fechaRetencion;
	}

	public void setFechaRetencion(Date fechaRetencion) {
		this.fechaRetencion = fechaRetencion;
	}

	public Date getFechaProcesoBlanqueo() {
		return fechaProcesoBlanqueo;
	}

	public void setFechaProcesoBlanqueo(Date fechaProcesoBlanqueo) {
		this.fechaProcesoBlanqueo = fechaProcesoBlanqueo;
	}

	public DDResultadoProcesoBlanqueo getResultadoProcesoBlanqueo() {
		return resultadoProcesoBlanqueo;
	}

	public void setResultadoProcesoBlanqueo(
			DDResultadoProcesoBlanqueo resultadoProcesoBlanqueo) {
		this.resultadoProcesoBlanqueo = resultadoProcesoBlanqueo;
	}
	
	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getCustodio() {
		return custodio;
	}

	public void setCustodio(Integer custodio) {
		this.custodio = custodio;
	}

	public DDTipoActivosCartera getTipoActivosCartera() {
		return tipoActivosCartera;
	}

	public void setTipoActivosCartera(DDTipoActivosCartera tipoActivosCartera) {
		this.tipoActivosCartera = tipoActivosCartera;
	}

	public List<ActivoAdjuntoProveedor> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<ActivoAdjuntoProveedor> adjuntos) {
		this.adjuntos = adjuntos;
	}

	public DDOperativa getOperativa() {
		return operativa;
	}

	public void setOperativa(DDOperativa operativa) {
		this.operativa = operativa;
	}
	
	public Long getCodigoProveedorRem() {
		return codigoProveedorRem;
	}

	public void setCodigoProveedorRem(Long codigoProveedorRem) {
		this.codigoProveedorRem = codigoProveedorRem;
	}

	public String getCodigoApiProveedor() {
		return codigoApiProveedor;
	}

	public void setCodigoApiProveedor(String codigoApiProveedor) {
		this.codigoApiProveedor = codigoApiProveedor;
	}

	public Integer getAutorizacionWeb() {
		return autorizacionWeb;
	}

	public void setAutorizacionWeb(Integer autorizacionWeb) {
		this.autorizacionWeb = autorizacionWeb;
	}
	
	public Integer getCriterioCajaIVA() {
		return criterioCajaIVA;
	}

	public void setCriterioCajaIVA(Integer criterioCajaIVA) {
		this.criterioCajaIVA = criterioCajaIVA;
	}

	public Date getFechaEjercicioOpcion() {
		return fechaEjercicioOpcion;
	}

	public void setFechaEjercicioOpcion(Date fechaEjercicioOpcion) {
		this.fechaEjercicioOpcion = fechaEjercicioOpcion;
	}

	public DDCalificacionProveedorRetirar getCalificacionProveedorPropuesta() {
		return calificacionProveedorPropuesta;
	}

	public void setCalificacionProveedorPropuesta(DDCalificacionProveedorRetirar calificacionProveedorPropuesta) {
		this.calificacionProveedorPropuesta = calificacionProveedorPropuesta;
	}

	public Integer getTopPropuesto() {
		return topPropuesto;
	}

	public void setTopPropuesto(Integer topPropuesto) {
		this.topPropuesto = topPropuesto;
	}
	
	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}

	public ActivoProveedor getMediadorRelacionado() {
		return mediadorRelacionado;
	}

	public void setMediadorRelacionado(ActivoProveedor mediadorRelacionado) {
		this.mediadorRelacionado = mediadorRelacionado;
	}

	public InfoAdicionalPersona getInfoAdicionalPersona() {
		return infoAdicionalPersona;
	}

	public void setInfoAdicionalPersona(InfoAdicionalPersona infoAdicionalPersona) {
		this.infoAdicionalPersona = infoAdicionalPersona;
	}
}
