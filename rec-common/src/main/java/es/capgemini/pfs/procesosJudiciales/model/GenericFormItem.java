package es.capgemini.pfs.procesosJudiciales.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

/**
 * Clase form item. Cada instancia es un elemento de un formulario
 * @author omedrano
 *
 */
@Entity
@Table(name = "TFI_TAREAS_FORM_ITEMS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class GenericFormItem implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unchecked")
    @Transient
    private List values;

    @Id
    @Column(name = "TFI_ID")
    private Long id;

    @Column(name = "TFI_LABEL")
    private String label;

    @Column(name = "TFI_VALOR_INICIAL")
    private String valueRO;
    
    @Transient
    private String value;

    @Column(name = "TFI_TIPO")
    private String type;

    @Column(name = "TFI_BUSINESS_OPERATION")
    private String valuesBusinessOperation;

    @Column(name = "TFI_NOMBRE")
    private String nombre;

    @Column(name = "TFI_VALIDACION")
    private String validation;

    @Column(name = "TFI_ORDEN")
    private int order;

    @Column(name = "TFI_ERROR_VALIDACION")
    private String validationError;

    @ManyToOne
    @JoinColumn(name = "TAP_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private TareaProcedimiento tareaProcedimiento;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    
    public static GenericFormItem getInstance(int order, String label, String valueRO, String type, String values, String validation,
            String validationError) {
        GenericFormItem item = new GenericFormItem();
        item.setOrder(order);
        item.setLabel(label);
        item.setValueRO(valueRO);        
        item.setValue(valueRO);
        item.setType(type);
        item.setValuesBusinessOperation(values);
        item.setValidation(validation);
        item.setValidationError(validationError);
        return item;
    }

    public static GenericFormItem getInstance(int order, String label, String valueRO, String type) {
        return getInstance(order, label, valueRO, type, "", "", "");
    }

    public String getLabel() {
        return label;
    }

    public String getType() {
        return type;
    }

    public String getValue() {
        if (value == null)
            return valueRO;
        else
            return value;
    }

    public String getValueRO() {
        return valueRO;
    }

    public void setValueRO(String valueRO) {
        this.valueRO = valueRO;
    }

    public String getValuesBusinessOperation() {
        return valuesBusinessOperation;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setValuesBusinessOperation(String values) {
        this.valuesBusinessOperation = values;
    }

    public void setValidation(String validation) {
        this.validation = validation;
    }

    public String getValidation() {
        return validation;
    }

    @SuppressWarnings("unchecked")
    public List getValues() {
        return values;
    }

    @SuppressWarnings("unchecked")
    public void setValues(List values) {
        this.values = values;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public int getOrder() {
        return order;
    }

    public String getValidationError() {
        return validationError;
    }

    public void setValidationError(String validationError) {
        this.validationError = validationError;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Auditoria getAuditoria() {
        return auditoria;
    }

    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }

    public TareaProcedimiento getTareaProcedimiento() {
        return tareaProcedimiento;
    }

    public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
        this.tareaProcedimiento = tareaProcedimiento;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

}
