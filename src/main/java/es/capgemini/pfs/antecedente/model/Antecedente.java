package es.capgemini.pfs.antecedente.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.antecedenteexterno.model.AntecedenteExterno;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Entidad Antecedentes.
 * @author omedrano
 *
 */
@Entity
@Table(name = "ANT_ANTECEDENTES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Antecedente implements Serializable,Auditable {

   private static final long serialVersionUID = -5000987797957822994L;

   @Id
   @Column(name = "ANT_ID")
   @GeneratedValue(strategy = GenerationType.AUTO, generator = "AntecedenteGenerator")
   @SequenceGenerator(name = "AntecedenteGenerator", sequenceName = "S_ANT_ANTECEDENTES")
   private Long id;

   @Column(name = "ANT_OBSERVACIONES")
   private String observaciones;

   @Column(name = "ANT_FECHA_VERIFICACION")
   private Date fechaVerificacion;

   @Column(name = "ANT_REINCIDENCIA_INTERNOS")
   private Long numReincidenciasInterno;

   @OneToOne
   @JoinColumn(name = "AEX_ID", nullable = true)
   @Where(clause = Auditoria.UNDELETED_RESTICTION)
   private AntecedenteExterno antecedenteExterno;

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
    * @return the observaciones
    */
   public String getObservaciones() {
      return observaciones;
   }

   /**
    * @param observaciones the observaciones to set
    */
   public void setObservaciones(String observaciones) {
      this.observaciones = observaciones;
   }

   /**
    * @return the fechaVerificacion
    */
   public Date getFechaVerificacion() {
      return fechaVerificacion;
   }

   /**
    * @param fechaVerificacion the fechaVerificacion to set
    */
   public void setFechaVerificacion(Date fechaVerificacion) {
      this.fechaVerificacion = fechaVerificacion;
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
    * @param version
    *            the version to set
    */
   public void setVersion(Integer version) {
      this.version = version;
   }

   /**
    * @return the numReincidenciasInterno
    */
   public Long getNumReincidenciasInterno() {
       return numReincidenciasInterno;
   }

   /**
    * @param numReincidenciasInterno the numReincidenciasInterno to set
    */
   public void setNumReincidenciasInterno(Long numReincidenciasInterno) {
       this.numReincidenciasInterno = numReincidenciasInterno;
   }

   /**
    * @return the antecedenteExterno
    */
   public AntecedenteExterno getAntecedenteExterno() {
       return antecedenteExterno;
   }

   /**
    * @param antecedenteExterno the antecedenteExterno to set
    */
   public void setAntecedenteExterno(AntecedenteExterno antecedenteExterno) {
       this.antecedenteExterno = antecedenteExterno;
   }
}
