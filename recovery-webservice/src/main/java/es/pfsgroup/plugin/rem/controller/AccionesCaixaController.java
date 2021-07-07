package es.pfsgroup.plugin.rem.controller;

import es.capgemini.devon.exception.UserException;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.api.AccionesCaixaApi;
import es.pfsgroup.plugin.rem.model.DtoAccionRechazoCaixa;
import es.pfsgroup.plugin.rem.rest.dto.AccionesCaixaDtoData;
import es.pfsgroup.plugin.rem.rest.dto.AccionesCaixaRequestDto;
import es.pfsgroup.plugin.rem.model.DtoAccionAprobacionCaixa;
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

}
