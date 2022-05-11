package es.pfsgroup.plugin.rem.model.dd;

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
 * Modelo que gestiona el diccionario de los estados de los activos
 * 
 * @author Benjamín Guerrero
 *
 */
@Entity
@Table(name = "DD_EAC_ESTADO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoActivo implements Auditable, Dictionary {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3836191709700209057L;
	
	public static final String ESTADO_ACTIVO_SUELO = "01";
	public static final String ESTADO_ACTIVO_PROMOCION = "02";
	public static final String ESTADO_ACTIVO_TERMINADO = "03";
	public static final String ESTADO_ACTIVO_RUINA = "05";
	public static final String ESTADO_ACTIVO_VANDALIZADO = "07";
	public static final String ESTADO_ACTIVO_EN_CONSTRUCCION_EN_CURSO = "02";
	public static final String ESTADO_ACTIVO_EN_CONSTRUCCION_PARADA = "06";
	public static final String ESTADO_ACTIVO_OBRA_NUEVA_VANDALIZADO = "07";
	public static final String ESTADO_ACTIVO_NO_OBRA_NUEVA_VANDALIZADO = "08";
	public static final String ESTADO_ACTIVO_EDIFICIO_A_REHABILITAR = "09";
	public static final String ESTADO_ACTIVO_OBRA_NUEVA_PDTE_LEGALIZAR = "10";
	public static final String ESTADO_ACTIVO_NO_OBRA_NUEVA_PDTE_LEGALIZAR = "11";

	@Id
	@Column(name = "DD_EAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoActivoGenerator")
	@SequenceGenerator(name = "DDEstadoActivoGenerator", sequenceName = "S_DD_EAC_ESTADO_ACTIVO")
	private Long id;
	 
	@Column(name = "DD_EAC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EAC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EAC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	
	    
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
	
	public static boolean isObraNueva (DDEstadoActivo estadoFisico) {
        boolean is = false;
        if(estadoFisico != null && ESTADO_ACTIVO_TERMINADO.equals(estadoFisico.getCodigo())) {
            is = true;
        }
        
        return is;
    }

}
