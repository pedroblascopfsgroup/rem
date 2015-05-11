package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model;

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
 * @author diana
 *
 */
@Entity
@Table(name = "DD_RGM_RESULT_GESTION_MENSA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class DDResultadoGestionMensajeria implements Auditable, Dictionary{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8900112323438284139L;

	@Id
    @Column(name = "DD_RGM_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDResultadoGestionMensajeriaGenerator")
	@SequenceGenerator(name = "DDResultadoGestionMensajeriaGenerator", sequenceName = "S_DD_RGM_RESULT_GESTION_MENSA")
    private Long id;

    @Column(name = "DD_RGM_CODIGO")
    private String codigo;

    @Column(name = "DD_RGM_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_RGM_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Version
    private Integer version;

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

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}
    

}
