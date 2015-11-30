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
	var oficinaDir		= label('oficinaDireccion',	'<s:message code="expedientes.consulta.tabcabecera.oficinaDireccion" text="**Direccion Oficina"/>',cfg);
	var oficinaTel		= label('oficinaTelefono',	'<s:message code="expedientes.consulta.tabcabecera.oficinaTelefono" text="**Telefono Oficina"/>',cfg);
	var fechaUltModif	= label('fechaUltModif',	'<s:message code="expedientes.consulta.tabcabecera.ultimamodif" text="**Fecha Ultima Mod."/>',cfg);
	var usuModif		= label('usuModif',	'<s:message code="expedientes.consulta.tabcabecera.usuariomodif" text="**Usuario Ult. Modificacion"/>',cfg);
	var manual			= label('manual',	'<s:message code="expedientes.consulta.tabcabecera.manual" text="**Manual"/>',cfg);
	var gestor			= label('gestor',	'<s:message code="expedientes.consulta.tabcabecera.gestor" text="**Gestor"/>',cfg);
	var supervisor		= label('supervisor',	'<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>',cfg);
	
	var tipoExpediente		= label('tipoExpediente',	'<s:message code="expedientes.consulta.tabcabecera.tipoExpediente" text="**Tipo Expediente"/>',cfg);
	var cartera				= label('cartera',	'<s:message code="expedientes.consulta.tabcabecera.cartera" text="**Cartera"/>',cfg);
	var subcartera			= label('subcartera',	'<s:message code="expedientes.consulta.tabcabecera.subcartera" text="**Subcartera"/>',cfg);
	var agencia				= label('agencia',	'<s:message code="expedientes.consulta.tabcabecera.agencia" text="**Agencia"/>',cfg);
	var fechaAsignacion		= label('fechaAsignacion',	'<s:message code="expedientes.consulta.tabcabecera.fechaAsignacion" text="**F. asignación"/>',cfg);
	var itinerarioMV		= label('itinerarioMV',	'<s:message code="expedientes.consulta.tabcabecera.itinerarioMV" text="**Iti. Metas Volantes"/>',cfg);
	var fechaMaxEnAgencia	= label('fechaMaxEnAgencia',	'<s:message code="expedientes.consulta.tabcabecera.fechaMaxEnAgencia" text="**F. Max. en Agencia"/>',cfg);
	var fechaMaxCobroParcial= label('fechaMaxCobroParcial',	'<s:message code="expedientes.consulta.tabcabecera.fechaMaxCobroParcial" text="**F. Max. Cobro Parcial"/>',cfg);
		

	var datosPrincipalesFieldSet = fieldSet('<s:message code="menu.clientes.consultacliente.menu.DatosPrincipales" text="**Datos Principales"/>'
		,[
				  {items:[codExpediente,descripcion,fechaCreacion,tipoExpediente]},				  
				  {items:[manual,usuModif,fechaUltModif]}
		]);
	
	var datosGestionFieldSet = fieldSet('<s:message code="menu.clientes.consultacliente.menu.DatosGestion" text="**Datos Gestion"/>'
		,[
				  {items:[estado
				  		,situacion
				  		,supervisor
				  		//,fechaComite
				  		,oficina
				  		,oficinaDir
				  		,oficinaTel]},
				  {items:[// diasVencido,
				  			gestor,volRiesgos,volRiesgosVenc
				  			//,comite
				  			, fechaMaxCobroParcial
				  		    , fechaMaxEnAgencia
				  			]}
		]);
		
	var datosRecobroFieldSet = fieldSet('<s:message code="menu.clientes.consultacliente.menu.DatosRecobro" text="**Datos Recobro"/>'
		,[
				  {items:[cartera, subcartera, agencia, itinerarioMV]},
				  {items:[fechaAsignacion]}
		]);
		
//Panel propiamente dicho...

  
  panel.add(datosPrincipalesFieldSet);
  panel.add(datosGestionFieldSet);
  panel.add(datosRecobroFieldSet); 

  panel.getValue = function(){};
  panel.setValue = function(){
    var data= entidad.get("data");
    var cabecera = data.cabecera;
    var oficina = data.oficina;

    entidad.setLabel('codExpediente', cabecera.codExpediente);
	entidad.setLabel('fechaCreacion',cabecera.fechaCreacion);
	entidad.setLabel('tipoExpediente',cabecera.tipoExpediente);
    var situacionTmp = cabecera.situacionData;
    if (cabecera.situacionTipoItinerario) {
      situacionTmp += " / " + cabecera.situacionTipoItinerario;
    }
    entidad.setLabel('situacion', situacionTmp);
    entidad.setLabel('estado',cabecera.estado);
    entidad.setLabel('descripcion',cabecera.descripcion);
    entidad.setLabel('diasVencido',cabecera.diasVencido);
    entidad.setLabel('volRiesgos',app.format.moneyRenderer(cabecera.volRiesgos));
    entidad.setLabel('volRiesgosVenc',app.format.moneyRenderer(cabecera.volRiesgosVenc));
    entidad.setLabel('comite',cabecera.comite);
    entidad.setLabel('fechaComite',cabecera.fechaComite);
    entidad.setLabel('oficina',oficina.nombre);
    var dom1 = oficina.domicilioPlaza;
    if (dom1==null) dom1='';
    var dom2 = oficina.domicilio;
    if (dom2==null) dom2='';
    if ((dom1=='') &&	(dom2=='')){
    	entidad.setLabel('oficinaDireccion','N/A');
	}else{
		entidad.setLabel('oficinaDireccion',dom1 + " " + dom2);
	}   
	var tel1=oficina.telefono1;
	var tel2=oficina.telefono2;
	 	
    entidad.setLabel('oficinaTelefono',tel1);
    if(tel1==''){
    	entidad.setLabel('oficinaTelefono',tel2);
    	/* if (tel2==''){
    		entidad.setLabel('oficinaTelefono','N/A');
   		} */
    }
    	
    if ((oficina.tel1!='')&&(oficina.tel2!=''))
    {
    	entidad.setLabel('oficinaTel',oficina.telefono1 + ' - ' + oficina.telefono2);
    }
    
    entidad.setLabel('oficina',oficina.nombre);
    entidad.setLabel('fechaUltModif',cabecera.fechaUltModif);
    entidad.setLabel('usuModif',cabecera.usuModif);
    var manual = app.format.booleanToYesNoRenderer(cabecera.manual);
    entidad.setLabel('manual', manual);
    entidad.setLabel('gestor',cabecera.gestor);
    entidad.setLabel('supervisor',cabecera.supervisor);

	if (entidad.get("data").toolbar.tipoExpediente == 'REC') {
		var cabeceraRecobro = data.cabeceraRecobro;
		
	  	entidad.setLabel('cartera',cabeceraRecobro.cartera);
		entidad.setLabel('subcartera', cabeceraRecobro.subcartera);
		entidad.setLabel('agencia',	cabeceraRecobro.agencia);
		entidad.setLabel('fechaAsignacion',	cabeceraRecobro.fechaAsignacion);
		entidad.setLabel('itinerarioMV', cabeceraRecobro.itinerarioMV);
		entidad.setLabel('fechaMaxEnAgencia',cabeceraRecobro.fechaMaxEnAgencia);
		entidad.setLabel('fechaMaxCobroParcial',cabeceraRecobro.fechaMaxCobroParcial);
		
		gestor.setVisible(false);
		situacion.setVisible(false);
		supervisor.setVisible(false);
	} else {
		datosRecobroFieldSet.setVisible(false);
		tipoExpediente.setVisible(false);
	}
	
  };
  
	return panel;

})
