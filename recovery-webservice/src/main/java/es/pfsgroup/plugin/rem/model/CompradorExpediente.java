package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDUsosActivo;


/**
 * Modelo que gestiona la informacion de un comprador en un expediente
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "CEX_COMPRADOR_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class CompradorExpediente implements Serializable {
	
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
	    
    @Column(name = "CEX_NOMBRE_REPRESENTANTE")
    private String nombreRepresentante;
    
    @Column(name = "CEX_APELLIDOS_REPRESENTANTE")
    private String apellidosRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_REPRESENTANTE	")
	private DDTipoDocumento tipoDocumentoRepresentante;
    
    @Column(name = "CEX_DOCUMENTO_REPRESENTANTE")
    private String documentoRepresentante;
    
    @Column(name = "CEX_TELEFONO1_REPRESENTANTE")
    private String telefono1Representante;
    
    @Column(name = "CEX_TELEFONO2_REPRESENTANTE")
    private String telefono2Representante;
    
    @Column(name = "CEX_EMAIL_REPRESENTANTE")
    private String emailRepresentante;
    
    @Column(name = "CEX_DIRECCION_REPRESENTANTE")
    private String direccionRepresentante;
    
    @Column(name = "CEX_MUNICIPIO_REPRESENTANTE")
    private String municipioRepresentante;
    
    @Column(name = "CEX_CODIGO_POSTAL_REPRESENTANTE")
    private String codigoPostalRepresentante;
    
    @Column(name = "CEX_PROVINCIA_REPRESENTANTE")
    private String provinciaRepresentante;
    
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
    
    @Column(name="CEX_IMPORTE_PROPORCIONAL_OFERTA")
    private Double importeProporcionalOferta;
    
    @Column(name="CEX_IMPORTE_FINANCIADO")
    private Double importeFinanciado;
    
    @Column(name="CEX_RESPONSABLE_TRAMITACION")
    private String responsableTramitacion;
    
    
    
	@Version   
	private Long version;

    
    /**
     * defualt contructor.
     */
    public CompradorExpediente() {
        primaryKey = new CompradorExpedientePk();
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

	public String getMunicipioRepresentante() {
		return municipioRepresentante;
	}

	public void setMunicipioRepresentante(String municipioRepresentante) {
		this.municipioRepresentante = municipioRepresentante;
	}

	public String getCodigoPostalRepresentante() {
		return codigoPostalRepresentante;
	}

	public void setCodigoPostalRepresentante(String codigoPostalRepresentante) {
		this.codigoPostalRepresentante = codigoPostalRepresentante;
	}

	public String getProvinciaRepresentante() {
		return provinciaRepresentante;
	}

	public void setProvinciaRepresentante(String provinciaRepresentante) {
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
    
   
}
