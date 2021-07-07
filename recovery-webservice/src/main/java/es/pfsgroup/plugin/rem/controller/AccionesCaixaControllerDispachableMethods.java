package es.pfsgroup.plugin.rem.controller;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.DtoAccionAprobacionCaixa;
import es.pfsgroup.plugin.rem.model.DtoAccionRechazoCaixa;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

class AccionesCaixaControllerDispachableMethods {

    static abstract class DispachableMethod<T> {
        protected AccionesCaixaController controller;

        protected void setController(AccionesCaixaController c)  {
            this.controller = c;
        }

        public abstract Class<T> getArgumentType();
        public abstract Boolean execute(T dto);
    }

    private static Map<String, DispachableMethod> dispachableMethods;

    static {
        dispachableMethods = new HashMap<String, DispachableMethod>();

        dispachableMethods.put(AccionesCaixaController.ACCION_APROBACION, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoAccionAprobacionCaixa>() {
            @Override
            public Class<DtoAccionAprobacionCaixa> getArgumentType() {
                return DtoAccionAprobacionCaixa.class;
            }

            @Override
            public Boolean execute(DtoAccionAprobacionCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionAprobacion(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }  return true;
                }

                return false;
            }
        });

        dispachableMethods.put(AccionesCaixaController.ACCION_RECHAZO, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoAccionRechazoCaixa>() {
            @Override
            public Class<DtoAccionRechazoCaixa> getArgumentType() {
                return DtoAccionRechazoCaixa.class;
            }

            @Override
            public Boolean execute(DtoAccionRechazoCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionRechazo(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }  return true;
                }

                return false;
            }
        });

        dispachableMethods.put(AccionesCaixaController.ACCION_RECHAZO_AVANZA_RE, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoAccionRechazoCaixa>() {
            @Override
            public Class<DtoAccionRechazoCaixa> getArgumentType() {
                return DtoAccionRechazoCaixa.class;
            }

            @Override
            public Boolean execute(DtoAccionRechazoCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionRechazoAvanzaRE(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }  return true;
                }

                return false;
            }
        });
    }

    private AccionesCaixaController controller;

    AccionesCaixaControllerDispachableMethods(AccionesCaixaController c) {
        this.controller = c;
    }

    DispachableMethod findDispachableMethod(String modelName) {
        return configure(dispachableMethods.get(modelName));
    }

    private DispachableMethod configure(DispachableMethod m) {
        if (m != null) {
            m.setController(this.controller);
        }
        return m;
    }
}
