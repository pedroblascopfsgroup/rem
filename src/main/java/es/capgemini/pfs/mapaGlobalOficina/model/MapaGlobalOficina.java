package es.capgemini.pfs.mapaGlobalOficina.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.segmento.model.DDSegmento;
import es.capgemini.pfs.subfase.model.Subfase;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Entidad de resumen por oficina.
 * <br> Ver tabla ans_mgb_mapa_global_oficinas.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "ans_mgb_mapa_global_oficinas", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class MapaGlobalOficina implements Serializable, Auditable {

   private static final long serialVersionUID = 1L;

   @Id
   @Column(name = "ANS_MGB_ID")
   @GeneratedValue(strategy = GenerationType.AUTO, generator = "MGBGenerator")
   @SequenceGenerator(name = "MGBGenerator", sequenceName = "S_ANS_MGB_MAPA_GLOBAL_OFICINAS")
   private Long id;

   @Embedded
   private Auditoria auditoria;

   @Version
   private Integer version;

   @Column(name = "FECHA_EXTRACCION")
   private Date fechaExtraccion;

   @ManyToOne
   @JoinColumn(name = "DD_SMG_ID")
   private Subfase subfase;

   @ManyToOne
   @JoinColumn(name = "OFI_ID")
   private Oficina oficina;

   @ManyToOne
   @JoinColumn(name = "ZON_ID")
   private DDZona zona;

   @ManyToOne
   @JoinColumn(name = "DD_SCL_ID")
   private DDSegmento segmentoPersona;

   @ManyToOne
   @JoinColumn(name = "DD_TPR_ID")
   private DDTipoProducto tipoProducto;

   @Column(name = "ANS_MGB_CLIENTES")
   private Long cantidadClientes;

   @Column(name = "ANS_MGB_CONTRATOS")
   private Long cantidadContratos;

   @Column(name = "ANS_MGB_SUM_POS_VIVA")
   private Double sumaPosVivaNoVencida;

   @Column(name = "ANS_MGB_SUM_POS_VENCIDA")
   private Double sumaPosVivaVencida;

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

   /**
    * @return the fechaExtraccion
    */
   public Date getFechaExtraccion() {
      return fechaExtraccion;
   }

   /**
    * @param fechaExtraccion the fechaExtraccion to set
    */
   public void setFechaExtraccion(Date fechaExtraccion) {
      this.fechaExtraccion = fechaExtraccion;
   }

   /**
    * @return the subFase
    */
   public Subfase getSubfase() {
      return subfase;
   }

   /**
    * @param subFase the subFase to set
    */
   public void setSubfase(Subfase subFase) {
      this.subfase = subFase;
   }

   /**
    * @return the oficina
    */
   public Oficina getOficina() {
      return oficina;
   }

   /**
    * @param oficina the oficina to set
    */
   public void setOficina(Oficina oficina) {
      this.oficina = oficina;
   }

   /**
    * @return the zona
    */
   public DDZona getZona() {
      return zona;
   }

   /**
    * @param zona the zona to set
    */
   public void setZona(DDZona zona) {
      this.zona = zona;
   }

   /**
    * @return the segmentoPersona
    */
   public DDSegmento getSegmentoPersona() {
      return segmentoPersona;
   }

   /**
    * @param segmentoPersona the segmentoPersona to set
    */
   public void setSegmentoPersona(DDSegmento segmentoPersona) {
      this.segmentoPersona = segmentoPersona;
   }

   /**
    * @return the tipoProducto
    */
   public DDTipoProducto getTipoProducto() {
      return tipoProducto;
   }

   /**
    * @param tipoProducto the tipoProducto to set
    */
   public void setTipoProducto(DDTipoProducto tipoProducto) {
      this.tipoProducto = tipoProducto;
   }

   /**
    * @return the cantidadClientes
    */
   public Long getCantidadClientes() {
      return cantidadClientes;
   }

   /**
    * @param cantidadClientes the cantidadClientes to set
    */
   public void setCantidadClientes(Long cantidadClientes) {
      this.cantidadClientes = cantidadClientes;
   }

   /**
    * @return the cantidadContratos
    */
   public Long getCantidadContratos() {
      return cantidadContratos;
   }

   /**
    * @param cantidadContratos the cantidadContratos to set
    */
   public void setCantidadContratos(Long cantidadContratos) {
      this.cantidadContratos = cantidadContratos;
   }

   /**
    * @return the sumaPosVivaNoVencida
    */
   public Double getSumaPosVivaNoVencida() {
      return sumaPosVivaNoVencida;
   }

   /**
    * @param sumaPosVivaNoVencida the sumaPosVivaNoVencida to set
    */
   public void setSumaPosVivaNoVencida(Double sumaPosVivaNoVencida) {
      this.sumaPosVivaNoVencida = sumaPosVivaNoVencida;
   }

   /**
    * @return the sumaPosVivaVencida
    */
   public Double getSumaPosVivaVencida() {
      return sumaPosVivaVencida;
   }

   /**
    * @param sumaPosVivaVencida the sumaPosVivaVencida to set
    */
   public void setSumaPosVivaVencida(Double sumaPosVivaVencida) {
      this.sumaPosVivaVencida = sumaPosVivaVencida;
   }

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
}
