<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

<fwk:page>
	var creditosStore = page.getStore({
	       remoteSort:false
	       ,id:'creditosStore'
	       ,flow:'credito/getCreditosAsunto'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'lista',fields:[
             {name: 'codigo'}
             ,{name: 'descripcion'}
         ]
	    })	       
	});

var cfg = {
		store:creditosStore,
		id:'comboCreditos',
		width:300
	};
var comboCreditos = app.creaDblSelect('','<s:message code="asunto.concurso.tabFaseComun.insinuaciones" text="**Insinuaciones" />',cfg);

<pfs:ddCombo name="estadoCredito"
		labelKey="asunto.concurso.tabFaseComun.estado" label="**Estado"
		value=""
		dd="${estados}" />
		
	var validarForm = function(){
	
		if(estadoCredito.getValue() == ''){
			Ext.Msg.alert('Aviso','Debe seleccionar un estado');
			return false;
		}
		if(comboCreditos.getValue() == ''){
			Ext.Msg.alert('Aviso','Debe seleccionar los créditos a insinuar');
			return false
		}
			
		return true;		
	}	
	
	var btnGuardar = new Ext.Button({
			text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
			,handler : function(){ 
						var parametros = {
								idAsunto : "${idAsunto}",
								estadoCredito : estadoCredito.getValue(),
								creditos:comboCreditos.getValue()
						};
						
						if(validarForm()){
							Ext.Ajax.request({
							url: page.resolveUrl('credito/guardarCambioEstadoCreditos')
							,params: parametros
							,success: function (result, request){
									page.fireEvent(app.event.DONE);
									}
								});
						}
					}				
			});
				 
	
	
	var mainPanel = new Ext.Panel({
        labelWidth: 100,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
        items:[estadoCredito,comboCreditos],
        bbar:[btnGuardar]
       
    });
	
	
    

    
    
	page.add(mainPanel);
	
	Ext.onReady(function() {
		creditosStore.webflow({idAsunto:"${idAsunto}"});
	});
	
</fwk:page>