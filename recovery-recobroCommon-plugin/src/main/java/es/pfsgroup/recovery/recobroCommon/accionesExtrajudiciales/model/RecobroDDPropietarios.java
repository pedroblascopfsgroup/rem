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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Clase donde se mapean los propietarios
 * @author Guillem
 *
 */
@Entity
@Table(name = "DD_PRO_PROPIETARIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroDDPropietarios implements Auditable, Dictionary{
	
	private static final long serialVersionUID = 3537825507762616481L;

	@Id
    @Column(name = "DD_PRO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroPropietariosGenerator")
	@SequenceGenerator(name = "RecobroPropietariosGenerator", sequenceName = "S_DD_PRO_PROPIETARIOS")
    private Long id;

    @Column(name = "DD_PRO_CODIGO")
    private String codigo;

    @Column(name = "DD_PRO_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_PRO_DESCRIPCION_LARGA")
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
