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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
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

    public void callReplicateClientSyncVisitas(final Long id, final String tipoId, final String dataSourceCode, final Boolean vieneVisita){
        hibernateUtils.flushSession();

        caixaBcRestClient.callReplicateClientVisita(id, tipoId, dataSourceCode, vieneVisita);
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


    public InfoAdicionalPersona getIapCaixaOrDefaultAndCleanReferences(String idPersonaHayaCaixa, String idPersonaHaya) {

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
                if (idPersonaHayaCaixa != null)
                    iapBusqueda.setIdPersonaHayaCaixa(idPersonaHayaCaixa);
                if (iapBusqueda.getEstadoComunicacionC4C() == null )
                    iapBusqueda.setEstadoComunicacionC4C(genericDao.get(DDEstadoComunicacionC4C.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "codigo", DDEstadoComunicacionC4C.C4C_NO_ENVIADO)));
                if (idPersonaHaya != null)
                    iapBusqueda.setIdPersonaHaya(idPersonaHaya);

                return genericDao.save(InfoAdicionalPersona.class, iapBusqueda);
            }
    }

    private InfoAdicionalPersona mergueIaps(InfoAdicionalPersona iap1,InfoAdicionalPersona iap2){

        InfoAdicionalPersona tokeep = null;
        InfoAdicionalPersona toDelete = null;

        if (iap1.getUltimaModificacion().after(iap2.getUltimaModificacion())){
             tokeep = iap1;
             toDelete = iap2;
        }else{
             tokeep = iap2;
             toDelete = iap1;
        }

        copyIapDataifNull(tokeep,toDelete);

        removeIap(toDelete,InfoAdicionalPersona.USUARIO_BORRAR_MERGE,tokeep);

        return genericDao.save(InfoAdicionalPersona.class, tokeep);
    }

    private InfoAdicionalPersona getIapAndDeleteDuplicates(String idPersona,String fieldname){

        List<InfoAdicionalPersona> iaps = genericDao.getList(InfoAdicionalPersona.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, fieldname, idPersona));

        if (iaps != null && iaps.size()>1){

            Collections.sort(iaps,Collections.<InfoAdicionalPersona>reverseOrder());

            for (int i = 1; i < iaps.size(); i++) {
                InfoAdicionalPersona toDelete = iaps.get(i);
                copyIapDataifNull(iaps.get(0),iaps.get(i));
                removeIap(toDelete,InfoAdicionalPersona.USUARIO_BORRAR_DUPLICATE,iaps.get(0));
            }

            return genericDao.save(InfoAdicionalPersona.class,iaps.get(0));

        }else{
            return iaps.size() > 0 ? iaps.get(0) : null;
        }
    }

    private void copyIapDataifNull(InfoAdicionalPersona toDelete, InfoAdicionalPersona toKeep){

        if (toKeep.getEstadoComunicacionC4C() == null)
            toKeep.setEstadoComunicacionC4C(toDelete.getEstadoComunicacionC4C());
        if (toKeep.getAntiguoDeudor() == null)
            toKeep.setAntiguoDeudor(toDelete.getAntiguoDeudor());
        if (toKeep.getRolInterlocutor() == null)
            toKeep.setRolInterlocutor(toDelete.getRolInterlocutor());
        if (toKeep.getCnae() == null)
            toKeep.setCnae(toDelete.getCnae());
        if (toKeep.getCnOcupacional() == null)
            toKeep.setCnOcupacional(toDelete.getCnOcupacional());
        if (toKeep.getEsUsufructuario() == null)
            toKeep.setEsUsufructuario(toDelete.getEsUsufructuario());
        if (toKeep.getFormaJuridica() == null)
            toKeep.setFormaJuridica(toDelete.getFormaJuridica());
        if (toKeep.getIdC4C() == null)
            toKeep.setIdC4C(toDelete.getIdC4C());
        if (toKeep.getPrp() == null)
            toKeep.setPrp(toDelete.getPrp());
        if (toKeep.getModificaPBC() == null)
            toKeep.setModificaPBC(toDelete.getModificaPBC());
        if (toKeep.getOficinaTrabajo() == null)
            toKeep.setOficinaTrabajo(toDelete.getOficinaTrabajo());
        if (toKeep.getSociedad() == null)
            toKeep.setSociedad(toDelete.getSociedad());
        if (toKeep.getTipoSocioComercial() == null)
            toKeep.setTipoSocioComercial(toDelete.getTipoSocioComercial());
        if (toKeep.getVinculoCaixa() == null)
            toKeep.setVinculoCaixa(toDelete.getVinculoCaixa());
        if (toKeep.getNacionalidadCodigo() == null)
            toKeep.setNacionalidadCodigo(toDelete.getNacionalidadCodigo());

    }

    private void removeIap (InfoAdicionalPersona toDelete, String usuarioBorrar, InfoAdicionalPersona toReplace){

        updatedeletdIAPReference(toDelete,toReplace);

        toDelete.getAuditoria().setBorrado(Boolean.TRUE);
        toDelete.getAuditoria().setUsuarioBorrar(usuarioBorrar);
        toDelete.getAuditoria().setFechaBorrar(new Date());

        genericDao.save(InfoAdicionalPersona.class, toDelete);

    }
    
        public void updatedeletdIAPReference(InfoAdicionalPersona iaopToDelete, InfoAdicionalPersona iapToSet){

            if (iaopToDelete == null || iaopToDelete.getId() == null)
                return;

            Long idIapToDelete = iaopToDelete.getId();

            for (ClienteComercial clc:
                    genericDao.getList(ClienteComercial.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalPersona.id", idIapToDelete))) {
                clc.setInfoAdicionalPersona(iapToSet);

                genericDao.update(ClienteComercial.class,clc);
            }

            for (ClienteComercial clienteComercial:
                    genericDao.getList(ClienteComercial.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalPersonaRep.id", idIapToDelete))) {
                clienteComercial.setInfoAdicionalPersonaRep(iapToSet);
                genericDao.update(ClienteComercial.class,clienteComercial);
            }

            for (Comprador com:
                    genericDao.getList(Comprador.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalPersona.id", idIapToDelete))) {
                com.setInfoAdicionalPersona(iapToSet);
                genericDao.update(Comprador.class,com);
            }

            for (CompradorExpediente cex:
                    genericDao.getList(CompradorExpediente.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalRepresentante.id", idIapToDelete))) {
                cex.setInfoAdicionalRepresentante(iapToSet);
                genericDao.update(CompradorExpediente.class,cex);
            }

            for (InterlocutorPBCCaixa interlocutor:
                    genericDao.getList(InterlocutorPBCCaixa.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalPersona.id", idIapToDelete))) {
                interlocutor.setInfoAdicionalPersona(iapToSet);
                genericDao.update(InterlocutorPBCCaixa.class,interlocutor);
            }

            for (ActivoProveedor proveedor:
                    genericDao.getList(ActivoProveedor.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalPersona.id", idIapToDelete))) {
                proveedor.setInfoAdicionalPersona(iapToSet);
                genericDao.update(ActivoProveedor.class,proveedor);
            }

            for (TitularesAdicionalesOferta tit:
                    genericDao.getList(TitularesAdicionalesOferta.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalPersona.id", idIapToDelete))) {
                tit.setInfoAdicionalPersona(iapToSet);
                genericDao.update(TitularesAdicionalesOferta.class,tit);
            }

            for (TitularesAdicionalesOferta titRep:
                    genericDao.getList(TitularesAdicionalesOferta.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "infoAdicionalPersonaRep.id", idIapToDelete))) {
                titRep.setInfoAdicionalPersona(iapToSet);
                genericDao.update(TitularesAdicionalesOferta.class,titRep);
            }

    }

}
