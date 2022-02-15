package es.pfsgroup.plugin.rem.service;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.*;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Component
public class InterlocutorCaixaService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private CaixaBcRestClient caixaBcRestClient;

    @Autowired
    private ParticularValidatorApi particularValidatorApi;

    @Autowired
    private HibernateUtils hibernateUtils;

    @Autowired
    private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

    @Autowired
    private OfertaApi ofertaApi;

    public boolean hasChangestoBC(DtoInterlocutorBC oldValues, DtoInterlocutorBC newValues, String idPersonaHaya){

        if (idPersonaHaya == null)
            return false;

        InfoAdicionalPersona infoAdicionalPersona = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "idPersonaHayaCaixa", idPersonaHaya));

        if (infoAdicionalPersona != null){

            String codigoEcc = infoAdicionalPersona.getEstadoComunicacionC4C() != null ? infoAdicionalPersona.getEstadoComunicacionC4C().getCodigo() : "";

                DtoInterlocutorBC.CompareResult result = oldValues.compare(newValues);

                boolean pbcChanged = result.getModificaPBC();
                boolean changed = result.getModifica();

                if (pbcChanged)
                    infoAdicionalPersona.setModificaPBC(result.getModificaPBC());

                if (pbcChanged || changed){
                    infoAdicionalPersona.setEstadoComunicacionC4C(genericDao.get(DDEstadoComunicacionC4C.class,genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "codigo", DDEstadoComunicacionC4C.C4C_NO_ENVIADO)));

                    genericDao.update(InfoAdicionalPersona.class,infoAdicionalPersona);
                    return true;

                }
        }
        return false;
    }


    public boolean isProveedorInvolucradoBC(ActivoProveedor proveedor){
        return particularValidatorApi.esProveedorOfertaCaixa(proveedor.getId().toString());
    }

    public boolean esClienteInvolucradoBC(ClienteComercial clienteComercial) {
    return particularValidatorApi.esClienteEnOfertaCaixa(clienteComercial.getId().toString());
    }

    public void callReplicateClientAsync(final Comprador comprador, final Oferta oferta){
            hibernateUtils.flushSession();
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    caixaBcRestClient.callReplicateClientUpdateComprador(comprador.getId(),oferta.getNumOferta());
                }
            });
            thread.start();
    }


    public void callReplicateClientAndOfertaOnComprador(final DtoCompradorLLamadaBC dtoCompradorLLamadaBC){
        hibernateUtils.flushSession();
        Thread thread = new Thread(new Runnable() {
            public void run() {
                if (dtoCompradorLLamadaBC.getReplicarCLiente() != null && dtoCompradorLLamadaBC.getReplicarCLiente())
                caixaBcRestClient.callReplicateClientUpdateComprador(dtoCompradorLLamadaBC.getIdComprador(),dtoCompradorLLamadaBC.getNumOferta());
                if (dtoCompradorLLamadaBC.getReplicarOferta() != null && dtoCompradorLLamadaBC.getReplicarOferta())
                    ofertaApi.replicarOferta(dtoCompradorLLamadaBC.getNumOferta());
            }
        });
        thread.start();

    }

    public void callReplicateClientAsync(final DtoInterlocutorBC oldData, final DtoInterlocutorBC newData, final ActivoProveedor proveedor){

        if (hasChangestoBC(oldData,newData,proveedor.getIdPersonaHaya())){
           hibernateUtils.flushSession();
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    caixaBcRestClient.callReplicateClientUpdate(proveedor.getId(),CaixaBcRestClient.ID_PROVEEDOR);
                }
            });
            thread.start();
        }

    }

    public void callReplicateClientAsync(final DtoInterlocutorBC oldData, final DtoInterlocutorBC newData, final ClienteComercial clienteComercial){
        if (hasChangestoBC(oldData,newData,clienteComercial.getIdPersonaHayaCaixa())){
            hibernateUtils.flushSession();
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    caixaBcRestClient.callReplicateClientUpdate(clienteComercial.getId(),CaixaBcRestClient.ID_CLIENTE);
                }
            });
            thread.start();
        }

    }

    public void callReplicateClientAsync(final Long id, final String tipoId){
            hibernateUtils.flushSession();
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    caixaBcRestClient.callReplicateClientUpdate(id,tipoId);
                }
            });
            thread.start();
    }

    public void callReplicateClientSync(final Long id, final String tipoId, final String dataSourceCode){
        hibernateUtils.flushSession();

        caixaBcRestClient.callReplicateClient(id, tipoId, dataSourceCode);
    }

    public String getIdPersonaHayaCaixaByCarteraAndDocumento(DDCartera cartera, DDSubcartera subcartera, String documento){

        if (cartera != null && documento != null && DDCartera.CODIGO_CAIXA.equals(cartera.getCodigo())){
            MaestroDePersonas maestroDePersonas = new MaestroDePersonas(gestorDocumentalAdapterApi.getMaestroPersonasByCarteraySubcarterayPropietario(cartera,subcartera,null));
            return maestroDePersonas.getIdPersonaHayaByDocumento(documento);
        }
        return null;
    }

    @Transactional
    public String getIdPersonaHayaCaixa(Oferta oferta, Activo activo,String documento, DDCartera cartera){

        if(cartera == null){
            if (activo == null){
                activo = oferta != null ? oferta.getActivoPrincipal() : null;
            }
            cartera = activo != null ? activo.getCartera() : null;
        }

        if (DDCartera.CODIGO_CAIXA.equals(cartera != null ? cartera.getCodigo() : null)){
            DDSubcartera subCartera = activo != null ? activo.getSubcartera() : null;

            return getIdPersonaHayaCaixaByCarteraAndDocumento(cartera,subCartera,documento);
        }
        return null;
    }


    public InfoAdicionalPersona getIapCaixaOrDefault(InfoAdicionalPersona iap, String idPersonaHayaCaixa,String idPersonaHaya) {

        if (idPersonaHayaCaixa == null && idPersonaHaya == null){
            return null;
        }

        InfoAdicionalPersona iapBusqueda = null;

            InfoAdicionalPersona iapGenerica = idPersonaHaya != null ? genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "idPersonaHaya", idPersonaHaya)) : null;
            InfoAdicionalPersona iapCaixa = idPersonaHayaCaixa != null ? genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "idPersonaHayaCaixa", idPersonaHayaCaixa)) : null;

            if (iapGenerica != null && iapCaixa != null && !iapGenerica.getId().equals(iapCaixa.getId())){
                iapBusqueda = mergueIaps(iapGenerica,iapCaixa);
            }else if (iapGenerica == null){
                iapBusqueda = iapCaixa;
            }else {
                iapBusqueda = iapGenerica;
            }

            if (iapBusqueda == null) {
                InfoAdicionalPersona infoAdicionalPersona = new InfoAdicionalPersona();
                infoAdicionalPersona.setAuditoria(Auditoria.getNewInstance());
                infoAdicionalPersona.setIdPersonaHayaCaixa(idPersonaHayaCaixa);
                infoAdicionalPersona.setIdPersonaHaya(idPersonaHaya);
                infoAdicionalPersona.setEstadoComunicacionC4C(genericDao.get(DDEstadoComunicacionC4C.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "codigo", DDEstadoComunicacionC4C.C4C_NO_ENVIADO)));
                return genericDao.save(InfoAdicionalPersona.class, infoAdicionalPersona);

            } else {
                if (iapBusqueda.getIdPersonaHayaCaixa() == null && idPersonaHayaCaixa != null)
                    iapBusqueda.setIdPersonaHayaCaixa(idPersonaHayaCaixa);
                if (iapBusqueda.getEstadoComunicacionC4C() == null )
                    iapBusqueda.setEstadoComunicacionC4C(genericDao.get(DDEstadoComunicacionC4C.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "codigo", DDEstadoComunicacionC4C.C4C_NO_ENVIADO)));
                if (iapBusqueda.getIdPersonaHaya() == null && idPersonaHaya != null)
                    iapBusqueda.setIdPersonaHaya(idPersonaHaya);

                return genericDao.save(InfoAdicionalPersona.class, iapBusqueda);
            }
    }

    private InfoAdicionalPersona mergueIaps(InfoAdicionalPersona iap1,InfoAdicionalPersona iap2){

        Date ultimaModificacion1 = iap1.getAuditoria().getFechaModificar() == null ? iap1.getAuditoria().getFechaCrear() : iap1.getAuditoria().getFechaModificar();
        Date ultimaModificacion2 = iap2.getAuditoria().getFechaModificar() == null ? iap2.getAuditoria().getFechaCrear() : iap2.getAuditoria().getFechaModificar();

        InfoAdicionalPersona older = null;
        InfoAdicionalPersona newer = null;

        if (ultimaModificacion1.after(ultimaModificacion2)){
             older = iap2;
             newer = iap1;
        }else{
             older = iap1;
             newer = iap2;
        }

        if (newer.getEstadoComunicacionC4C() != null)
        older.setEstadoComunicacionC4C(newer.getEstadoComunicacionC4C());
        if (newer.getAntiguoDeudor() != null)
        older.setAntiguoDeudor(newer.getAntiguoDeudor());
        if (newer.getRolInterlocutor() != null)
        older.setRolInterlocutor(newer.getRolInterlocutor());
        if (newer.getCnae() != null)
        older.setCnae(newer.getCnae());
        if (newer.getCnOcupacional() != null)
        older.setCnOcupacional(newer.getCnOcupacional());
        if (newer.getEsUsufructuario() != null)
        older.setEsUsufructuario(newer.getEsUsufructuario());
        if (newer.getFormaJuridica() != null)
        older.setFormaJuridica(newer.getFormaJuridica());
        if (newer.getIdC4C() != null)
        older.setIdC4C(newer.getIdC4C());
        if (newer.getPrp() != null)
        older.setPrp(newer.getPrp());
        if (newer.getModificaPBC() != null)
        older.setModificaPBC(newer.getModificaPBC());
        if (newer.getOficinaTrabajo() != null)
        older.setOficinaTrabajo(newer.getOficinaTrabajo());
        if (newer.getSociedad() != null)
        older.setSociedad(newer.getSociedad());
        if (newer.getTipoSocioComercial() != null)
        older.setTipoSocioComercial(newer.getTipoSocioComercial());
        if (newer.getVinculoCaixa() != null)
        older.setVinculoCaixa(newer.getVinculoCaixa());

        newer.getAuditoria().setBorrado(Boolean.TRUE);

        genericDao.save(InfoAdicionalPersona.class, newer);
        return genericDao.save(InfoAdicionalPersona.class, older);
    }

}
