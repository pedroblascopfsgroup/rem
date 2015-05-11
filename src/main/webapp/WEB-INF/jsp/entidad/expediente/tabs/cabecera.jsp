<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var panel=new Ext.Panel({
		title : '<s:message code="contrato.consulta.tabcabecera.titulo" text="**Cabecera"/>'
		,layout:'table'
		,border : false
		,layoutConfig: { columns: 1 }
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'cabecera'
	});
	
	var cfg = {labelStyle:"width:200px;font-weight:bolder",width:375};
	var limit = 10;

   function label(id,text){
		  return app.creaLabel(text,"",  {id:'entidad-expediente-'+id});
	 }

   function fieldSet(title,items){
	return new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : items
		});
   }
	
	
	var codExpediente	= label('codExpediente',	'<s:message code="expedientes.consulta.tabcabecera.codigo" text="**Codigo"/>',cfg);
	var fechaCreacion	= label('fechaCreacion',	'<s:message code="expedientes.consulta.tabcabecera.creacion" text="**Fecha Creacion"/>',cfg);
	var situacion		= label('situacion',	'<s:message code="expedientes.consulta.tabcabecera.situacion" text="**Situacion"/>',cfg);
	var estado			= label('estado',	'<s:message code="expedientes.consulta.tabcabecera.estado" text="**Estado"/>',cfg);
	var descripcion		= label('descripcion',	'<s:message code="expedientes.consulta.tabcabecera.descripcion" text="**Descripcion"/>',cfg);
	var diasVencido		= label('diasVencido',	'<s:message code="expedientes.consulta.tabcabecera.diasvencido" text="**Dias Venc"/>',cfg);
	var volRiesgos		= label('volRiesgos',	'<s:message code="expedientes.consulta.tabcabecera.riesgos" text="**Volumen riesgos"/>',cfg);
	var volRiesgosVenc	= label('volRiesgosVenc',	'<s:message code="expedientes.consulta.tabcabecera.riesgosvencidos" text="**Volumen riesgos Vencidos"/>',cfg);
	var comite			= label('comite',	'<s:message code="expedientes.consulta.tabcabecera.comite" text="**Comite"/>',cfg);
	var fechaComite		= label('fechaComite',	'<s:message code="expedientes.consulta.tabcabecera.fechavto" text="**Fecha Comite"/>',cfg);
	var oficina			= label('oficina',	'<s:message code="expedientes.consulta.tabcabecera.oficina" text="**Oficina"/>',cfg);
	var fechaUltModif	= label('fechaUltModif',	'<s:message code="expedientes.consulta.tabcabecera.ultimamodif" text="**Fecha Ultima Mod."/>',cfg);
	var usuModif			= label('usuModif',	'<s:message code="expedientes.consulta.tabcabecera.usuariomodif" text="**Usuario Ult. Modificacion"/>',cfg);
	var manual			= label('manual',	'<s:message code="expedientes.consulta.tabcabecera.manual" text="**Manual"/>',cfg);
	var gestor			= label('gestor',	'<s:message code="expedientes.consulta.tabcabecera.gestor" text="**Gestor"/>',cfg);
	var supervisor		= label('supervisor',	'<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>',cfg);
	


	var datosPrincipalesFieldSet = fieldSet('<s:message code="menu.clientes.consultacliente.menu.DatosPrincipales" text="**Datos Principales"/>'
		,[
				  {items:[codExpediente,descripcion,fechaCreacion]},
				  {items:[manual,usuModif,fechaUltModif]}
		]);
	
	var datosGestionFieldSet = fieldSet('<s:message code="menu.clientes.consultacliente.menu.DatosGestion" text="**Datos Gestion"/>'
		,[
				  {items:[estado,situacion,gestor,supervisor,fechaComite]},
				  {items:[diasVencido,volRiesgos,volRiesgosVenc,comite,oficina]}
		]);
		
		//Panel propiamente dicho...

  panel.add(datosPrincipalesFieldSet);
  panel.add(datosGestionFieldSet);

  panel.getValue = function(){};
  panel.setValue = function(){
    var data= entidad.get("data");
    var cabecera = data.cabecera;

    entidad.setLabel('codExpediente', cabecera.codExpediente);
	entidad.setLabel('fechaCreacion',cabecera.fechaCreacion);
    var situacion = cabecera.situacionData;
    if (cabecera.situacionTipoItinerario) {
      situacion += " / " + cabecera.situacionTipoItinerario;
    }
    entidad.setLabel('situacion', situacion);
    entidad.setLabel('estado',cabecera.estado);
    entidad.setLabel('descripcion',cabecera.descripcion);
    entidad.setLabel('diasVencido',cabecera.diasVencido);
    entidad.setLabel('volRiesgos',app.format.moneyRenderer(cabecera.volRiesgos));
    entidad.setLabel('volRiesgosVenc',app.format.moneyRenderer(cabecera.volRiesgosVenc));
    entidad.setLabel('comite',cabecera.comite);
    entidad.setLabel('fechaComite',cabecera.fechaComite);
    entidad.setLabel('oficina',cabecera.oficina);
    entidad.setLabel('fechaUltModif',cabecera.fechaUltModif);
    entidad.setLabel('usuModif',cabecera.usuModif);
    var manual = app.format.booleanToYesNoRenderer(cabecera.manual);
    entidad.setLabel('manual', manual);
    entidad.setLabel('gestor',cabecera.gestor);
    entidad.setLabel('supervisor',cabecera.supervisor);

  
  };
  
   panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente != 'REC';
   }
  
		
		return panel;

})
