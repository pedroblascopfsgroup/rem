
package org.cajamar.ws.S_C_RECOVERY_DAT_FT;

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
 *         &lt;element name="COMISION_DEVOLUCION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="DEMORA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="DEMORA_RECIBOS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="DISPONIBLE" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="DISPUESTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="EXCEDIDO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FECHA_IMPAGO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FECHA_MORA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FINANCIADO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="IMPORTE_LIMITE" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="INTERES_RECIBOS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="IVA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="MOVIMIENTOS_3M" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NUM_CUENTA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="OFICINA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="RIESGO_GLOBAL" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SALDO_ACT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SALDO_GASTOS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SALDO_MED_12M" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SALDO_MED_3M" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SALDO_RETENIDO" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
    @XmlElement(name = "COMISION_DEVOLUCION", required = true)
    protected String comisiondevolucion;
    @XmlElement(name = "DEMORA", required = true)
    protected String demora;
    @XmlElement(name = "DEMORA_RECIBOS", required = true)
    protected String demorarecibos;
    @XmlElement(name = "DISPONIBLE", required = true)
    protected String disponible;
    @XmlElement(name = "DISPUESTO", required = true)
    protected String dispuesto;
    @XmlElement(name = "EXCEDIDO", required = true)
    protected String excedido;
    @XmlElement(name = "FECHA_IMPAGO", required = true)
    protected String fechaimpago;
    @XmlElement(name = "FECHA_MORA", required = true)
    protected String fechamora;
    @XmlElement(name = "FINANCIADO", required = true)
    protected String financiado;
    @XmlElement(name = "IMPORTE_LIMITE", required = true)
    protected String importelimite;
    @XmlElement(name = "INTERES_RECIBOS", required = true)
    protected String interesrecibos;
    @XmlElement(name = "IVA", required = true)
    protected String iva;
    @XmlElement(name = "MOVIMIENTOS_3M", required = true)
    protected String movimientos3M;
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
    @XmlElement(name = "SALDO_MED_12M", required = true)
    protected String saldomed12M;
    @XmlElement(name = "SALDO_MED_3M", required = true)
    protected String saldomed3M;
    @XmlElement(name = "SALDO_RETENIDO", required = true)
    protected String saldoretenido;
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
     * Gets the value of the comisiondevolucion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCOMISIONDEVOLUCION() {
        return comisiondevolucion;
    }

    /**
     * Sets the value of the comisiondevolucion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCOMISIONDEVOLUCION(String value) {
        this.comisiondevolucion = value;
    }

    /**
     * Gets the value of the demora property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDEMORA() {
        return demora;
    }

    /**
     * Sets the value of the demora property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDEMORA(String value) {
        this.demora = value;
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
     * Gets the value of the disponible property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDISPONIBLE() {
        return disponible;
    }

    /**
     * Sets the value of the disponible property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDISPONIBLE(String value) {
        this.disponible = value;
    }

    /**
     * Gets the value of the dispuesto property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDISPUESTO() {
        return dispuesto;
    }

    /**
     * Sets the value of the dispuesto property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDISPUESTO(String value) {
        this.dispuesto = value;
    }

    /**
     * Gets the value of the excedido property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEXCEDIDO() {
        return excedido;
    }

    /**
     * Sets the value of the excedido property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEXCEDIDO(String value) {
        this.excedido = value;
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
     * Gets the value of the fechamora property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFECHAMORA() {
        return fechamora;
    }

    /**
     * Sets the value of the fechamora property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFECHAMORA(String value) {
        this.fechamora = value;
    }

    /**
     * Gets the value of the financiado property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFINANCIADO() {
        return financiado;
    }

    /**
     * Sets the value of the financiado property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFINANCIADO(String value) {
        this.financiado = value;
    }

    /**
     * Gets the value of the importelimite property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIMPORTELIMITE() {
        return importelimite;
    }

    /**
     * Sets the value of the importelimite property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIMPORTELIMITE(String value) {
        this.importelimite = value;
    }

    /**
     * Gets the value of the interesrecibos property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getINTERESRECIBOS() {
        return interesrecibos;
    }

    /**
     * Sets the value of the interesrecibos property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setINTERESRECIBOS(String value) {
        this.interesrecibos = value;
    }

    /**
     * Gets the value of the iva property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIVA() {
        return iva;
    }

    /**
     * Sets the value of the iva property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIVA(String value) {
        this.iva = value;
    }

    /**
     * Gets the value of the movimientos3M property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getMOVIMIENTOS3M() {
        return movimientos3M;
    }

    /**
     * Sets the value of the movimientos3M property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setMOVIMIENTOS3M(String value) {
        this.movimientos3M = value;
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
     * Gets the value of the saldomed12M property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSALDOMED12M() {
        return saldomed12M;
    }

    /**
     * Sets the value of the saldomed12M property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSALDOMED12M(String value) {
        this.saldomed12M = value;
    }

    /**
     * Gets the value of the saldomed3M property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSALDOMED3M() {
        return saldomed3M;
    }

    /**
     * Sets the value of the saldomed3M property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSALDOMED3M(String value) {
        this.saldomed3M = value;
    }

    /**
     * Gets the value of the saldoretenido property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSALDORETENIDO() {
        return saldoretenido;
    }

    /**
     * Sets the value of the saldoretenido property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSALDORETENIDO(String value) {
        this.saldoretenido = value;
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
