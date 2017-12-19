package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Modelo que gestiona los activos.
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "DD_GCM_GESTOR_CARGA_MASIVA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDGestorCargaMasiva implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "DD_GCM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDGestorCargaMasivaGenerator")
    @SequenceGenerator(name = "DDGestorCargaMasivaGenerator", sequenceName = "S_DD_GCM_GESTOR_CARGA_MASIVA")
    private Long id;
    
    @Column(name = "DD_ERE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_ERE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_ERE_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera; 
    
    @Column(name = "DD_GCM_ACTIVO")   
	private Boolean permiteActivo;
    
    @Column(name = "DD_GCM_AGRUPACION")   
	private Boolean permiteAgrupacion;
    
    @Column(name = "DD_GCM_EXPEDIENTE")   
	private Boolean permiteExpediente;

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

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public Boolean getPermiteActivo() {
		return permiteActivo;
	}

	public void setPermiteActivo(Boolean permiteActivo) {
		this.permiteActivo = permiteActivo;
	}

	public Boolean getPermiteAgrupacion() {
		return permiteAgrupacion;
	}

	public void setPermiteAgrupacion(Boolean permiteAgrupacion) {
		this.permiteAgrupacion = permiteAgrupacion;
	}

	public Boolean getPermiteExpediente() {
		return permiteExpediente;
	}

	public void setPermiteExpediente(Boolean permiteExpediente) {
		this.permiteExpediente = permiteExpediente;
	}

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub
		
	}
	
}
    
    
    