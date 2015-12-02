
package org.cajamar.ws.S_A_RECOVERY_TASACION;

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
 *         &lt;element name="DOC_SOLICITUD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ESTADO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="IDTA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TASA" type="{http://www.w3.org/2001/XMLSchema}string"/>
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

    @XmlElement(name = "DOC_SOLICITUD", required = true)
    protected String docsolicitud;
    @XmlElement(name = "ESTADO", required = true)
    protected String estado;
    @XmlElement(name = "IDTA", required = true)
    protected String idta;
    @XmlElement(name = "TASA", required = true)
    protected String tasa;
    @XmlElement(name = "COD_ERROR", required = true)
    protected String coderror;
    @XmlElement(name = "TXT_ERROR", required = true)
    protected String txterror;

    /**
     * Gets the value of the docsolicitud property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDOCSOLICITUD() {
        return docsolicitud;
    }

    /**
     * Sets the value of the docsolicitud property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDOCSOLICITUD(String value) {
        this.docsolicitud = value;
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
     * Gets the value of the idta property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIDTA() {
        return idta;
    }

    /**
     * Sets the value of the idta property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIDTA(String value) {
        this.idta = value;
    }

    /**
     * Gets the value of the tasa property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTASA() {
        return tasa;
    }

    /**
     * Sets the value of the tasa property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTASA(String value) {
        this.tasa = value;
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
