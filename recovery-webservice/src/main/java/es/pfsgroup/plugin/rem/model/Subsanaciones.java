package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import es.pfsgroup.plugin.rem.model.dd.DDEstadosSubsanacion;


/**
 * Modelo que gestiona la informacion de las subsanaciones de un expediente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "SUB_SUBSANACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Subsanaciones implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "SUB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "SubsanacionesGenerator")
    @SequenceGenerator(name = "SubsanacionesGenerator", sequenceName = "S_SUB_SUBSANACIONES")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ESU_ID")
	private DDEstadosSubsanacion estado;   
	
	@Column(name="SUB_PETICIONARIO")
	private String peticionario;	
	
	@Column(name="SUB_MOTIVO")
	private String motivo;
	
	@Column(name="SUB_FECHA_PETICION")
	private Date fechaPeticion;

	@Column(name="SUB_GASTOS_SUBSANACION")
	private String gastosSubsanacion;
	
	@Column(name="SUB_GASTOS_INSCRIPCION")
	private String gastosInscripcion;
	
	
    
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

	

	public String getPeticionario() {
		return peticionario;
	}

	public void setPeticionario(String peticionario) {
		this.peticionario = peticionario;
	}

	public Date getFechaPeticion() {
		return fechaPeticion;
	}

	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}

	

	public DDEstadosSubsanacion getEstado() {
		return estado;
	}

	public void setEstado(DDEstadosSubsanacion estado) {
		this.estado = estado;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public String getGastosSubsanacion() {
		return gastosSubsanacion;
	}

	public void setGastosSubsanacion(String gastosSubsanacion) {
		this.gastosSubsanacion = gastosSubsanacion;
	}

	public String getGastosInscripcion() {
		return gastosInscripcion;
	}

	public void setGastosInscripcion(String gastosInscripcion) {
		this.gastosInscripcion = gastosInscripcion;
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
