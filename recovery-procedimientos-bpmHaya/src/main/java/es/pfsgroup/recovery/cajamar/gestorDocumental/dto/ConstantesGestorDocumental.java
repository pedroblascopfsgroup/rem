package es.pfsgroup.recovery.cajamar.gestorDocumental.dto;

import java.util.HashMap;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

public class ConstantesGestorDocumental {

	public final static String ALTA_DOCUMENTO_OPERACION = "A";
	public final static String CONSULTA_DOCUMENTO_OPERACION = "C";
	public final static String LISTADO_DOCUMENTO_OPERACION = "L";
	public final static String GESTOR_DOCUMENTAL_ORIGEN = "2";
	public final static String GESTOR_DOCUMENTAL_TIPO_ASOCIACION_CONTRATO = "MCTA";
	public final static String GESTOR_DOCUMENTAL_TIPO_ASOCIACION_ASUNTO = "ASUN";
	public final static String GESTOR_DOCUMENTAL_TIPO_ASOCIACION_EXPEDIENTE = "EXTE";
	public final static String GESTOR_DOCUMENTAL_TIPO_ASOCIACION_PERSONA = "PERS";
	public final static String GESTOR_DOCUMENTAL_TIPO_ASOCIACION_PROCEDIMIENTO = "ACTU";	

	// Relaciona los tipos de entidad recovery con los tipos de asociacion de cajamar
	public final static HashMap<String, String> tipoAsociacionPorEntidad;

    static
    {
        tipoAsociacionPorEntidad = new HashMap<String, String>();
        tipoAsociacionPorEntidad.put(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, GESTOR_DOCUMENTAL_TIPO_ASOCIACION_EXPEDIENTE);
        tipoAsociacionPorEntidad.put(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE, GESTOR_DOCUMENTAL_TIPO_ASOCIACION_PERSONA);
        tipoAsociacionPorEntidad.put(DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, GESTOR_DOCUMENTAL_TIPO_ASOCIACION_CONTRATO);
        tipoAsociacionPorEntidad.put(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, GESTOR_DOCUMENTAL_TIPO_ASOCIACION_ASUNTO);
        tipoAsociacionPorEntidad.put(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, GESTOR_DOCUMENTAL_TIPO_ASOCIACION_PROCEDIMIENTO);
        
    }
}
