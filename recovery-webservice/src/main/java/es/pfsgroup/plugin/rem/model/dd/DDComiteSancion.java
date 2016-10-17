package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;

/**
 * Modelo que gestiona el diccionario de comités sancionadores
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_COS_COMITES_SANCION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDComiteSancion implements Auditable, Dictionary {
	

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_COS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDComiteSancionGenerator")
	@SequenceGenerator(name = "DDComiteSancionGenerator", sequenceName = "S_DD_COS_COMITES_SANCION")
	private Long id;
	    
	@Column(name = "DD_COS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_COS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_COS_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;
    
    @Transient
    private String carteraCodigo;

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

	public String getCarteraCodigo() {
		return Checks.esNulo(cartera) ? carteraCodigo : cartera.getCodigo();
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = Checks.esNulo(cartera) ? carteraCodigo : cartera.getCodigo();
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