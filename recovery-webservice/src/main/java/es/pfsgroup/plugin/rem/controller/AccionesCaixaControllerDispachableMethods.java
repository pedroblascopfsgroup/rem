package es.pfsgroup.plugin.rem.controller;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.*;
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

        dispachableMethods.put(AccionesCaixaController.ACCION_RESULTADO_RIESGO, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoAccionResultadoRiesgoCaixa>() {
            @Override
            public Class<DtoAccionResultadoRiesgoCaixa> getArgumentType() {
                return DtoAccionResultadoRiesgoCaixa.class;
            }

            @Override
            public Boolean execute(DtoAccionResultadoRiesgoCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionResultadoRiesgo(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }
                    return true;
                }

                return false;
            }
        });

        dispachableMethods.put(AccionesCaixaController.ACCION_ARRAS_APROBADAS, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoOnlyExpedienteYOfertaCaixa>() {
            @Override
            public Class<DtoOnlyExpedienteYOfertaCaixa> getArgumentType() {
                return DtoOnlyExpedienteYOfertaCaixa.class;
            }

            @Override
            public Boolean execute(DtoOnlyExpedienteYOfertaCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionArrasAprobadas(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }
                    return true;
                }

                return false;
            }
        });

        dispachableMethods.put(AccionesCaixaController.ACCION_INGRESO_FINAL_APR, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoOnlyExpedienteYOfertaCaixa>() {
            @Override
            public Class<DtoOnlyExpedienteYOfertaCaixa> getArgumentType() {
                return DtoOnlyExpedienteYOfertaCaixa.class;
            }

            @Override
            public Boolean execute(DtoOnlyExpedienteYOfertaCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionIngresoFinalAprobado(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }
                    return true;
                }

                return false;
            }
        });

        dispachableMethods.put(AccionesCaixaController.ACCION_FIRMA_ARRAS_APR, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoFirmaArrasAprobadasCaixa>() {
            @Override
            public Class<DtoFirmaArrasAprobadasCaixa> getArgumentType() {
                return DtoFirmaArrasAprobadasCaixa.class;
            }

            @Override
            public Boolean execute(DtoFirmaArrasAprobadasCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionFirmaArrasAprobadas(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }
                    return true;
                }

                return false;
            }
        });

        dispachableMethods.put(AccionesCaixaController.ACCION_FIRMA_CONTRATO_APR, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoFirmaContratoAprobadaCaixa>() {
            @Override
            public Class<DtoFirmaContratoAprobadaCaixa> getArgumentType() {
                return DtoFirmaContratoAprobadaCaixa.class;
            }

            @Override
            public Boolean execute(DtoFirmaContratoAprobadaCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionFirmaContratoAprobada(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }
                    return true;
                }

                return false;
            }
        });

        dispachableMethods.put(AccionesCaixaController.ACCION_VENTA_CONTABILIZADA, new AccionesCaixaControllerDispachableMethods.DispachableMethod<DtoOnlyExpedienteYOfertaCaixa>() {
            @Override
            public Class<DtoOnlyExpedienteYOfertaCaixa> getArgumentType() {
                return DtoOnlyExpedienteYOfertaCaixa.class;
            }

            @Override
            public Boolean execute(DtoOnlyExpedienteYOfertaCaixa dto) {
                if (dto != null) {
                    ModelAndView mm = this.controller.accionVentaContabilizada(dto);
                    if ("false".equals(mm.getModel().get("success").toString())
                            && !Checks.esNulo(mm.getModel().get("msgError"))) {
                        throw new JsonViewerException(mm.getModel().get("msgError").toString());
                    }
                    return true;
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
