package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Funcion;


@Entity
@Table(name = "DD_OPM_OPERACION_MASIVA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDDOperacionMasiva implements Serializable, Auditable, Dictionary {

	// (Tabla DD_OPM_OPERACION_MASIVA)
	// CODIGO POR TIPOS DE PROCESIMIENTOS MASIVO
	public static final String CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED="AGAR";
	public static final String CODE_FILE_BULKUPLOAD_NEW_BUILDING="AGAN";
	public static final String CODE_FILE_BULKUPLOAD_LISTAACTIVOS="LACT";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR="APUB";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO="AOAC";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARACTIVO="ADAC";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARPRECIO="AOPR";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARPRECIO="ADPR";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESPUBLICAR="ADPU";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION="AEME";
		  
		  
	private static final long serialVersionUID = 5938440720826995243L;

	
	
	@Id
    @Column(name = "DD_OPM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDOperacionMasivaGenerator")
    @SequenceGenerator(name = "MSVDDOperacionMasivaGenerator", sequenceName = "S_DD_OPM_OPERACION_MASIVA")
    private Long id;

    @Column(name = "DD_OPM_CODIGO")
    private String codigo;

    @Column(name = "DD_OPM_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_OPM_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @ManyToOne
    @JoinColumn(name = "FUN_ID")
    private Funcion funcion;
    
    @Column(name="DD_OPM_VALIDACION_FORMATO")
    private String validacionFormato;
    
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

	public Funcion getFuncion() {
		return funcion;
	}

	public void setFuncion(Funcion funcion) {
		this.funcion = funcion;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setValidacionFormato(String validacionFormato) {
		this.validacionFormato = validacionFormato;
	}

	public String getValidacionFormato() {
		return validacionFormato;
	}

}
