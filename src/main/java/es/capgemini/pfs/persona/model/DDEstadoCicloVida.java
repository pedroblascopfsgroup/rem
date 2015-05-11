package es.capgemini.pfs.persona.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * 
 * @author david
 *
 */
@Entity
@Table(name = "DD_ECV_ESTADO_CICLO_VIDA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoCicloVida implements Auditable, Dictionary {

	private static final long serialVersionUID = -6869689861057287120L;

	@Id
	 @Column(name = "DD_ECV_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoCicloVidaGenerator")
	 @SequenceGenerator(name = "DDEstadoCicloVidaGenerator", sequenceName = "S_DD_ECV_ESTADO_CICLO_VIDA")
	 private Long id;
	    
	 @Column(name = "DD_ECV_DESCRIPCION")   
	 private String descripcion;
	    
	 @Column(name = "DD_ECV_DESCRIPCION_LARGA")   
	 private String descripcionLarga;
	    
	 @Column(name = "DD_ECV_CODIGO")   
	 private String codigo;
	    
	 @Version   
	 private Long version;

	 @Embedded
	 private Auditoria auditoria;
	 
	@Override
	public Long getId() {
		// TODO Auto-generated method stub
		return id;
	}

	@Override
	public String getCodigo() {
		// TODO Auto-generated method stub
		return codigo;
	}
	
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	
	@Override
	public String getDescripcion() {
		// TODO Auto-generated method stub
		return descripcion;
	}
	
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	@Override
	public String getDescripcionLarga() {
		// TODO Auto-generated method stub
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}
	
	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub
		this.auditoria=auditoria;

	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

}
