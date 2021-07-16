package es.pfsgroup.plugin.rem.accionesCaixa;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.AccionesCaixaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.controller.AgendaController;
import es.pfsgroup.plugin.rem.expedienteComercial.ExpedienteComercialManager;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;
import es.pfsgroup.plugin.rem.model.dd.DDRiesgoOperacion;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service("accionesCaixaManager")
public class AccionesCaixaManager extends BusinessOperationOverrider<AccionesCaixaApi> implements AccionesCaixaApi {

    protected static final Log logger = LogFactory.getLog(AccionesCaixaManager.class);

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfEntrada = new SimpleDateFormat("yyyy-MM-dd");

    @Autowired
    public AgendaController agendaController;

    @Autowired
    public AgendaAdapter adapter;

    @Autowired
    public ActivoTramiteDao tramiteDao;

    @Autowired
    public GenericABMDao genericDao;

    @Autowired
    public ActivoTramiteApi activoTramiteApi;

    @Autowired
    public ExpedienteComercialManager expedienteComercialManager;

    @Override
    public String managerName() {
        return "accionesCaixaManager";
    }

    @Transactional
    @Override
    public void accionAprobacion(DtoAccionAprobacionCaixa dto) throws Exception {
        adapter.save(createRequestAccionAprobacion(dto));
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

    @Override
    @Transactional
    public void accionResultadoRiesgo(DtoAccionResultadoRiesgoCaixa dto){
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());
        OfertaCaixa ofrCaixa = genericDao.get(OfertaCaixa.class, genericDao.createFilter(FilterType.EQUALS, "oferta.numOferta", dto.getNumOferta()));
        DDRiesgoOperacion rop = genericDao.get(DDRiesgoOperacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getRiesgoOperacion()));

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_PTE_CALCULO_RIESGO));
        expediente.setEstadoBc(estadoExpedienteBc);
        ofrCaixa.setRiesgoOperacion(rop);

        genericDao.save(OfertaCaixa.class, ofrCaixa);
        genericDao.save(ExpedienteComercial.class, expediente);
    }

    @Override
    @Transactional
    public void accionArrasAprobadas(DtoOnlyExpedienteYOfertaCaixa dto){
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS));
        expediente.setEstadoBc(estadoExpedienteBc);
        genericDao.save(ExpedienteComercial.class, expediente);
    }

    @Override
    @Transactional
    public void accionIngresoFinalAprobado(DtoOnlyExpedienteYOfertaCaixa dto){
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO));
        expediente.setEstadoBc(estadoExpedienteBc);
        genericDao.save(ExpedienteComercial.class, expediente);
    }

    @Transactional
    @Override
    public void accionFirmaArrasAprobadas(DtoFirmaArrasAprobadasCaixa dto) throws Exception {
        adapter.save(createRequestAccionFirmaArrasAprobadas(dto));

        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_FIRMA_DE_ARRAS_AGENDADAS));
        expediente.setEstadoBc(estadoExpedienteBc);

        FechaArrasExpediente fae = genericDao.get(FechaArrasExpediente.class,
                genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdFae()));
        DDMotivosEstadoBC motivoEstado = genericDao.get(DDMotivosEstadoBC.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_APROBADA_BC));

        genericDao.save(FechaArrasExpediente.class, fae);
        genericDao.save(ExpedienteComercial.class, expediente);
    }

    public Map<String, String[]> createRequestAccionFirmaArrasAprobadas(DtoFirmaArrasAprobadasCaixa dto) throws ParseException {
        Map<String,String[]> map = new HashMap<String,String[]>();

        String[] idTarea = {dto.getIdTarea().toString()};
        String[] comboValidacionBC = {dto.getComboValidacionBC()};
        String[] observacionesBC = {dto.getObservacionesBC()};
        String[] fechaPropuesta = {sdf.format(sdf.parse(dto.getFechaPropuesta()))};

        map.put("idTarea", idTarea);
        map.put("comboValidacionBC", comboValidacionBC);
        map.put("observacionesBC", observacionesBC);
        map.put("fechaPropuesta", fechaPropuesta);

        return map;
    }

    @Transactional
    @Override
    public void accionFirmaContratoAprobada(DtoFirmaContratoAprobadaCaixa dto) throws Exception {
        adapter.save(createRequestAccionFirmaContratoAprobada(dto));

        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO));
        expediente.setEstadoBc(estadoExpedienteBc);
        genericDao.save(ExpedienteComercial.class, expediente);
    }

    public Map<String, String[]> createRequestAccionFirmaContratoAprobada(DtoFirmaContratoAprobadaCaixa dto) throws ParseException {
        Map<String,String[]> map = new HashMap<String,String[]>();

        String[] idTarea = {dto.getIdTarea().toString()};
        String[] comboValidacionBC = {dto.getComboValidacionBC()};
        String[] observacionesBC = {dto.getObservacionesBC()};
        String[] fechaPropuesta = {sdf.format(sdfEntrada.parse(dto.getFechaPropuesta()))};
        String[] fechaRespuesta = {sdf.format(sdfEntrada.parse(dto.getFechaRespuesta()))};

        map.put("idTarea", idTarea);
        map.put("comboValidacionBC", comboValidacionBC);
        map.put("observacionesBC", observacionesBC);
        map.put("fechaPropuesta", fechaPropuesta);
        map.put("fechaRespuesta", fechaRespuesta);

        return map;
    }

    @Override
    @Transactional
    public void accionVentaContabilizada(DtoOnlyExpedienteYOfertaCaixa dto){
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_VENTA_FORMALIZADA));
        expediente.setEstadoBc(estadoExpedienteBc);

        DDEstadosExpedienteComercial eec = genericDao.get(DDEstadosExpedienteComercial.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO));
        expediente.setEstado(eec);

        genericDao.save(ExpedienteComercial.class, expediente);
    }

    @Override
    @Transactional
    public void accionArrasRechazadas(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
    }

    @Override
    @Transactional
    public void accionArrasPteDoc(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_ARRAS_PTE_DOCUMENTACION));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
    }

    @Override
    @Transactional
    public void accionIngresoFinalRechazado(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
    }

    @Override
    @Transactional
    public void accionIngresoFinalPdteDoc(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialManager.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
    }
}
