
package org.cajamar.ws.S_M_GESTIONDOCUMENTAL;

import java.util.ArrayList;
import java.util.List;
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
 *         &lt;element name="DESC_ESTADO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ESTADO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="EXTENSIONFICHERO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FECHAALTARELACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FECHAALTAVERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FICHEROBASE64" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="IDDOCUMENTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="LB_LISTADODOCUMENTOS">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="element" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;all>
 *                             &lt;element name="TIPODOC" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="NOMBRETIPODOC" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="DESCRIPCION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="ALTAVERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="VERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="ALTARELACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="ENTIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="CENTRO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="MAESTRO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="CLAVERELACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="PERMACT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="FECHAVIG" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="HIST" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="IDDOCUMENTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="CONSULTABILIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="RETENIDO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="EXTFICHERO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="ESTADOSFD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="REFCENTERA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                           &lt;/all>
 *                         &lt;/restriction>
 *                       &lt;/complexContent>
 *                     &lt;/complexType>
 *                   &lt;/element>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *         &lt;element name="VERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
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

    @XmlElement(name = "DESC_ESTADO", required = true)
    protected String descestado;
    @XmlElement(name = "ESTADO", required = true)
    protected String estado;
    @XmlElement(name = "EXTENSIONFICHERO", required = true)
    protected String extensionfichero;
    @XmlElement(name = "FECHAALTARELACION", required = true)
    protected String fechaaltarelacion;
    @XmlElement(name = "FECHAALTAVERSION", required = true)
    protected String fechaaltaversion;
    @XmlElement(name = "FICHEROBASE64", required = true)
    protected String ficherobase64;
    @XmlElement(name = "IDDOCUMENTO", required = true)
    protected String iddocumento;
    @XmlElement(name = "LB_LISTADODOCUMENTOS", required = true)
    protected OUTPUT.LBLISTADODOCUMENTOS lblistadodocumentos;
    @XmlElement(name = "VERSION", required = true)
    protected String version;
    @XmlElement(name = "COD_ERROR", required = true)
    protected String coderror;
    @XmlElement(name = "TXT_ERROR", required = true)
    protected String txterror;

    /**
     * Gets the value of the descestado property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDESCESTADO() {
        return descestado;
    }

    /**
     * Sets the value of the descestado property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDESCESTADO(String value) {
        this.descestado = value;
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
     * Gets the value of the fechaaltarelacion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFECHAALTARELACION() {
        return fechaaltarelacion;
    }

    /**
     * Sets the value of the fechaaltarelacion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFECHAALTARELACION(String value) {
        this.fechaaltarelacion = value;
    }

    /**
     * Gets the value of the fechaaltaversion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFECHAALTAVERSION() {
        return fechaaltaversion;
    }

    /**
     * Sets the value of the fechaaltaversion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFECHAALTAVERSION(String value) {
        this.fechaaltaversion = value;
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
     * Gets the value of the iddocumento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIDDOCUMENTO() {
        return iddocumento;
    }

    /**
     * Sets the value of the iddocumento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIDDOCUMENTO(String value) {
        this.iddocumento = value;
    }

    /**
     * Gets the value of the lblistadodocumentos property.
     * 
     * @return
     *     possible object is
     *     {@link OUTPUT.LBLISTADODOCUMENTOS }
     *     
     */
    public OUTPUT.LBLISTADODOCUMENTOS getLBLISTADODOCUMENTOS() {
        return lblistadodocumentos;
    }

    /**
     * Sets the value of the lblistadodocumentos property.
     * 
     * @param value
     *     allowed object is
     *     {@link OUTPUT.LBLISTADODOCUMENTOS }
     *     
     */
    public void setLBLISTADODOCUMENTOS(OUTPUT.LBLISTADODOCUMENTOS value) {
        this.lblistadodocumentos = value;
    }

    /**
     * Gets the value of the version property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVERSION() {
        return version;
    }

    /**
     * Sets the value of the version property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVERSION(String value) {
        this.version = value;
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


    /**
     * <p>Java class for anonymous complex type.
     * 
     * <p>The following schema fragment specifies the expected content contained within this class.
     * 
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;sequence>
     *         &lt;element name="element" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;all>
     *                   &lt;element name="TIPODOC" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="NOMBRETIPODOC" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="DESCRIPCION" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="ALTAVERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="VERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="ALTARELACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="ENTIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="CENTRO" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="MAESTRO" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="CLAVERELACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="PERMACT" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="FECHAVIG" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="HIST" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="IDDOCUMENTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="CONSULTABILIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="RETENIDO" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="EXTFICHERO" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="ESTADOSFD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="REFCENTERA" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                 &lt;/all>
     *               &lt;/restriction>
     *             &lt;/complexContent>
     *           &lt;/complexType>
     *         &lt;/element>
     *       &lt;/sequence>
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "element"
    })
    public static class LBLISTADODOCUMENTOS {

        protected List<OUTPUT.LBLISTADODOCUMENTOS.Element> element;

        /**
         * Gets the value of the element property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the element property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getElement().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link OUTPUT.LBLISTADODOCUMENTOS.Element }
         * 
         * 
         */
        public List<OUTPUT.LBLISTADODOCUMENTOS.Element> getElement() {
            if (element == null) {
                element = new ArrayList<OUTPUT.LBLISTADODOCUMENTOS.Element>();
            }
            return this.element;
        }


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
         *         &lt;element name="TIPODOC" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="NOMBRETIPODOC" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="DESCRIPCION" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="ALTAVERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="VERSION" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="ALTARELACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="ENTIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="CENTRO" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="MAESTRO" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="CLAVERELACION" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="PERMACT" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="FECHAVIG" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="HIST" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="IDDOCUMENTO" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="CONSULTABILIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="RETENIDO" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="EXTFICHERO" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="ESTADOSFD" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="REFCENTERA" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
        public static class Element {

            @XmlElement(name = "TIPODOC", required = true)
            protected String tipodoc;
            @XmlElement(name = "NOMBRETIPODOC", required = true)
            protected String nombretipodoc;
            @XmlElement(name = "DESCRIPCION", required = true)
            protected String descripcion;
            @XmlElement(name = "ALTAVERSION", required = true)
            protected String altaversion;
            @XmlElement(name = "VERSION", required = true)
            protected String version;
            @XmlElement(name = "ALTARELACION", required = true)
            protected String altarelacion;
            @XmlElement(name = "ENTIDAD", required = true)
            protected String entidad;
            @XmlElement(name = "CENTRO", required = true)
            protected String centro;
            @XmlElement(name = "MAESTRO", required = true)
            protected String maestro;
            @XmlElement(name = "CLAVERELACION", required = true)
            protected String claverelacion;
            @XmlElement(name = "PERMACT", required = true)
            protected String permact;
            @XmlElement(name = "FECHAVIG", required = true)
            protected String fechavig;
            @XmlElement(name = "HIST", required = true)
            protected String hist;
            @XmlElement(name = "IDDOCUMENTO", required = true)
            protected String iddocumento;
            @XmlElement(name = "CONSULTABILIDAD", required = true)
            protected String consultabilidad;
            @XmlElement(name = "RETENIDO", required = true)
            protected String retenido;
            @XmlElement(name = "EXTFICHERO", required = true)
            protected String extfichero;
            @XmlElement(name = "ESTADOSFD", required = true)
            protected String estadosfd;
            @XmlElement(name = "REFCENTERA", required = true)
            protected String refcentera;

            /**
             * Gets the value of the tipodoc property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getTIPODOC() {
                return tipodoc;
            }

            /**
             * Sets the value of the tipodoc property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setTIPODOC(String value) {
                this.tipodoc = value;
            }

            /**
             * Gets the value of the nombretipodoc property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getNOMBRETIPODOC() {
                return nombretipodoc;
            }

            /**
             * Sets the value of the nombretipodoc property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setNOMBRETIPODOC(String value) {
                this.nombretipodoc = value;
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
             * Gets the value of the altaversion property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getALTAVERSION() {
                return altaversion;
            }

            /**
             * Sets the value of the altaversion property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setALTAVERSION(String value) {
                this.altaversion = value;
            }

            /**
             * Gets the value of the version property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getVERSION() {
                return version;
            }

            /**
             * Sets the value of the version property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setVERSION(String value) {
                this.version = value;
            }

            /**
             * Gets the value of the altarelacion property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getALTARELACION() {
                return altarelacion;
            }

            /**
             * Sets the value of the altarelacion property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setALTARELACION(String value) {
                this.altarelacion = value;
            }

            /**
             * Gets the value of the entidad property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getENTIDAD() {
                return entidad;
            }

            /**
             * Sets the value of the entidad property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setENTIDAD(String value) {
                this.entidad = value;
            }

            /**
             * Gets the value of the centro property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCENTRO() {
                return centro;
            }

            /**
             * Sets the value of the centro property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCENTRO(String value) {
                this.centro = value;
            }

            /**
             * Gets the value of the maestro property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getMAESTRO() {
                return maestro;
            }

            /**
             * Sets the value of the maestro property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setMAESTRO(String value) {
                this.maestro = value;
            }

            /**
             * Gets the value of the claverelacion property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCLAVERELACION() {
                return claverelacion;
            }

            /**
             * Sets the value of the claverelacion property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCLAVERELACION(String value) {
                this.claverelacion = value;
            }

            /**
             * Gets the value of the permact property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getPERMACT() {
                return permact;
            }

            /**
             * Sets the value of the permact property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setPERMACT(String value) {
                this.permact = value;
            }

            /**
             * Gets the value of the fechavig property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getFECHAVIG() {
                return fechavig;
            }

            /**
             * Sets the value of the fechavig property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setFECHAVIG(String value) {
                this.fechavig = value;
            }

            /**
             * Gets the value of the hist property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getHIST() {
                return hist;
            }

            /**
             * Sets the value of the hist property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setHIST(String value) {
                this.hist = value;
            }

            /**
             * Gets the value of the iddocumento property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getIDDOCUMENTO() {
                return iddocumento;
            }

            /**
             * Sets the value of the iddocumento property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setIDDOCUMENTO(String value) {
                this.iddocumento = value;
            }

            /**
             * Gets the value of the consultabilidad property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCONSULTABILIDAD() {
                return consultabilidad;
            }

            /**
             * Sets the value of the consultabilidad property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCONSULTABILIDAD(String value) {
                this.consultabilidad = value;
            }

            /**
             * Gets the value of the retenido property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getRETENIDO() {
                return retenido;
            }

            /**
             * Sets the value of the retenido property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setRETENIDO(String value) {
                this.retenido = value;
            }

            /**
             * Gets the value of the extfichero property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getEXTFICHERO() {
                return extfichero;
            }

            /**
             * Sets the value of the extfichero property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setEXTFICHERO(String value) {
                this.extfichero = value;
            }

            /**
             * Gets the value of the estadosfd property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getESTADOSFD() {
                return estadosfd;
            }

            /**
             * Sets the value of the estadosfd property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setESTADOSFD(String value) {
                this.estadosfd = value;
            }

            /**
             * Gets the value of the refcentera property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getREFCENTERA() {
                return refcentera;
            }

            /**
             * Sets the value of the refcentera property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setREFCENTERA(String value) {
                this.refcentera = value;
            }

        }

    }

}
