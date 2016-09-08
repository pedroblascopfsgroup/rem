package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTiposCompareciente;


/**
 * Modelo que gestiona la informacion de un compareciente por cuenta del vendedor en el informe comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "COV_COMPARECIENTES_VENDEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ComparecienteVendedor implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "COV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ComparecientesVendedorGenerator")
    @SequenceGenerator(name = "ComparecientesVendedorGenerator", sequenceName = "S_COV_COMPARECIENTES_VENDEDOR")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCO_ID")
    private DDTiposCompareciente tipoCompareciente;
    
    @Column(name = "COV_NOMBRE")
    private String nombre;
        
    @Column(name = "COV_DIRECCION")
    private String direccion;    
      
    @Column(name = "COV_TELEFONO1")
    private String telefono1;
     
    @Column(name = "COV_EMAIL")
    private String email;    
   
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public DDTiposCompareciente getTipoCompareciente() {
		return tipoCompareciente;
	}

	public void setTipoCompareciente(DDTiposCompareciente tipoCompareciente) {
		this.tipoCompareciente = tipoCompareciente;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getTelefono1() {
		return telefono1;
	}

	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
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

   
}
