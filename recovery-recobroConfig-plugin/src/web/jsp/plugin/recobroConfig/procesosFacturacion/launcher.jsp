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
      iconCls:'icon_btn_calcularFacturacion',
      text: '<s:message code="plugin.recobroConfig.procesosFacturacion.launcher.botones.calculo" text="**Calcular facturación"/>',               
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
        	loadPanelProcesosFact('<s:message code="plugin.recobroConfig.procesosFacturacion.launcher.botones.calculo" text="**Calcular facturación"/>', "recobroprocesosfacturacion/abrirCalculo",{});            			
		}			
   });  
   
var btn_2 = new Ext.Button({
      iconCls:'icon_btn_remesasFacturacion',
      text: '<s:message code="plugin.recobroConfig.procesosFacturacion.launcher.botones.remesas" text="**Remesas facturación"/>',               
      iconAlign: 'top',
	  scale: 'large',
	  width: ancho,
	  height: alto,
	  style: {
	  	padding: '0 0 5 0'
	  },
	  enableToggle: true,
	  handler: function() {          			
        	loadPanelProcesosFact('<s:message code="plugin.recobroConfig.procesosFacturacion.launcher.botones.remesas" text="**Remesas facturación"/>', "recobroprocesosfacturacion/abrirRemesas",{});            			
		}				
   });  

 btn_1.on('click', function(){
   	if (btn_1.pressed!=true){
   		btn_1.toggle();
   	} 
   	if (btn_2.pressed==true){
   		btn_2.toggle(); 
   	}
  });  
  
  btn_2.on('click', function(){
   	if (btn_2.pressed!=true){
   		btn_2.toggle();
   	} 
   	if (btn_1.pressed==true){
   		btn_1.toggle(); 
   	}
  });  
  
  

 var botones = new Ext.Panel({
 		id:'botProcFact',
        region:'west',
        margins: '5 0 0 5',
        padding: '5 5 5 5',
        width: 230,
        collapsible: true,   // make collapsible
        cmargins: '5 5 0 5', // adjust top margin when collapsed
        id: 'botProcFact',
	 	layout: 'column'        
		,width: 133
		,height: 550
		,items:[
			btn_1,
			btn_2
		]
	});
	
				
	var contenido = new Ext.Panel({
		id: 'contProcFact',
        title: '<s:message code="plugin.recobroConfig.procesosFacturacion.launcher.botones.calculo" text="**Calcular facturación"/>',
        region: 'center',
        xtype: 'container',
        layout: 'fit',
        margins: '5 5 0 0',        
		autoLoad: {
                    url : app.resolveFlow('recobroprocesosfacturacion/abrirCalculo')
                    ,scripts : true 
                                     
            }
    });
	
	
	var panel = new Ext.Panel({
	id:'panelProcFact',    
    autoWidth: true,
    height : 600,
    title: '<s:message code="plugin.recobroConfig.procesosFacturacion.launcher.title" text="**Procesos de facturación"/>',
    layout: 'border',    
    items: [    
	     botones
	     ,contenido]
	});
	
	
	
	var loadPanelProcesosFact = function(title, flow, params){
		//debugger;
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