package es.pfsgroup.plugin.rem.controller;

import es.capgemini.devon.exception.UserException;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.api.AccionesCaixaApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.rest.dto.AccionesCaixaDtoData;
import es.pfsgroup.plugin.rem.rest.dto.AccionesCaixaRequestDto;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Map;

@Controller
public class AccionesCaixaController extends ParadiseJsonController {

    public static final String ACCION_APROBACION = "001";
    public static final String ACCION_RECHAZO = "002";
    public static final String ACCION_RECHAZO_AVANZA_RE = "000";
    public static final String ACCION_RESULTADO_RIESGO = "004";
    public static final String ACCION_ARRAS_APROBADAS = "005";
    public static final String ACCION_ARRAS_RECHAZADAS = "006";
    public static final String ACCION_ARRAS_PDTE_DOCUMENTACION = "007";
    public static final String ACCION_INGRESO_FINAL_APR = "008";
    public static final String ACCION_INGRESO_FINAL_RECHAZADO = "009";
    public static final String ACCION_INGRESO_FINAL_PDTE_DOC = "010";
    public static final String ACCION_FIRMA_ARRAS_APR = "013";
    public static final String ACCION_FIRMA_CONTRATO_APR = "015";
    public static final String ACCION_VENTA_CONTABILIZADA = "023";
    public static final String ACCION_RECHAZO_SCREENING = "036";
    public static final String ACCION_BLOQUEO_SCREENING = "011";
    public static final String ACCION_DESBLOQUEO_SCREENING = "012";
    public static final String ACCION_APROBAR_MOD_TITULARES = "026";
    public static final String ACCION_DEVOLVER_ARRAS = "027";
    public static final String ACCION_INCAUTAR_ARRAS = "028";
    public static final String ACCION_DEVOLVER_RESERVA = "029";
    public static final String ACCION_INCAUTAR_RESERVA = "030";
    public static final String ACCION_DEVOL_ARRAS_CONT = "032";
    public static final String ACCION_DEVOL_RESERVA_CONT = "033";
    public static final String ACCION_INCAUTACION_ARRAS_CONT = "034";
    public static final String ACCION_INCAUTACION_RESERVA_CONT = "035";
    public static final String ACCION_FIRMA_ARRAS_RECHAZADAS = "014";
    public static final String ACCION_FIRMA_CONTRATO_RECHAZADO = "016";
    public static final String ACCION_ARRAS_CONTABILIZADAS = "022";
    public static final String ACCION_COM_CONTRAOFERTA = "003";

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    public AccionesCaixaApi accionesCaixaApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    public String accionComercialCaixa(ModelMap model, RestRequestWrapper request, HttpServletResponse response){

        AccionesCaixaRequestDto jsonData = null;
        ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
        JSONObject jsonFields = null;
        JSONObject jsonDto = null;
        AccionesCaixaDtoData accionesCaixaDto = null;

        try {

            jsonFields = request.getJsonObject();
            jsonData = (AccionesCaixaRequestDto) request.getRequestData(AccionesCaixaRequestDto.class);
            accionesCaixaDto = jsonData.getData() != null ? jsonData.getData().get(0) : null;

            AccionesCaixaDispatcher dispatcher = new AccionesCaixaDispatcher(this);
            dispatcher.dispatchAccion(JSONObject.fromObject(accionesCaixaDto), accionesCaixaDto.getIdAccion());

            model.put("id", jsonFields.get("id"));
            model.put("error", "null");

        } catch (UserException e) {
            return e.getMessage();
        } catch (Exception e) {
            return e.getMessage();
        }

        return null;

    }

    public ModelAndView accionAprobacion(DtoAccionAprobacionCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionAprobacion(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionRechazo(DtoAccionRechazoCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionRechazo(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionRechazoAvanzaRE(DtoAccionRechazoCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionRechazoAvanzaRE(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionResultadoRiesgo(DtoAccionResultadoRiesgoCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionResultadoRiesgo(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionArrasAprobadas(DtoOnlyExpedienteYOfertaCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionArrasAprobadas(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIngresoFinalAprobado(DtoOnlyExpedienteYOfertaCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIngresoFinalAprobado(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionFirmaArrasAprobadas(DtoFirmaArrasCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionFirmaArrasAprobadas(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionFirmaContratoAprobada(DtoFirmaContratoCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionFirmaContratoAprobada(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionVentaContabilizada(DtoOnlyExpedienteYOfertaCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionVentaContabilizada(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionArrasRechazadas(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionArrasRechazadas(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionArrasPteDoc(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionArrasPteDoc(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIngresoFinalRechazado(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIngresoFinalRechazado(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIngresoFinalPdteDoc(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIngresoFinalPdteDoc(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionBloqueoScreening(DtoScreening dto) {
        ModelMap model = new ModelMap();
        try {
            expedienteComercialApi.tareaBloqueoScreening(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);

    }

    public ModelAndView accionDesbloqueoScreening(DtoScreening dto) {
        ModelMap model = new ModelMap();
        try {
            expedienteComercialApi.tareaDesbloqueoScreening(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionAprobarModTitulares(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionAprobarModTitulares(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionDevolverArras(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionDevolverArras(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIncautarArras(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIncautarArras(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionDevolverReserva(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionDevolverReserva(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIncautarReserva(DtoOnlyExpedienteYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIncautarReserva(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionDevolArrasCont(DtoAccionRechazoCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionDevolArrasCont(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionDevolReservaCont(DtoAccionRechazoCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionDevolReservaCont(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIncautacionArrasCont(DtoAccionRechazoCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIncautacionArrasCont(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIncautacionReservaCont(DtoAccionRechazoCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIncautacionReservaCont(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionFirmaArrasRechazadas(DtoFirmaArrasCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionFirmaArrasRechazadas(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionFirmaContratoRechazada(DtoFirmaContratoCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionFirmaContratoRechazada(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionArrasContabilizadas(DtoExpedienteFechaYOfertaCaixa dto) {
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionArrasContabilizadas(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionContraoferta(DtoAccionAprobacionCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionContraoferta(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
            model.put("msgError", e.getMessage());
        }

        return createModelAndViewJson(model);
    }
}
