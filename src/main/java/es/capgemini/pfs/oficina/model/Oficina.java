package es.capgemini.pfs.oficina.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.apache.commons.lang.StringUtils;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;

/**
 * clase que representa una oficina.
 * @author pamuller
 *
 */
@Entity
@Table(name = "OFI_OFICINAS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class Oficina implements Serializable, Auditable {

    private static final long serialVersionUID = 6708859812609838113L;

    @Id
    @Column(name = "OFI_ID")
    private Long id;

    @Column(name = "DD_PRV_ID")
    private Long idProvincia;

    @Column(name = "OFI_CODIGO")
    private Long codigo;

    @Column(name = "OFI_NOMBRE")
    private String nombre;

    @Column(name = "OFI_TIPO_VIA")
    private String tipoVia;

    @Column(name = "OFI_DOMICILIO")
    private String domicilio;

    @Column(name = "OFI_DOMICILIO_PLAZA")
    private String domicilioPlaza;

    @Column(name = "OFI_CODIGO_POSTAL")
    private Integer codigoPostal;

    @Column(name = "OFI_PERSONA_CONTACTO")
    private String personaContacto;

    @Column(name = "OFI_TELEFONO1")
    private String telefono1;

    @Column(name = "OFI_TELEFONO2")
    private String telefono2;

    @OneToOne(mappedBy="oficina")
    private DDZona zona;
    
    @Column(name = "OFI_CODIGO_OFICINA")
    private Integer codigoOficina;

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
     * @return the idProvincia
     */
    public Long getIdProvincia() {
        return idProvincia;
    }

    /**
     * @param idProvincia the idProvincia to set
     */
    public void setIdProvincia(Long idProvincia) {
        this.idProvincia = idProvincia;
    }

    /**
     * @return the codigo
     */
    public Long getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(Long codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
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
	 * @return the zona
	 */
	public DDZona getZona() {
		return zona;
	}

	/**
	 * @param zona the zona to set
	 */
	public void setZona(DDZona zona) {
		this.zona = zona;
	}

	public Integer getCodigoOficina() {
		return codigoOficina;
	}

	public void setCodigoOficina(Integer codigoOficina) {
		this.codigoOficina = codigoOficina;
	}
	
	/**
	 * Devuelve el código de oficina formateado con ceros por la izquierda hasta completar cuatro posiciones.
	 * Si el campo "OFI_CODIGO_OFICINA" fuera nulo devolvería el "OFI_CODIGO" sin formatear.
	 * @return String con el código de oficina formateado con ceros por la izquierda
	 */
	public String getCodigoOficinaFormat() {		
		return (!Checks.esNulo(codigoOficina)) ? StringUtils.leftPad(codigoOficina.toString(), 4, '0') : 
			(!Checks.esNulo(this.codigo)) ? this.codigo.toString() : null;
	}
	
    /**
     * Devuelve la oficina de zona correspondiente a una oficina
     * @return
     */
    public Oficina getOficinaZona(){
		return (!Checks.esNulo(this)) ? this.getZona().getZonaPadre().getOficina() : null;
    }
    
    /**
     * Devuelve la oficina territorial correspondiente a una oficina
     * @return
     */
    public Oficina getOficinaTerritorial(){
    	return (!Checks.esNulo(this.getOficinaZona())) ? this.getOficinaZona().getZona().getZonaPadre().getOficina() : null;
    }
        
    /**
     * Obtiene las cadenas de codigo de oficina para los campos DZ y DT/DN del cliente
     * @param descripcion: Set true/false to show descripcion
     * @param nombre: Set true/false to show nombre
     * @return
     */
	public String getCodDescripOficina(Boolean descripcion, Boolean nombre) {
		String codigoOficina = null;
		if (!Checks.esNulo(this.getCodigo())) {
			codigoOficina = this.getCodigo().toString();			
			if (codigoOficina.length()>2) {
				codigoOficina = codigoOficina.substring(0, codigoOficina.length()-2);
			}
			codigoOficina = StringUtils.leftPad(codigoOficina, 4, '0');
			return (descripcion) ? codigoOficina + " - " + ((nombre) ? this.getNombre() : this.getDomicilio()) : codigoOficina;
		}
		return "";
	}

}
