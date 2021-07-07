package es.pfsgroup.plugin.rem.accionesCaixa;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.AccionesCaixaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.controller.AgendaController;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service("accionesCaixaManager")
public class AccionesCaixaManager extends BusinessOperationOverrider<AccionesCaixaApi> implements AccionesCaixaApi {

    protected static final Log logger = LogFactory.getLog(AccionesCaixaManager.class);

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    @Autowired
    public AgendaController agendaController;

    @Autowired
    public AgendaAdapter adapter;

    @Autowired
    public CaixaBcRestClient caixaBcRestClient;

    @Autowired
    public ActivoTramiteDao tramiteDao;

    @Autowired
    public GenericABMDao genericDao;

    @Autowired
    public ActivoTramiteApi activoTramiteApi;

    @Override
    public String managerName() {
        return "accionesCaixaManager";
    }

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

    @Transactional
    @Override
    public void accionAprobacion(DtoAccionAprobacionCaixa dto) throws Exception {
        adapter.save(createRequestAccionAprobacion(dto));
        caixaBcRestClient.callReplicateOferta(dto.getNumOferta());
    }

    public Map<String, String[]> createRequestAccionAprobacion(DtoAccionAprobacionCaixa dto){
        Map<String,String[]> map = new HashMap<String,String[]>();

        String[] fechaRespuesta = {sdf.format(new Date())};
        String[] idTarea = {dto.getIdTarea().toString()};
        String[] observacionesBc = {dto.getObservacionesBC()};
        String[] comboResolucion = {dto.getComboResolucion()};

        map.put("fechaRespuesta", fechaRespuesta);
        map.put("idTarea", idTarea);
        map.put("observacionesBc", observacionesBc);
        map.put("comboResolucion", comboResolucion);

        return map;
    }

    @Transactional
    @Override
    public void accionRechazo(DtoAccionRechazoCaixa dto) throws Exception {
        agendaController.saltoResolucionExpedienteByIdExp(dto.getIdExpediente(), new ModelMap());
    }

    @Override
    public void accionRechazoAvanzaRE(DtoAccionRechazoCaixa dto) throws Exception {
        adapter.save(createRequestAccionRechazo(dto));
        caixaBcRestClient.callReplicateOferta(dto.getNumOferta());
    }

    public Map<String, String[]> createRequestAccionRechazo(DtoAccionRechazoCaixa dto){
        Map<String,String[]> map = new HashMap<String,String[]>();

        String[] idTarea = {dto.getIdTarea().toString()};
        String[] tipoArras = {dto.getTipoArras()};
        String[] motivoAnulacion = {dto.getMotivoAnulacion()};
        String[] estadoReserva = {dto.getEstadoReserva()};

        map.put("idTarea", idTarea);
        map.put("tipoArras", tipoArras);
        map.put("motivoAnulacion", motivoAnulacion);
        map.put("estadoReserva", estadoReserva);

        return map;
    }
}
