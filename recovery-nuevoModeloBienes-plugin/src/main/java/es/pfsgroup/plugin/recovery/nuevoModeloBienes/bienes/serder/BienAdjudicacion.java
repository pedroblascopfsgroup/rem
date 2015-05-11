package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.serder;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Generated;
import javax.persistence.Column;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("org.jsonschema2pojo")
@JsonPropertyOrder({
"idBien"
,"codigo"
,"origen"
,"descripcion"
,"habitual"
,"idAdjudicacion"
,"fechaDecretoNoFirme"
,"fechaDecretoFirme"
,"fechaEntregaGestor"
,"fechaPresentacionHacienda"
,"fechaSegundaPresentacion"
,"fechaRecepcionTitulo"
,"fechaInscripcionTitulo"
,"fechaEnvioAdicion"
,"fechaPresentacionRegistro"
,"fechaSolicitudPosesion"
,"fechaSenalamientoPosesion"
,"fechaRealizacionPosesion"
,"fechaSolicitudLanzamiento"
,"fechaSenalamientoLanzamiento"
,"fechaRealizacionLanzamiento"
,"fechaSolicitudMoratoria"
,"fechaResolucionMoratoria"
,"fechaContratoArrendamiento"
,"fechaCambioCerradura"
,"fechaEnvioLLaves"
,"fechaRecepcionDepositario"
,"fechaEnvioDepositario"
,"fechaRecepcionDepositarioFinal"
,"requiereSubsanacion"
,"notificacion"
,"ocupado"
,"posiblePosesion"
,"ocupantesDiligencia"
,"lanzamientoNecesario"
,"entregaVoluntaria"
,"necesariaFuerzaPublica"
,"existeInquilino"
,"llavesNecesarias"
,"gestoriaAdjudicataria"
,"nombreArrendatario"
,"nombreDepositario"
,"nombreDepositarioFinal"
,"fondo"
,"entidadAdjudicataria"
,"situacionTitulo"
,"resolucionMoratoria"
,"fechaRevisarPropuestaCancelacion"
,"fechaPropuestaCancelacion"
,"fechaRevisarCargas"
,"fechaPresentacionInsEco" 
,"fechaPresentacionIns"
,"fechaCancelacionRegEco" 
,"fechaCancelacionReg"
,"fechaCancelacionEco" 
,"fechaLiquidacion" 
,"fechaRecepcion"
,"fechaCancelacion"
})

public class BienAdjudicacion {

@JsonProperty("idBien")
private String idBien;
@JsonProperty("codigo")
private String codigo;
@JsonProperty("origen")
private String origen;
@JsonProperty("descripcion")
private String descripcion;
@JsonProperty("habitual")
private String habitual;
@JsonProperty("idAdjudicacion")
private String idAdjudicacion;
@JsonProperty("fechaDecretoNoFirme")
private String fechaDecretoNoFirme;
@JsonProperty("fechaDecretoFirme")
private String fechaDecretoFirme;
@JsonProperty("fechaEntregaGestor")
private String fechaEntregaGestor;
@JsonProperty("fechaPresentacionHacienda")
private String fechaPresentacionHacienda;
@JsonProperty("fechaSegundaPresentacion")
private String fechaSegundaPresentacion;
@JsonProperty("fechaRecepcionTitulo")
private String fechaRecepcionTitulo;
@JsonProperty("fechaInscripcionTitulo")
private String fechaInscripcionTitulo;
@JsonProperty("fechaEnvioAdicion")
private String fechaEnvioAdicion;
@JsonProperty("fechaPresentacionRegistro")
private String fechaPresentacionRegistro;
@JsonProperty("fechaSolicitudPosesion")
private String fechaSolicitudPosesion;
@JsonProperty("fechaSenalamientoPosesion")
private String fechaSenalamientoPosesion;
@JsonProperty("fechaRealizacionPosesion")
private String fechaRealizacionPosesion;
@JsonProperty("fechaSolicitudLanzamiento")
private String fechaSolicitudLanzamiento;
@JsonProperty("fechaSenalamientoLanzamiento")
private String fechaSenalamientoLanzamiento;
@JsonProperty("fechaRealizacionLanzamiento")
private String fechaRealizacionLanzamiento;
@JsonProperty("fechaSolicitudMoratoria")
private String fechaSolicitudMoratoria;
@JsonProperty("fechaResolucionMoratoria")
private String fechaResolucionMoratoria;
@JsonProperty("fechaContratoArrendamiento")
private String fechaContratoArrendamiento;
@JsonProperty("fechaCambioCerradura")
private String fechaCambioCerradura;
@JsonProperty("fechaEnvioLLaves")
private String fechaEnvioLLaves;
@JsonProperty("fechaRecepcionDepositario")
private String fechaRecepcionDepositario;
@JsonProperty("fechaEnvioDepositario")
private String fechaEnvioDepositario;
@JsonProperty("fechaRecepcionDepositarioFinal")
private String fechaRecepcionDepositarioFinal;
@JsonProperty("notificacion")
private String notificacion;
@JsonProperty("requiereSubsanacion")
private String requiereSubsanacion;
@JsonProperty("ocupado")
private String ocupado;
@JsonProperty("posiblePosesion")
private String posiblePosesion;
@JsonProperty("ocupantesDiligencia")
private String ocupantesDiligencia;
@JsonProperty("lanzamientoNecesario")
private String lanzamientoNecesario;
@JsonProperty("entregaVoluntaria")
private String entregaVoluntaria;
@JsonProperty("necesariaFuerzaPublica")
private String necesariaFuerzaPublica;
@JsonProperty("existeInquilino")
private String existeInquilino;
@JsonProperty("llavesNecesarias")
private String llavesNecesarias;
@JsonProperty("gestoriaAdjudicataria")
private String gestoriaAdjudicataria;
@JsonProperty("nombreArrendatario")
private String nombreArrendatario;
@JsonProperty("nombreDepositario")
private String nombreDepositario;
@JsonProperty("nombreDepositarioFinal")
private String nombreDepositarioFinal;
@JsonProperty("fondo")
private String fondo;
@JsonProperty("entidadAdjudicataria")
private String entidadAdjudicataria;
@JsonProperty("situacionTitulo")
private String situacionTitulo;
@JsonProperty("resolucionMoratoria")
private String resolucionMoratoria;
@JsonProperty("fechaRevisarPropuestaCancelacion")
private String fechaRevisarPropuestaCancelacion;
@JsonProperty("fechaPropuestaCancelacion")
private String fechaPropuestaCancelacion;
@JsonProperty("fechaRevisarCargas")
private String fechaRevisarCargas;
@JsonProperty("fechaPresentacionInsEco")
private String fechaPresentacionInsEco;
@JsonProperty("fechaPresentacionIns")
private String fechaPresentacionIns;
@JsonProperty("fechaCancelacionRegEco") 
private String fechaCancelacionRegEco;
@JsonProperty("fechaCancelacionReg")
private String fechaCancelacionReg;
@JsonProperty("fechaCancelacionEco")
private String fechaCancelacionEco;
@JsonProperty("fechaLiquidacion")
private String fechaLiquidacion;
@JsonProperty("fechaRecepcion")
private String fechaRecepcion;
@JsonProperty("fechaCancelacion")
private String fechaCancelacion;

private Map<String, Object> additionalProperties = new HashMap<String, Object>();


public String getId() {
	return idBien;
}


public void setId(String id) {
	this.idBien = idBien;
}


public String getCodigo() {
	return codigo;
}

public void setCodigo(String codigo) {
	this.codigo = codigo;
}

public String getOrigen() {
	return origen;
}

public void setOrigen(String origen) {
	this.origen = origen;
}

public String getDescripcion() {
	return descripcion;
}

public void setDescripcion(String descripcion) {
	this.descripcion = descripcion;
}

public String getHabitual() {
	return habitual;
}

public void setHabitual(String habitual) {
	this.habitual = habitual;
}

public String getIdAdjudicacion() {
	return idAdjudicacion;
}

public void setIdAdjudicacion(String idAdjudicacion) {
	this.idAdjudicacion = idAdjudicacion;
}

public String getFechaDecretoNoFirme() {
	return fechaDecretoNoFirme;
}

public void setFechaDecretoNoFirme(String fechaDecretoNoFirme) {
	this.fechaDecretoNoFirme = fechaDecretoNoFirme;
}

public String getFechaDecretoFirme() {
	return fechaDecretoFirme;
}

public void setFechaDecretoFirme(String fechaDecretoFirme) {
	this.fechaDecretoFirme = fechaDecretoFirme;
}

public String getFechaEntregaGestor() {
	return fechaEntregaGestor;
}

public void setFechaEntregaGestor(String fechaEntregaGestor) {
	this.fechaEntregaGestor = fechaEntregaGestor;
}

public String getFechaPresentacionHacienda() {
	return fechaPresentacionHacienda;
}

public void setFechaPresentacionHacienda(String fechaPresentacionHacienda) {
	this.fechaPresentacionHacienda = fechaPresentacionHacienda;
}

public String getFechaSegundaPresentacion() {
	return fechaSegundaPresentacion;
}

public void setFechaSegundaPresentacion(String fechaSegundaPresentacion) {
	this.fechaSegundaPresentacion = fechaSegundaPresentacion;
}

public String getFechaRecepcionTitulo() {
	return fechaRecepcionTitulo;
}

public void setFechaRecepcionTitulo(String fechaRecepcionTitulo) {
	this.fechaRecepcionTitulo = fechaRecepcionTitulo;
}

public String getFechaInscripcionTitulo() {
	return fechaInscripcionTitulo;
}

public void setFechaInscripcionTitulo(String fechaInscripcionTitulo) {
	this.fechaInscripcionTitulo = fechaInscripcionTitulo;
}

public String getFechaEnvioAdicion() {
	return fechaEnvioAdicion;
}

public void setFechaEnvioAdicion(String fechaEnvioAdicion) {
	this.fechaEnvioAdicion = fechaEnvioAdicion;
}

public String getFechaPresentacionRegistro() {
	return fechaPresentacionRegistro;
}

public void setFechaPresentacionRegistro(String fechaPresentacionRegistro) {
	this.fechaPresentacionRegistro = fechaPresentacionRegistro;
}

public String getFechaSolicitudPosesion() {
	return fechaSolicitudPosesion;
}

public void setFechaSolicitudPosesion(String fechaSolicitudPosesion) {
	this.fechaSolicitudPosesion = fechaSolicitudPosesion;
}

public String getFechaSenalamientoPosesion() {
	return fechaSenalamientoPosesion;
}

public void setFechaSenalamientoPosesion(String fechaSenalamientoPosesion) {
	this.fechaSenalamientoPosesion = fechaSenalamientoPosesion;
}

public String getFechaRealizacionPosesion() {
	return fechaRealizacionPosesion;
}

public void setFechaRealizacionPosesion(String fechaRealizacionPosesion) {
	this.fechaRealizacionPosesion = fechaRealizacionPosesion;
}

public String getFechaSolicitudLanzamiento() {
	return fechaSolicitudLanzamiento;
}

public void setFechaSolicitudLanzamiento(String fechaSolicitudLanzamiento) {
	this.fechaSolicitudLanzamiento = fechaSolicitudLanzamiento;
}

public String getFechaSenalamientoLanzamiento() {
	return fechaSenalamientoLanzamiento;
}

public void setFechaSenalamientoLanzamiento(String fechaSenalamientoLanzamiento) {
	this.fechaSenalamientoLanzamiento = fechaSenalamientoLanzamiento;
}

public String getFechaRealizacionLanzamiento() {
	return fechaRealizacionLanzamiento;
}

public void setFechaRealizacionLanzamiento(String fechaRealizacionLanzamiento) {
	this.fechaRealizacionLanzamiento = fechaRealizacionLanzamiento;
}

public String getFechaSolicitudMoratoria() {
	return fechaSolicitudMoratoria;
}

public void setFechaSolicitudMoratoria(String fechaSolicitudMoratoria) {
	this.fechaSolicitudMoratoria = fechaSolicitudMoratoria;
}

public String getFechaResolucionMoratoria() {
	return fechaResolucionMoratoria;
}

public void setFechaResolucionMoratoria(String fechaResolucionMoratoria) {
	this.fechaResolucionMoratoria = fechaResolucionMoratoria;
}

public String getFechaContratoArrendamiento() {
	return fechaContratoArrendamiento;
}

public void setFechaContratoArrendamiento(String fechaContratoArrendamiento) {
	this.fechaContratoArrendamiento = fechaContratoArrendamiento;
}

public String getFechaCambioCerradura() {
	return fechaCambioCerradura;
}

public void setFechaCambioCerradura(String fechaCambioCerradura) {
	this.fechaCambioCerradura = fechaCambioCerradura;
}

public String getFechaEnvioLLaves() {
	return fechaEnvioLLaves;
}

public void setFechaEnvioLLaves(String fechaEnvioLLaves) {
	this.fechaEnvioLLaves = fechaEnvioLLaves;
}

public String getFechaRecepcionDepositario() {
	return fechaRecepcionDepositario;
}

public void setFechaRecepcionDepositario(String fechaRecepcionDepositario) {
	this.fechaRecepcionDepositario = fechaRecepcionDepositario;
}

public String getFechaEnvioDepositario() {
	return fechaEnvioDepositario;
}

public void setFechaEnvioDepositario(String fechaEnvioDepositario) {
	this.fechaEnvioDepositario = fechaEnvioDepositario;
}

public String getFechaRecepcionDepositarioFinal() {
	return fechaRecepcionDepositarioFinal;
}

public void setFechaRecepcionDepositarioFinal(String fechaRecepcionDepositarioFinal) {
	this.fechaRecepcionDepositarioFinal = fechaRecepcionDepositarioFinal;
}

public String getNotificacion() {
	return notificacion;
}

public void setNotificacion(String notificacion) {
	this.notificacion = notificacion;
}

public String getRequiereSubsanacion() {
	return requiereSubsanacion;
}


public void setRequiereSubsanacion(String requiereSubsanacion) {
	this.requiereSubsanacion = requiereSubsanacion;
}


public String getOcupado() {
	return ocupado;
}

public void setOcupado(String ocupado) {
	this.ocupado = ocupado;
}

public String getPosiblePosesion() {
	return posiblePosesion;
}

public void setPosiblePosesion(String posiblePosesion) {
	this.posiblePosesion = posiblePosesion;
}

public String getOcupantesDiligencia() {
	return ocupantesDiligencia;
}

public void setOcupantesDiligencia(String ocupantesDiligencia) {
	this.ocupantesDiligencia = ocupantesDiligencia;
}

public String getLanzamientoNecesario() {
	return lanzamientoNecesario;
}

public void setLanzamientoNecesario(String lanzamientoNecesario) {
	this.lanzamientoNecesario = lanzamientoNecesario;
}

public String getEntregaVoluntaria() {
	return entregaVoluntaria;
}

public void setEntregaVoluntaria(String entregaVoluntaria) {
	this.entregaVoluntaria = entregaVoluntaria;
}

public String getNecesariaFuerzaPublica() {
	return necesariaFuerzaPublica;
}

public void setNecesariaFuerzaPublica(String necesariaFuerzaPublica) {
	this.necesariaFuerzaPublica = necesariaFuerzaPublica;
}

public String getExisteInquilino() {
	return existeInquilino;
}

public void setExisteInquilino(String existeInquilino) {
	this.existeInquilino = existeInquilino;
}

public String getLlavesNecesarias() {
	return llavesNecesarias;
}

public void setLlavesNecesarias(String llavesNecesarias) {
	this.llavesNecesarias = llavesNecesarias;
}

public String getGestoriaAdjudicataria() {
	return gestoriaAdjudicataria;
}

public void setGestoriaAdjudicataria(String gestoriaAdjudicataria) {
	this.gestoriaAdjudicataria = gestoriaAdjudicataria;
}

public String getNombreArrendatario() {
	return nombreArrendatario;
}

public void setNombreArrendatario(String nombreArrendatario) {
	this.nombreArrendatario = nombreArrendatario;
}

public String getNombreDepositario() {
	return nombreDepositario;
}

public void setNombreDepositario(String nombreDepositario) {
	this.nombreDepositario = nombreDepositario;
}

public String getNombreDepositarioFinal() {
	return nombreDepositarioFinal;
}

public void setNombreDepositarioFinal(String nombreDepositarioFinal) {
	this.nombreDepositarioFinal = nombreDepositarioFinal;
}

public String getFondo() {
	return fondo;
}

public void setFondo(String fondo) {
	this.fondo = fondo;
}

public String getEntidadAdjudicataria() {
	return entidadAdjudicataria;
}

public void setEntidadAdjudicataria(String entidadAdjudicataria) {
	this.entidadAdjudicataria = entidadAdjudicataria;
}

public String getSituacionTitulo() {
	return situacionTitulo;
}

public void setSituacionTitulo(String situacionTitulo) {
	this.situacionTitulo = situacionTitulo;
}

public String getResolucionMoratoria() {
	return resolucionMoratoria;
}

public void setResolucionMoratoria(String resolucionMoratoria) {
	this.resolucionMoratoria = resolucionMoratoria;
}

public void setAdditionalProperties(Map<String, Object> additionalProperties) {
	this.additionalProperties = additionalProperties;
}

public String getIdBien() {
	return idBien;
}


public void setIdBien(String idBien) {
	this.idBien = idBien;
}


public String getFechaRevisarPropuestaCancelacion() {
	return fechaRevisarPropuestaCancelacion;
}


public void setFechaRevisarPropuestaCancelacion(String fechaRevisarPropuestaCancelacion) {
	this.fechaRevisarPropuestaCancelacion = fechaRevisarPropuestaCancelacion;
}


public String getFechaPropuestaCancelacion() {
	return fechaPropuestaCancelacion;
}


public void setFechaPropuestaCancelacion(String fechaPropuestaCancelacion) {
	this.fechaPropuestaCancelacion = fechaPropuestaCancelacion;
}


public String getFechaRevisarCargas() {
	return fechaRevisarCargas;
}


public void setFechaRevisarCargas(String fechaRevisarCargas) {
	this.fechaRevisarCargas = fechaRevisarCargas;
}


public String getFechaPresentacionInsEco() {
	return fechaPresentacionInsEco;
}


public void setFechaPresentacionInsEco(String fechaPresentacionInsEco) {
	this.fechaPresentacionInsEco = fechaPresentacionInsEco;
}


public String getFechaPresentacionIns() {
	return fechaPresentacionIns;
}


public void setFechaPresentacionIns(String fechaPresentacionIns) {
	this.fechaPresentacionIns = fechaPresentacionIns;
}


public String getFechaCancelacionRegEco() {
	return fechaCancelacionRegEco;
}


public void setFechaCancelacionRegEco(String fechaCancelacionRegEco) {
	this.fechaCancelacionRegEco = fechaCancelacionRegEco;
}


public String getFechaCancelacionReg() {
	return fechaCancelacionReg;
}


public void setFechaCancelacionReg(String fechaCancelacionReg) {
	this.fechaCancelacionReg = fechaCancelacionReg;
}


public String getFechaCancelacionEco() {
	return fechaCancelacionEco;
}


public void setFechaCancelacionEco(String fechaCancelacionEco) {
	this.fechaCancelacionEco = fechaCancelacionEco;
}


public String getFechaLiquidacion() {
	return fechaLiquidacion;
}


public void setFechaLiquidacion(String fechaLiquidacion) {
	this.fechaLiquidacion = fechaLiquidacion;
}


public String getFechaRecepcion() {
	return fechaRecepcion;
}


public void setFechaRecepcion(String fechaRecepcion) {
	this.fechaRecepcion = fechaRecepcion;
}


public String getFechaCancelacion() {
	return fechaCancelacion;
}


public void setFechaCancelacion(String fechaCancelacion) {
	this.fechaCancelacion = fechaCancelacion;
}


@JsonAnyGetter
public Map<String, Object> getAdditionalProperties() {
return this.additionalProperties;
}

@JsonAnySetter
public void setAdditionalProperty(String name, Object value) {
this.additionalProperties.put(name, value);
}

}
