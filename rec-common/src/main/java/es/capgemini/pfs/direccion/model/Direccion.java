package es.capgemini.pfs.direccion.model;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase que representa una direccion.
 */

@Entity
@Table(name = "DIR_DIRECCIONES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class Direccion implements Serializable, Auditable {

    private static final long serialVersionUID = -4165996513581993354L;
    private static final NumberFormat codigoPostalFormat = new DecimalFormat("00000");
    
    @Id
    @Column(name = "DIR_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad;

    @Column(name = "DIR_MUNICIPIO")
    private String municipio;

    @OneToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;

    @Column(name = "DIR_DOMICILIO")
    private String domicilio;

    @Column(name = "DIR_DOM_N")
    private String domicilio_n;

    @Column(name = "DIR_DOM_PISO")
    private String piso;

    @Column(name = "DIR_DOM_PORTAL")
    private String portal;

    @Column(name = "DIR_DOM_ESC")
    private String escalera;

    @Column(name = "DIR_DOM_PUERTA")
    private String puerta;

    @Column(name = "DIR_CODIGO_POSTAL")
    private Integer codigoPostal;

    @ManyToOne
    @JoinColumn(name = "DD_TVI_ID")
    private DDTipoVia tipoVia;

    @ManyToMany(mappedBy = "direcciones")
    // map info is in person class
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<Persona> personas;

    @Column(name = "DIR_COD_DIRECCION")
    private String codDireccion;
    
    @Column(name = "DIR_COD_POST_INTL")
	private String codigoPostalInternacional;
    
    @Column(name = "DIR_FECHA_EXTRACCION")
    private Date fechaExtraccion;
    
	@Column(name = "DIR_PROVINCIA")
	private String nomProvincia;
	
	@Column(name = "DIR_POBLACION")
	private String nomPoblacion;
	
	@Column(name = "DIR_INE_PROV")
	private Integer ineProv;
	
	@Column(name = "DIR_INE_POB")
	private Integer inePob;
	
	@Column(name = "DIR_INE_MUN")
	private Integer ineMun;
	
	@Column(name = "DIR_INE_VIA")
	private Integer ineVia;
	
	@Column(name = "DIR_NORMALIZADA")
	private Boolean normalizada;
	
	@Column(name = "DIR_ORIGEN")
	private String origen;

    @Embedded
    private Auditoria auditoria;

    public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public String getNomProvincia() {
		return nomProvincia;
	}

	public void setNomProvincia(String nomProvincia) {
		this.nomProvincia = nomProvincia;
	}

	public String getNomPoblacion() {
		return nomPoblacion;
	}

	public void setNomPoblacion(String nomPoblacion) {
		this.nomPoblacion = nomPoblacion;
	}

	public Integer getIneProv() {
		return ineProv;
	}

	public void setIneProv(Integer ineProv) {
		this.ineProv = ineProv;
	}

	public Integer getInePob() {
		return inePob;
	}

	public void setInePob(Integer inePob) {
		this.inePob = inePob;
	}

	public Integer getIneMun() {
		return ineMun;
	}

	public void setIneMun(Integer ineMun) {
		this.ineMun = ineMun;
	}

	public Integer getIneVia() {
		return ineVia;
	}

	public void setIneVia(Integer ineVia) {
		this.ineVia = ineVia;
	}

	public Boolean getNormalizada() {
		return normalizada;
	}

	public void setNormalizada(Boolean normalizada) {
		this.normalizada = normalizada;
	}

	public String getOrigen() {
		return origen;
	}

	public void setOrigen(String origen) {
		this.origen = origen;
	}

	@Version
    private Integer version;
    
    public String getCodigoPostalInternacional() {
		if (Checks.esNulo(codigoPostalInternacional)) {
			if (Checks.esNulo(this.getCodigoPostal())) {
				return "";
			} else {
				return (new DecimalFormat("00000")).format(getCodigoPostal());
			}
		} else {
			return codigoPostalInternacional;
		}
	}

	public void setCodigoPostalInternacional(String codigoPostalInternacional) {
		this.codigoPostalInternacional = codigoPostalInternacional;
	}

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the localidad
     */
    public Localidad getLocalidad() {
        return localidad;
    }

    /**
     * @param localidad the localidad to set
     */
    public void setLocalidad(Localidad localidad) {
        this.localidad = localidad;
    }

    /**
     * @return the municipio
     */
    public String getMunicipio() {
        return municipio;
    }

    /**
     * @param municipio the municipio to set
     */
    public void setMunicipio(String municipio) {
        this.municipio = municipio;
    }

    /**
     * @return the provincia
     */
    public DDProvincia getProvincia() {
        return provincia;
    }

    /**
     * @param provincia the provincia to set
     */
    public void setProvincia(DDProvincia provincia) {
        this.provincia = provincia;
    }

    /**
     * @return the domicilio
     */
    public String getDomicilio() {
        return domicilio;
    }

    /**
     * @param domicilio the domicilio to set
     */
    public void setDomicilio(String domicilio) {
        this.domicilio = domicilio;
    }

    /**
     * @return the domicilio_n
     */
    public String getDomicilio_n() {
        return domicilio_n;
    }

    /**
     * @param domicilio_n the domicilio_n to set
     */
    public void setDomicilio_n(String domicilio_n) {
        this.domicilio_n = domicilio_n;
    }

    /**
     * @return the piso
     */
    public String getPiso() {
        return piso;
    }

    /**
     * @param piso the piso to set
     */
    public void setPiso(String piso) {
        this.piso = piso;
    }

    /**
     * @return the portal
     */
    public String getPortal() {
        return portal;
    }

    /**
     * @param portal the portal to set
     */
    public void setPortal(String portal) {
        this.portal = portal;
    }

    /**
     * @return the escalera
     */
    public String getEscalera() {
        return escalera;
    }

    /**
     * @param escalera the escalera to set
     */
    public void setEscalera(String escalera) {
        this.escalera = escalera;
    }

    /**
     * @return the puerta
     */
    public String getPuerta() {
        return puerta;
    }

    /**
     * @param puerta the puerta to set
     */
    public void setPuerta(String puerta) {
        this.puerta = puerta;
    }

    /**
     * @return the codigoPostal
     */
    public Integer getCodigoPostal() {
        return codigoPostal;
    }

    /**
     * @param codigoPostal the codigoPostal to set
     */
    public void setCodigoPostal(Integer codigoPostal) {
        this.codigoPostal = codigoPostal;
    }

    /**
     * @return the tipoVia
     */
    public DDTipoVia getTipoVia() {
        return tipoVia;
    }

    /**
     * @param tipoVia the tipoVia to set
     */
    public void setTipoVia(DDTipoVia tipoVia) {
        this.tipoVia = tipoVia;
    }

    /**
     * @return the personas
     */
    public Set<Persona> getPersonas() {
        return personas;
    }

    /**
     * @param personas the personas to set
     */
    public void setPersonas(Set<Persona> personas) {
        this.personas = personas;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

	/**
	 * @return the codDireccion
	 */
	public String getCodDireccion() {
		return codDireccion;
	}

	/**
	 * @param codDireccion the codDireccion to set
	 */
	public void setCodDireccion(String codDireccion) {
		this.codDireccion = codDireccion;
	}

	/**
	 * @return String: domicilio [domicilio_n] [(CP)] [, provincia].
	 */
	@Override
    public String toString() {
		String dir = domicilio;
		if(domicilio_n != null) {
			dir += " " + domicilio_n;
		}
		if(codigoPostal != null) {
			dir += " (" + codigoPostalFormat.format(codigoPostal) + ")";
		}
		if(provincia != null) {
			dir += ", " + provincia.getDescripcion();
		}
		return dir;
	}
}
