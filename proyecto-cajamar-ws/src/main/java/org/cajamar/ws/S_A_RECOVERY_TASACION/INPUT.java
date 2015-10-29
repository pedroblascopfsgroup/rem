
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
 *         &lt;element name="CODDIR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CODPOSTAL" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="COMAUT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="CTAC" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ESTADOBIEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FINALIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="FOLIO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="IMPORIESGVIV" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="INCO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="INSCRIP" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="LIBRO" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="LOCALIDAD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NCTA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NFINCAREG" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NOMBPERSCONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NPERSONA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NRPROP" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NSECUENCIA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="OBSERV" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="OCUPACIONBIEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="OPCION" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="PROVINCIA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SITUACIONBIEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SOLICITANTE" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TBIEN" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TELFNCONTAS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TENC_RELA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TINMU" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TIPOPER" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TLF1" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TLF2" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="TOMO" type="{http://www.w3.org/2001/XMLSchema}string"/>
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

    @XmlElement(name = "CODDIR", required = true)
    protected String coddir;
    @XmlElement(name = "CODPOSTAL", required = true)
    protected String codpostal;
    @XmlElement(name = "COMAUT", required = true)
    protected String comaut;
    @XmlElement(name = "CTAC", required = true)
    protected String ctac;
    @XmlElement(name = "ESTADOBIEN", required = true)
    protected String estadobien;
    @XmlElement(name = "FINALIDAD", required = true)
    protected String finalidad;
    @XmlElement(name = "FOLIO", required = true)
    protected String folio;
    @XmlElement(name = "IMPORIESGVIV", required = true)
    protected String imporiesgviv;
    @XmlElement(name = "INCO", required = true)
    protected String inco;
    @XmlElement(name = "INSCRIP", required = true)
    protected String inscrip;
    @XmlElement(name = "LIBRO", required = true)
    protected String libro;
    @XmlElement(name = "LOCALIDAD", required = true)
    protected String localidad;
    @XmlElement(name = "NCTA", required = true)
    protected String ncta;
    @XmlElement(name = "NFINCAREG", required = true)
    protected String nfincareg;
    @XmlElement(name = "NOMBPERSCONT", required = true)
    protected String nombperscont;
    @XmlElement(name = "NPERSONA", required = true)
    protected String npersona;
    @XmlElement(name = "NRPROP", required = true)
    protected String nrprop;
    @XmlElement(name = "NSECUENCIA", required = true)
    protected String nsecuencia;
    @XmlElement(name = "OBSERV", required = true)
    protected String observ;
    @XmlElement(name = "OCUPACIONBIEN", required = true)
    protected String ocupacionbien;
    @XmlElement(name = "OPCION", required = true)
    protected String opcion;
    @XmlElement(name = "PROVINCIA", required = true)
    protected String provincia;
    @XmlElement(name = "SITUACIONBIEN", required = true)
    protected String situacionbien;
    @XmlElement(name = "SOLICITANTE", required = true)
    protected String solicitante;
    @XmlElement(name = "TBIEN", required = true)
    protected String tbien;
    @XmlElement(name = "TELFNCONTAS", required = true)
    protected String telfncontas;
    @XmlElement(name = "TENC_RELA", required = true)
    protected String tencrela;
    @XmlElement(name = "TINMU", required = true)
    protected String tinmu;
    @XmlElement(name = "TIPOPER", required = true)
    protected String tipoper;
    @XmlElement(name = "TLF1", required = true)
    protected String tlf1;
    @XmlElement(name = "TLF2", required = true)
    protected String tlf2;
    @XmlElement(name = "TOMO", required = true)
    protected String tomo;

    /**
     * Gets the value of the coddir property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCODDIR() {
        return coddir;
    }

    /**
     * Sets the value of the coddir property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCODDIR(String value) {
        this.coddir = value;
    }

    /**
     * Gets the value of the codpostal property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCODPOSTAL() {
        return codpostal;
    }

    /**
     * Sets the value of the codpostal property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCODPOSTAL(String value) {
        this.codpostal = value;
    }

    /**
     * Gets the value of the comaut property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCOMAUT() {
        return comaut;
    }

    /**
     * Sets the value of the comaut property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCOMAUT(String value) {
        this.comaut = value;
    }

    /**
     * Gets the value of the ctac property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCTAC() {
        return ctac;
    }

    /**
     * Sets the value of the ctac property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCTAC(String value) {
        this.ctac = value;
    }

    /**
     * Gets the value of the estadobien property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getESTADOBIEN() {
        return estadobien;
    }

    /**
     * Sets the value of the estadobien property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setESTADOBIEN(String value) {
        this.estadobien = value;
    }

    /**
     * Gets the value of the finalidad property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFINALIDAD() {
        return finalidad;
    }

    /**
     * Sets the value of the finalidad property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFINALIDAD(String value) {
        this.finalidad = value;
    }

    /**
     * Gets the value of the folio property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFOLIO() {
        return folio;
    }

    /**
     * Sets the value of the folio property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFOLIO(String value) {
        this.folio = value;
    }

    /**
     * Gets the value of the imporiesgviv property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIMPORIESGVIV() {
        return imporiesgviv;
    }

    /**
     * Sets the value of the imporiesgviv property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIMPORIESGVIV(String value) {
        this.imporiesgviv = value;
    }

    /**
     * Gets the value of the inco property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getINCO() {
        return inco;
    }

    /**
     * Sets the value of the inco property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setINCO(String value) {
        this.inco = value;
    }

    /**
     * Gets the value of the inscrip property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getINSCRIP() {
        return inscrip;
    }

    /**
     * Sets the value of the inscrip property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setINSCRIP(String value) {
        this.inscrip = value;
    }

    /**
     * Gets the value of the libro property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLIBRO() {
        return libro;
    }

    /**
     * Sets the value of the libro property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLIBRO(String value) {
        this.libro = value;
    }

    /**
     * Gets the value of the localidad property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLOCALIDAD() {
        return localidad;
    }

    /**
     * Sets the value of the localidad property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLOCALIDAD(String value) {
        this.localidad = value;
    }

    /**
     * Gets the value of the ncta property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNCTA() {
        return ncta;
    }

    /**
     * Sets the value of the ncta property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNCTA(String value) {
        this.ncta = value;
    }

    /**
     * Gets the value of the nfincareg property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNFINCAREG() {
        return nfincareg;
    }

    /**
     * Sets the value of the nfincareg property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNFINCAREG(String value) {
        this.nfincareg = value;
    }

    /**
     * Gets the value of the nombperscont property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNOMBPERSCONT() {
        return nombperscont;
    }

    /**
     * Sets the value of the nombperscont property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNOMBPERSCONT(String value) {
        this.nombperscont = value;
    }

    /**
     * Gets the value of the npersona property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNPERSONA() {
        return npersona;
    }

    /**
     * Sets the value of the npersona property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNPERSONA(String value) {
        this.npersona = value;
    }

    /**
     * Gets the value of the nrprop property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNRPROP() {
        return nrprop;
    }

    /**
     * Sets the value of the nrprop property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNRPROP(String value) {
        this.nrprop = value;
    }

    /**
     * Gets the value of the nsecuencia property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNSECUENCIA() {
        return nsecuencia;
    }

    /**
     * Sets the value of the nsecuencia property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNSECUENCIA(String value) {
        this.nsecuencia = value;
    }

    /**
     * Gets the value of the observ property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOBSERV() {
        return observ;
    }

    /**
     * Sets the value of the observ property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOBSERV(String value) {
        this.observ = value;
    }

    /**
     * Gets the value of the ocupacionbien property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOCUPACIONBIEN() {
        return ocupacionbien;
    }

    /**
     * Sets the value of the ocupacionbien property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOCUPACIONBIEN(String value) {
        this.ocupacionbien = value;
    }

    /**
     * Gets the value of the opcion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOPCION() {
        return opcion;
    }

    /**
     * Sets the value of the opcion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOPCION(String value) {
        this.opcion = value;
    }

    /**
     * Gets the value of the provincia property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPROVINCIA() {
        return provincia;
    }

    /**
     * Sets the value of the provincia property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPROVINCIA(String value) {
        this.provincia = value;
    }

    /**
     * Gets the value of the situacionbien property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSITUACIONBIEN() {
        return situacionbien;
    }

    /**
     * Sets the value of the situacionbien property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSITUACIONBIEN(String value) {
        this.situacionbien = value;
    }

    /**
     * Gets the value of the solicitante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSOLICITANTE() {
        return solicitante;
    }

    /**
     * Sets the value of the solicitante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSOLICITANTE(String value) {
        this.solicitante = value;
    }

    /**
     * Gets the value of the tbien property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTBIEN() {
        return tbien;
    }

    /**
     * Sets the value of the tbien property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTBIEN(String value) {
        this.tbien = value;
    }

    /**
     * Gets the value of the telfncontas property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTELFNCONTAS() {
        return telfncontas;
    }

    /**
     * Sets the value of the telfncontas property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTELFNCONTAS(String value) {
        this.telfncontas = value;
    }

    /**
     * Gets the value of the tencrela property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTENCRELA() {
        return tencrela;
    }

    /**
     * Sets the value of the tencrela property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTENCRELA(String value) {
        this.tencrela = value;
    }

    /**
     * Gets the value of the tinmu property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTINMU() {
        return tinmu;
    }

    /**
     * Sets the value of the tinmu property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTINMU(String value) {
        this.tinmu = value;
    }

    /**
     * Gets the value of the tipoper property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTIPOPER() {
        return tipoper;
    }

    /**
     * Sets the value of the tipoper property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTIPOPER(String value) {
        this.tipoper = value;
    }

    /**
     * Gets the value of the tlf1 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTLF1() {
        return tlf1;
    }

    /**
     * Sets the value of the tlf1 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTLF1(String value) {
        this.tlf1 = value;
    }

    /**
     * Gets the value of the tlf2 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTLF2() {
        return tlf2;
    }

    /**
     * Sets the value of the tlf2 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTLF2(String value) {
        this.tlf2 = value;
    }

    /**
     * Gets the value of the tomo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTOMO() {
        return tomo;
    }

    /**
     * Sets the value of the tomo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTOMO(String value) {
        this.tomo = value;
    }

}
