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

var btn_1 = new Ext.Button({
 	  id: 'btn_1_facturacion_${idModFact}',
      iconCls:'icon_btn_factGeneral',
      text: '<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.general" text="**Datos generales"/>',               
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  pressed: true,
	  handler: function() {            			
        	loadPanelModeloFact('<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.general" text="**Datos generales"/>', "recobromodelofacturacion/abrirGeneral",{idModFact:${idModFact}});            			
		}			
   });  
   
var btn_2 = new Ext.Button({
	  id: 'btn_2_facturacion_${idModFact}',
      iconCls:'icon_btn_factCobros',
      text: '<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.cobros" text="**Cobros"/>',               
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {          			
        	loadPanelModeloFact('<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.cobros" text="**Cobros"/>', "recobromodelofacturacion/abrirCobros",{idModFact:${idModFact}});            			
		}				
   });  
var btn_3 = new Ext.Button({
      id: 'btn_3_facturacion_${idModFact}',
      iconCls:'icon_btn_factTarifas',
      text: '<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.tarifas" text="**Tarifas"/>',
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {            			
        	loadPanelModeloFact('<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.tarifas" text="**Tarifas"/>', "recobromodelofacturacion/abrirTarifas",{idModFact:${idModFact}});            			
		}				
   });  
var btn_4 = new Ext.Button({
      id: 'btn_4_facturacion_${idModFact}',
      iconCls:'icon_btn_factCorrectores',
      text: '<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.correctores" text="**Correctores"/>',
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {            			
        	loadPanelModeloFact('<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.correctores" text="**Correctores"/>', "recobromodelofacturacion/abrirCorrectores",{idModFact:${idModFact}});            			
		}				
   });

 btn_1.on('click', function(){
   	if (btn_1.pressed!=true){
   		btn_1.toggle();
   	} 
   	if (btn_2.pressed==true){
   		btn_2.toggle(); 
   	}
  	if (btn_3.pressed==true){
   		btn_3.toggle(); 
   	}
   	if (btn_4.pressed==true){
   		btn_4.toggle(); 
   	}
  });  
  
  btn_2.on('click', function(){
   	if (btn_2.pressed!=true){
   		btn_2.toggle();
   	} 
   	if (btn_1.pressed==true){
   		btn_1.toggle(); 
   	}
  	if (btn_3.pressed==true){
   		btn_3.toggle(); 
   	}
   	if (btn_4.pressed==true){
   		btn_4.toggle(); 
   	}
  });  
  
  btn_3.on('click', function(){
   	if (btn_3.pressed!=true){
   		btn_3.toggle();
   	} 
   	if (btn_2.pressed==true){
   		btn_2.toggle(); 
   	}
  	if (btn_1.pressed==true){
   		btn_1.toggle(); 
   	}
   	if (btn_4.pressed==true){
   		btn_4.toggle(); 
   	}
  }); 
  
  btn_4.on('click', function(){
   	if (btn_4.pressed!=true){
   		btn_4.toggle();
   	} 
   	if (btn_2.pressed==true){
   		btn_2.toggle(); 
   	}
  	if (btn_1.pressed==true){
   		btn_1.toggle(); 
   	}
   	if (btn_3.pressed==true){
   		btn_3.toggle(); 
   	}
  }); 
  
 var botones = new Ext.Panel({
 		id:'botFact_${idModFact}'
        ,region:'west'
        ,margins: '5 0 0 5'
        ,padding: '5 5 5 5'
        ,width: 230
        ,collapsible: true   // make collapsible
        ,cmargins: '5 5 0 5' // adjust top margin when collapsed
	 	,layout: 'column'
		,width: 133
		,height: 550
		,items:[
			btn_1,
			btn_2,
			btn_3,
			btn_4
		]
	});
	
				
	var contenido = new Ext.Panel({
		id: 'contFact_${idModFact}',
        title: '<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.general" text="**Datos generales"/>',
        region: 'center',
        xtype: 'container',
        layout: 'fit',
        margins: '5 5 0 0',        
		autoLoad: {
                    url : app.resolveFlow('recobromodelofacturacion/abrirGeneral')
                    ,scripts : true  
                    ,params: {idModFact:${idModFact}}                 
            }
    });
	
	
	var panel = new Ext.Panel({
	id:'panelFact_${idModFact}',    
    autoWidth: true,
    height : 500,
    title: '<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.title" text="**Modelos de Facturación"/>',
    layout: 'border',    
    items: [    
	     botones
	     ,contenido]
	});
	
	
	
	var loadPanelModeloFact = function(title, flow, params){
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
	
	
	page.add(panel);

</fwk:page>	