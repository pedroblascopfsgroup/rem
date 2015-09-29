package es.capgemini.pfs.contrato.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.LazyToOne;
import org.hibernate.annotations.LazyToOneOption;
import org.hibernate.annotations.Where;
import org.hibernate.bytecode.javassist.FieldHandled;
import org.hibernate.bytecode.javassist.FieldHandler;

import bsh.This;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.antecedenteinterno.model.AntecedenteInterno;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.multigestor.model.EXTGestorEntidad;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.titulo.model.Titulo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.Describible;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;

/**
 * Entidad Contrato.
 * @author Lisandro Medrano
 *
 */

@Entity
@Table(name = "CNT_CONTRATOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Contrato implements Serializable, Auditable, Comparable<Contrato>, Describible, FieldHandled {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -8368485360179310334L;

	private static Properties appProperties;
	
	@Transient
	private FieldHandler fieldHandler;
    
    @Id
    @Column(name = "CNT_ID")
    private Long id;

    // Tipo de producto entidad
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
    private DDTipoProductoEntidad tipoProductoEntidad;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFI_ID")
    private Oficina oficina;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ZON_ID")
    private DDZona zona;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MON_ID")
    private DDMoneda moneda;

    // Tipo de producto
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPR_ID")
    private DDTipoProducto tipoProducto;

    // ContratosPersona
    @OneToMany(mappedBy = "contrato", fetch = FetchType.LAZY)
    @OrderBy("orden asc")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ContratoPersona> contratoPersona;

    // Movimientos
    @OneToMany(mappedBy = "contrato", fetch = FetchType.LAZY)
    @JoinColumn(name = "CNT_ID")
    @OrderBy("fechaExtraccion desc")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Movimiento> movimientos;

    @Column(name = "CNT_FECHA_EXTRACCION")
    private Date fechaExtraccion;

    @Column(name = "CNT_COD_ENTIDAD")
    private Integer codigoEntidad;

    @Column(name = "CNT_COD_OFICINA")
    private Long codigoOficina;

    @Column(name = "CNT_COD_CENTRO")
    private Long codigoCentro;

    @Column(name = "CNT_CONTRATO")
    private String nroContrato;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EFC_ID")
    private DDEstadoFinanciero estadoFinanciero;

    @Column(name = "CNT_FECHA_EFC")
    private Date fechaEstadoFinanciero;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EFC_ID_ANT")
    private DDEstadoFinanciero estadoFinancieroAnterior;

    @Column(name = "CNT_FECHA_EFC_ANT")
    private Date fechaEstadoFinancieroAnterior;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ESC_ID")
    private DDEstadoContrato estadoContrato;

    @Column(name = "CNT_FECHA_ESC")
    private Date fechaEstadoContrato;

    @Column(name = "CNT_FECHA_CREACION")
    private Date fechaCreacion;

    @Column(name = "CNT_FECHA_CARGA")
    private Date fechaCarga;

    @Column(name = "CNT_FICHERO_CARGA")
    private String ficheroCarga;

    @OneToOne(mappedBy = "contrato", fetch = FetchType.LAZY)
    @JoinColumn(name = "cnt_id")
    private AntecedenteInterno antecendenteInterno;

    @OneToMany(mappedBy = "contrato", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Titulo> titulos;

    @OneToMany(mappedBy = "contrato", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ExpedienteContrato> expedienteContratos;

    @OneToMany(mappedBy = "contrato", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Cascade( { org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private Set<AdjuntoContrato> adjuntos;
    
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "BIE_CNT", joinColumns = { @JoinColumn(name = "CNT_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "BIE_ID") })
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<Bien> bienes;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @Transient
    private String codigoContrato;

    @Column(name = "CNT_LIMITE_INI")
    private Float limiteInicial;
    @Column(name = "CNT_LIMITE_FIN")
    private Float limiteFinal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_FCN_ID")
    private DDFinalidadContrato finalidadContrato;

    //finalidad ofical o finalidad acuerdo
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_FNO_ID")
    private DDFinalidadOficial finalidadAcuerdo;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_GC1_ID")
    private DDGarantiaContrato garantia1;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_GC2_ID")
    private DDGarantiaContable garantia2;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CT1_ID")
    private DDCatalogo1 catalogo1;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CT2_ID")
    private DDCatalogo2 catalogo2;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CT3_ID")
    private DDCatalogo3 catalogo3;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CT4_ID")
    private DDCatalogo4 catalogo4;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CT5_ID")
    private DDCatalogo5 catalogo5;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CT6_ID")
    private DDCatalogo6 catalogo6;

	@OneToOne(fetch = FetchType.LAZY, optional=true)
	@JoinColumn(name = "CNT_ID", updatable= false)
	@LazyToOne(LazyToOneOption.PROXY)
	private ContratoFormulas formulas;
    
    //    CNT_FECHA_CONSTITUCION   DATE, campo no viene en la carga

    @Column(name = "CNT_FECHA_VENC")
    private Date fechaVencimiento;
    
    //Nuevos campos 10.0
    
    @Column(name = "CNT_FECHA_DATO")
    private Date fechaDato;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_APO_ID")
    private DDAplicativoOrigen aplicativoOrigen;
    
    @Column(name = "CNT_IBAN")
    private String iban;

    @Column(name = "CNT_CUOTA_IMPORTE")
    private Float cuotaImporte;
    
    @Column(name = "CNT_CUOTA_PERIODICIDAD")
    private Integer cuotaPeriodicidad;
    
    @Column(name = "CNT_DISPUESTO")
    private Float dispuesto;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CNT_SISTEMA_AMORTIZACION")
    private DDSistemaAmortizContrato sistemaAmortizacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CNT_INTERES_FIJO_VAR" ,  referencedColumnName = "DD_TIN_CODIGO")
    private DDTipoInteres interesFijoVariable;
    
    @Column(name = "CNT_TIPO_INTERES")
    private Float tipoInteres;
    
    @Column(name = "CNT_CCC_DOMICILIACION")
    private String cccDomiciliacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFI_ID_CONTABLE", referencedColumnName = "OFI_ID")
    private Oficina oficinaContable;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFI_ID_ADMIN", referencedColumnName = "OFI_ID")
    private Oficina oficinaAdministrativa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_GES_ID")
    private DDGestionEspecial gestionEspecial;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRE_ID")
    private DDCondicionesRemuneracion RemuneracionEspecial;
    
    @Column(name = "CNT_DOMICI_EXT")
    private Boolean domiciliacionExterna;

    @Column(name = "CNT_PARAGUAS_ID")
    private Long contratoParaguas;
    
    @Column(name = "CNT_CONTRATO_ANTERIOR")
    private String contratoAnterior;
    
    @ManyToOne
    @JoinColumn(name = "DD_MTR_ID")
    private DDMotivoRenumeracion motivoRenumeracion;
    
    
    
	@OneToMany(mappedBy = "unidadGestionId", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "UG_ID")
	@Where(clause = "DD_EIN_ID = " + DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO)
	private List<EXTGestorEntidad> gestoresContrato;

    
  	public String getTitulizado() {
  		return this.getFormulas() == null ? null :this.getFormulas().getTitulizado();
  	}
  	
  	public String getFondo() {
  		return this.getFormulas() == null ? null :this.getFormulas().getFondo();
  	}

  	public String getNumextra1() {
  		return this.getFormulas() == null ? null :this.getFormulas().getNumExtra1();
  	}

  	public String getNumextra2() {
  		return this.getFormulas() == null ? null :this.getFormulas().getNumExtra2();
  	}

  	public String getNumextra3() {
  		return this.getFormulas() == null ? null :this.getFormulas().getNumExtra3();
  	}

  	public String getDateextra1() {
  		return this.getFormulas() == null ? null :this.getFormulas().getDateExtra1();
  	}

  	public String getCharextra1() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra1();
  	}

  	public String getCharextra2() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra2();
  	}

  	public String getCharextra3() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra3();
  	}

  	public String getCharextra4() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra4();
  	}

  	public String getCharextra5() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra5();
  	}

  	public String getCharextra6() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra6();
  	}

  	public String getCharextra7() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra7();
  	}

  	public String getCharextra8() {
  		return this.getFormulas() == null ? null :this.getFormulas().getCharExtra8();
  	}

  	public String getFlagextra1() {
  		return this.getFormulas() == null ? null :this.getFormulas().getFlagExtra1();
  	}

  	public String getFlagextra2() {
  		return this.getFormulas() == null ? null :this.getFormulas().getFlagExtra2();
  	}

  	public String getFlagextra3() {
  		return this.getFormulas() == null ? null :this.getFormulas().getFlagExtra3();
  	}
    

    
    /**
     * @return the titulos
     */
    @SuppressWarnings("unchecked")
	public List<Titulo> getTitulos() {
    	if(fieldHandler!=null)
	        return (List<Titulo>)fieldHandler.readObject(this, "titulos", titulos);
        return titulos;
    }

    /**
     * @param titulos
     *            the titulos to set
     */
    public void setTitulos(List<Titulo> titulos) {
    	if(fieldHandler!=null)
	        fieldHandler.writeObject(this, "titulos", this.titulos, titulos);
        this.titulos = titulos;
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
     * Metodo para obtener el codigo del contrato.<br>
     * Codigo Entidad + Codigo Oficina + XX + Numero de Contrato<br>
     *
     * @return el codigo de contrato
     */
    public String getCodigoContratoENTITY() {
        if (codigoContrato == null) {
            String codEntidad = rellenaConCeros(4, codigoEntidad.toString());
            String codOficina = rellenaConCeros(4, codigoOficina.toString());
            String contrato = rellenaConCeros(10, nroContrato.toString());

            return codEntidad + " " + codOficina + " " + contrato;
        }
        return codigoContrato;
    }

    /**
     * Obtiene el primer Titular del contrato.
     *
     * @return persona
     */
    public Persona getPrimerTitular() {

        List<ContratoPersona> list = getContratoPersonaOrdenado();

        if (list != null && list.size() > 0) { return getContratoPersonaOrdenado().get(0).getPersona(); }
        return null;
    }

    /**
     * devuelve el ultimo movimiento.
     *
     * @return moviemiento
     */
    public Movimiento getLastMovimiento() {
        Movimiento mv = null;

        if (movimientos != null) {
            for (Movimiento movAux : movimientos) {
                if (mv == null) {
                    mv = movAux;
                } else {
                    if (movAux.getFechaExtraccion().after(mv.getFechaExtraccion())) {
                        mv = movAux;
                    }
                }
            }
        }
        return mv;
    }

    /**
     * devuelve el primer moviemiento.
     *
     * @return movimiento
     */
    public Movimiento getFirstMovimiento() {
        Movimiento mv = null;
        if (movimientos != null) {
            for (Movimiento movAux : movimientos) {
                if (mv == null) {
                    mv = movAux;
                } else {
                    if (movAux.getFechaExtraccion().before(mv.getFechaExtraccion())) {
                        mv = movAux;
                    }
                }
            }
        }
        return mv;
    }

    /**
     * getDescripcionProductoCodificada.
     *
     * @return codificacion
     */
    public String getDescripcionProductoCodificada() {
        String codificacion = "";
        codificacion += this.tipoProducto.getDescripcion();
        codificacion += " ";
        codificacion += this.codigoEntidad;
        codificacion += " ";
        codificacion += this.codigoOficina;
        codificacion += " ";
        codificacion += this.getCodigoContrato();
        return codificacion;
    }

    /**
     * Compara si ambos contratos son el mismo.
     *
     * @param contrato Contrato
     * @return boolean
     */
    public boolean equals(Contrato contrato) {
        if (id == null || contrato == null || contrato.getId() == null) { throw new BusinessOperationException("contrato.comparar.null"); }
        if (id.equals(contrato.getId())) { return true; }
        return false;
    }

    /**
     * hashcode.
     * @return hashcode
     */
    /*   @Override
       public int hashCode() {
           return this.getId().hashCode();
       }
    */
    /**
     * is vencido.
     *
     * @return true or false
     */
    public boolean isVencido() {
        return (getLastMovimiento().getPosVivaVencida() != null || getLastMovimiento().getPosVivaVencida().doubleValue() == 0)
                && getLastMovimiento().getFechaPosVencida() != null;
    }

    /**
     * getEstaVencido. Para que se pueda utilizar con expresiones regulares
     *
     * @return true or false
     */
    public boolean getEstaVencido() {
        return isVencido();
    }

    private static final Long UN_DIA = 1000L * 60L * 60L * 24L;

    /**
     * cantidad de dias irregular.
     *
     * @return dias
     */
    public Integer getDiasIrregular() {
        if (getLastMovimiento().getFechaPosVencida() == null) { return null; }
        return diasDiferencia(getLastMovimiento().getFechaPosVencida(), new Date());
    }

    private Integer diasDiferencia(Date inicio, Date fin) {
        if (inicio == null || fin == null) { return 0; }
        long diferencia = fin.getTime() - inicio.getTime();
        if (diferencia < 0) { return 0; }
        return Math.round(diferencia / UN_DIA);
    }

    /**
     * @return monto Float: riesgo o deuda total del contrato, <code>0</code> si no tiene deuda.
     */
    public Float getRiesgo() {
        return getLastMovimiento().getRiesgo();
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the tipoProductoEntidad
     */
    public DDTipoProductoEntidad getTipoProductoEntidad() {
    	if(fieldHandler!=null)
	        return (DDTipoProductoEntidad)fieldHandler.readObject(this, "tipoProductoEntidad", tipoProductoEntidad);
        return tipoProductoEntidad;
    }

    /**
     * @param tipoProductoEntidad
     *            the tipoProductoEntidad to set
     */
    public void setTipoProductoEntidad(DDTipoProductoEntidad tipoProductoEntidad) {
    	if(fieldHandler!=null)
	        fieldHandler.writeObject(this, "tipoProductoEntidad", this.tipoProductoEntidad, tipoProductoEntidad);
        this.tipoProductoEntidad = tipoProductoEntidad;
    }

    /**
     * @return the oficina
     */
    public Oficina getOficina() {
    	if(fieldHandler!=null)
	        return (Oficina)fieldHandler.readObject(this, "oficina", oficina);
        return oficina;
    }

    /**
     * @param oficina
     *            the oficina to set
     */
    public void setOficina(Oficina oficina) {
    	if(fieldHandler!=null)
	        fieldHandler.writeObject(this, "oficina", this.oficina, oficina);       
        this.oficina = oficina;
    }

    /**
     * @return the zona
     */
    public DDZona getZona() {
    	if(fieldHandler!=null)
	        return (DDZona)fieldHandler.readObject(this, "zona", zona);
        return zona;
    }

    /**
     * @param zona
     *            the zona to set
     */
    public void setZona(DDZona zona) {
    	if(fieldHandler!=null)
    			fieldHandler.writeObject(this, "zona", this.zona, zona);
        this.zona = zona;
    }

    /**
     * @return the moneda
     */
    public DDMoneda getMoneda() {
    	if(fieldHandler!=null)
	        return (DDMoneda)fieldHandler.readObject(this, "moneda", moneda);        
        return moneda;
    }

    /**
     * @param moneda
     *            the moneda to set
     */
    public void setMoneda(DDMoneda moneda) {
    	if(fieldHandler!=null)
    			fieldHandler.writeObject(this, "moneda", this.moneda, moneda);
        this.moneda = moneda;
    }

    /**
     * @return the tipoProducto
     */
    public DDTipoProducto getTipoProducto() {
    	if(fieldHandler!=null)
    			return (DDTipoProducto) fieldHandler.readObject(this, "tipoProducto", tipoProducto);
        return tipoProducto;
    }

    /**
     * @param tipoProducto
     *            the tipoProducto to set
     */
    public void setTipoProducto(DDTipoProducto tipoProducto) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "tipoProducto", this.tipoProducto, tipoProducto);
        this.tipoProducto = tipoProducto;
    }

    /**
     * @return the contratoPersona
     */
    @SuppressWarnings("unchecked")
	public List<ContratoPersona> getContratoPersona() {
    	if(fieldHandler!=null)
    			return (List<ContratoPersona>) fieldHandler.readObject(this, "contratoPersona", contratoPersona);
        return contratoPersona;
    }

//    /**
//     * Lista ordenada por tipo de intervencion y orden de la misma.
//     * @return the contratoPersona
//     */
//    public List<ContratoPersona> getContratoPersonaOrdenado() {
//        if (contratoPersona == null || contratoPersona.isEmpty()) { return contratoPersona; }
//        SortedSet<ContratoPersona> cntPerSort = new TreeSet<ContratoPersona>(new Comparator<ContratoPersona>() {
//
//            @Override
//            public int compare(ContratoPersona o1, ContratoPersona o2) {
//                // Validaciones
//                if (o1.getTipoIntervencion() == null) { return 1; }
//                if (o2.getTipoIntervencion() == null) { return -1; }
//                // Si es del mismo tipo de intervencion orderno por el orden
//                if (o1.getTipoIntervencion().getCodigo().equals(o2.getTipoIntervencion().getCodigo())) { return o1.getOrden()
//                        .compareTo(o2.getOrden()); }
//                // Si el o1 es titular va primero
//                if (o1.getTipoIntervencion().getTitular()) { return -1; }
//                // Si el o2 es el titular o1 va después
//                if (o2.getTipoIntervencion().getTitular()) { return 1; }
//                // Si ninguno es titular ordena por codigo
//                return o1.getTipoIntervencion().getCodigo().compareTo(o2.getTipoIntervencion().getCodigo());
//            }
//        });
//
//        cntPerSort.addAll(contratoPersona);
//        // Lo transformo a lista para usarla en el jsp.
//        List<ContratoPersona> lista = new ArrayList<ContratoPersona>();
//        lista.addAll(cntPerSort);
//        return lista;
//    }

    /**
     * @param contratoPersona
     *            the contratoPersona to set
     */
    public void setContratoPersona(List<ContratoPersona> contratoPersona) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "contratoPersona", this.contratoPersona, contratoPersona);
        this.contratoPersona = contratoPersona;
    }

    /**
     * @return the movimientos
     */
    @SuppressWarnings("unchecked")
	public List<Movimiento> getMovimientos() {
    	if(fieldHandler!=null)
    		return (List<Movimiento>) fieldHandler.readObject(this, "movimientos", movimientos);
        return movimientos;
    }

    /**
     * @param movimientos
     *            the movimientos to set
     */
    public void setMovimientos(List<Movimiento> movimientos) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "movimientos", this.movimientos, movimientos);
        this.movimientos = movimientos;
    }

    /**
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
    	
        return fechaExtraccion;
    }

    /**
     * @param fechaExtraccion
     *            the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
    	
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @return the codigoEntidad
     */
    public Integer getCodigoEntidad() {
    	
        return codigoEntidad;
    }

    /**
     * @param codigoEntidad
     *            the codigoEntidad to set
     */
    public void setCodigoEntidad(Integer codigoEntidad) {
    	
        this.codigoEntidad = codigoEntidad;
    }

    /**
     * @return the codigoOficina
     */
    public Long getCodigoOficina() {
    	
        return codigoOficina;
    }

    /**
     * @param codigoOficina
     *            the codigoOficina to set
     */
    public void setCodigoOficina(Long codigoOficina) {
    	
        this.codigoOficina = codigoOficina;
    }

    /**
     * @return the codigoCentro
     */
    public Long getCodigoCentro() {
    	
        return codigoCentro;
    }

    /**
     * @param codigoCentro
     *            the codigoCentro to set
     */
    public void setCodigoCentro(Long codigoCentro) {
    	
        this.codigoCentro = codigoCentro;
    }

    /**
     * @return the nroContrato
     */
    public String getNroContrato() {
    
        return nroContrato;
    }

    
    public String getNroContratoFormat() {
    	if (nroContrato == null) {
    		return null;
    	}
		String formato = appProperties.getProperty(APPConstants.CNT_PROP_FORMATO_CONTRATO);
		String formatoSubstringStart = appProperties.getProperty(APPConstants.CNT_PROP_FORMAT_SUBST_INI);
		String formatoSubstringEnd = appProperties.getProperty(APPConstants.CNT_PROP_FORMAT_SUBST_FIN);
		if (formato == null || formatoSubstringStart==null || formatoSubstringEnd== null) {
			return nroContrato;
		}
		
    	
    	return getCodigoFormat(nroContrato, formato, formatoSubstringStart, formatoSubstringEnd);
    }
    
    /**
     * Devuelve el c�digo a�adiendo espacios seg�n el formato indicado 
     * @param formato Se debe indicar los caracteres en los que habr� 
     * espacio separados por ",".<br><br><u>Ejemplo: 5,5,17,15</u> <br>indicar� que el c�digo se compone de 42 d�gitos, 
     * en caso de no alcanzar la longitud de 42 d�gitos se rellenar�n con ceros por la izquierda. <br><br> 
     * Y el formato devuelto ser�a el siguiente:<br>
     * 12345 12345 12345678901234567 123456789012345  
     * @param formatoSubstringEnd hace un substring desde este caracter inicio, si es null será el primero
     * @param formatoSubstringStart hasta este caracter fin, si es null será el último
     * @return
     */
	private String getCodigoFormat(String codigo, String formato, String formatoSubstringStart, String formatoSubstringEnd) {
    	
    	if (codigo == null ) {
    		return null;
    	}
    	String contratoSubstring= codigo;
    	
    	if (formatoSubstringStart!=null || formatoSubstringEnd!=null){
    		if (formatoSubstringStart== null){
    			formatoSubstringStart="0";
    		} 
    		if (formatoSubstringEnd==null){
    			contratoSubstring = codigo.substring(Integer.parseInt(formatoSubstringStart));
    		} else {
    			contratoSubstring = codigo.substring(Integer.parseInt(formatoSubstringStart), Integer.parseInt(formatoSubstringEnd));
    		} 
    	}
    	
    	if (formato!= null){
	    	String[] formatDigitos = formato.split(",");
	    	int longitud = 0;
	    	for (int i=0;i<formatDigitos.length;i++) {
	    		longitud += Integer.parseInt(formatDigitos[i]);
	    	}
	    	
	    	String nroContratoCompleto = rellenaConCeros(longitud, contratoSubstring);
	    	String nroContratoFormat = "";
	    	int digitoInicio = 0;
	    	int digitoFinal = 0;
	    	for (int i=0;i<formatDigitos.length;i++) {
	    		if (i>0) {
	    			nroContratoFormat += " ";
	    		}
	    		digitoFinal += Integer.parseInt(formatDigitos[i]);
	    		nroContratoFormat += nroContratoCompleto.substring(digitoInicio, digitoFinal);
	    		digitoInicio += Integer.parseInt(formatDigitos[i]);
	    	}
	    	return nroContratoFormat;
    	} else {
    		return contratoSubstring;
    	}
    }
    /**
     * @param nroContrato
     *            the nroContrato to set
     */
    public void setNroContrato(String nroContrato) {
        this.nroContrato = nroContrato;
    }

    /**
     * @return the estadoFinanciero
     */
    public DDEstadoFinanciero getEstadoFinanciero() {
    	if(fieldHandler!=null)
    		return (DDEstadoFinanciero) fieldHandler.readObject(this, "estadoFinanciero", estadoFinanciero);
        return estadoFinanciero;
    }

    /**
     * @param estadoFinanciero
     *            the estadoFinanciero to set
     */
    public void setEstadoFinanciero(DDEstadoFinanciero estadoFinanciero) {
    	if(fieldHandler!=null)
    			fieldHandler.writeObject(this, "estadoFinanciero", this.estadoFinanciero, estadoFinanciero);
        this.estadoFinanciero = estadoFinanciero;
    }

    /**
     * @return the fechaEstadoFinanciero
     */
    public Date getFechaEstadoFinanciero() {
        return fechaEstadoFinanciero;
    }

    /**
     * @param fechaEstadoFinanciero
     *            the fechaEstadoFinanciero to set
     */
    public void setFechaEstadoFinanciero(Date fechaEstadoFinanciero) {
        this.fechaEstadoFinanciero = fechaEstadoFinanciero;
    }

    /**
     * @return the estadoContrato
     */
    public DDEstadoContrato getEstadoContrato() {
    	if(fieldHandler!=null)
    			return (DDEstadoContrato) fieldHandler.readObject(this, "estadoContrato", estadoContrato);
        return estadoContrato;
    }

    /**
     * @param estadoContrato
     *            the estadoContrato to set
     */
    public void setEstadoContrato(DDEstadoContrato estadoContrato) {
    	if(fieldHandler!=null)
    			fieldHandler.writeObject(this, "estadoContrato", this.estadoContrato, estadoContrato);
    	this.estadoContrato = estadoContrato;
    }

    /**
     * @return the fechaEstadoContrato
     */
    public Date getFechaEstadoContrato() {
        return fechaEstadoContrato;
    }

    /**
     * @param fechaEstadoContrato
     *            the fechaEstadoContrato to set
     */
    public void setFechaEstadoContrato(Date fechaEstadoContrato) {
        this.fechaEstadoContrato = fechaEstadoContrato;
    }

    /**
     * @return the fechaCreacion
     */
    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    /**
     * @param fechaCreacion
     *            the fechaCreacion to set
     */
    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    /**
     * @return the fechaCarga
     */
    public Date getFechaCarga() {
        return fechaCarga;
    }

    /**
     * @param fechaCarga
     *            the fechaCarga to set
     */
    public void setFechaCarga(Date fechaCarga) {
        this.fechaCarga = fechaCarga;
    }

    /**
     * @return the ficheroCarga
     */
    public String getFicheroCarga() {
        return ficheroCarga;
    }

    /**
     * @param ficheroCarga
     *            the ficheroCarga to set
     */
    public void setFicheroCarga(String ficheroCarga) {
        this.ficheroCarga = ficheroCarga;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
    	if(fieldHandler!=null)
    		return (Auditoria) fieldHandler.readObject(this, "auditoria", auditoria);
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
    	if(fieldHandler!=null)
    			fieldHandler.writeObject(this, "auditoria", this.auditoria, auditoria);
        this.auditoria = auditoria;
    }

    /**
     * Indica si el contrato esta cancelado.
     *
     * @return boolean
     */
    public boolean estaCancelado() {
        return getEstadoContrato().getCodigo().equals(DDEstadoContrato.ESTADO_CONTRATO_CANCELADO);
    }

    /**
     * @return the antecendenteInterno
     */
    public AntecedenteInterno getAntecendenteInterno() {
    	if(fieldHandler!=null)
    		return (AntecedenteInterno) fieldHandler.readObject(this, "antecedenteIntero", antecendenteInterno);
        return antecendenteInterno;
    }

    /**
     * @param antecendenteInterno
     *            the antecendenteInterno to set
     */
    public void setAntecendenteInterno(AntecedenteInterno antecendenteInterno) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "antecedenteInterno", this.antecendenteInterno, antecendenteInterno);
        this.antecendenteInterno = antecendenteInterno;
    }

    /**
     * @param codigoContrato
     *            the codigoContrato to set
     */
    public void setCodigoContrato(String codigoContrato) {
        this.codigoContrato = codigoContrato;
    }

    /**
     * @return the contratoPersona
     */
    public List<Persona> getTitulares() {
        List<Persona> titulares = new ArrayList<Persona>();
        for (ContratoPersona cp : contratoPersona) {
            if (cp.isTitular()) {
                titulares.add(cp.getPersona());
            }
        }
        return titulares;
    }

    /**
     * @return the contratoPersona
     */
    public List<Persona> getIntervinientes() {
        List<Persona> intervinientes = new ArrayList<Persona>();
        for (ContratoPersona cp : contratoPersona) {
            if (cp.isTitular() || cp.isAvalista()) {
                intervinientes.add(cp.getPersona());
            }
        }
        return intervinientes;
    }

    /**
     * @return String: nombre de todos los titulares separados por punto y coma (<code>"; "</code>)
     */
    public String getNombresTitulares() {
        String titulares = "";
        Iterator<ContratoPersona> it = contratoPersona.iterator();
        while (it.hasNext()) {
            ContratoPersona cp = it.next();
            if (cp.isTitular()) {
                titulares += cp.getPersona().getApellidoNombre();
                if (it.hasNext()) {
                    titulares += "; ";
                }
            }
        }
        return titulares;
    }

    /**
     * @return lista de procedimientos.
     */
    public List<Procedimiento> getProcedimientos() {
        return getExpedienteContratoActivo().getProcedimientosActivos();
    }

//    /**
//     * Devuelve los asuntos activos del contrato.
//     * @return una lista de asuntos activos
//     */
//    public List<Asunto> getAsuntosActivos() {
//        List<Asunto> asuntos = new ArrayList<Asunto>();
//        if (getExpedienteContratoActivo() != null) {
//            for (Procedimiento p : getProcedimientos()) {
//                if (!asuntos.contains(p.getAsunto())) {
//                    asuntos.add(p.getAsunto());
//                }
//            }
//        }
//        return asuntos;
//    }

    /**
     * @param procedimientos the procedimientos to set
     */
    public void setProcedimientos(List<Procedimiento> procedimientos) {
        this.getExpedienteContratoActivo().setProcedimientos(procedimientos);
    }

    /**
    * @return the expedienteContratos
    */
    @SuppressWarnings("unchecked")
	public List<ExpedienteContrato> getExpedienteContratos() {
    	if(fieldHandler!=null)
    		return (List<ExpedienteContrato>) fieldHandler.readObject(this, "expedienteContratos", expedienteContratos);
        return expedienteContratos;
    }

    public ExpedienteContrato getExpedienteContrato(Long idExpediente) {
        for (ExpedienteContrato exp : expedienteContratos) {
            if (exp.getExpediente().getId().equals(idExpediente)) return exp;
        }
        return null;
    }

    /**
     * @return the expedienteContrato
     */
    public ExpedienteContrato getExpedienteContratoActivo() {
        for (ExpedienteContrato exp : expedienteContratos) {
            if (!DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO.equals(exp.getExpediente().getEstadoExpediente().getCodigo())) { return exp; }
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int compareTo(Contrato c) {
        return c.getCodigoContrato().compareTo(this.getCodigoContrato());
    }

    /**
     * @return cantTitulos
     *            the cantTitulos to set
     */
    public Integer getCantTitulos() {
        return titulos.size();
    }

    /**
     * @param expedienteContratos the expedienteContratos to set
     */
    public void setExpedienteContratos(List<ExpedienteContrato> expedienteContratos) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "expedienteContratos", this.expedienteContratos, expedienteContratos);
        this.expedienteContratos = expedienteContratos;
    }

    /**
     * @return int: cant. de intervinientes del contrato
     */
    public Integer getCantIntervinientes() {
        Integer cant = contratoPersona.size();
        return cant;
    }

    /**
     * @return the estadoFinancieroAnterior
     */
    public DDEstadoFinanciero getEstadoFinancieroAnterior() {
    	if(fieldHandler!=null)
    		return (DDEstadoFinanciero) fieldHandler.readObject(this, "estadoFinancieroAnterior", estadoFinancieroAnterior);
        return estadoFinancieroAnterior;
    }

    /**
     * @param estadoFinancieroAnterior the estadoFinancieroAnterior to set
     */
    public void setEstadoFinancieroAnterior(DDEstadoFinanciero estadoFinancieroAnterior) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "estadoFinancieroAnterior", this.estadoFinancieroAnterior, this.estadoFinancieroAnterior);
        this.estadoFinancieroAnterior = estadoFinancieroAnterior;
    }

    /**
     * @return the fechaEstadoFinancieroAnterior
     */
    public Date getFechaEstadoFinancieroAnterior() {
        return fechaEstadoFinancieroAnterior;
    }

    /**
     * @param fechaEstadoFinancieroAnterior the fechaEstadoFinancieroAnterior to set
     */
    public void setFechaEstadoFinancieroAnterior(Date fechaEstadoFinancieroAnterior) {
        this.fechaEstadoFinancieroAnterior = fechaEstadoFinancieroAnterior;
    }

    /**
     * @return the adjuntos
     */
    @SuppressWarnings("unchecked")
	public Set<AdjuntoContrato> getAdjuntos() {
    	if(fieldHandler!=null)
    		return (Set<AdjuntoContrato>) fieldHandler.readObject(this, "adjuntos", adjuntos);
        return adjuntos;
    }

    /**
     * @param adjuntos the adjuntos to set
     */
    public void setAdjuntos(Set<AdjuntoContrato> adjuntos) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "adjuntos", this.adjuntos, adjuntos);
        this.adjuntos = adjuntos;
    }

    /**
     * Devuelve los adjuntos (que estan en un Set) como una lista
     * para que pueda ser accedido aleatoreamente.
     * @return List AdjuntoContrato
     */
    @SuppressWarnings("unchecked")
	public List<AdjuntoContrato> getAdjuntosAsList() {
    	if(fieldHandler!=null)
    		return (List<AdjuntoContrato>) fieldHandler.readObject(this, "adjuntos", adjuntos);
        return new ArrayList<AdjuntoContrato>(adjuntos);
    }

    /**
     * devuelve el adjunto por Id.
     * @param id Long
     * @return AdjuntoContrato
     */
    public AdjuntoContrato getAdjunto(Long id) {
        for (AdjuntoContrato adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

    /**
     * Agrega un adjunto a la persona, tomando los datos de un FileItem.
     * @param fileItem file
     */
    public void addAdjunto(FileItem fileItem) {
        AdjuntoContrato adjuntoContrato = new AdjuntoContrato(fileItem);
        adjuntoContrato.setContrato(this);
        Auditoria.save(adjuntoContrato);
        getAdjuntos().add(adjuntoContrato);
    }

    /**
     * {@inheritDoc}
     */
    public String getDescripcion() {
        return getCodigoContrato();
    }

    /**
     * Filtra y retorna los procedimientos relacionados con el contrato del asunto indicado.
     * @param asuntoId string
     * @return lista de procedimientos
     */
    public List<Procedimiento> getProcedimietosForAsuntoId(String asuntoId) {
        List<Procedimiento> procedimientos = new ArrayList<Procedimiento>();
        for (Procedimiento procedimiento : getProcedimientos()) {
            if (procedimiento.getAsunto().getId().equals(new Long(asuntoId))) {
                procedimientos.add(procedimiento);
            }
        }
        return procedimientos;
    }

    /**
     * @return the limiteInicial
     */
    public Float getLimiteInicial() {
        return limiteInicial;
    }

    /**
     * @param limiteInicial the limiteInicial to set
     */
    public void setLimiteInicial(Float limiteInicial) {
        this.limiteInicial = limiteInicial;
    }

    /**
     * @return the limiteFinal
     */
    public Float getLimiteFinal() {
        return limiteFinal;
    }

    /**
     * @param limiteFinal the limiteFinal to set
     */
    public void setLimiteFinal(Float limiteFinal) {
        this.limiteFinal = limiteFinal;
    }

    /**
     * @return the finalidadContrato
     */
    public DDFinalidadContrato getFinalidadContrato() {
    	if(fieldHandler!=null)
    		return (DDFinalidadContrato) fieldHandler.readObject(this, "finalidadContrato", finalidadContrato);
        return finalidadContrato;
    }

    /**
     * @param finalidadContrato the finalidadContrato to set
     */
    public void setFinalidadContrato(DDFinalidadContrato finalidadContrato) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "finalidadContrato", this.finalidadContrato, finalidadContrato);
        this.finalidadContrato = finalidadContrato;
    }

    /**
     * @return the finalidadAcuerdo
     */
    public DDFinalidadOficial getFinalidadAcuerdo() {
    	if(fieldHandler!=null)
    		return (DDFinalidadOficial) fieldHandler.readObject(this, "finalidadAcuerdo", finalidadAcuerdo);
        return finalidadAcuerdo;
    }

    /**
     * @param finalidadAcuerdo the finalidadAcuerdo to set
     */
    public void setFinalidadAcuerdo(DDFinalidadOficial finalidadAcuerdo) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "finalidadAcuerdo", this.finalidadAcuerdo, finalidadAcuerdo);
        this.finalidadAcuerdo = finalidadAcuerdo;
    }

    /**
     * @return the garantia1
     */
    public DDGarantiaContrato getGarantia1() {
    	if(fieldHandler!=null)
    		return (DDGarantiaContrato) fieldHandler.readObject(this, "garantia1", garantia1);
        return garantia1;
    }

    /**
     * @param garantia1 the garantia1 to set
     */
    public void setGarantia1(DDGarantiaContrato garantia1) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "garantia1", this.garantia1, garantia1);
        this.garantia1 = garantia1;
    }

    /**
     * @return the garantia2
     */
    public DDGarantiaContable getGarantia2() {
    	if(fieldHandler!=null)
    		return (DDGarantiaContable) fieldHandler.readObject(this, "garantia2", garantia2);
        return garantia2;
    }

    /**
     * @param garantia2 the garantia2 to set
     */
    public void setGarantia2(DDGarantiaContable garantia2) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "garantia2", this.garantia2, garantia1);
        this.garantia2 = garantia2;
    }

    /**
     * @return the catalogo1
     */
    public DDCatalogo1 getCatalogo1() {
    	if(fieldHandler!=null)
    		return (DDCatalogo1) fieldHandler.readObject(this, "catalogo1", catalogo1);
        return catalogo1;
    }

    /**
     * @param catalogo1 the catalogo1 to set
     */
    public void setCatalogo1(DDCatalogo1 catalogo1) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "catalogo1", this.catalogo1, catalogo1);
        this.catalogo1 = catalogo1;
    }

    /**
     * @return the catalogo2
     */
    public DDCatalogo2 getCatalogo2() {
    	if(fieldHandler!=null)
    		return (DDCatalogo2) fieldHandler.readObject(this, "catalogo2", catalogo2);
        return catalogo2;
    }

    /**
     * @param catalogo2 the catalogo2 to set
     */
    public void setCatalogo2(DDCatalogo2 catalogo2) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "catalogo2", this.catalogo2, catalogo2);
        this.catalogo2 = catalogo2;
    }

    /**
     * @return the catalogo3
     */
    public DDCatalogo3 getCatalogo3() {
    	if(fieldHandler!=null)
    		return (DDCatalogo3) fieldHandler.readObject(this, "catalogo3", catalogo3);
        return catalogo3;
    }

    /**
     * @param catalogo3 the catalogo3 to set
     */
    public void setCatalogo3(DDCatalogo3 catalogo3) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "catalogo3", this.catalogo3, catalogo3);
        this.catalogo3 = catalogo3;
    }

    /**
     * @return the catalogo4
     */
    public DDCatalogo4 getCatalogo4() {
    	if(fieldHandler!=null)
    		return (DDCatalogo4) fieldHandler.readObject(this, "catalogo4", catalogo4);
        return catalogo4;
    }

    /**
     * @param catalogo4 the catalogo4 to set
     */
    public void setCatalogo4(DDCatalogo4 catalogo4) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "catalogo4", this.catalogo4, catalogo4);
        this.catalogo4 = catalogo4;
    }

    /**
     * @return the catalogo5
     */
    public DDCatalogo5 getCatalogo5() {
    	if(fieldHandler!=null)
    		return (DDCatalogo5) fieldHandler.readObject(this, "catalogo5", catalogo5);
        return catalogo5;
    }

    /**
     * @param catalogo5 the catalogo5 to set
     */
    public void setCatalogo5(DDCatalogo5 catalogo5) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "catalogo5", this.catalogo5, catalogo5);
        this.catalogo5 = catalogo5;
    }

    /**
     * @return the catalogo6
     */
    public DDCatalogo6 getCatalogo6() {
    	if(fieldHandler!=null)
    		return (DDCatalogo6) fieldHandler.readObject(this, "catalogo6", catalogo6);
        return catalogo6;
    }

    /**
     * @param catalogo6 the catalogo6 to set
     */
    public void setCatalogo6(DDCatalogo6 catalogo6) {
    	if(fieldHandler!=null)
    		fieldHandler.writeObject(this, "catalogo6", this.catalogo6, catalogo6);
        this.catalogo6 = catalogo6;
    }

    /**
     * @return the fechaVencimiento
     */
    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    /**
     * @param fechaVencimiento the fechaVencimiento to set
     */
    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }
    
    

	public String getContratoOrigen() {
		return this.getFormulas() == null ? null :this.getFormulas().getContratoOrigen();
	}
	
	public String getNuevoCodigoOficina() {
		return this.getFormulas() == null ? null :this.getFormulas().getNuevoCodigoOficina();
	}
	
//	@Override
	public String getCodigoContrato() {
		if (codigoContrato == null) {

			//Si las propiedades est�n seteadas por la clase SpringContratoConfigurator las comprobamos
			String formato = null;
			String formatoSubstringStart=null;
			String formatoSubstringEnd=null;
			if (appProperties != null) {
				formato = appProperties.getProperty(APPConstants.CNT_PROP_FORMATO_CONTRATO);
				formatoSubstringStart = appProperties.getProperty(APPConstants.CNT_PROP_FORMAT_SUBST_INI);
				formatoSubstringEnd = appProperties.getProperty(APPConstants.CNT_PROP_FORMAT_SUBST_FIN);
			}
			
			//Si tiene el formato creado es que est� usando el modelo V10 
			// en el que el contrato est� todo persistido en el mismo campo 
			if (formato != null || formatoSubstringStart !=null || formatoSubstringEnd !=null) {			
				String contrato = (getContratoOrigen() == null) ? nroContrato : getContratoOrigen();
				return getCodigoFormat(contrato, formato, formatoSubstringStart, formatoSubstringEnd);
			}
			
			if (getEntidadOrigen()==null
					||  getNuevoCodigoOficina() ==null
					|| getContratoOrigen()==null) {
				return this.getCodigoContratoENTITY();
			} else {
				String codEntidad = rellenaConCeros(4, getEntidadOrigen());
				String codOficina = rellenaConCeros(4, getNuevoCodigoOficina());
				String contrato = rellenaConCeros(10, getContratoOrigen());
				codigoContrato = codEntidad + " " + codOficina + " " + contrato;
			}
		}
		return codigoContrato;
	}

	private String rellenaConCeros(int longitud, String nbr) {
		StringBuffer s = new StringBuffer();
		for (int i = 0; i < longitud - nbr.length(); i++) {
			s.append("0");
		}
		
		return s.toString() + nbr;
	}

	public String getEntidadOrigen() {
		return this.getFormulas() == null ? null :this.getFormulas().getEntidadOrigen();
	}

//	@Override
	public List<Asunto> getAsuntosActivos() {
		List<Asunto> asuntos = new ArrayList<Asunto>();
		for (ExpedienteContrato exp : getListaExpedienteContratoActivo()) {
			for (Procedimiento p : exp.getProcedimientos()) {
				if (!asuntos.contains(p.getAsunto())
						&& !p.getAsunto().getAuditoria().isBorrado()) {
					asuntos.add(p.getAsunto());
				}
			}
		}
		return asuntos;
	}

//	@Override
//	public ExpedienteContrato getExpedienteContratoActivo() {
//		return super.getExpedienteContratoActivo();
//	}

	public List<ExpedienteContrato> getListaExpedienteContratoActivo() {

		List<ExpedienteContrato> listaExpedienteContrato = new ArrayList<ExpedienteContrato>();
		for (ExpedienteContrato exp : getExpedienteContratos()) {
			if (!DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO.equals(exp
					.getExpediente().getEstadoExpediente().getCodigo())) {
				listaExpedienteContrato.add(exp);
			}
		}
		return listaExpedienteContrato;

	}

	public Usuario getGestor(String codigoGestor) {
		if (gestoresContrato==null || gestoresContrato.size()<=0 || codigoGestor==null) {
			return null;
		} else {
			for (EXTGestorEntidad ge : gestoresContrato) {
				if (codigoGestor.equals(ge.getTipoGestor().getCodigo())) {
					System.out.println("EXTContrato devuelve gestor "
							+ ge.getTipoGestor().getCodigo());
					return ge.getGestor();
				}
			}
			return null;
		}
	}

	public String getTipoProductoOrigen() {
		return this.getFormulas() == null ? null :this.getFormulas().getTipoProductoOrigen();
	}

	public void setGestoresContrato(List<EXTGestorEntidad> gestoresContrato) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "gestoresContrato", this.gestoresContrato, gestoresContrato);
		this.gestoresContrato = gestoresContrato;
	}

	@SuppressWarnings("unchecked")
	public List<EXTGestorEntidad> getGestoresContrato() {
		if(fieldHandler!=null)
			return (List<EXTGestorEntidad>) fieldHandler.readObject(this, "gestoresContrato", gestoresContrato);
		
		return gestoresContrato;
	}


	/**
	 * @param contratoPrincipal the contratoPrincipal to set
	 */
//	public void setContratoPrincipal(String contratoPrincipal) {
//		this.contratoPrincipal = contratoPrincipal;
//	}

	/**
	 * @return the contratoPrincipal
	 */
	public String getContratoPrincipal() {
		return this.getFormulas() == null ? null :this.getFormulas().getContratoPrincipal();
	}

	/**
	 * @param faseRecuperacion the faseRecuperacion to set
	 */
//	public void setFaseRecuperacion(String faseRecuperacion) {
//		this.faseRecuperacion = faseRecuperacion;
//	}

	/**
	 * @return the faseRecuperacion
	 */
	public String getFaseRecuperacion() {
		return this.getFormulas() == null ? null :this.getFormulas().getFaseRecuperacion();
	}

	/**
	 * @param estadoLitigio the estadoLitigio to set
	 */
//	public void setEstadoLitigio(String estadoLitigio) {
//		this.estadoLitigio = estadoLitigio;
//	}

	/**
	 * @return the estadoLitigio
	 */
	public String getEstadoLitigio() {
		return this.getFormulas() == null ? null :this.getFormulas().getEstadoLitigio();
	}



	/**
	 * @param gastos the gastos to set
	 */
//	public void setGastos(String gastos) {
//		this.gastos = gastos;
//	}

	/**
	 * @return the gastos
	 */
	public String getGastos() {
		return this.getFormulas() == null ? null :this.getFormulas().getGastos();
	}

	/**
	 * @param provisionProcurador the provisionProcurador to set
	 */
//	public void setProvisionProcurador(String provisionProcurador) {
//		this.provisionProcurador = provisionProcurador;
//	}

	/**
	 * @return the provisionProcurador
	 */
	public String getProvisionProcurador() {
		return this.getFormulas() == null ? null :this.getFormulas().getProvisionProcurador();
	}

	/**
	 * @param interesesDemora the interesesDemora to set
	 */
//	public void setInteresesDemora(String interesesDemora) {
//		this.interesesDemora = interesesDemora;
//	}

	/**
	 * @return the interesesDemora
	 */
	public String getInteresesDemora() {
		return this.getFormulas() == null ? null :this.getFormulas().getInteresesDemora();
	}

	/**
	 * @param minutaLetrado the minutaLetrado to set
	 */
//	public void setMinutaLetrado(String minutaLetrado) {
//		this.minutaLetrado = minutaLetrado;
//	}

	/**
	 * @return the minutaLetrado
	 */
	public String getMinutaLetrado() {
		return this.getFormulas() == null ? null :this.getFormulas().getMinutaLetrado();
	}

	/**
	 * @param entregas the entregas to set
	 */
//	public void setEntregas(String entregas) {
//		this.entregas = entregas;
//	}

	/**
	 * @return the entregas
	 */
	public String getEntregas() {
		return this.getFormulas() == null ? null :this.getFormulas().getEntregas();
	}
	
    /**
     * Lista ordenada por tipo de intervencion y orden de la misma.
     * @return the contratoPersona
     */
    public List<ContratoPersona> getContratoPersonaOrdenado() {
        if (this.getContratoPersona() == null || this.getContratoPersona().isEmpty()) { return this.getContratoPersona(); }
        SortedSet<ContratoPersona> cntPerSort = new TreeSet<ContratoPersona>(new Comparator<ContratoPersona>() {

            @Override
            public int compare(ContratoPersona o1, ContratoPersona o2) {
                // Validaciones
                if (o1.getTipoIntervencion() == null) { return 1; }
                if (o2.getTipoIntervencion() == null) { return -1; }
                // Si los dos tipos de intervencion son titulares orderno por el orden
                if (o1.getTipoIntervencion().getTitular() && o2.getTipoIntervencion().getTitular()) { 
                	return (o1.getOrden().compareTo(o2.getOrden())==0) ? -1 : o1.getOrden().compareTo(o2.getOrden()); 
                }
                // Si es del mismo tipo de intervencion orderno por el orden
                if (o1.getTipoIntervencion().getCodigo().equals(o2.getTipoIntervencion().getCodigo())) { 
                	return (o1.getOrden().compareTo(o2.getOrden())==0) ? -1 : o1.getOrden().compareTo(o2.getOrden()); 
                }
                // Si el o1 es titular va primero
                if (o1.getTipoIntervencion().getTitular()) { return -1; }
                // Si el o2 es el titular o1 va despu�s
                if (o2.getTipoIntervencion().getTitular()) { return 1; }
                // Si ninguno es titular ordena por codigo
                return o1.getTipoIntervencion().getCodigo().compareTo(o2.getTipoIntervencion().getCodigo());
            }
        });

        cntPerSort.addAll(this.getContratoPersona());
        // Lo transformo a lista para usarla en el jsp.
        List<ContratoPersona> lista = new ArrayList<ContratoPersona>();
        lista.addAll(cntPerSort);
        return lista;
    }

	/*
	 * public String getCodigoContratoSQL() { return codigoContratoSQL; }
	 */
    
    /**
     * PBO: Introducido para soporte de Lindorff
     */
    //FIXME Mover esto al plugin de Lindorff

	public String getCreditor() {
		return this.getFormulas() == null ? null :this.getFormulas().getCreditor();
	}


	/**
	 * Devuelve el codigo del contrato paraguas
	 * @return
	 */
	public String getCodigoContratoParaguas() {
		String codigoContratoParaguas ="";
		if (!Checks.esNulo(contratoParaguas)){
			codigoContratoParaguas=contratoParaguas.toString();
		}
		return codigoContratoParaguas;
	}
	

	public Date getFechaDato() {
		return fechaDato;
	}

	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	public DDAplicativoOrigen getAplicativoOrigen() {
		if(fieldHandler!=null)
			return (DDAplicativoOrigen) fieldHandler.readObject(this, "aplicativoOrigen", aplicativoOrigen);
		return aplicativoOrigen;
	}

	public void setAplicativoOrigen(DDAplicativoOrigen aplicativoOrigen) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "aplicativoOrigen", this.aplicativoOrigen, aplicativoOrigen);
		this.aplicativoOrigen = aplicativoOrigen;
	}

	public String getIban() {
		return iban;
	}

	public void setIban(String iban) {
		this.iban = iban;
	}

	public Float getCuotaImporte() {
		return cuotaImporte;
	}

	public void setCuotaImporte(Float cuotaImporte) {
		this.cuotaImporte = cuotaImporte;
	}

	public Integer getCuotaPeriodicidad() {
		return cuotaPeriodicidad;
	}

	public void setCuotaPeriodicidad(Integer cuotaPeriodicidad) {
		this.cuotaPeriodicidad = cuotaPeriodicidad;
	}

	public Float getDispuesto() {
		return dispuesto;
	}

	public void setDispuesto(Float dispuesto) {
		this.dispuesto = dispuesto;
	}

	public DDSistemaAmortizContrato getSistemaAmortizacion() {
		if(fieldHandler!=null)
			return (DDSistemaAmortizContrato) fieldHandler.readObject(this, "sistemaAmortizacion", sistemaAmortizacion);
		return sistemaAmortizacion;
	}

	public void setSistemaAmortizacion(DDSistemaAmortizContrato sistemaAmortizacion) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "sistemaAmortizacion", this.sistemaAmortizacion, sistemaAmortizacion);
		this.sistemaAmortizacion = sistemaAmortizacion;
	}

	public DDTipoInteres getInteresFijoVariable() {
		if(fieldHandler!=null)
			return (DDTipoInteres) fieldHandler.readObject(this, "interesFijoVariable", interesFijoVariable);
		return interesFijoVariable;
	}

	public void setInteresFijoVariable(DDTipoInteres interesFijoVariable) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "interesFijoVariable", this.interesFijoVariable, interesFijoVariable);
		this.interesFijoVariable = interesFijoVariable;
	}

	public Float getTipoInteres() {
		return tipoInteres;
	}

	public void setTipoInteres(Float tipoInteres) {
		this.tipoInteres = tipoInteres;
	}

	public String getCccDomiciliacion() {
		return cccDomiciliacion;
	}

	public void setCccDomiciliacion(String cccDomiciliacion) {
		this.cccDomiciliacion = cccDomiciliacion;
	}

	public String getCodEntidadPropietaria() {
		return this.getFormulas() == null ? null :this.getFormulas().getCodEntidadPropietaria();
	}


	public String getCondicionesEspeciales() {
		return this.getFormulas() == null ? null :this.getFormulas().getCondicionesEspeciales();
	}
	
	public String getSegmentoCartera() {
		return this.getFormulas() == null ? null :this.getFormulas().getSegmentoCartera();
	}

	public Oficina getOficinaContable() {
		if(fieldHandler!=null)
			return (Oficina) fieldHandler.readObject(this, "oficinaContable", oficinaContable);
		return oficinaContable;
	}

	public void setOficinaContable(Oficina oficinaContable) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "oficinaContable", this.oficinaContable, oficinaContable);
		this.oficinaContable = oficinaContable;
	}

	public Oficina getOficinaAdministrativa() {
		if(fieldHandler!=null)
			return (Oficina) fieldHandler.readObject(this, "oficinaAdministrativa", oficinaAdministrativa);
		return oficinaAdministrativa;
	}

	public void setOficinaAdministrativa(Oficina oficinaAdministrativa) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "oficinaAdministrativa", oficinaAdministrativa, oficinaAdministrativa);
		this.oficinaAdministrativa = oficinaAdministrativa;
	}

	public DDGestionEspecial getGestionEspecial() {
		if(fieldHandler!=null)
			return (DDGestionEspecial) fieldHandler.readObject(this, "gestionEspecial", gestionEspecial);
		return gestionEspecial;
	}

	public void setGestionEspecial(DDGestionEspecial gestionEspecial) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "gestionEspecial", this.gestionEspecial, gestionEspecial);
		this.gestionEspecial = gestionEspecial;
	}

	public DDCondicionesRemuneracion getRemuneracionEspecial() {
		if(fieldHandler!=null)
			return (DDCondicionesRemuneracion) fieldHandler.readObject(this, "RemuneracionEspecial", RemuneracionEspecial);
		return RemuneracionEspecial;
	}

	public void setRemuneracionEspecial(DDCondicionesRemuneracion remuneracionEspecial) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "RemuneracionEspecial", this.RemuneracionEspecial, remuneracionEspecial);
		RemuneracionEspecial = remuneracionEspecial;
	}

	public Boolean getDomiciliacionExterna() {
		return domiciliacionExterna;
	}

	public void setDomiciliacionExterna(Boolean domiciliacionExterna) {
		this.domiciliacionExterna = domiciliacionExterna;
	}

	public Long getContratoParaguas() {
		return contratoParaguas;
	}

	public void setContratoParaguas(Long contratoParaguas) {
		this.contratoParaguas = contratoParaguas;
	}

	public String getContratoAnterior() {
		return contratoAnterior;
	}

	public void setContratoAnterior(String contratoAnterior) {
		this.contratoAnterior = contratoAnterior;
	}

	public static void setAppProperties(final Properties p) {
		appProperties = p;
		
	}

	public DDMotivoRenumeracion getMotivoRenumeracion() {
		if(fieldHandler!=null)
			return (DDMotivoRenumeracion) fieldHandler.readObject(this, "motivoRenumeracion", motivoRenumeracion);
		return motivoRenumeracion;
	}

	public void setMotivoRenumeracion(DDMotivoRenumeracion motivoRenumeracion) {
		if(fieldHandler!=null)
			fieldHandler.writeObject(this, "motivoRenumeracion", this.motivoRenumeracion, motivoRenumeracion);
		this.motivoRenumeracion = motivoRenumeracion;
	}

	public String getEstadoContratoEntidad() {
		return this.getFormulas() == null ? null :this.getFormulas().getEstadoContratoEntidad();
	}

//	public void setEstadoContratoEntidad(String estadoContratoEntidad) {
//		this.estadoContratoEntidad = estadoContratoEntidad;
//	}
	public List<Bien> getBienes() {
		return bienes;
	}
	
	public void setBienes(List<Bien> bienes) {
		this.bienes = bienes;
	}

	public String getMarcaOperacion() {
		return this.getFormulas() == null ? null :this.getFormulas().getMarcaOperacion();
	}
	
	public String getMotivoMarca() {
		return this.getFormulas() == null ? null :this.getFormulas().getMotivoMarca();
	}
	
	public String getIndicadorNominaPension() {
		return this.getFormulas() == null ? null :this.getFormulas().getIndicadorNominaPension();
	}

	@Override
	public void setFieldHandler(FieldHandler handler) {
		this.fieldHandler = handler;

	}

	@Override
	public FieldHandler getFieldHandler() {
		return this.fieldHandler;
	}
	
	public ContratoFormulas getFormulas() {
		if(fieldHandler!=null)
	        return (ContratoFormulas)fieldHandler.readObject(this, "formulas", formulas);
		return formulas;
	}	
	
}
