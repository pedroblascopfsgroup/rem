
package org.cajamar.ws.S_C_RECOVERY_DAT_PR;

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
 *         &lt;element name="CAPITAL_DISPUESTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CAPITAL_NO_VENCIDO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CAPITAL_RECIBOS_PEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CARENCIA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CLASE_P_P" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="DEMORA_RECIBOS_PEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FECHA_IMPAGO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="INTERESES_RECIBOS_PEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NUM_CUENTA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="OFICINA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="RIESGO_GLOBAL" type="{http://www.w3.org/2001/XMLSchema}string"/>
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

    @XmlElement(name = "CAPITAL_DISPUESTO", required = true)
    protected String capitaldispuesto;
    @XmlElement(name = "CAPITAL_NO_VENCIDO", required = true)
    protected String capitalnovencido;
    @XmlElement(name = "CAPITAL_RECIBOS_PEN", required = true)
    protected String capitalrecibospen;
    @XmlElement(name = "CARENCIA", required = true)
    protected String carencia;
    @XmlElement(name = "CLASE_P_P", required = true)
    protected String clasepp;
    @XmlElement(name = "DEMORA_RECIBOS_PEN", required = true)
    protected String demorarecibospen;
    @XmlElement(name = "FECHA_IMPAGO", required = true)
    protected String fechaimpago;
    @XmlElement(name = "INTERESES_RECIBOS_PEN", required = true)
    protected String interesesrecibospen;
    @XmlElement(name = "NUM_CUENTA", required = true)
    protected String numcuenta;
    @XmlElement(name = "OFICINA", required = true)
    protected String oficina;
    @XmlElement(name = "RIESGO_GLOBAL", required = true)
    protected String riesgoglobal;
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
     * Gets the value of the capitaldispuesto property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCAPITALDISPUESTO() {
        return capitaldispuesto;
    }

    /**
     * Sets the value of the capitaldispuesto property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCAPITALDISPUESTO(String value) {
        this.capitaldispuesto = value;
    }

    /**
     * Gets the value of the capitalnovencido property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCAPITALNOVENCIDO() {
        return capitalnovencido;
    }

    /**
     * Sets the value of the capitalnovencido property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCAPITALNOVENCIDO(String value) {
        this.capitalnovencido = value;
    }

    /**
     * Gets the value of the capitalrecibospen property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCAPITALRECIBOSPEN() {
        return capitalrecibospen;
    }

    /**
     * Sets the value of the capitalrecibospen property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCAPITALRECIBOSPEN(String value) {
        this.capitalrecibospen = value;
    }

    /**
     * Gets the value of the carencia property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCARENCIA() {
        return carencia;
    }

    /**
     * Sets the value of the carencia property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCARENCIA(String value) {
        this.carencia = value;
    }

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
     * Gets the value of the demorarecibospen property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDEMORARECIBOSPEN() {
        return demorarecibospen;
    }

    /**
     * Sets the value of the demorarecibospen property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDEMORARECIBOSPEN(String value) {
        this.demorarecibospen = value;
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
     * Gets the value of the interesesrecibospen property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getINTERESESRECIBOSPEN() {
        return interesesrecibospen;
    }

    /**
     * Sets the value of the interesesrecibospen property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setINTERESESRECIBOSPEN(String value) {
        this.interesesrecibospen = value;
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
     * Gets the value of the riesgoglobal property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRIESGOGLOBAL() {
        return riesgoglobal;
    }

    /**
     * Sets the value of the riesgoglobal property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRIESGOGLOBAL(String value) {
        this.riesgoglobal = value;
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
