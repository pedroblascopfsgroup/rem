package es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cirbe.model.DDPais;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;


/**
 * Clase donde se guardan las distintas Agencias de Recobro de la entidad
 *
 * @author Diana
 * 
 */
@Entity
@Table(name = "RCF_AGE_AGENCIAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroAgencia implements Auditable, Serializable{
	
	 /**
	 * 
	 */
	private static final long serialVersionUID = -1934773194960249533L;

	 @Id
	 @Column(name = "RCF_AGE_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "AgenciaRecobroGenerator")
	 @SequenceGenerator(name = "AgenciaRecobroGenerator", sequenceName = "S_RCF_AGE_AGENCIAS")
	 private Long id;
	 
	 @Column(name = "RCF_AGE_CODIGO")
	 private String codigo;
	 
	 @Column(name = "RCF_AGE_NOMBRE")
	 private String nombre;
	 
	 @Column(name = "RCF_AGE_NIF")
	 private String nif;
	 
	 @Column(name = "RCF_AGE_CONTACTO_NOMBRE")
	 private String contactoNombre;
	 
	 @Column(name = "RCF_AGE_CONTACTO_APE1")
	 private String contactoApe1;
	 
	 @Column(name = "RCF_AGE_CONTACTO_APE2")
	 private String contactoApe2;
	 
	 @Column(name = "RCF_AGE_CONTACTO_MAIL")
	 private String contactoMail;
	 
	 @Column(name = "RCF_AGE_CONTACTO_TELF")
	 private String contactoTelf;
	 
	 @Column(name = "RCF_AGE_DEN_FISCAL")
	 private String denominacionFiscal;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_TVI_ID")
	 private DDTipoVia tipoVia;
	 
	 @Column(name = "RCF_AGE_NOMBRE_VIA")
	 private String nombreVia;
	 
	 @Column(name = "RCF_AGE_NUMERO_VIA")
	 private String numero;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_PRV_ID")
	 private DDProvincia provincia;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_LOC_ID_POB")
	 private Localidad poblacion;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_LOC_ID_MUNI")
	 private Localidad municipio;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_CIC_ID")
	 private DDPais pais;
	 
	 @OneToMany(cascade = CascadeType.ALL)
	 @JoinColumn(name="RCF_AGE_ID")
	 @Where(clause=Auditoria.UNDELETED_RESTICTION)
	 private List<RecobroSubcarteraAgencia> subcarterasAgencia;
	 
	 @ManyToOne
	 @JoinColumn(name = "DES_ID")
	 private DespachoExterno despacho;

	 @ManyToOne
	 @JoinColumn(name = "USU_ID")
	 private Usuario gestor;
	 
	 @Embedded
	 private Auditoria auditoria;

	 @Version
	 private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getContactoNombre() {
		return contactoNombre;
	}

	public void setContactoNombre(String contactoNombre) {
		this.contactoNombre = contactoNombre;
	}

	public String getContactoApe1() {
		return contactoApe1;
	}

	public void setContactoApe1(String contactoApe1) {
		this.contactoApe1 = contactoApe1;
	}

	public String getContactoApe2() {
		return contactoApe2;
	}

	public void setContactoApe2(String contactoApe2) {
		this.contactoApe2 = contactoApe2;
	}

	public String getContactoMail() {
		return contactoMail;
	}

	public void setContactoMail(String contactoMail) {
		this.contactoMail = contactoMail;
	}

	public String getContactoTelf() {
		return contactoTelf;
	}

	public void setContactoTelf(String contactoTelf) {
		this.contactoTelf = contactoTelf;
	}

	public String getDenominacionFiscal() {
		return denominacionFiscal;
	}

	public void setDenominacionFiscal(String denominacionFiscal) {
		this.denominacionFiscal = denominacionFiscal;
	}

	public DDTipoVia getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(DDTipoVia tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}

	public String getNumero() {
		return numero;
	}

	public void setNumero(String numero) {
		this.numero = numero;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public Localidad getPoblacion() {
		return poblacion;
	}

	public void setPoblacion(Localidad poblacion) {
		this.poblacion = poblacion;
	}

	public Localidad getMunicipio() {
		return municipio;
	}

	public void setMunicipio(Localidad municipio) {
		this.municipio = municipio;
	}

	public DDPais getPais() {
		return pais;
	}

	public void setPais(DDPais pais) {
		this.pais = pais;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	 
	public List<RecobroSubcarteraAgencia> getSubcarterasAgencia() {
		return subcarterasAgencia;
	}

	public void setSubcarterasAgencia(List<RecobroSubcarteraAgencia> subcarterasAgencia) {
		this.subcarterasAgencia = subcarterasAgencia;
	}
	
	public String getContactoNombreApellido(){
		String r = "";
        if (contactoNombre != null && contactoNombre.length() > 0) {
            r += contactoNombre;
        }
        if (contactoApe1 != null && contactoApe1.length() > 0) {
            if (r.trim().length() > 0) {
                r += " ";
            }
            r += contactoApe1;
        }
        if (r.trim().length() > 0) {
            if (r.trim().length() > 0) {
                r += " ";
            }
        }
        if (contactoApe2 != null && contactoApe2.length() > 0) {
            r += contactoApe2;
        }
        return r;
	}

	public DespachoExterno getDespacho() {
		return despacho;
	}

	public void setDespacho(DespachoExterno despacho) {
		this.despacho = despacho;
	}

	public Usuario getGestor() {
		return gestor;
	}

	public void setGestor(Usuario gestor) {
		this.gestor = gestor;
	}

}
