package es.pfsgroup.plugin.rem.model;

import org.apache.poi.hssf.record.formula.functions.T;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DtoInterlocutorBC {

    private static final SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    private String receiverInternalID;
    private String internalID;
    private String zznombreBp;
    private String zzapellidosBp;
    private String roleCode;
    private String zztipoSocio;
    private String naturalPersonIndicator;
    private String zzbirthDate;
    private String pais_nacimiento;
    private String municipio_nac;
    private String nacionalidad;
    private String sexo;
    private String estado_civilcontent;
    private String cnae;
    private String cno;
    private String via;
    private String street;
    private String cod_post;
    private String city;
    private String regioID;
    private String country;
    private String telefono;
    private String tlf_movil;
    private String email;
    private String taxNumberCategoryCode;
    private String partyTaxID;
    private String companyLegalFormCode;
    private Boolean prp_kyc;

    public class CompareResult{
        private Boolean modificaPBC;
        private Boolean modifica;

        public Boolean getModificaPBC() {
            return modificaPBC;
        }

        public void setModificaPBC(Boolean modificaPBC) {
            this.modificaPBC = modificaPBC;
        }

        public Boolean getModifica() {
            return modifica;
        }

        public void setModifica(Boolean modifica) {
            this.modifica = modifica;
        }
    }

    public String getReceiverInternalID() {
        return receiverInternalID;
    }

    public void setReceiverInternalID(String receiverInternalID) {
        this.receiverInternalID = receiverInternalID;
    }

    public String getInternalID() {
        return internalID;
    }

    public void setInternalID(String internalID) {
        this.internalID = internalID;
    }

    public String getZznombreBp() {
        return zznombreBp;
    }

    public void setZznombreBp(String zznombreBp) {
        this.zznombreBp = zznombreBp;
    }

    public String getZzapellidosBp() {
        return zzapellidosBp;
    }

    public void setZzapellidosBp(String zzapellidosBp) {
        this.zzapellidosBp = zzapellidosBp;
    }

    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }

    public String getZztipoSocio() {
        return zztipoSocio;
    }

    public void setZztipoSocio(String zztipoSocio) {
        this.zztipoSocio = zztipoSocio;
    }

    public String getNaturalPersonIndicator() {
        return naturalPersonIndicator;
    }

    public void setNaturalPersonIndicator(String naturalPersonIndicator) {
        this.naturalPersonIndicator = naturalPersonIndicator;
    }

    public String getZzbirthDate() {
        return zzbirthDate;
    }

    public void setZzbirthDate(String zzbirthDate) {
        this.zzbirthDate = zzbirthDate;
    }

    public String getPais_nacimiento() {
        return pais_nacimiento;
    }

    public void setPais_nacimiento(String pais_nacimiento) {
        this.pais_nacimiento = pais_nacimiento;
    }

    public String getMunicipio_nac() {
        return municipio_nac;
    }

    public void setMunicipio_nac(String municipio_nac) {
        this.municipio_nac = municipio_nac;
    }

    public String getNacionalidad() {
        return nacionalidad;
    }

    public void setNacionalidad(String nacionalidad) {
        this.nacionalidad = nacionalidad;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public String getEstado_civilcontent() {
        return estado_civilcontent;
    }

    public void setEstado_civilcontent(String estado_civilcontent) {
        this.estado_civilcontent = estado_civilcontent;
    }

    public String getCnae() {
        return cnae;
    }

    public void setCnae(String cnae) {
        this.cnae = cnae;
    }

    public String getCno() {
        return cno;
    }

    public void setCno(String cno) {
        this.cno = cno;
    }

    public String getVia() {
        return via;
    }

    public void setVia(String via) {
        this.via = via;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getCod_post() {
        return cod_post;
    }

    public void setCod_post(String cod_post) {
        this.cod_post = cod_post;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getRegioID() {
        return regioID;
    }

    public void setRegioID(String regioID) {
        this.regioID = regioID;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getTlf_movil() {
        return tlf_movil;
    }

    public void setTlf_movil(String tlf_movil) {
        this.tlf_movil = tlf_movil;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTaxNumberCategoryCode() {
        return taxNumberCategoryCode;
    }

    public void setTaxNumberCategoryCode(String taxNumberCategoryCode) {
        this.taxNumberCategoryCode = taxNumberCategoryCode;
    }

    public String getPartyTaxID() {
        return partyTaxID;
    }

    public void setPartyTaxID(String partyTaxID) {
        this.partyTaxID = partyTaxID;
    }

    public String getCompanyLegalFormCode() {
        return companyLegalFormCode;
    }

    public void setCompanyLegalFormCode(String companyLegalFormCode) {
        this.companyLegalFormCode = companyLegalFormCode;
    }

    public Boolean getPrp_kyc() {
        return prp_kyc;
    }

    public void setPrp_kyc(Boolean prp_kyc) {
        this.prp_kyc = prp_kyc;
    }

    public void compradorToDto(Comprador comprador){

        if (comprador == null)
            return;

        InfoAdicionalPersona infoAdicionalPersona = comprador.getInfoAdicionalPersona();

        this.receiverInternalID= comprador.getIdPersonaHaya() != null ? comprador.getIdPersonaHaya().toString() : null;
        this.zznombreBp =comprador.getNombre();
        this.zzapellidosBp =comprador.getApellidos();
        this.naturalPersonIndicator=comprador.getTipoPersona() != null ? comprador.getTipoPersona().getCodigo() : null;
        this.zzbirthDate =dateToString(comprador.getFechaNacimientoConstitucion());
        this.pais_nacimiento=comprador.getPaisNacimientoComprador() != null ? comprador.getPaisNacimientoComprador().getCodigo() : null;
        this.municipio_nac=comprador.getLocalidadNacimientoComprador() != null ? comprador.getLocalidadNacimientoComprador().getCodigo() : null;
        this.nacionalidad=comprador.getPaisNacimientoComprador() != null ? comprador.getPaisNacimientoComprador().getCodigo() : null;
        this.sexo=null;
        this.via=comprador.getDireccion();
        this.street=comprador.getDireccion();
        this.cod_post=comprador.getCodigoPostal();
        this.city=comprador.getLocalidad() != null ? comprador.getLocalidad().getCodigo() : null;
        this.regioID=comprador.getProvincia() != null ? comprador.getProvincia().getCodigo() : null;
        this.telefono=comprador.getTelefono1();
        this.tlf_movil=comprador.getTelefono2();
        this.email=comprador.getEmail();
        this.taxNumberCategoryCode=comprador.getTipoDocumento() != null ? comprador.getTipoDocumento().getCodigo() : null;
        this.partyTaxID=comprador.getDocumento();
        if (infoAdicionalPersona != null){
            this.internalID=infoAdicionalPersona.getIdC4C();
            this.companyLegalFormCode=infoAdicionalPersona.getFormaJuridica() != null ? infoAdicionalPersona.getFormaJuridica().getCodigo() : null;
            this.prp_kyc=infoAdicionalPersona.getPrp();
            this.cnae=infoAdicionalPersona.getCnae() != null ? infoAdicionalPersona.getCnae().getCodigo() : null;
            this.cno=infoAdicionalPersona.getCnOcupacional() != null ? infoAdicionalPersona.getCnOcupacional().getCodigo() : null;
            this.roleCode=infoAdicionalPersona.getRolInterlocutor() != null ? infoAdicionalPersona.getRolInterlocutor().getCodigo() : null;
            this.zztipoSocio =infoAdicionalPersona.getTipoSocioComercial() != null ? infoAdicionalPersona.getTipoSocioComercial().getCodigo() : null;
        }
    }

    public void representanteToDto(CompradorExpediente cex){
        if (cex == null)
            return;

        InfoAdicionalPersona infoAdicionalPersona = cex.getInfoAdicionalRepresentante();

        this.receiverInternalID= cex.getIdPersonaHayaRepresentante() != null ? cex.getIdPersonaHayaRepresentante().toString() : null;
        this.zznombreBp = cex.getNombreRepresentante();
        this.zzapellidosBp =cex.getApellidosRepresentante();
        this.naturalPersonIndicator=null;
        this.zzbirthDate =dateToString(cex.getFechaNacimientoRepresentante());
        this.pais_nacimiento=cex.getPaisNacimientoRepresentante() != null ? cex.getPaisNacimientoRepresentante().getCodigo() : null;
        this.municipio_nac=cex.getLocalidadNacimientoRepresentante() != null ? cex.getLocalidadNacimientoRepresentante().getCodigo() : null;
        this.nacionalidad=cex.getPaisNacimientoRepresentante() != null ? cex.getPaisNacimientoRepresentante().getCodigo() : null;
        this.sexo=null;
        this.via=cex.getDireccionRepresentante();
        this.street=cex.getDireccionRepresentante();
        this.cod_post=cex.getCodigoPostalRepresentante();
        this.city=null;
        this.regioID=cex.getLocalidadRepresentante() != null ? cex.getLocalidadRepresentante().getCodigo() : null;
        this.telefono=cex.getTelefono1Representante();
        this.tlf_movil=cex.getTelefono2Representante();
        this.email=cex.getEmailRepresentante();
        this.taxNumberCategoryCode=null;
        this.partyTaxID=cex.getDocumentoRepresentante();
        if (infoAdicionalPersona != null){
            this.internalID=infoAdicionalPersona.getIdC4C();
            this.companyLegalFormCode=infoAdicionalPersona.getFormaJuridica() != null ? infoAdicionalPersona.getFormaJuridica().getCodigo() : null;
            this.prp_kyc=infoAdicionalPersona.getPrp();
            this.cnae=infoAdicionalPersona.getCnae() != null ? infoAdicionalPersona.getCnae().getCodigo() : null;
            this.cno=infoAdicionalPersona.getCnOcupacional() != null ? infoAdicionalPersona.getCnOcupacional().getCodigo() : null;
            this.roleCode=infoAdicionalPersona.getRolInterlocutor() != null ? infoAdicionalPersona.getRolInterlocutor().getCodigo() : null;
            this.zztipoSocio =infoAdicionalPersona.getTipoSocioComercial() != null ? infoAdicionalPersona.getTipoSocioComercial().getCodigo() : null;
        }
    }

    public void proveedorToDto(ActivoProveedor proveedor){

        if (proveedor == null)
            return;

        InfoAdicionalPersona infoAdicionalPersona = proveedor.getInfoAdicionalPersona();

        this.receiverInternalID= proveedor.getIdPersonaHaya();
        this.zznombreBp =proveedor.getNombre();
        this.zzapellidosBp =null;
        this.naturalPersonIndicator=proveedor.getTipoPersona() != null ? proveedor.getTipoPersona().getCodigo() : null;
        this.zzbirthDate =dateToString(proveedor.getFechaConstitucion());
        this.pais_nacimiento=null;
        this.municipio_nac=null;
        this.nacionalidad=null;
        this.sexo=null;
        this.via=proveedor.getDireccion();
        this.street=proveedor.getDireccion();
        this.cod_post=proveedor.getCodigoPostal() != null ? proveedor.getCodigoPostal().toString() : null;
        this.city=proveedor.getLocalidad() != null ? proveedor.getLocalidad().getCodigo() : null;
        this.regioID=proveedor.getProvincia() != null ? proveedor.getProvincia().getCodigo() : null;
        this.telefono=proveedor.getTelefono1();
        this.tlf_movil=proveedor.getTelefono2();
        this.email=proveedor.getEmail();
        this.taxNumberCategoryCode=proveedor.getTipoDocIdentificativo() != null ? proveedor.getTipoDocIdentificativo().getCodigo() : null;
        this.partyTaxID=proveedor.getDocIdentificativo();
        if (infoAdicionalPersona != null){
            this.internalID=infoAdicionalPersona.getIdC4C();
            this.companyLegalFormCode=infoAdicionalPersona.getFormaJuridica() != null ? infoAdicionalPersona.getFormaJuridica().getCodigo() : null;
            this.prp_kyc=infoAdicionalPersona.getPrp();
            this.cnae=infoAdicionalPersona.getCnae() != null ? infoAdicionalPersona.getCnae().getCodigo() : null;
            this.cno=infoAdicionalPersona.getCnOcupacional() != null ? infoAdicionalPersona.getCnOcupacional().getCodigo() : null;
            this.roleCode=infoAdicionalPersona.getRolInterlocutor() != null ? infoAdicionalPersona.getRolInterlocutor().getCodigo() : null;
            this.zztipoSocio =infoAdicionalPersona.getTipoSocioComercial() != null ? infoAdicionalPersona.getTipoSocioComercial().getCodigo() : null;
        }
    }

    public void clienteToDto(ClienteComercial cliente){

        if (cliente == null)
            return;

        InfoAdicionalPersona infoAdicionalPersona = cliente.getInfoAdicionalPersona();

        this.receiverInternalID= cliente.getIdPersonaHaya();
        this.zznombreBp =cliente.getNombre();
        this.zzapellidosBp =cliente.getApellidos();
        this.naturalPersonIndicator=cliente.getTipoPersona() != null ? cliente.getTipoPersona().getCodigo() : null;
        this.zzbirthDate =dateToString(cliente.getFechaNacimiento());
        this.pais_nacimiento=cliente.getPaisNacimiento() != null ? cliente.getPaisNacimiento().getCodigo() : null;
        this.municipio_nac=cliente.getLocalidadNacimiento() != null ? cliente.getLocalidadNacimiento().getCodigo() : null;
        this.nacionalidad=cliente.getPaisNacimiento() != null ? cliente.getPaisNacimiento().getCodigo() : null;
        this.sexo=null;
        this.via=cliente.getDireccion();
        this.street=cliente.getDireccion();
        this.cod_post=cliente.getCodigoPostal() != null ? cliente.getCodigoPostal().toString() : null;
        this.city=cliente.getMunicipio() != null ? cliente.getMunicipio().getCodigo() : null;
        this.regioID=cliente.getProvincia() != null ? cliente.getProvincia().getCodigo() : null;
        this.telefono=cliente.getTelefono1();
        this.tlf_movil=cliente.getTelefono2();
        this.email=cliente.getEmail();
        this.taxNumberCategoryCode=cliente.getTipoDocumento() != null ? cliente.getTipoDocumento().getCodigo() : null;
        this.partyTaxID=cliente.getTipoDocumento() != null ? cliente.getTipoDocumento().getCodigo() : null;
        if (infoAdicionalPersona != null){
            this.internalID=infoAdicionalPersona.getIdC4C();
            this.companyLegalFormCode=infoAdicionalPersona.getFormaJuridica() != null ? infoAdicionalPersona.getFormaJuridica().getCodigo() : null;
            this.prp_kyc=infoAdicionalPersona.getPrp();
            this.cnae=infoAdicionalPersona.getCnae() != null ? infoAdicionalPersona.getCnae().getCodigo() : null;
            this.cno=infoAdicionalPersona.getCnOcupacional() != null ? infoAdicionalPersona.getCnOcupacional().getCodigo() : null;
            this.roleCode=infoAdicionalPersona.getRolInterlocutor() != null ? infoAdicionalPersona.getRolInterlocutor().getCodigo() : null;
            this.zztipoSocio =infoAdicionalPersona.getTipoSocioComercial() != null ? infoAdicionalPersona.getTipoSocioComercial().getCodigo() : null;
        }
    }



    public void cexToDto(CompradorExpediente compradorExpediente){
        this.country=compradorExpediente.getPais() != null ? compradorExpediente.getPais().getCodigo() : null;
        this.estado_civilcontent=compradorExpediente.getEstadoCivil() != null ? compradorExpediente.getEstadoCivil().getCodigo() : null;

    }

    public CompareResult compare (final DtoInterlocutorBC dtoInterlocutorBC){
     return new CompareResult(){{
         setModificaPBC(modificaPbc(dtoInterlocutorBC));
         setModifica(modifica(dtoInterlocutorBC));
     }};
    }


    private boolean modifica(DtoInterlocutorBC dto){
        return !(
                equals(this.internalID,dto.internalID) &&
                        equals(this.roleCode,dto.roleCode) &&
                        equals(this.zztipoSocio ,dto.zztipoSocio) &&
                        equals(this.municipio_nac,dto.municipio_nac) &&
                        equals(this.sexo,dto.sexo) &&
                        equals(this.estado_civilcontent,dto.estado_civilcontent) &&
                        equals(this.cnae,dto.cnae) &&
                        equals(this.cno,dto.cno) &&
                        equals(this.via,dto.via) &&
                        equals(this.street,dto.street) &&
                        equals(this.cod_post,dto.cod_post) &&
                        equals(this.city,dto.city) &&
                        equals(this.regioID,dto.regioID) &&
                        equals(this.telefono,dto.telefono) &&
                        equals(this.tlf_movil,dto.tlf_movil) &&
                        equals(this.email,dto.email) &&
                        equals(this.companyLegalFormCode,dto.companyLegalFormCode)
        );
    }

    private boolean modificaPbc(DtoInterlocutorBC dto){
        return !(

                equals(this.receiverInternalID,dto.receiverInternalID) &&
                        equals(this.zznombreBp ,dto.zznombreBp) &&
                        equals(this.zzapellidosBp ,dto.zzapellidosBp) &&
                        equals(this.naturalPersonIndicator,dto.naturalPersonIndicator) &&
                        equals(this.zzbirthDate ,dto.zzbirthDate) &&
                        equals(this.pais_nacimiento,dto.pais_nacimiento) &&
                        equals(this.nacionalidad,dto.nacionalidad) &&
                        equals(this.country,dto.country) &&
                        equals(this.taxNumberCategoryCode,dto.taxNumberCategoryCode) &&
                        equals(this.partyTaxID,dto.partyTaxID) &&
                        equals(this.prp_kyc,dto.prp_kyc)
                );
    }

    private boolean equals(Object comparable1,Object comparable2){
        if (comparable1 != null && comparable1 instanceof String && !(((String) comparable1).length() > 0))
            comparable1 = null;
        if (comparable2 != null && comparable2 instanceof String && !(((String) comparable2).length() > 0))
            comparable2 = null;
        return  comparable1 == null && comparable2 == null ? true : (comparable1 != null && comparable1.equals(comparable2));
    }

    private String dateToString(Date date){
        return date != null ? format.format(date) : null;
    }


}
