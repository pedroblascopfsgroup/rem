package es.capgemini.pfs.recuperacion.model;

import java.io.Serializable;
import java.util.Date;

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

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;

/**
 * Clase que representa una fecuperación.
 * @author Mariano ruiz
 *
 */
@Entity
@Table(name = "REC_RECUPERACIONES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Recuperacion implements Serializable,Auditable {

   private static final long serialVersionUID = 615350232809294377L;

   @Id
   @Column(name = "REC_ID")
   @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecuperacionGenerator")
   @SequenceGenerator(name = "RecuperacionGenerator", sequenceName = "S_REC_RECUPERACIONES")
   private Long id;

   @ManyToOne
   @JoinColumn(name = "CNT_ID")
   private Contrato contrato;

   @ManyToOne
   @JoinColumn(name = "ASU_ID")
   private Asunto asunto;

   @ManyToOne
   @JoinColumn(name = "EXP_ID")
   private Expediente expediente;

   @ManyToOne
   @JoinColumn(name = "CLI_ID")
   private Cliente cliente;

   @Column(name = "REC_FECHA_ENTREGA")
   private Date fechaEntrega;

   @ManyToOne
   @JoinColumn(name = "DD_EST_ID")
   private DDEstadoItinerario estadoItineario;

   @Column(name = "REC_IMPORTE_ENTREGADO")
   private Double importeEntregado;

   @Column(name = "REC_IMPORTE_RECUPERADO")
   private Double importeRecuperado;

   @Version
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
    * @return the asunto
    */
   public Asunto getAsunto() {
      return asunto;
   }

   /**
    * @param asunto the asunto to set
    */
   public void setAsunto(Asunto asunto) {
      this.asunto = asunto;
   }

   /**
    * @return the expediente
    */
   public Expediente getExpediente() {
      return expediente;
   }

   /**
    * @param expediente the expediente to set
    */
   public void setExpediente(Expediente expediente) {
      this.expediente = expediente;
   }

   /**
    * @return the cliente
    */
   public Cliente getCliente() {
      return cliente;
   }

   /**
    * @param cliente the cliente to set
    */
   public void setCliente(Cliente cliente) {
      this.cliente = cliente;
   }

   /**
    * @return the fechaEntrega
    */
   public Date getFechaEntrega() {
      return fechaEntrega;
   }

   /**
    * @param fechaEntrega the fechaEntrega to set
    */
   public void setFechaEntrega(Date fechaEntrega) {
      this.fechaEntrega = fechaEntrega;
   }

   /**
    * @return the estadoItineario
    */
   public DDEstadoItinerario getEstadoItineario() {
      return estadoItineario;
   }

   /**
    * @param estadoItineario the estadoItineario to set
    */
   public void setEstadoItineario(DDEstadoItinerario estadoItineario) {
      this.estadoItineario = estadoItineario;
   }

   /**
    * @return the importeEntregado
    */
   public Double getImporteEntregado() {
      return importeEntregado;
   }

   /**
    * @param importeEntregado the importeEntregado to set
    */
   public void setImporteEntregado(Double importeEntregado) {
      this.importeEntregado = importeEntregado;
   }

   /**
    * @return the importeRecuperado
    */
   public Double getImporteRecuperado() {
      return importeRecuperado;
   }

   /**
    * @param importeRecuperado the importeRecuperado to set
    */
   public void setImporteRecuperado(Double importeRecuperado) {
      this.importeRecuperado = importeRecuperado;
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
