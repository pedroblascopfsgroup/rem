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

    public String getIdPersonaHayaCaixaByCarteraAndDocumento(DDCartera cartera, DDSubcartera subcartera, String documento){

        if (cartera != null && documento != null && DDCartera.CODIGO_CAIXA.equals(cartera.getCodigo())){
            MaestroDePersonas maestroDePersonas = new MaestroDePersonas(gestorDocumentalAdapterApi.getMaestroPersonasByCarteraySubcarterayPropietario(cartera,subcartera,null));
            return maestroDePersonas.getIdPersonaHayaByDocumento(documento);
        }
        return null;
    }

    @Transactional
    public String getIdPersonaHayaCaixa(Oferta oferta, Activo activo,String documento){

        if (activo == null){
            activo = oferta != null ? oferta.getActivoPrincipal() : null;
        }

        DDCartera cartera = activo != null ? activo.getCartera() : genericDao.get(DDCartera.class,genericDao.createFilter(GenericABMDao.FilterType.EQUALS,"codigo",DDCartera.CODIGO_CAIXA));
        DDSubcartera subCartera = activo != null ? activo.getSubcartera() : null;

        return getIdPersonaHayaCaixaByCarteraAndDocumento(cartera,subCartera,documento);

    }


    public InfoAdicionalPersona getIapCaixaOrDefault(InfoAdicionalPersona iap, String idPersonaHayaCaixa,String idPersonaHaya) {

        if (idPersonaHayaCaixa != null) {

            InfoAdicionalPersona iapBusqueda = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "idPersonaHayaCaixa", idPersonaHayaCaixa));

            if (iapBusqueda == null) {
                InfoAdicionalPersona infoAdicionalPersona = new InfoAdicionalPersona();
                infoAdicionalPersona.setAuditoria(Auditoria.getNewInstance());
                infoAdicionalPersona.setIdPersonaHayaCaixa(idPersonaHayaCaixa);
                infoAdicionalPersona.setEstadoComunicacionC4C(genericDao.get(DDEstadoComunicacionC4C.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "codigo", DDEstadoComunicacionC4C.C4C_NO_ENVIADO)));
                return genericDao.save(InfoAdicionalPersona.class, infoAdicionalPersona);
            } else {
                return iapBusqueda;
            }
        }
            return iap == null ? genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "idPersonaHaya", idPersonaHaya != null ? idPersonaHaya : "")) : iap;
    }

}
