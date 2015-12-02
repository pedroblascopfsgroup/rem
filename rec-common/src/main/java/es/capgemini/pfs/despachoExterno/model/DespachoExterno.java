package es.capgemini.pfs.despachoExterno.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Clase que representa un despacho externo.
 * @author pamuller
 *
 */
@Entity
@Table(name = "DES_DESPACHO_EXTERNO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DespachoExterno implements Serializable, Auditable {

    private static final long serialVersionUID = -4061616096861079806L;

    @Id
    @Column(name = "DES_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DespachoExternoGenerator")
    @SequenceGenerator(name = "DespachoExternoGenerator", sequenceName = "S_DES_DESPACHO_EXTERNO")
    private Long id;

    @Column(name = "DES_DESPACHO")
    private String despacho;

    @Column(name = "DES_TIPO_VIA")
    private String tipoVia;

    @Column(name = "DES_DOMICILIO")
    private String domicilio;

    @Column(name = "DES_DOMICILIO_PLAZA")
    private String domicilioPlaza;

    @Column(name = "DES_CODIGO_POSTAL")
    private Integer codigoPostal;

    @Column(name = "DES_PERSONA_CONTACTO")
    private String personaContacto;

    @Column(name = "DES_TELEFONO1")
    private String telefono1;

    @Column(name = "DES_TELEFONO2")
    private String telefono2;

    @OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_TDE_ID")
    private DDTipoDespachoExterno tipoDespacho;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ZON_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private DDZona zona;

    @Column(name = "ETC_CON_CODIGO_IMPORTE")
    private String turnadoCodigoImporteConcursal;
    
    @Column(name = "ETC_CON_CODIGO_CALIDAD")
    private String turnadoCodigoCalidadConcursal;
    
    @Column(name = "ETC_LIT_CODIGO_IMPORTE")
    private String turnadoCodigoImporteLitigios;
    
    @Column(name = "ETC_LIT_CODIGO_CALIDAD")
    private String turnadoCodigoCalidadLitigios;
    
    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

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
     * @return the despacho
     */
    public String getDespacho() {
        return despacho;
    }

    /**
     * @param despacho the despacho to set
     */
    public void setDespacho(String despacho) {
        this.despacho = despacho;
    }

    /**
     * @return the tipoVia
     */
    public String getTipoVia() {
        return tipoVia;
    }

    /**
     * @param tipoVia the tipoVia to set
     */
    public void setTipoVia(String tipoVia) {
        this.tipoVia = tipoVia;
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
     * @return the domicilioPlaza
     */
    public String getDomicilioPlaza() {
        return domicilioPlaza;
    }

    /**
     * @param domicilioPlaza the domicilioPlaza to set
     */
    public void setDomicilioPlaza(String domicilioPlaza) {
        this.domicilioPlaza = domicilioPlaza;
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
     * @return the personaContacto
     */
    public String getPersonaContacto() {
        return personaContacto;
    }

    /**
     * @param personaContacto the personaContacto to set
     */
    public void setPersonaContacto(String personaContacto) {
        this.personaContacto = personaContacto;
    }

    /**
     * @return the telefono1
     */
    public String getTelefono1() {
        return telefono1;
    }

    /**
     * @param telefono1 the telefono1 to set
     */
    public void setTelefono1(String telefono1) {
        this.telefono1 = telefono1;
    }

    /**
     * @return the telefono2
     */
    public String getTelefono2() {
        return telefono2;
    }

    /**
     * @param telefono2 the telefono2 to set
     */
    public void setTelefono2(String telefono2) {
        this.telefono2 = telefono2;
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
     * Método para el tag app:dict.
     * @return el id del despacho
     */
    public Long getCodigo() {
        return id;
    }

    /**
     * Método para el tag app:dict.
     * @return el nombre del despacho
     */
    public String getDescripcion() {
        return despacho;
    }

    public DDTipoDespachoExterno getTipoDespacho() {
        return tipoDespacho;
    }

    public void setTipoDespacho(DDTipoDespachoExterno tipoDespacho) {
        this.tipoDespacho = tipoDespacho;
    }

    public DDZona getZona() {
        return zona;
    }

    public void setZona(DDZona zona) {
        this.zona = zona;
    }

	public String getTurnadoCodigoImporteConcursal() {
		return turnadoCodigoImporteConcursal;
	}

	public void setTurnadoCodigoImporteConcursal(String turnadoCodigoImporteConcursal) {
		this.turnadoCodigoImporteConcursal = turnadoCodigoImporteConcursal;
	}

	public String getTurnadoCodigoCalidadConcursal() {
		return turnadoCodigoCalidadConcursal;
	}

	public void setTurnadoCodigoCalidadConcursal(String turnadoCodigoCalidadConcursal) {
		this.turnadoCodigoCalidadConcursal = turnadoCodigoCalidadConcursal;
	}

	public String getTurnadoCodigoImporteLitigios() {
		return turnadoCodigoImporteLitigios;
	}

	public void setTurnadoCodigoImporteLitigios(String turnadoCodigoImporteLitigios) {
		this.turnadoCodigoImporteLitigios = turnadoCodigoImporteLitigios;
	}

	public String getTurnadoCodigoCalidadLitigios() {
		return turnadoCodigoCalidadLitigios;
	}

	public void setTurnadoCodigoCalidadLitigios(String turnadoCodigoCalidadLitigios) {
		this.turnadoCodigoCalidadLitigios = turnadoCodigoCalidadLitigios;
	}
    
}
