package es.pfsgroup.plugin.rem.accionesCaixa;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.AccionesCaixaApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.controller.AgendaController;
import es.pfsgroup.plugin.rem.expedienteComercial.ExpedienteComercialManager;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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
    public ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ActivoTareaExternaApi activoTareaExternaApi;
    
	 @Autowired
	 private ReservaApi reservaApi;

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
        map.put("resolucionOferta", comboResolucion);
        map.put("fechaElevacion", fechaRespuesta);
        if (TareaProcedimientoConstants.CODIGO_SANCION_BC.equals(dto.getCodTarea()))
        map.put("comboResultado", comboResolucion);


        return map;
    }

    @Transactional
    @Override
    public void accionRechazo(DtoAccionRechazoCaixa dto) throws Exception {
        Oferta ofr =  genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "numOferta", dto.getNumOferta()));
        if (DDTipoOferta.isTipoAlquiler(ofr.getTipoOferta()) || DDTipoOferta.isTipoAlquilerNoComercial(ofr.getTipoOferta())) {
            ExpedienteComercial eco = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdExpediente()));
            ActivoTramite acTra = genericDao.get(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "trabajo.id", eco.getTrabajo().getId()));
            adapter.anularTramiteAlquiler(acTra.getId(), "905");
        }else {
        	TareaExterna tareaExternaActual = genericDao.get(TareaExterna.class, genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", dto.getIdTarea()));
        	ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        	
        	if(tareaExternaActual != null && expediente != null) {
        		String estadoBc = null;
	        	String codigoTarea = tareaExternaActual.getTareaProcedimiento().getCodigo();
				if(ComercialUserAssigantionService.CODIGO_T017_DEFINICION_OFERTA.equals(codigoTarea) || ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_CES.equals(codigoTarea)
					|| ComercialUserAssigantionService.TramiteVentaAppleT017.CODIGO_T017_PBC_CN.equals(codigoTarea)) {
					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
				}else if(reservaApi.tieneReservaFirmada(expediente)) {
					estadoBc = DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC;
				}else {
					estadoBc = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
				}
				expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo",estadoBc)));
				genericDao.save(ExpedienteComercial.class, expediente);
				
	            agendaController.saltoResolucionExpedienteByIdExp(dto.getIdExpediente(), new ModelMap());
	        }
        }
    }

    @Override
    @Transactional
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
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        OfertaCaixa ofrCaixa = genericDao.get(OfertaCaixa.class, genericDao.createFilter(FilterType.EQUALS, "oferta.numOferta", dto.getNumOferta()));
        DDRiesgoOperacion rop = genericDao.get(DDRiesgoOperacion.class, genericDao.createFilter(FilterType.EQUALS, "codigoC4C", dto.getRiesgoOperacion()));

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_PTE_CALCULO_RIESGO));
        expediente.setEstadoBc(estadoExpedienteBc);
        ofrCaixa.setRiesgoOperacion(rop);

        genericDao.save(OfertaCaixa.class, ofrCaixa);
        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionArrasAprobadas(DtoOnlyExpedienteYOfertaCaixa dto){
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS));
        expediente.setEstadoBc(estadoExpedienteBc);
        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionIngresoFinalAprobado(DtoOnlyExpedienteYOfertaCaixa dto){
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO));
        expediente.setEstadoBc(estadoExpedienteBc);
        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Transactional
    @Override
    public void accionFirmaArrasAprobadas(DtoFirmaArrasCaixa dto) throws Exception {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_FIRMA_DE_ARRAS_AGENDADAS));
        expediente.setEstadoBc(estadoExpedienteBc);

        FechaArrasExpediente fae = genericDao.get(FechaArrasExpediente.class,
                genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdFae()));
        DDMotivosEstadoBC motivoEstado = genericDao.get(DDMotivosEstadoBC.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_APROBADA_BC));
        fae.setValidacionBC(motivoEstado);
        fae.setFechaRespuestaBC(new Date());

        genericDao.save(FechaArrasExpediente.class, fae);
        genericDao.save(ExpedienteComercial.class, expediente);

        adapter.save(createRequestAccionFirmaArras(dto));

		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    public Map<String, String[]> createRequestAccionFirmaArras(DtoFirmaArrasCaixa dto) throws ParseException {
        Map<String,String[]> map = new HashMap<String,String[]>();

        String[] idTarea = {dto.getIdTarea().toString()};
        String[] comboValidacionBC = {dto.getComboValidacionBC()};
        String[] observacionesBC = {dto.getObservacionesBC()};
        String[] fechaPropuesta = {dto.getFechaPropuesta() != null ? sdf.format(sdfEntrada.parse(dto.getFechaPropuesta())) : null};

        map.put("idTarea", idTarea);
        map.put("comboValidacionBC", comboValidacionBC);
        map.put("observacionesBC", observacionesBC);
        map.put("fechaPropuesta", fechaPropuesta);

        return map;
    }

    @Transactional
    @Override
    public void accionFirmaContratoAprobada(DtoFirmaContratoCaixa dto) throws Exception {

        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO));
        expediente.setEstadoBc(estadoExpedienteBc);

        Posicionamiento posicionamiento = genericDao.get(Posicionamiento.class,
                genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPosicionamiento()));

        posicionamiento.setValidacionBCPos(genericDao.get(DDMotivosEstadoBC.class,genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_APROBADA_BC)));
        posicionamiento.setFechaValidacionBCPos(new Date());

        genericDao.save(ExpedienteComercial.class, expediente);
        genericDao.save(Posicionamiento.class,posicionamiento);

        adapter.save(createRequestAccionFirmaContrato(dto));
        ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    public Map<String, String[]> createRequestAccionFirmaContrato(DtoFirmaContratoCaixa dto) throws ParseException {
        Map<String,String[]> map = new HashMap<String,String[]>();

        String[] idTarea = {dto.getIdTarea().toString()};
        String[] comboValidacionBC = {dto.getComboValidacionBC()};
        String[] observacionesBC = {dto.getObservacionesBC()};
        String[] fechaPropuesta = {dto.getFechaPropuesta() != null ? sdf.format(sdfEntrada.parse(dto.getFechaPropuesta())) : null};
        String[] fechaRespuesta = {dto.getFechaRespuesta() != null ? sdf.format(sdfEntrada.parse(dto.getFechaRespuesta())) : null};

        map.put("idTarea", idTarea);
        map.put("comboValidacionBC", comboValidacionBC);
        map.put("observacionesBC", observacionesBC);
        map.put("fechaPropuesta", fechaPropuesta);
        map.put("fechaRespuesta", fechaRespuesta);
        map.put("comboArras", new  String[]{DDSiNo.NO});

        return map;
    }

    @Override
    @Transactional
    public void accionVentaContabilizada(DtoOnlyExpedienteYOfertaCaixa dto){
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_VENTA_FORMALIZADA));
        expediente.setEstadoBc(estadoExpedienteBc);

        DDEstadosExpedienteComercial eec = genericDao.get(DDEstadosExpedienteComercial.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO));
        expediente.setEstado(eec);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionArrasRechazadas(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionArrasPteDoc(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_ARRAS_PTE_DOCUMENTACION));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionIngresoFinalRechazado(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionIngresoFinalPdteDoc(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionAprobarModTitulares(DtoOnlyExpedienteYOfertaCaixa dto) {
        List<InterlocutorExpediente> iexList = genericDao.getList(InterlocutorExpediente.class,
                genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", dto.getIdExpediente()));

        DDEstadoInterlocutor eic = genericDao.get(DDEstadoInterlocutor.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInterlocutor.CODIGO_ACTIVO));

        for(InterlocutorExpediente iex: iexList){
            iex.setEstadoInterlocutor(eic);
            genericDao.save(InterlocutorExpediente.class, iex);
        }
    }

    @Override
    @Transactional
    public void accionDevolverArras(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionIncautarArras(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionDevolverReserva(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionIncautarReserva(DtoOnlyExpedienteYOfertaCaixa dto) {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC));
        expediente.setEstadoBc(estadoExpedienteBc);

        genericDao.save(ExpedienteComercial.class, expediente);
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionDevolArrasCont(DtoAccionRechazoCaixa dto) {
        agendaController.saltoResolucionExpedienteByIdExp(dto.getIdExpediente(), new ModelMap());
    }

    @Override
    @Transactional
    public void accionDevolReservaCont(DtoAccionRechazoCaixa dto) {
        agendaController.saltoResolucionExpedienteByIdExp(dto.getIdExpediente(), new ModelMap());
    }

    @Override
    @Transactional
    public void accionIncautacionArrasCont(DtoAccionRechazoCaixa dto) {
        agendaController.saltoResolucionExpedienteByIdExp(dto.getIdExpediente(), new ModelMap());
    }

    @Override
    @Transactional
    public void accionIncautacionReservaCont(DtoAccionRechazoCaixa dto) {
        agendaController.saltoResolucionExpedienteByIdExp(dto.getIdExpediente(), new ModelMap());
    }

    @Override
    @Transactional
    public void accionFirmaArrasRechazadas(DtoFirmaArrasCaixa dto) throws Exception {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS));
        expediente.setEstadoBc(estadoExpedienteBc);

        FechaArrasExpediente fae = genericDao.get(FechaArrasExpediente.class,
                genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdFae()));
        DDMotivosEstadoBC motivoEstado = genericDao.get(DDMotivosEstadoBC.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_RECHAZADA_BC));
        fae.setValidacionBC(motivoEstado);
        fae.setFechaRespuestaBC(new Date());

        genericDao.save(ExpedienteComercial.class, expediente);
        genericDao.save(FechaArrasExpediente.class,fae);

        adapter.save(createRequestAccionFirmaArras(dto));

		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionFirmaContratoRechazada(DtoFirmaContratoCaixa dto) throws Exception {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());
        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
                genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO));
        expediente.setEstadoBc(estadoExpedienteBc);

        Posicionamiento posicionamiento = genericDao.get(Posicionamiento.class,
                genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPosicionamiento()));

        posicionamiento.setValidacionBCPos(genericDao.get(DDMotivosEstadoBC.class,genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_RECHAZADA_BC)));
        posicionamiento.setFechaValidacionBCPos(new Date());

        genericDao.save(Posicionamiento.class,posicionamiento);
        genericDao.save(ExpedienteComercial.class, expediente);

        adapter.save(createRequestAccionFirmaContrato(dto));

		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionArrasContabilizadas(DtoExpedienteFechaYOfertaCaixa dto) throws ParseException {
        ExpedienteComercial expediente = expedienteComercialApi.findOne(dto.getIdExpediente());

        DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
        genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_INGRESO_DE_ARRAS));
        expediente.setEstadoBc(estadoExpedienteBc);
        expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_PBC_VENTAS)));

        Reserva res = expediente.getReserva();
        res.setFechaContArras(sdfEntrada.parse(dto.getFechaContArras()));

        genericDao.save(Reserva.class, res);
        genericDao.save(ExpedienteComercial.class, expediente);
        
		ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
    }

    @Override
    @Transactional
    public void accionContraoferta(DtoAccionAprobacionCaixa dto) throws Exception {
    	this.createRequestAccionAprobacion(dto);
    	TareaExterna tarea = genericDao.get(TareaExterna.class, genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", dto.getIdTarea()));
    	expedienteComercialApi.setValoresTEB(dto, tarea, dto.getCodTarea());
    }

    @Override
    @Transactional
    public void accionScoringBC(DtoAvanzaScoringBC dto) throws Exception {
        adapter.save(createRequestAccionScoringBC(dto));
    }

    public Map<String, String[]> createRequestAccionScoringBC(DtoAvanzaScoringBC dto){
        Map<String,String[]> map = new HashMap<String,String[]>();

        String[] idTarea = {dto.getIdTarea().toString()};
        String[] observaciones = {dto.getObservaciones()};
        String[] comboResultado = {dto.getComboResultado()};

        map.put("idTarea", idTarea);
        map.put("observaciones", observaciones);
        map.put("comboResultado", comboResultado);


        return map;
    }

    @Override
    @Transactional
    public void avanzarTareaGenerico(net.sf.json.JSONObject dto) throws Exception {
        adapter.save(createRequestAvanzarTareaGenerico(dto));
    }

    public Map<String, String[]> createRequestAvanzarTareaGenerico(net.sf.json.JSONObject dto) throws ParseException {
        Map<String,String[]> map = new HashMap<String,String[]>();

        Iterator<String> keys = dto.keys();
        while(keys.hasNext()) {
            String key = keys.next();
            Object value = dto.get(key);
            if (key.toLowerCase().contains("fecha") && value != null){
                map.put(key,new String[]{sdf.format(sdfEntrada.parse(value.toString()))});
            }
            else if (value != null){
                map.put(key,new String[]{value.toString()});
            }
        }
        return map;
    }




}
