package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * Modelo que gestiona la información de los ejercicios laborales.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_EJE_EJERCICIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Ejercicio implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;	
	
	@Id
    @Column(name = "EJE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EjercicioGenerator")
    @SequenceGenerator(name = "EjercicioGenerator", sequenceName = "S_ACT_EJE_EJERCICIO")
    private Long id;	


    @Column(name = "EJE_ANYO")
    private String anyo;   

	@Column(name = "EJE_FECHAINI")
	private Date fechaIni;
	
	@Column(name = "EJE_FECHAFIN")
	private Date fechaFin;
	
	@Column(name = "EJE_DESCRIPCION")
	private String descripcion;

	
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

	public String getAnyo() {
		return anyo;
	}

	public void setAnyo(String anyo) {
		this.anyo = anyo;
	}

	public Date getFechaIni() {
		return fechaIni;
	}

	public void setFechaIni(Date fechaIni) {
		this.fechaIni = fechaIni;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
