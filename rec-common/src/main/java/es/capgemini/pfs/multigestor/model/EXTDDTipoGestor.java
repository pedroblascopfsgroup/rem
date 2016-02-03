package es.capgemini.pfs.multigestor.model;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_TGE_TIPO_GESTOR", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class EXTDDTipoGestor implements Dictionary, Auditable{
	
	public static final String DESCONOCIDO = "DESCONOCIDO";
	public static final String CODIGO_TIPO_GESTOR_SUPERVISOR = "SUP";
	public static final String CODIGO_TIPO_GESTOR_EXTERNO = "GEXT";
	public static final String CODIGO_TIPO_GESTOR_PROCURADOR = "PROC";
	public static final String CODIGO_TIPO_GESTOR_CONF_EXP = "GECEXP";
	public static final String CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP = "SUPCEXP";
	public static final String CODIGO_TIPO_GESTOR_ADMINISTRATIVO= "GADM";
	public static final String CODIGO_TIPO_GESTOR_EMPRESAS_CARACTERIZADAS= "GESEMP";
	public static final String CODIGO_TIPO_SUPERVISOR_EMPRESAS_CARACTERIZADAS= "SUPEMP";
	public static final String CODIGO_TIPO_GESTOR_PROMOTORES_CARACTERIZADAS= "GESPRO";
	public static final String CODIGO_TIPO_SUPERVISOR_PROMOTORES_CARACTERIZADAS= "SUPPRO";
	public static final String CODIGO_TIPO_GESTOR_AGENCIA_RECOBRO="GAGER";
	public static final String CODIGO_TIPO_SUPERVISOR_AGENCIA_RECOBRO="SAGER";
	public static final String CODIGO_TIPO_GESTOR_PROPONENTE_ACUERDO="PROPACU";
	public static final String CODIGO_TIPO_LETRADO = "LETR";
    public static final String CODIGO_TIPO_PREPARADOR_DOCUMENTAL_PCO = "PREDOC";

    // CAJAMAR
    public static final String CODIGO_TIPO_GESTOR_DOCUMENTAL_PCO = "CM_GD_PCO";

	/**
	 * 
	 */
	private static final long serialVersionUID = 5144231969419560830L;

	@Id
    @Column(name = "DD_TGE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTDDTipoGestorGenerator")
    @SequenceGenerator(name = "EXTDDTipoGestorGenerator", sequenceName = "S_DD_TGE_TIPO_GESTOR")
    private Long id;

    @Column(name = "DD_TGE_CODIGO")
    private String codigo;

    @Column(name = "DD_TGE_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TGE_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    
    @OneToMany(mappedBy = "supervisor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "dd_tge_sup")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<EXTDDSupervisores> supervisados;

    @Column(name = "DD_TGE_EDITABLE_WEB")
    private Boolean editableWeb;
    
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

    public Boolean getEditableWeb() {
		return editableWeb;
	}

	public void setEditableWeb(Boolean editableWeb) {
		this.editableWeb = editableWeb;
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

	public List<EXTDDSupervisores> getSupervisados() {
		return supervisados;
	}

	public void setSupervisados(List<EXTDDSupervisores> supervisados) {
		this.supervisados = supervisados;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof EXTDDTipoGestor){
			return id.equals(((EXTDDTipoGestor)obj).id);
		}else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return (EXTDDTipoGestor.class.getName() + id.toString()).hashCode();
	}
    
    
    
}
