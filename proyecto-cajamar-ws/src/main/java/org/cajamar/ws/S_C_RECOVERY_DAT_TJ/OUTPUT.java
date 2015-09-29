
package org.cajamar.ws.S_C_RECOVERY_DAT_TJ;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;all>
 *         &lt;element name="CLASE_P_P" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="DEMORA_RECIBOS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FECHA_IMPAGO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="INTERESES_RECIBOS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NUM_CUENTA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="OFICINA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SALDO_ACT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SALDO_GASTOS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ESTADO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="COD_ERROR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TXT_ERROR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/all>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {

})
@XmlRootElement(name = "OUTPUT")
public class OUTPUT {

    @XmlElement(name = "CLASE_P_P", required = true)
    protected String clasepp;
    @XmlElement(name = "DEMORA_RECIBOS", required = true)
    protected String demorarecibos;
    @XmlElement(name = "FECHA_IMPAGO", required = true)
    protected String fechaimpago;
    @XmlElement(name = "INTERESES_RECIBOS", required = true)
    protected String interesesrecibos;
    @XmlElement(name = "NUM_CUENTA", required = true)
    protected String numcuenta;
    @XmlElement(name = "OFICINA", required = true)
    protected String oficina;
    @XmlElement(name = "SALDO_ACT", required = true)
    protected String saldoact;
    @XmlElement(name = "SALDO_GASTOS", required = true)
    protected String saldogastos;
    @XmlElement(name = "ESTADO", required = true)
    protected String estado;
    @XmlElement(name = "COD_ERROR", required = true)
    protected String coderror;
    @XmlElement(name = "TXT_ERROR", required = true)
    protected String txterror;

    /**
     * Gets the value of the clasepp property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCLASEPP() {
        return clasepp;
    }

    /**
     * Sets the value of the clasepp property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCLASEPP(String value) {
        this.clasepp = value;
    }

    /**
     * Gets the value of the demorarecibos property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDEMORARECIBOS() {
        return demorarecibos;
    }

    /**
     * Sets the value of the demorarecibos property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDEMORARECIBOS(String value) {
        this.demorarecibos = value;
    }

    /**
     * Gets the value of the fechaimpago property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFECHAIMPAGO() {
        return fechaimpago;
    }

    /**
     * Sets the value of the fechaimpago property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFECHAIMPAGO(String value) {
        this.fechaimpago = value;
    }

    /**
     * Gets the value of the interesesrecibos property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getINTERESESRECIBOS() {
        return interesesrecibos;
    }

    /**
     * Sets the value of the interesesrecibos property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setINTERESESRECIBOS(String value) {
        this.interesesrecibos = value;
    }

    /**
     * Gets the value of the numcuenta property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNUMCUENTA() {
        return numcuenta;
    }

    /**
     * Sets the value of the numcuenta property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNUMCUENTA(String value) {
        this.numcuenta = value;
    }

    /**
     * Gets the value of the oficina property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOFICINA() {
        return oficina;
    }

    /**
     * Sets the value of the oficina property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOFICINA(String value) {
        this.oficina = value;
    }

    /**
     * Gets the value of the saldoact property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSALDOACT() {
        return saldoact;
    }

    /**
     * Sets the value of the saldoact property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSALDOACT(String value) {
        this.saldoact = value;
    }

    /**
     * Gets the value of the saldogastos property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSALDOGASTOS() {
        return saldogastos;
    }

    /**
     * Sets the value of the saldogastos property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSALDOGASTOS(String value) {
        this.saldogastos = value;
    }

    /**
     * Gets the value of the estado property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getESTADO() {
        return estado;
    }

    /**
     * Sets the value of the estado property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setESTADO(String value) {
        this.estado = value;
    }

    /**
     * Gets the value of the coderror property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCODERROR() {
        return coderror;
    }

    /**
     * Sets the value of the coderror property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCODERROR(String value) {
        this.coderror = value;
    }

    /**
     * Gets the value of the txterror property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTXTERROR() {
        return txterror;
    }

    /**
     * Sets the value of the txterror property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTXTERROR(String value) {
        this.txterror = value;
    }

}
