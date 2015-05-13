package es.pfsgroup.plugin.controlcalidad.model;

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
 * Modelo de datos para el diccionario de tipos de control de calidad
 * @author Guillem
 *
 */
@Entity
@Table(name = "DD_TCC_TIPO_CONTROL_CALIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DDTipoControlCalidad implements Auditable, Dictionary{
	
	private static final long serialVersionUID = 3537825507762616481L;
	public final static String CODIGO_TIPO_CONTROL_CALIDAD_PROCEDIMIENTO_RECOBRO = "PRC_REC";

	@Id
    @Column(name = "DD_TCC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoControlCalidadGenerator")
	@SequenceGenerator(name = "TipoControlCalidadGenerator", sequenceName = "S_DD_TCC_TIPO_CONTROL_CALIDAD")
    private Long id;

    @Column(name = "DD_TCC_CODIGO")
    private String codigo;

    @Column(name = "DD_TCC_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_TCC_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "DD_TCC_NOMBRE_TABLA")
    private String nombreTabla;
    
    @Column(name = "DD_TCC_NOMBRE_ENTIDAD")
    private String nombreEntidad;
    
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

	public String getNombreTabla() {
		return nombreTabla;
	}

	public void setNombreTabla(String nombreTabla) {
		this.nombreTabla = nombreTabla;
	}

	public String getNombreEntidad() {
		return nombreEntidad;
	}

	public void setNombreEntidad(String nombreEntidad) {
		this.nombreEntidad = nombreEntidad;
	}
    
}
