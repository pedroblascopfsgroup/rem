package es.pfsgroup.plugin.rem.controller;

import es.capgemini.devon.exception.UserException;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.api.AccionesCaixaApi;
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
    public static final String ACCION_RECHAZO_AVANZA_RE = "002B";
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

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    public AccionesCaixaApi accionesCaixaApi;

    public ModelMap accionComercialCaixa(ModelMap model, RestRequestWrapper request, HttpServletResponse response){

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
            if (jsonFields!=null) {
                model.put("id", jsonFields.get("id"));
            }
            model.put("error", "null");
        } catch (Exception e) {
            logger.error("Error en la acción", e);
            request.getPeticionRest().setErrorDesc(e.getMessage());
            if (jsonFields!=null) {
                model.put("id", jsonFields.get("id"));
            }
            model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
        }

        return model;

    }

    public ModelAndView accionAprobacion(DtoAccionAprobacionCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionAprobacion(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
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
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionFirmaArrasAprobadas(DtoFirmaArrasAprobadasCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionFirmaArrasAprobadas(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionFirmaContratoAprobada(DtoFirmaContratoAprobadaCaixa dto){
        ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionFirmaContratoAprobada(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
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
        }

        return createModelAndViewJson(model);
    }

    public ModelAndView accionIngresoFinalRechazado(DtoOnlyExpedienteYOfertaCaixa dto) {ModelMap model = new ModelMap();
        try {
            accionesCaixaApi.accionIngresoFinalRechazado(dto);
            model.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            model.put("success", false);
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
        }

        return createModelAndViewJson(model);
    }
}
