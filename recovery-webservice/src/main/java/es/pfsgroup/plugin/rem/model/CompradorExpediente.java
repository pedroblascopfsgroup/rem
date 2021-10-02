package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoContrasteListas;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInterlocutor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosPbc;
import es.pfsgroup.plugin.rem.model.dd.DDInterlocutorOferta;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;
import es.pfsgroup.plugin.rem.model.dd.DDUsosActivo;
import es.pfsgroup.plugin.rem.model.dd.DDVinculoCaixa;


/**
 * Modelo que gestiona la informacion de un comprador en un expediente
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "CEX_COMPRADOR_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Inheritance(strategy=InheritanceType.JOINED)
public class CompradorExpediente implements Serializable, Auditable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
    @Id
    private CompradorExpedientePk primaryKey = new CompradorExpedientePk();

    @Column(name = "COM_ID", nullable = false, updatable = false, insertable = false)
    private Long comprador;
    
    @Column(name = "ECO_ID", nullable = false, updatable = false, insertable = false)
    private Long expediente;
	    
    @Column(name = "CEX_NOMBRE_RTE")
    private String nombreRepresentante;
    
    @Column(name = "CEX_APELLIDOS_RTE")
    private String apellidosRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_RTE")
	private DDTipoDocumento tipoDocumentoRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_CONYUGE")
	private DDTipoDocumento tipoDocumentoConyuge;
    
    @Column(name = "CEX_DOCUMENTO_RTE")
    private String documentoRepresentante;
    
    @Column(name = "CEX_TELEFONO1_RTE")
    private String telefono1Representante;
    
    @Column(name = "CEX_TELEFONO2_RTE")
    private String telefono2Representante;
    
    @Column(name = "CEX_EMAIL_RTE")
    private String emailRepresentante;
    
    @Column(name = "CEX_DIRECCION_RTE")
    private String direccionRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LOC_ID_RTE")
	private Localidad localidadRepresentante;
    
    @Column(name = "CEX_CODIGO_POSTAL_RTE")
    private String codigoPostalRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID_RTE")
	private DDProvincia provinciaRepresentante;
    
    @Column(name="CEX_PORCION_COMPRA")
    private Double porcionCompra;
    
    @Column(name="CEX_TITULAR_RESERVA")
    private Integer titularReserva;
    
    @Column(name="CEX_TITULAR_CONTRATACION")
    private Integer titularContratacion;  
   
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECV_ID")
    private DDEstadosCiviles estadoCivil;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_REM_ID")
    private DDRegimenesMatrimoniales regimenMatrimonial;
    
    @Column(name="CEX_DOCUMENTO_CONYUGE")
    private String documentoConyuge;
    
    @Column(name="CEX_ANTIGUO_DEUDOR")
    private Integer antiguoDeudor;
    
    @Column(name="CEX_RELACION_ANT_DEUDOR")
    private Integer relacionAntDeudor;    
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_UAC_ID")
    private DDUsosActivo usoActivo;
    
    @Column(name="CEX_IMPTE_PROPORCIONAL_OFERTA")
    private Double importeProporcionalOferta;
    
    @Column(name="CEX_IMPTE_FINANCIADO")
    private Double importeFinanciado;
    
    @Column(name="CEX_RESPONSABLE_TRAMITACION")
    private String responsableTramitacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPI_ID")
    private DDTipoInquilino tipoInquilino;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPB_ID")
    private DDEstadosPbc estadosPbc;
    
    @Column(name="CEX_RELACION_HRE")
    private String relacionHre;
    
    @Column(name="CEX_FECHA_PETICION")
    private Date fechaPeticion;
    
    @Column(name="CEX_FECHA_RESOLUCION")
    private Date fechaResolucion;
    
    @Column(name="CEX_NUM_FACTURA")
    private String numFactura;
    
    @Column(name="CEX_FECHA_FACTURA")
    private Date fechaFactura;
    
    @Column(name="CEX_FECHA_BAJA")
    private Date fechaBaja;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TGP_ID")
    private DDTipoGradoPropiedad gradoPropiedad;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_ID")
    private DDPaises pais;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_ID_RTE")
    private DDPaises paisRte;
    

    @Column(name = "CEX_ID_PERSONA_HAYA")
    private String idPersonaHaya;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ADCOM_ID")
    private AdjuntoComprador documentoAdjunto;
    
    @Column(name="CEX_CLI_URSUS_CONYUGE_REM")
    private String clienteUrsusConyuge;
    
    @Column(name="CEX_NUM_URSUS_CONYUGE_REM")
    private Integer numUrsusConyuge;
    
    @Column(name="CEX_NUM_URSUS_CONYUGE_BH_REM")
    private Integer numUrsusConyugeBh;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECL_ID")
    private DDEstadoContrasteListas estadoContrasteListas;

    @Column(name="ECO_ECL_FECHA")
    private Date fechaContrasteListas;

	@Column(name = "CEX_C4C_ID")
	private Long idC4c;
	
    @Column(name="CEX_FECHA_NACIMIENTO_REPR")
    private Date fechaNacimientoRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CEX_LOC_NAC_REPR")
    private Localidad localidadNacimientoRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_NAC_REPR_ID")
    private DDPaises paisNacimientoRepresentante;
    
    @Column(name="CEX_USUFRUCTUARIO")
    private Boolean usufructuario;
    
    @ManyToOne
	@JoinColumn(name = "IAP_REPR_ID")
	private InfoAdicionalPersona infoAdicionalRepresentante;
    
	@ManyToOne
	@JoinColumn(name = "DD_FIO_ID")
	private DDInterlocutorOferta interlocutorOferta;
	
	@ManyToOne
	@JoinColumn(name = "DD_FIO_REPR_ID")
	private DDInterlocutorOferta interlocutorOfertaRepresentante;
	
	@Column(name = "CEX_SOCIEDAD")
	private String sociedad;
	
	@ManyToOne
	@JoinColumn(name = "DD_VIC_ID")
	private DDVinculoCaixa vinculoCaixa;

	@Column(name = "CEX_ID_PERSONA_HAYA_REPR")
	private Long idPersonaHayaRepresentante;

	@Column(name = "CEX_PRP")
	private Boolean prp;
	
	@Column(name = "CEX_OFICINA_TRABAJO")
	private String oficinaTrabajo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_NAC_ID_REP")
	private DDProvincia provinciaNacimientoRep;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EIC_ID")
	private DDEstadoInterlocutor estadoInterlocutor;

	@Column(name = "CEX_ID_PERSONA_HAYA_CAIXA_REPR")
	private String idPersonaHayaCaixaRepresentante;

	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

    
    /**
     * defualt contructor.
     */
    public CompradorExpediente() {
        primaryKey = new CompradorExpedientePk();
        this.auditoria = Auditoria.getNewInstance();
    }

	public Long getComprador() {
		return comprador;
	}

	public void setComprador(Long comprador) {
		this.comprador = comprador;
	}

	public Long getExpediente() {
		return expediente;
	}

	public void setExpediente(Long expediente) {
		this.expediente = expediente;
	}

	public String getNombreRepresentante() {
		return nombreRepresentante;
	}

	public void setNombreRepresentante(String nombreRepresentante) {
		this.nombreRepresentante = nombreRepresentante;
	}

	public String getApellidosRepresentante() {
		return apellidosRepresentante;
	}

	public void setApellidosRepresentante(String apellidosRepresentante) {
		this.apellidosRepresentante = apellidosRepresentante;
	}

	public DDTipoDocumento getTipoDocumentoRepresentante() {
		return tipoDocumentoRepresentante;
	}

	public void setTipoDocumentoRepresentante(
			DDTipoDocumento tipoDocumentoRepresentante) {
		this.tipoDocumentoRepresentante = tipoDocumentoRepresentante;
	}

	public String getDocumentoRepresentante() {
		return documentoRepresentante;
	}

	public void setDocumentoRepresentante(String documentoRepresentante) {
		this.documentoRepresentante = documentoRepresentante;
	}

	public String getTelefono1Representante() {
		return telefono1Representante;
	}

	public void setTelefono1Representante(String telefono1Representante) {
		this.telefono1Representante = telefono1Representante;
	}

	public String getTelefono2Representante() {
		return telefono2Representante;
	}

	public void setTelefono2Representante(String telefono2Representante) {
		this.telefono2Representante = telefono2Representante;
	}

	public String getEmailRepresentante() {
		return emailRepresentante;
	}

	public void setEmailRepresentante(String emailRepresentante) {
		this.emailRepresentante = emailRepresentante;
	}

	public String getDireccionRepresentante() {
		return direccionRepresentante;
	}

	public void setDireccionRepresentante(String direccionRepresentante) {
		this.direccionRepresentante = direccionRepresentante;
	}

	public Localidad getLocalidadRepresentante() {
		return localidadRepresentante;
	}

	public void setLocalidadRepresentante(Localidad localidadRepresentante) {
		this.localidadRepresentante = localidadRepresentante;
	}

	public String getCodigoPostalRepresentante() {
		return codigoPostalRepresentante;
	}

	public void setCodigoPostalRepresentante(String codigoPostalRepresentante) {
		this.codigoPostalRepresentante = codigoPostalRepresentante;
	}

	public DDProvincia getProvinciaRepresentante() {
		return provinciaRepresentante;
	}

	public void setProvinciaRepresentante(DDProvincia provinciaRepresentante) {
		this.provinciaRepresentante = provinciaRepresentante;
	}

	public Double getPorcionCompra() {
		return porcionCompra;
	}

	public void setPorcionCompra(Double porcionCompra) {
		this.porcionCompra = porcionCompra;
	}

	public Integer getTitularReserva() {
		return titularReserva;
	}

	public void setTitularReserva(Integer titularReserva) {
		this.titularReserva = titularReserva;
	}

	public Integer getTitularContratacion() {
		return titularContratacion;
	}
	

	public void setTitularContratacion(Integer titularContratacion) {
		this.titularContratacion = titularContratacion;
	}

	public DDEstadosCiviles getEstadoCivil() {
		return estadoCivil;
	}

	public void setEstadoCivil(DDEstadosCiviles estadoCivil) {
		this.estadoCivil = estadoCivil;
	}


	public DDRegimenesMatrimoniales getRegimenMatrimonial() {
		return regimenMatrimonial;
	}

	public void setRegimenMatrimonial(DDRegimenesMatrimoniales regimenMatrimonial) {
		this.regimenMatrimonial = regimenMatrimonial;
	}
	
	public DDTipoDocumento getTipoDocumentoConyuge() {
		return tipoDocumentoConyuge;
	}

	public void setTipoDocumentoConyuge(DDTipoDocumento tipoDocumentoConyuge) {
		this.tipoDocumentoConyuge = tipoDocumentoConyuge;
	}

	public String getDocumentoConyuge() {
		return documentoConyuge;
	}

	public void setDocumentoConyuge(String documentoConyuge) {
		this.documentoConyuge = documentoConyuge;
	}

	public Integer getAntiguoDeudor() {
		return antiguoDeudor;
	}

	public void setAntiguoDeudor(Integer antiguoDeudor) {
		this.antiguoDeudor = antiguoDeudor;
	}

	public Integer getRelacionAntDeudor() {
		return relacionAntDeudor;
	}

	public void setRelacionAntDeudor(Integer relacionAntDeudor) {
		this.relacionAntDeudor = relacionAntDeudor;
	}

	public DDUsosActivo getUsoActivo() {
		return usoActivo;
	}

	public void setUsoActivo(DDUsosActivo usoActivo) {
		this.usoActivo = usoActivo;
	}

	public Double getImporteProporcionalOferta() {
		return importeProporcionalOferta;
	}

	public void setImporteProporcionalOferta(Double importeProporcionalOferta) {
		this.importeProporcionalOferta = importeProporcionalOferta;
	}

	public Double getImporteFinanciado() {
		return importeFinanciado;
	}

	public void setImporteFinanciado(Double importeFinanciado) {
		this.importeFinanciado = importeFinanciado;
	}

	public String getResponsableTramitacion() {
		return responsableTramitacion;
	}

	public void setResponsableTramitacion(String responsableTramitacion) {
		this.responsableTramitacion = responsableTramitacion;
	}

	public CompradorExpedientePk getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(CompradorExpedientePk primaryKey) {
		this.primaryKey = primaryKey;
	}

    public DDEstadosPbc getEstadosPbc() {
		return estadosPbc;
	}

	public void setEstadosPbc(DDEstadosPbc estadosPbc) {
		this.estadosPbc = estadosPbc;
	}

	public String getRelacionHre() {
		return relacionHre;
	}

	public void setRelacionHre(String relacionHre) {
		this.relacionHre = relacionHre;
	}
	
	public Date getFechaPeticion() {
		return fechaPeticion;
	}

	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}

	public Date getFechaResolucion() {
		return fechaResolucion;
	}

	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}

	public String getNumFactura() {
		return numFactura;
	}

	public void setNumFactura(String numFactura) {
		this.numFactura = numFactura;
	}

	public Date getFechaFactura() {
		return fechaFactura;
	}

	public void setFechaFactura(Date fechaFactura) {
		this.fechaFactura = fechaFactura;
	}
	
	public AdjuntoComprador getDocumentoAdjunto() {
		return documentoAdjunto;
	}

	public void setDocumentoAdjunto(AdjuntoComprador documentoAdjunto) {
		this.documentoAdjunto = documentoAdjunto;
	}

	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}




	/**
     * clase pk embebida
     */
    @Embeddable
    public static class CompradorExpedientePk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            CompradorExpediente other = (CompradorExpediente) obj;
            if (comprador == null) {
                if (other.comprador != null) { return false; }
            } else if (!comprador.equals(other.comprador)) { return false; }
            if (expediente == null) {
                if (other.expediente != null) { return false; }
            } else if (!expediente.equals(other.expediente)) { return false; }
            return true;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((comprador == null) ? 0 : comprador.hashCode());
            result = prime * result + ((expediente == null) ? 0 : expediente.hashCode());
            return result;
        }

        /**
         * setial.
         */
        private static final long serialVersionUID = 1L;

        @ManyToOne
        @JoinColumn(name = "COM_ID")
        private Comprador comprador;

        @ManyToOne
        @JoinColumn(name = "ECO_ID")
        private ExpedienteComercial expediente;

        /**
         * default contructor.
         */
        public CompradorExpedientePk() {

        }
	
		public Comprador getComprador() {
				return comprador;
			}
	
		public void setComprador(Comprador comprador) {
			this.comprador = comprador;
		}
	
		public ExpedienteComercial getExpediente() {
			return expediente;
		}
	
		public void setExpediente(ExpedienteComercial expediente) {
			this.expediente = expediente;
		}
    }

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public DDTipoGradoPropiedad getGradoPropiedad() {
		return gradoPropiedad;
	}

	public void setGradoPropiedad(DDTipoGradoPropiedad gradoPropiedad) {
		this.gradoPropiedad = gradoPropiedad;
	}

	public DDPaises getPais() {
		return pais;
	}

	public void setPais(DDPaises pais) {
		this.pais = pais;
	}

	public DDPaises getPaisRte() {
		return paisRte;
	}

	public void setPaisRte(DDPaises paisRte) {
		this.paisRte = paisRte;
	}

	public DDTipoInquilino getTipoInquilino() {
		return tipoInquilino;
	}

	public void setTipoInquilino(DDTipoInquilino tipoInquilino) {
		this.tipoInquilino = tipoInquilino;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public String getClienteUrsusConyuge() {
		return clienteUrsusConyuge;
	}

	public void setClienteUrsusConyuge(String clienteUrsusConyuge) {
		this.clienteUrsusConyuge = clienteUrsusConyuge;
	}

	public Integer getNumUrsusConyuge() {
		return numUrsusConyuge;
	}

	public void setNumUrsusConyuge(Integer numUrsusConyuge) {
		this.numUrsusConyuge = numUrsusConyuge;
	}

	public Integer getNumUrsusConyugeBh() {
		return numUrsusConyugeBh;
	}

	public void setNumUrsusConyugeBh(Integer numUrsusConyugeBh) {
		this.numUrsusConyugeBh = numUrsusConyugeBh;
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public DDEstadoContrasteListas getEstadoContrasteListas() {
		return estadoContrasteListas;
	}

	public void setEstadoContrasteListas(DDEstadoContrasteListas estadoContrasteListas) {
		this.estadoContrasteListas = estadoContrasteListas;
	}

	public Date getFechaContrasteListas() {
		return fechaContrasteListas;
	}

	public void setFechaContrasteListas(Date fechaContrasteListas) {
		this.fechaContrasteListas = fechaContrasteListas;
	}

	public Long getIdC4c() {
		return idC4c;
	}

	public void setIdC4c(Long idC4c) {
		this.idC4c = idC4c;
	}

	public Date getFechaNacimientoRepresentante() {
		return fechaNacimientoRepresentante;
	}

	public void setFechaNacimientoRepresentante(Date fechaNacimientoRepresentante) {
		this.fechaNacimientoRepresentante = fechaNacimientoRepresentante;
	}

	public Localidad getLocalidadNacimientoRepresentante() {
		return localidadNacimientoRepresentante;
	}

	public void setLocalidadNacimientoRepresentante(Localidad localidadNacimientoRepresentante) {
		this.localidadNacimientoRepresentante = localidadNacimientoRepresentante;
	}

	public DDPaises getPaisNacimientoRepresentante() {
		return paisNacimientoRepresentante;
	}

	public void setPaisNacimientoRepresentante(DDPaises paisNacimientoRepresentante) {
		this.paisNacimientoRepresentante = paisNacimientoRepresentante;
	}

	public Boolean getUsufructuario() {
		return usufructuario;
	}

	public void setUsufructuario(Boolean usufructuario) {
		this.usufructuario = usufructuario;
	}

	public InfoAdicionalPersona getInfoAdicionalRepresentante() {
		return infoAdicionalRepresentante;
	}

	public void setInfoAdicionalRepresentante(InfoAdicionalPersona infoAdicionalRepresentante) {
		this.infoAdicionalRepresentante = infoAdicionalRepresentante;
	}

	public DDInterlocutorOferta getInterlocutorOferta() {
		return interlocutorOferta;
	}

	public void setInterlocutorOferta(DDInterlocutorOferta interlocutorOferta) {
		this.interlocutorOferta = interlocutorOferta;
	}

	public DDInterlocutorOferta getInterlocutorOfertaRepresentante() {
		return interlocutorOfertaRepresentante;
	}

	public void setInterlocutorOfertaRepresentante(DDInterlocutorOferta interlocutorOfertaRepresentante) {
		this.interlocutorOfertaRepresentante = interlocutorOfertaRepresentante;
	}

	public String getSociedad() {
		return sociedad;
	}

	public void setSociedad(String sociedad) {
		this.sociedad = sociedad;
	}

	public DDVinculoCaixa getVinculoCaixa() {
		return vinculoCaixa;
	}

	public void setVinculoCaixa(DDVinculoCaixa vinculoCaixa) {
		this.vinculoCaixa = vinculoCaixa;
	}

	public Long getIdPersonaHayaRepresentante() {
		return idPersonaHayaRepresentante;
	}

	public void setIdPersonaHayaRepresentante(Long idPersonaHayaRepresentante) {
		this.idPersonaHayaRepresentante = idPersonaHayaRepresentante;
	}

	public Boolean getPrp() {
		return prp;
	}

	public void setPrp(Boolean prp) {
		this.prp = prp;
	}

	public String getOficinaTrabajo() {
		return oficinaTrabajo;
	}

	public void setOficinaTrabajo(String oficinaTrabajo) {
		this.oficinaTrabajo = oficinaTrabajo;
	}

	public DDProvincia getProvinciaNacimientoRep() {
		return provinciaNacimientoRep;
	}

	public void setProvinciaNacimientoRep(DDProvincia provinciaNacimientoRep) {
		this.provinciaNacimientoRep = provinciaNacimientoRep;
	}

	public DDEstadoInterlocutor getEstadoInterlocutor() {
		return estadoInterlocutor;
	}

	public void setEstadoInterlocutor(DDEstadoInterlocutor estadoInterlocutor) {
		this.estadoInterlocutor = estadoInterlocutor;
	}


	public String getIdPersonaHayaCaixaRepresentante() {
		return idPersonaHayaCaixaRepresentante;
	}

	public void setIdPersonaHayaCaixaRepresentante(String idPersonaHayaCaixaRepresentante) {
		this.idPersonaHayaCaixaRepresentante = idPersonaHayaCaixaRepresentante;
	}
}
