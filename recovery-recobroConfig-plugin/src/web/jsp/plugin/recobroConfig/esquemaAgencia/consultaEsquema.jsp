<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

var ancho = 120;
var alto = 80;
var ultimaVersionDelEsquema = ${ultimaVersionDelEsquema};
var botonPulsado = '${botonPulsado}' || '1';

if (!Array.prototype.forEach) {
   		Array.prototype.forEach = function(fn, scope) {
       		for(var i = 0, len = this.length; i < len; ++i) {
           	fn.call(scope, this[i], i, this);
       			}
   		}
	}


var getObjURL = function(boton) {		
	var objReturn = {};
	if (boton == '1' || boton == '') {
		objReturn.title = '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.esquema" text="**Esquema"/>';
		objReturn.flow = "recobroesquema/abrirFichaEsquema";
		objReturn.params ={idEsquema:${idEsquema},ultimaVersionDelEsquema:ultimaVersionDelEsquema};
	}
	if (boton == '2') {
		objReturn.title = '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.cartera" text="**Conformar Carteras"/>';
		objReturn.flow = "recobroesquema/abrirConformarCarteras";
		objReturn.params = {idEsquema:${idEsquema},ultimaVersionDelEsquema:ultimaVersionDelEsquema};
	}
	if (boton == '3') {
		objReturn.title = '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.repartos" text="**Repartos y Metas"/>';
		objReturn.flow = "recobroesquema/abrirRepartoSubcarteras";
		objReturn.params = {idEsquema:${idEsquema},ultimaVersionDelEsquema:ultimaVersionDelEsquema};
	}
	if (boton == '4') {
		objReturn.title = '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.modelosDeGestion" text="**Modelos de gestión"/>';
		objReturn.flow = "recobroesquema/openFacturacion";
		objReturn.params = {idEsquema:${idEsquema},ultimaVersionDelEsquema:ultimaVersionDelEsquema};
	}
	if (boton == '5') {
		objReturn.title = '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.simulacion" text="**Simulación"/>';
		objReturn.flow = "recobroesquema/openSimulacion";
		objReturn.params ={idEsquema:${idEsquema}};
	}	
	return objReturn;
};

var clickBoton = function(boton) {
	var objURL = getObjURL(boton);
	loadPanelEsquema(objURL.title, objURL.flow,objURL.params);
};

var btn_1 = new Ext.Button({
	  id: 'btn_1_esquema_${idEsquema}',
      iconCls:'icon_btn_esquema',
      text: '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.esquema" text="**Esquema"/>',               
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,	  
	  handler: function() {            			
			clickBoton('1');        	            			
		}			
   });  
   
var btn_2 = new Ext.Button({
	id: 'btn_2_esquema_${idEsquema}',
      iconCls:'icon_btn_cartera',
      text: '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.cartera" text="**Conformar Carteras"/>',               
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {          			
        	clickBoton('2');            			
		}				
   });  
var btn_3 = new Ext.Button({
      id: 'btn_3_esquema_${idEsquema}',
      iconCls:'icon_btn_repartos',
      text: '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.repartos" text="**Repartos y Metas"/>',               
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {            			
        	clickBoton('3');            			
		}				
   });  
var btn_4 = new Ext.Button({
	  id: 'btn_4_esquema_${idEsquema}',
      iconCls:'icon_btn_acuerdos',
      text: '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.modelosGestion" text="**Modelos de Gestión"/>',
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {            			
			clickBoton('4');        	            			
		}				
   });
var btn_5 = new Ext.Button({
	  id: 'btn_5_esquema_${idEsquema}',
      iconCls:'icon_btn_simulacion',
      text: '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.simulacion" text="**Simulación"/>',
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  disabled: ${sinSimulacion},
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {            			
        	clickBoton('5');            			
		}				
   });     
   
   var cambiaToggle = function(boton) {
	 	var panelBotones = Ext.getCmp('botEsquema_${idEsquema}');
	 	panelBotones.items.items.forEach(function(item) {
	 		if (boton==item) {
	 			if (item.pressed!=true) {
	  				item.toggle();
	  			}
	  		} else {
	  			if (item.pressed==true) {
	  				item.toggle();
	  			}
	  		} 	 	
	 	});	
   };
   
   btn_1.on('click', function(esteBoton){
		cambiaToggle(esteBoton);   	  	 	
   });
   btn_2.on('click', function(esteBoton){
		cambiaToggle(esteBoton);   	  	 	
   });
   btn_3.on('click', function(esteBoton){
		cambiaToggle(esteBoton);   	  	 	
   });
   btn_4.on('click', function(esteBoton){
		cambiaToggle(esteBoton);   	  	 	
   });
   btn_5.on('click', function(esteBoton){
		cambiaToggle(esteBoton);   	  	 	
   });
   
  
  
 var botones = new Ext.Panel({
        region:'west',
        margins: '5 0 0 5',
        padding: '5 5 5 5',
        width: 230,
        collapsible: true,   // make collapsible
        cmargins: '5 5 0 5', // adjust top margin when collapsed
        id: 'botEsquema_${idEsquema}',
	 	layout: 'column'
		,width: 133
		,height: 550
		,items:[
			btn_1,
			btn_2,
			btn_3,
			btn_4,
			btn_5
		]
	});
	
				
	var contenido = new Ext.Panel({
		id: 'contEsquema_${idEsquema}',
        title: '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.esquema" text="**Esquema"/>',
        region: 'center',     // center region is required, no width/height specified
        xtype: 'container',
        layout: 'fit',
        margins: '5 5 0 0',        
		autoLoad: {
                    url : app.resolveFlow(getObjURL(botonPulsado).flow)
                    ,scripts : true  
                    ,params: getObjURL(botonPulsado).params                 
            }
    });
	
	
	var panel = new Ext.Panel({ 
	id : 'panelEsquema_${idEsquema}',   
    autoWidth: true,
    height : 500,
    title: '<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.title" text="**Consulta Esquema"/>',
    layout: 'border',    
    items: [    
	     botones
	     ,contenido]
	});
	
	
	var loadPanelEsquema = function(title, flow, params){
		contenido.removeAll();
		var url = '/${appProperties.appName}/'+flow+'.htm';
		contenido.setTitle(title);
		contenido.load({
		    url: url,
		    params: params, // or a URL encoded string
		    text: 'Cargando...',
		    timeout: 30,
		    scripts: true
		});
	};
	
	cambiaToggle(Ext.getCmp('btn_'+botonPulsado+'_esquema_${idEsquema}'));
	
	page.add(panel);
			
	
</fwk:page>	