
package org.cajamar.ws.S_M_GESTIONDOCUMENTAL;

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
 *         &lt;element name="CLAVEASOCIACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CLAVEASOCIACION2" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CLAVEASOCIACION3" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="DESCRIPCION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="EXTENSIONFICHERO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FECHAVIGENCIA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FICHEROBASE64" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="LOCALIZADOR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="OPERACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ORIGEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="RUTA_FICHERO_REMOTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TIPOASOCIACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TIPOASOCIACION2" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TIPOASOCIACION3" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TIPODOCUMENTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
@XmlRootElement(name = "INPUT")
public class INPUT {

    @XmlElement(name = "CLAVEASOCIACION")
    protected String claveasociacion;
    @XmlElement(name = "CLAVEASOCIACION2")
    protected String claveasociacion2;
    @XmlElement(name = "CLAVEASOCIACION3")
    protected String claveasociacion3;
    @XmlElement(name = "DESCRIPCION")
    protected String descripcion;
    @XmlElement(name = "EXTENSIONFICHERO")
    protected String extensionfichero;
    @XmlElement(name = "FECHAVIGENCIA")
    protected String fechavigencia;
    @XmlElement(name = "FICHEROBASE64")
    protected String ficherobase64;
    @XmlElement(name = "LOCALIZADOR")
    protected String localizador;
    @XmlElement(name = "OPERACION", required = true)
    protected String operacion;
    @XmlElement(name = "ORIGEN")
    protected String origen;
    @XmlElement(name = "RUTA_FICHERO_REMOTO")
    protected String rutaficheroremoto;
    @XmlElement(name = "TIPOASOCIACION")
    protected String tipoasociacion;
    @XmlElement(name = "TIPOASOCIACION2")
    protected String tipoasociacion2;
    @XmlElement(name = "TIPOASOCIACION3")
    protected String tipoasociacion3;
    @XmlElement(name = "TIPODOCUMENTO")
    protected String tipodocumento;

    /**
     * Gets the value of the claveasociacion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCLAVEASOCIACION() {
        return claveasociacion;
    }

    /**
     * Sets the value of the claveasociacion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCLAVEASOCIACION(String value) {
        this.claveasociacion = value;
    }

    /**
     * Gets the value of the claveasociacion2 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCLAVEASOCIACION2() {
        return claveasociacion2;
    }

    /**
     * Sets the value of the claveasociacion2 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCLAVEASOCIACION2(String value) {
        this.claveasociacion2 = value;
    }

    /**
     * Gets the value of the claveasociacion3 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCLAVEASOCIACION3() {
        return claveasociacion3;
    }

    /**
     * Sets the value of the claveasociacion3 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCLAVEASOCIACION3(String value) {
        this.claveasociacion3 = value;
    }

    /**
     * Gets the value of the descripcion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDESCRIPCION() {
        return descripcion;
    }

    /**
     * Sets the value of the descripcion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDESCRIPCION(String value) {
        this.descripcion = value;
    }

    /**
     * Gets the value of the extensionfichero property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEXTENSIONFICHERO() {
        return extensionfichero;
    }

    /**
     * Sets the value of the extensionfichero property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEXTENSIONFICHERO(String value) {
        this.extensionfichero = value;
    }

    /**
     * Gets the value of the fechavigencia property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFECHAVIGENCIA() {
        return fechavigencia;
    }

    /**
     * Sets the value of the fechavigencia property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFECHAVIGENCIA(String value) {
        this.fechavigencia = value;
    }

    /**
     * Gets the value of the ficherobase64 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFICHEROBASE64() {
        return ficherobase64;
    }

    /**
     * Sets the value of the ficherobase64 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFICHEROBASE64(String value) {
        this.ficherobase64 = value;
    }

    /**
     * Gets the value of the localizador property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLOCALIZADOR() {
        return localizador;
    }

    /**
     * Sets the value of the localizador property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLOCALIZADOR(String value) {
        this.localizador = value;
    }

    /**
     * Gets the value of the operacion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOPERACION() {
        return operacion;
    }

    /**
     * Sets the value of the operacion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOPERACION(String value) {
        this.operacion = value;
    }

    /**
     * Gets the value of the origen property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getORIGEN() {
        return origen;
    }

    /**
     * Sets the value of the origen property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setORIGEN(String value) {
        this.origen = value;
    }

    /**
     * Gets the value of the rutaficheroremoto property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRUTAFICHEROREMOTO() {
        return rutaficheroremoto;
    }

    /**
     * Sets the value of the rutaficheroremoto property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRUTAFICHEROREMOTO(String value) {
        this.rutaficheroremoto = value;
    }

    /**
     * Gets the value of the tipoasociacion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTIPOASOCIACION() {
        return tipoasociacion;
    }

    /**
     * Sets the value of the tipoasociacion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTIPOASOCIACION(String value) {
        this.tipoasociacion = value;
    }

    /**
     * Gets the value of the tipoasociacion2 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTIPOASOCIACION2() {
        return tipoasociacion2;
    }

    /**
     * Sets the value of the tipoasociacion2 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTIPOASOCIACION2(String value) {
        this.tipoasociacion2 = value;
    }

    /**
     * Gets the value of the tipoasociacion3 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTIPOASOCIACION3() {
        return tipoasociacion3;
    }

    /**
     * Sets the value of the tipoasociacion3 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTIPOASOCIACION3(String value) {
        this.tipoasociacion3 = value;
    }

    /**
     * Gets the value of the tipodocumento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTIPODOCUMENTO() {
        return tipodocumento;
    }

    /**
     * Sets the value of the tipodocumento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTIPODOCUMENTO(String value) {
        this.tipodocumento = value;
    }

}
