package es.capgemini.pfs.ruleengine.rule.dd;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoPersona;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Entity
@Table(name = DDRule.TABLE_NAME, schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDRule implements Serializable, Auditable {

    private static final long serialVersionUID = -2531383989081345299L;
    public static final String TABLE_NAME = "DD_RULE_DEFINITION";

    @Id
    @Column(name = "RD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RDGenerator")
    @SequenceGenerator(name = "RDGenerator", sequenceName = "S_DD_RULE_DEFINITION")
    private Long id = -1L;

    @Column(name = "RD_COLUMN")
    private String column;

    @Column(name = "RD_TYPE")
    private String type;

    @Transient
    private String tableRef;

    @Column(name = "RD_TITLE")
    private String title;

    @Column(name = "RD_VALUE_FORMAT")
    private String format;

    @Column(name = "RD_BO_VALUES")
    private String businessOperation;

    @Column(name = "RD_TAB")
    private String tab;
    
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TCN_ID")
	private DDTipoCnae tipoCnae;
    
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MRF_ID")
	private DDMarcaRefinanciacion marcaRefinanciacion;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_IDN_ID")
	private DDIndicadorNomina indicadorNomina;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MOM_ID")
	private DDMotivoMarcaR motivoMarcaR;
    

    @Embedded
    private Auditoria auditoria;

    @Transient
    private List<Object> values;

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
     * @return the column
     */
    public String getColumn() {
        return column;
    }

    /**
     * @param column the column to set
     */
    public void setColumn(String column) {
        this.column = column;
    }

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * @return the tableRef
     */
    public String getTableRef() {
        return tableRef;
    }

    /**
     * @param tableRef the tableRef to set
     */
    public void setTableRef(String tableRef) {
        this.tableRef = tableRef;
    }

    /**
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * @param title the title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * @return the format
     */
    public String getFormat() {
        return format;
    }

    /**
     * @param format the format to set
     */
    public void setFormat(String format) {
        this.format = format;
    }

    /**
     * @return the values
     */
    public List<Object> getValues() {
        return values;
    }

    /**
     * @param values the values to set
     */
    public void setValues(List<Object> values) {
        this.values = values;
    }

    /**
     * @return the businessOperation
     */
    public String getBusinessOperation() {
        return businessOperation;
    }

    /**
     * @param businessOperation the businessOperation to set
     */
    public void setBusinessOperation(String businessOperation) {
        this.businessOperation = businessOperation;
    }

    /**
     * @return the tab
     */
    public String getTab() {
        return tab;
    }

    /**
     * @param tab the tab to set
     */
    public void setTab(String tab) {
        this.tab = tab;
    }

    public DDTipoCnae getTipoCnae() {
		return tipoCnae;
	}

	public void setTipoCnae(DDTipoCnae tipoCnae) {
		this.tipoCnae = tipoCnae;
	}

	public DDMarcaRefinanciacion getMarcaRefinanciacion() {
		return marcaRefinanciacion;
	}

	public void setMarcaRefinanciacion(DDMarcaRefinanciacion marcaRefinanciacion) {
		this.marcaRefinanciacion = marcaRefinanciacion;
	}

	public DDIndicadorNomina getIndicadorNomina() {
		return indicadorNomina;
	}

	public void setIndicadorNomina(DDIndicadorNomina indicadorNomina) {
		this.indicadorNomina = indicadorNomina;
	}
	
	public DDMotivoMarcaR getMotivoMarcaR() {
		return motivoMarcaR;
	}

	public void setMotivoMarcaR(DDMotivoMarcaR motivoMarcaR) {
		this.motivoMarcaR = motivoMarcaR;
	}

	@Override
    public Auditoria getAuditoria() {
        return auditoria;
    }

    @Override
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

}
