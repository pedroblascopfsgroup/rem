package es.capgemini.pfs.segmento.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 *
 * DD_SCE_ID            BIGINT NOT NULL AUTO_INCREMENT,
   DD_SCL_ID            BIGINT NOT NULL,
   DD_SCE_CODIGO        VARCHAR(1024) NOT NULL,
   DD_SCE_DESCRIPCION   VARCHAR(50) NOT NULL,
   DD_SCE_DESCRIPCION_LARGA VARCHAR(250) DEFAULT NULL,
      VERSION INTEGER NOT NULL DEFAULT 0,USUARIOCREAR VARCHAR(10) NOT NULL,
   FECHACREAR           DATE NOT NULL,
   USUARIOMODIFICAR     VARCHAR(10),
   FECHAMODIFICAR       DATE,
   USUARIOBORRAR        VARCHAR(10),
   FECHABORRAR          DATE,
   BORRADO              NUMERIC(1,0) NOT NULL DEFAULT 0,
   PRIMARY KEY (DD_SCE_ID).
 *
 * @author Juan Pablo Bosnjak
 *
 */
@Entity
@Table(name = "DD_SCE_SEGTO_CLI_ENTIDAD", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDSegmentoEntidad implements Dictionary,Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "DD_SCE_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_SCL_ID")
    private DDSegmento segmento;

    @Column(name = "DD_SCE_CODIGO")
    private String codigo;

    @Column(name = "DD_SCE_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_SCE_DESCRIPCION_LARGA")
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
	 * @return the segmento
	 */
	public DDSegmento getSegmento() {
		return segmento;
	}

	/**
	 * @param segmento the segmento to set
	 */
	public void setSegmento(DDSegmento segmento) {
		this.segmento = segmento;
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


}
