package es.pfsgroup.plugin.rem.model.dd;


import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Diccionario Si/No para REM
 * @author Ivan Rubio
 *
 */
@Entity
@Table(name = "DD_SIN_SINO", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDSinSiNo implements Auditable, Dictionary {

    private static final long serialVersionUID = 1L;
    public static final String CODIGO_SI = "01";
    public static final String CODIGO_NO = "02";

    @Id
    @Column(name = "DD_SIN_ID")
    private Long id;

    @Column(name = "DD_SIN_CODIGO")
    private String codigo;

    @Column(name = "DD_SIN_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_SIN_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }
    

    public static Boolean cambioDiccionarioaBooleano(DDSinSiNo diccionario) {
        Boolean dicc= null;
        if(diccionario!=null) {
        	if(DDSinSiNo.CODIGO_NO.equals(diccionario.getCodigo())) {
        		dicc= false;
        	}else if(DDSinSiNo.CODIGO_SI.equals(diccionario.getCodigo())){
        		dicc = true;
        	}
        }
    	return dicc;   	
    }
    
    public static String cambioBooleanToCodigoDiccionario(Boolean valor) {
    	String codigoDiccionario = null;
    	if(valor != null) {
	    	if(valor) {
	    		codigoDiccionario = CODIGO_SI;
	    	}else {
	    		codigoDiccionario = CODIGO_NO;
	    	}
    	}
    	
    	return codigoDiccionario;
    }
    
    public static boolean cambioDiccionarioaBooleanoNativo(DDSinSiNo diccionario) {
        boolean dicc= false;
        if(diccionario!=null && DDSinSiNo.CODIGO_SI.equals(diccionario.getCodigo())){
        	dicc = true;
        }
    	return dicc;   	
    }
    
    public static Boolean cambioStringtoBooleano(String codigo) {
        Boolean dicc= null;

    	if(DDSinSiNo.CODIGO_NO.equals(codigo)) {
    		dicc= false;
    	}else if(DDSinSiNo.CODIGO_SI.equals(codigo)){
    		dicc = true;
    	}
    	return dicc;   	
    }
}
