package es.pfsgroup.plugin.rem.service;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionC4C;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;
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




    public boolean hasChangestoBC(DtoInterlocutorBC oldValues, DtoInterlocutorBC newValues, String idPersonaHaya){

        if (idPersonaHaya == null)
            return false;

        InfoAdicionalPersona infoAdicionalPersona = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(GenericABMDao.FilterType.EQUALS, "idPersonaHaya", idPersonaHaya));

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

    public void callReplicateClientAsync(final DtoInterlocutorBC oldData, final DtoInterlocutorBC newData, final Comprador comprador, final Oferta oferta){
        if (hasChangestoBC(oldData,newData,comprador.getIdPersonaHaya() != null ? comprador.getIdPersonaHaya().toString() : null)){
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    caixaBcRestClient.callReplicateClientUpdateComprador(comprador.getId(),oferta.getNumOferta());
                }
            });
            thread.start();
        }
    }

    public void callReplicateClientAsync(final DtoInterlocutorBC oldData, final DtoInterlocutorBC newData, final ActivoProveedor proveedor){

        if (hasChangestoBC(oldData,newData,proveedor.getIdPersonaHaya())){
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    caixaBcRestClient.callReplicateClientUpdate(proveedor.getId(),CaixaBcRestClient.ID_PROVEEDOR);
                }
            });
            thread.start();
        }

    }

    public void callReplicateClientAsync(final DtoInterlocutorBC oldData, final DtoInterlocutorBC newData, final ClienteComercial clienteComercial){
        if (hasChangestoBC(oldData,newData,clienteComercial.getIdPersonaHaya())){
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    caixaBcRestClient.callReplicateClientUpdate(clienteComercial.getId(),CaixaBcRestClient.ID_CLIENTE);
                }
            });
            thread.start();
        }

    }


}
