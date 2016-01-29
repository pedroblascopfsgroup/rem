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

import javax.persistence.Basic;
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

import org.apache.commons.lang.StringUtils;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

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
import es.pfsgroup.recovery.common.api.CommonProjectContext;

/**
 * Entidad Contrato.
 * @author Lisandro Medrano
 *
 */

@Entity
@Table(name = "CNT_CONTRATOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Contrato implements Serializable, Auditable, Comparable<Contrato>, Describible {
	
	/**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -8368485360179310334L;

	private static Properties appProperties;
	
	private static CommonProjectContext projectContext;
	
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

    
    //    CNT_FECHA_CONSTITUCION   DATE, campo no viene en la carga

    @Column(name = "CNT_FECHA_VENC")
    private Date fechaVencimiento;
    
  //BANKIA extras
   
    
  	@Formula("(select tfo.dd_tfo_ces_rem from ext_iac_info_add_contrato iac,dd_tfo_tipo_fondo tfo where iac.cnt_id = cnt_id "
  			+ "and iac.iac_value = tfo.dd_tfo_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA7 + "'))")
  	private String titulizado;
  	
  	@Formula("(select tfo.dd_tfo_descripcion from ext_iac_info_add_contrato iac,dd_tfo_tipo_fondo tfo where iac.cnt_id = cnt_id "
  			+ "and iac.iac_value = tfo.dd_tfo_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA7 + "'))")
  	private String fondo;  	
  	

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA1 + "'))")
  	private String numextra1;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA2 + "'))")
  	private String numextra2;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA3 + "'))")
  	private String numextra3;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA1 + "'))")
  	private String dateextra1;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA1 + "'))")
  	private String charextra1;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA2 + "'))")
  	private String charextra2;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA3 + "'))")
  	private String charextra3;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA4 + "'))")
  	private String charextra4;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA5 + "'))")
  	private String charextra5;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA6 + "'))")
  	private String charextra6;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA7 + "'))")
  	private String charextra7;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA8 + "'))")
  	private String charextra8;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.FLAG_EXTRA1 + "'))")
  	private String flagextra1;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.FLAG_EXTRA2 + "'))")
  	private String flagextra2;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.FLAG_EXTR3 + "'))")
  	private String flagextra3;
  	
  	@Formula("(select mrf.dd_mrf_descripcion from ext_iac_info_add_contrato iac,${master.schema}.dd_mrf_marca_refinanciacion mrf where iac.cnt_id = cnt_id "
  			+ "and iac.iac_value = mrf.dd_mrf_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA9 + "'))")
  	private String marcaOperacion;
  	
  	@Formula("(select mom.dd_mom_descripcion from ext_iac_info_add_contrato iac,${master.schema}.dd_mom_motivo_marca_r mom where iac.cnt_id = cnt_id "
  			+ "and iac.iac_value = mom.dd_mom_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA10 + "'))")
  	private String motivoMarca;
  	
  	@Formula("(select idn.dd_idn_descripcion from ext_iac_info_add_contrato iac,${master.schema}.dd_idn_indicador_nomina idn where iac.cnt_id = cnt_id "
  			+ "and iac.iac_value = idn.dd_idn_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA4 + "'))")
  	private String indicadorNominaPension;
  	
  	@Formula("(select est.dd_eic_descripcion from ext_iac_info_add_contrato iac, dd_eic_estado_interno_entidad est where iac.cnt_id = cnt_id "
  			+ "and iac.iac_value = est.dd_eic_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA10 + "'))")
  	private String estadoEntidad;
  	
  	/**@Formula("select acn.acn_num_reinciden from acn_anteced_contratos acn where acn.cnt_id = cnt_id")
  	private Integer contadorReincidencias;*/
  	
  	@Basic(fetch=FetchType.LAZY)
  	public String getTitulizado() {
  		return titulizado;
  	}
  	
  	/**@Basic(fetch=FetchType.LAZY)
  	public Integer getContadorReincidencias() {
  		if(contadorReincidencias == null)
  			return 0;
  		else
  			return contadorReincidencias;
  	}*/
  	
  	@Basic(fetch=FetchType.LAZY)
  	public String getFondo() {
  		return fondo;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getNumextra1() {
  		return numextra1;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getNumextra2() {
  		return numextra2;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getNumextra3() {
  		return numextra3;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getDateextra1() {
  		return dateextra1;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra1() {
  		return charextra1;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra2() {
  		return charextra2;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra3() {
  		return charextra3;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra4() {
  		return charextra4;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra5() {
  		return charextra5;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra6() {
  		return charextra6;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra7() {
  		return charextra7;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getCharextra8() {
  		return charextra8;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getFlagextra1() {
  		return flagextra1;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getFlagextra2() {
  		return flagextra2;
  	}

  	@Basic(fetch=FetchType.LAZY)
  	public String getFlagextra3() {
  		return flagextra3;
  	}
    
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
    
    /**
     * @return the titulos
     */
    public List<Titulo> getTitulos() {
        return titulos;
    }

    /**
     * @param titulos
     *            the titulos to set
     */
    public void setTitulos(List<Titulo> titulos) {
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

//    private String rellenaConCeros(int longitud, String nbr) {
//        String s = "";
//        for (int i = 0; i < longitud - nbr.length(); i++) {
//            s += "0";
//        }
//
//        return s + nbr;
//    }

    /**
     * Metodo para obtener el codigo del contrato.<br>
     * Codigo Entidad + Codigo Oficina + XX + Numero de Contrato<br>
     *
     * @return el codigo de contrato
     */
    public String getCodigoContratoENTITY() {
        if (codigoContrato == null) {
        	String contrato = rellenaConCeros(10, nroContrato.toString());
        	
        	String contratoSinEntidad = appProperties.getProperty(APPConstants.CNT_PROP_CONTRATO_SIN_ENTIDAD);        	
        	if (Checks.esNulo(contratoSinEntidad)) {
	            String codEntidad = rellenaConCeros(4, codigoEntidad.toString());
	            String codOficina = rellenaConCeros(4, codigoOficina.toString());	            

	            return codEntidad + " " + codOficina + " " + contrato;
        	} else {
        		return contrato;
        	}
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
        return tipoProductoEntidad;
    }

    /**
     * @param tipoProductoEntidad
     *            the tipoProductoEntidad to set
     */
    public void setTipoProductoEntidad(DDTipoProductoEntidad tipoProductoEntidad) {
        this.tipoProductoEntidad = tipoProductoEntidad;
    }

    /**
     * @return the oficina
     */
    public Oficina getOficina() {
        return oficina;
    }

    /**
     * @param oficina
     *            the oficina to set
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
     * @param zona
     *            the zona to set
     */
    public void setZona(DDZona zona) {
        this.zona = zona;
    }

    /**
     * @return the moneda
     */
    public DDMoneda getMoneda() {
        return moneda;
    }

    /**
     * @param moneda
     *            the moneda to set
     */
    public void setMoneda(DDMoneda moneda) {
        this.moneda = moneda;
    }

    /**
     * @return the tipoProducto
     */
    public DDTipoProducto getTipoProducto() {
        return tipoProducto;
    }

    /**
     * @param tipoProducto
     *            the tipoProducto to set
     */
    public void setTipoProducto(DDTipoProducto tipoProducto) {
        this.tipoProducto = tipoProducto;
    }

    /**
     * @return the contratoPersona
     */
    public List<ContratoPersona> getContratoPersona() {
        return contratoPersona;
    }
    
    /**
     * @param contratoPersona
     *            the contratoPersona to set
     */
    public void setContratoPersona(List<ContratoPersona> contratoPersona) {
        this.contratoPersona = contratoPersona;
    }

    /**
     * @return the movimientos
     */
    public List<Movimiento> getMovimientos() {
        return movimientos;
    }

    /**
     * @param movimientos
     *            the movimientos to set
     */
    public void setMovimientos(List<Movimiento> movimientos) {
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
    	else {
    		if(projectContext != null && projectContext.getFormatoNroContrato() != null) {
	    		return projectContext.getNroContratoFormateado(nroContrato);
    		}
    		else return nroContrato;
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
        return estadoFinanciero;
    }

    /**
     * @param estadoFinanciero
     *            the estadoFinanciero to set
     */
    public void setEstadoFinanciero(DDEstadoFinanciero estadoFinanciero) {
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
        return estadoContrato;
    }

    /**
     * @param estadoContrato
     *            the estadoContrato to set
     */
    public void setEstadoContrato(DDEstadoContrato estadoContrato) {
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
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
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
        return antecendenteInterno;
    }

    /**
     * @param antecendenteInterno
     *            the antecendenteInterno to set
     */
    public void setAntecendenteInterno(AntecedenteInterno antecendenteInterno) {
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

    /**
     * @param procedimientos the procedimientos to set
     */
    public void setProcedimientos(List<Procedimiento> procedimientos) {
        this.getExpedienteContratoActivo().setProcedimientos(procedimientos);
    }

    /**
    * @return the expedienteContratos
    */
    public List<ExpedienteContrato> getExpedienteContratos() {
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
        return estadoFinancieroAnterior;
    }

    /**
     * @param estadoFinancieroAnterior the estadoFinancieroAnterior to set
     */
    public void setEstadoFinancieroAnterior(DDEstadoFinanciero estadoFinancieroAnterior) {
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
    public Set<AdjuntoContrato> getAdjuntos() {
        return adjuntos;
    }

    /**
     * @param adjuntos the adjuntos to set
     */
    public void setAdjuntos(Set<AdjuntoContrato> adjuntos) {
        this.adjuntos = adjuntos;
    }

    /**
     * Devuelve los adjuntos (que est�n en un Set) como una lista
     * para que pueda ser accedido aleatoreamente.
     * @return List AdjuntoContrato
     */
    public List<AdjuntoContrato> getAdjuntosAsList() {
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
        return finalidadContrato;
    }

    /**
     * @param finalidadContrato the finalidadContrato to set
     */
    public void setFinalidadContrato(DDFinalidadContrato finalidadContrato) {
        this.finalidadContrato = finalidadContrato;
    }

    /**
     * @return the finalidadAcuerdo
     */
    public DDFinalidadOficial getFinalidadAcuerdo() {
        return finalidadAcuerdo;
    }

    /**
     * @param finalidadAcuerdo the finalidadAcuerdo to set
     */
    public void setFinalidadAcuerdo(DDFinalidadOficial finalidadAcuerdo) {
        this.finalidadAcuerdo = finalidadAcuerdo;
    }

    /**
     * @return the garantia1
     */
    public DDGarantiaContrato getGarantia1() {
        return garantia1;
    }

    /**
     * @param garantia1 the garantia1 to set
     */
    public void setGarantia1(DDGarantiaContrato garantia1) {
        this.garantia1 = garantia1;
    }

    /**
     * @return the garantia2
     */
    public DDGarantiaContable getGarantia2() {
        return garantia2;
    }

    /**
     * @param garantia2 the garantia2 to set
     */
    public void setGarantia2(DDGarantiaContable garantia2) {
        this.garantia2 = garantia2;
    }

    /**
     * @return the catalogo1
     */
    public DDCatalogo1 getCatalogo1() {
        return catalogo1;
    }

    /**
     * @param catalogo1 the catalogo1 to set
     */
    public void setCatalogo1(DDCatalogo1 catalogo1) {
        this.catalogo1 = catalogo1;
    }

    /**
     * @return the catalogo2
     */
    public DDCatalogo2 getCatalogo2() {
        return catalogo2;
    }

    /**
     * @param catalogo2 the catalogo2 to set
     */
    public void setCatalogo2(DDCatalogo2 catalogo2) {
        this.catalogo2 = catalogo2;
    }

    /**
     * @return the catalogo3
     */
    public DDCatalogo3 getCatalogo3() {
        return catalogo3;
    }

    /**
     * @param catalogo3 the catalogo3 to set
     */
    public void setCatalogo3(DDCatalogo3 catalogo3) {
        this.catalogo3 = catalogo3;
    }

    /**
     * @return the catalogo4
     */
    public DDCatalogo4 getCatalogo4() {
        return catalogo4;
    }

    /**
     * @param catalogo4 the catalogo4 to set
     */
    public void setCatalogo4(DDCatalogo4 catalogo4) {
        this.catalogo4 = catalogo4;
    }

    /**
     * @return the catalogo5
     */
    public DDCatalogo5 getCatalogo5() {
        return catalogo5;
    }

    /**
     * @param catalogo5 the catalogo5 to set
     */
    public void setCatalogo5(DDCatalogo5 catalogo5) {
        this.catalogo5 = catalogo5;
    }

    /**
     * @return the catalogo6
     */
    public DDCatalogo6 getCatalogo6() {
        return catalogo6;
    }

    /**
     * @param catalogo6 the catalogo6 to set
     */
    public void setCatalogo6(DDCatalogo6 catalogo6) {
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
    
    
    //==ExtContrato===//
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_CODIGO_OFICINA_ORIGEN + "'))")
	private String nuevoCodigoOficina;

	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_CODIGO_ENTIDAD_ORIGEN + "'))")
	private String entidadOrigen;

	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_CODIGO_CONTRATO_ORIGEN + "'))")
	private String contratoOrigen;

	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_CODIGO_TIPO_PRODUCTO_ORIGEN + "'))")
	private String tipoProductoOrigen;

	@OneToMany(mappedBy = "unidadGestionId", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "UG_ID")
	@Where(clause = "DD_EIN_ID = " + DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO)
	private List<EXTGestorEntidad> gestoresContrato;


	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_CODIGO_PRINCIPAL + "'))")
	private String contratoPrincipal;
	
	@Formula("(select stl.dd_stl_descripcion " 
			+ " from dd_stl_situacion_litigio stl "
			+ " where stl.dd_stl_codigo = (select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ " and iac.dd_ifc_id = ("
			+ " select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_ESTADO_LITIGIO + "')))")
	private String estadoLitigio;
	
	@Formula("(select frl.dd_frl_descripcion "
			+ " from dd_frl_fase_recup_litigio frl "
			+ " where frl.dd_frl_codigo = (select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_FASE_RECUPERACION + "')))")
	private String faseRecuperacion;
	
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_GASTOS_LITIGIO + "'))")
	private String gastos;
	
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_PROVISION_PROCURADOR + "'))")
	private String provisionProcurador;
	
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_INTERESES_DEMORA + "'))")
	private String interesesDemora;
	
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_MINUTA_LETRADO + "'))")
	private String minutaLetrado;
	
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_ENTREGAS_LITIGIO + "'))")
	private String entregas;
	
	
	@Formula("(select ece.dd_ece_descripcion " 
			+ " from DD_ECE_ESTADO_CONTRATO_ENTIDAD ece "
			+ " where ece.dd_ece_codigo = (select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ " and iac.dd_ifc_id = ("
			+ " select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_ESTADO_CONTRATO_ENTIDAD + "')))")
	private String estadoContratoEntidad;
	
//	@Override
	public String getCodigoContrato() {
		if (codigoContrato == null) {

			String contrato = (contratoOrigen == null) ? nroContrato : contratoOrigen;
			
			if(projectContext != null && projectContext.getFormatoNroContrato() != null) {
				return projectContext.getNroContratoFormateado(contrato);
			}
			else {
			
				if (entidadOrigen==null
						|| nuevoCodigoOficina==null
						|| contratoOrigen==null) {
					return this.getCodigoContratoENTITY();
				} 
				else {
					String codEntidad = rellenaConCeros(4, entidadOrigen);
					String codOficina = rellenaConCeros(4, nuevoCodigoOficina);
					contrato = rellenaConCeros(10, contratoOrigen);
					codigoContrato = codEntidad + " " + codOficina + " " + contrato;
				}
			}
		}
		return codigoContrato;
	}

	private String rellenaConCeros(int longitud, String nbr) 
	{
		return StringUtils.leftPad(nbr, longitud, "0");
	}

	public String getEntidadOrigen() {
		return entidadOrigen;
	}

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
		return tipoProductoOrigen;
	}

	public void setGestoresContrato(List<EXTGestorEntidad> gestoresContrato) {
		this.gestoresContrato = gestoresContrato;
	}

	public List<EXTGestorEntidad> getGestoresContrato() {
		return gestoresContrato;
	}


	/**
	 * @param contratoPrincipal the contratoPrincipal to set
	 */
	public void setContratoPrincipal(String contratoPrincipal) {
		this.contratoPrincipal = contratoPrincipal;
	}

	/**
	 * @return the contratoPrincipal
	 */
	public String getContratoPrincipal() {
		return contratoPrincipal;
	}

	/**
	 * @param faseRecuperacion the faseRecuperacion to set
	 */
	public void setFaseRecuperacion(String faseRecuperacion) {
		this.faseRecuperacion = faseRecuperacion;
	}

	/**
	 * @return the faseRecuperacion
	 */
	public String getFaseRecuperacion() {
		return faseRecuperacion;
	}

	/**
	 * @param estadoLitigio the estadoLitigio to set
	 */
	public void setEstadoLitigio(String estadoLitigio) {
		this.estadoLitigio = estadoLitigio;
	}

	/**
	 * @return the estadoLitigio
	 */
	public String getEstadoLitigio() {
		return estadoLitigio;
	}



	/**
	 * @param gastos the gastos to set
	 */
	public void setGastos(String gastos) {
		this.gastos = gastos;
	}

	/**
	 * @return the gastos
	 */
	public String getGastos() {
		return gastos;
	}

	/**
	 * @param provisionProcurador the provisionProcurador to set
	 */
	public void setProvisionProcurador(String provisionProcurador) {
		this.provisionProcurador = provisionProcurador;
	}

	/**
	 * @return the provisionProcurador
	 */
	public String getProvisionProcurador() {
		return provisionProcurador;
	}

	/**
	 * @param interesesDemora the interesesDemora to set
	 */
	public void setInteresesDemora(String interesesDemora) {
		this.interesesDemora = interesesDemora;
	}

	/**
	 * @return the interesesDemora
	 */
	public String getInteresesDemora() {
		return interesesDemora;
	}

	/**
	 * @param minutaLetrado the minutaLetrado to set
	 */
	public void setMinutaLetrado(String minutaLetrado) {
		this.minutaLetrado = minutaLetrado;
	}

	/**
	 * @return the minutaLetrado
	 */
	public String getMinutaLetrado() {
		return minutaLetrado;
	}

	/**
	 * @param entregas the entregas to set
	 */
	public void setEntregas(String entregas) {
		this.entregas = entregas;
	}

	/**
	 * @return the entregas
	 */
	public String getEntregas() {
		return entregas;
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

    /**
     * PBO: Introducido para soporte de Lindorff
     */
    //FIXME Mover esto al plugin de Lindorff
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_CREDITOR + "'))")
    private String creditor;

	public String getCreditor() {
		return creditor;
	}

	public void setCreditor(String creditor) {
		this.creditor = creditor;
	}
	
	@Formula("(SELECT DD_PRO.DD_PRO_DESCRIPCION FROM DD_PRO_PROPIETARIOS DD_PRO WHERE DD_PRO.DD_PRO_CODIGO = ("
			+"select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_COD_ENTIDAD_PROPIETARIA + "')))")
    private String codEntidadPropietaria;
	
	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_NUMERO_ESPEC + "'))")
    private String condicionesEspeciales;

	@Formula("(SELECT DD_SEC.DD_SEC_DESCRIPCION FROM DD_SEC_SEGMENTO_CARTERA DD_SEC WHERE DD_SEC.DD_SEC_CODIGO = ("
			+"select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
			+ "  and iac.dd_ifc_id = ("
			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
			+ APPConstants.CNT_IAC_NUM_EXTRA2 + "')))")
    private String segmentoCartera;


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
		return aplicativoOrigen;
	}

	public void setAplicativoOrigen(DDAplicativoOrigen aplicativoOrigen) {
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
		return sistemaAmortizacion;
	}

	public void setSistemaAmortizacion(DDSistemaAmortizContrato sistemaAmortizacion) {
		this.sistemaAmortizacion = sistemaAmortizacion;
	}

	public DDTipoInteres getInteresFijoVariable() {
		return interesFijoVariable;
	}

	public void setInteresFijoVariable(DDTipoInteres interesFijoVariable) {
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
		return codEntidadPropietaria;
	}


	public String getCondicionesEspeciales() {
		return condicionesEspeciales;
	}
	
	public String getSegmentoCartera() {
		return segmentoCartera;
	}

	public Oficina getOficinaContable() {
		return oficinaContable;
	}

	public void setOficinaContable(Oficina oficinaContable) {
		this.oficinaContable = oficinaContable;
	}

	public Oficina getOficinaAdministrativa() {
		return oficinaAdministrativa;
	}

	public void setOficinaAdministrativa(Oficina oficinaAdministrativa) {
		this.oficinaAdministrativa = oficinaAdministrativa;
	}

	public DDGestionEspecial getGestionEspecial() {
		return gestionEspecial;
	}

	public void setGestionEspecial(DDGestionEspecial gestionEspecial) {
		this.gestionEspecial = gestionEspecial;
	}

	public DDCondicionesRemuneracion getRemuneracionEspecial() {
		return RemuneracionEspecial;
	}

	public void setRemuneracionEspecial(
			DDCondicionesRemuneracion remuneracionEspecial) {
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

	public static void setProjectContext(final CommonProjectContext commonProjectContext) 
	{
		projectContext = commonProjectContext;
	}

	public DDMotivoRenumeracion getMotivoRenumeracion() {
		return motivoRenumeracion;
	}

	public void setMotivoRenumeracion(DDMotivoRenumeracion motivoRenumeracion) {
		this.motivoRenumeracion = motivoRenumeracion;
	}

	public String getEstadoContratoEntidad() {
		return estadoContratoEntidad;
	}

	public void setEstadoContratoEntidad(String estadoContratoEntidad) {
		this.estadoContratoEntidad = estadoContratoEntidad;
	}
	public List<Bien> getBienes() {
		return bienes;
	}
	
	public void setBienes(List<Bien> bienes) {
		this.bienes = bienes;
	}

	@Basic(fetch=FetchType.LAZY)
	public String getMarcaOperacion() {
		return marcaOperacion;
	}
	
	@Basic(fetch=FetchType.LAZY)
	public String getMotivoMarca() {
		return motivoMarca;
	}
	
	@Basic(fetch=FetchType.LAZY)
	public String getIndicadorNominaPension() {
		return indicadorNominaPension;
	}

	@Basic(fetch=FetchType.LAZY)
	public String getEstadoEntidad() {
		return estadoEntidad;
	}

	
}
