package es.capgemini.pfs.antecedenteinterno.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Clase que representa un registro de la tabla de antecendentes internos.
 * @author Mariano Ruiz
 *
 */
@Entity
@Table(name = "AIN_ANTECEDENTEINTERNOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AntecedenteInterno implements Serializable, Auditable {

   private static final long serialVersionUID = -3467423441938453169L;

   @Id
   @Column(name = "AIN_ID")
   @GeneratedValue(strategy = GenerationType.AUTO, generator = "AntecedenteInternoGenerator")
   @SequenceGenerator(name = "AntecedenteInternoGenerator", sequenceName = "S_AIN_ANTECEDENTEINTERNOS")
   private Long id;

   @OneToOne
   @JoinColumn(name = "CNT_ID")
   @Where(clause = Auditoria.UNDELETED_RESTICTION)
   private Contrato contrato;

   @Column(name = "AIN_POS_IRREGULAR_MAX")
   private Double posIrregularMax;

   @Column(name = "AIN_DIAS_MAX_IRREGULAR")
   private Long diasIrregularMax;

   @Column(name = "AIN_FECHA_ULT_REGULARIZACION")
   private Date fechaUltimaRegularizacion;

   private Integer version;

   @Embedded
   private Auditoria auditoria;

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
    * @return the contrato
    */
   public Contrato getContrato() {
      return contrato;
   }

   /**
    * @param contrato the contrato to set
    */
   public void setContrato(Contrato contrato) {
      this.contrato = contrato;
   }

   /**
    * @return the posIrregularMax
    */
   public Double getPosIrregularMax() {
      return posIrregularMax;
   }

   /**
    * @param posIrregularMax the posIrregularMax to set
    */
   public void setPosIrregularMax(Double posIrregularMax) {
      this.posIrregularMax = posIrregularMax;
   }

   /**
    * @return the diasIrregularMax
    */
   public Long getDiasIrregularMax() {
      return diasIrregularMax;
   }

   /**
    * @param diasIrregularMax the diasIrregularMax to set
    */
   public void setDiasIrregularMax(Long diasIrregularMax) {
      this.diasIrregularMax = diasIrregularMax;
   }

   /**
    * @return the fechaUltimaRegularizacion formateada
    */
   public String getFechaUltimaRegularizacionFormateada() {
      SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
      if (getFechaUltimaRegularizacion() != null) {
         return df.format(getFechaUltimaRegularizacion());
      }
      return "";
   }

   /**
    * @return the fechaUltimaRegularizacion
    */
   public Date getFechaUltimaRegularizacion() {
      return fechaUltimaRegularizacion;
   }

   /**
    * @param fechaUltimaRegularizacion the fechaUltimaRegularizacion to set
    */
   public void setFechaUltimaRegularizacion(Date fechaUltimaRegularizacion) {
      this.fechaUltimaRegularizacion = fechaUltimaRegularizacion;
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
}
