package es.pfsgroup.recovery.ext.impl.visibilidad.model;

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

@Entity
@Table(name = "DD_TVB_TIPO_VISIBILIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class EXTDDTipoVisibilidad implements Dictionary, Auditable{
	
/**
	 * 
	 */
	private static final long serialVersionUID = -5842838120807719789L;

public static final String CODIGO_VISIBILIDAD_DESPACHO = "DES";
	
	@Id
    @Column(name = "DD_TVB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoVisibilidadGenerator")
    @SequenceGenerator(name = "DDTipoVisibilidadGenerator", sequenceName = "S_DD_TVB_TIPO_VISIBILIDAD")
    private Long id;

    @Column(name = "DD_TVB_CODIGO")
    private String codigo;

    @Column(name = "DD_TVB_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TVB_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "DD_TVB_NOMBRE_CLASE")
    private String nombreClase;
    
    @Column(name = "DD_TVB_NOMBRE_TABLA")
    private String nombreTabla;

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

	public String getNombreClase() {
		return nombreClase;
	}

	public void setNombreClase(String nombreClase) {
		this.nombreClase = nombreClase;
	}

	public String getNombreTabla() {
		return nombreTabla;
	}

	public void setNombreTabla(String nombreTabla) {
		this.nombreTabla = nombreTabla;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

}
